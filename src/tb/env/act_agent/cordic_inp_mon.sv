class cordic_inp_mon extends uvm_monitor;

  `uvm_component_utils(cordic_inp_mon)

  virtual cordic_intf.mon_in vif;
  cordic_config  cfg;
  uvm_analysis_port #(cordic_seq_item) ap;

  function new(string name = "cordic_inp_mon", uvm_component parent = null);
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
      @(vif.mon_in_cb);
        
        tr = cordic_seq_item::type_id::create("tr");
        tr.start = vif.mon_in_cb.start;
        tr.ang_mul = vif.mon_in_cb.ang_mul;
        tr.data_in = vif.mon_in_cb.data_in;

 tr.rst=vif.rstn;
      
        ap.write(tr);
        //`uvm_info(get_type_name(),$sformatf("[%0t] Sending DATA item to scb: ang_mul=%0b inp=0x%04h",$time, tr.ang_mul, tr.inp), UVM_MEDIUM)
      end
  endtask

endclass


