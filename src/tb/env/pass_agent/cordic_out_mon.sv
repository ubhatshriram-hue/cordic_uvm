class cordic_out_mon extends uvm_monitor;

  `uvm_component_utils(cordic_out_mon)

  virtual cordic_intf.mon_out vif;
  cordic_config  cfg;
  uvm_analysis_port #(cordic_seq_item) ap;
  int idx;

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
  
  task error_handling();
    cordic_seq_item t;
    t = cordic_seq_item::type_id::create("tr");
    t.error = 1'b1;
    ap.write(t);
     `uvm_info(get_type_name(),
            $sformatf("[%0t] Sending ERROR item to scb (DUT error=1)", $time),
            UVM_MEDIUM)
  endtask
    
  
  task run_phase(uvm_phase phase);
    cordic_seq_item tr;
     forever begin
      @(vif.mon_out_cb);
      if (vif.mon_out_cb.error === 1'b1) error_handling();
        
       if (vif.mon_out_cb.done) begin
        tr = cordic_seq_item::type_id::create("tr");
          idx = 0;
        while (vif.mon_out_cb.done === 1'b1) begin
          tr.out[idx++] = vif.mon_out_cb.data_out;
          tr.busy       = vif.mon_out_cb.busy;
          tr.done       = vif.mon_out_cb.done;
          @(vif.mon_out_cb);
          if (vif.mon_out_cb.error === 1'b1) error_handling();
        end
         ap.write(tr);
          `uvm_info(get_type_name(),
                $sformatf("[%0t] Sending DATA item to scb: %0d beat(s), out[0]=0x%02h",
                          $time, idx, tr.out[0]),
                UVM_MEDIUM)
       end
     end
  endtask
 endclass
      
        
        
        
        

        
