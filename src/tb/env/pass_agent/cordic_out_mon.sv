

class cordic_out_mon extends uvm_monitor;

  `uvm_component_utils(cordic_out_mon)
  virtual cordic_intf.mon_out vif;
  cordic_config  cfg;
  uvm_analysis_port #(cordic_seq_item) ap;

  function new(string name = "cordic_out_mon", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(cordic_config)::get(this, "", "cordic_config", cfg))
      `uvm_fatal(get_type_name(), "Configuration not found")
  endfunction

 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
   vif=cfg.vif;
 endfunction  
  
  task run_phase(uvm_phase phase);
    cordic_seq_item tr;
     forever begin
      @(vif.mon_out_cb);
        tr = cordic_seq_item::type_id::create("tr");
        tr.data_out = vif.mon_out_cb.data_out;
        tr.enable   = vif.mon_out_cb.enable;
        tr.busy = vif.mon_out_cb.busy;
        tr.error = vif.mon_out_cb.error;
        tr.done = vif.mon_out_cb.done;
        tr.rst=vif.rstn;
         ap.write(tr);
         //`uvm_info(get_type_name(),$sformatf("[%0t] Sending DATA item to scb: %0d beat(s): %p", $time, idx, tr.out),UVM_MEDIUM)
       end
  endtask
 endclass
      
        
        
        
        

        

