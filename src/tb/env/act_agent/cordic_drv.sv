class cordic_drv extends uvm_driver#(cordic_seq_item);
  `uvm_component_utils(cordic_drv)
  virtual cordic_intf.drv vif;
  cordic_config cfg;;
  int t;
  
  function new(string name="cordic_drv",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(cordic_config)::get(this,"", "cordic_config",cfg))
      `uvm_fatal(get_type_name(), "Configuration not found")
  endfunction
 
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=cfg.vif;
  endfunction
      
  
  task run_phase(uvm_phase phase);
    //@(vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive(cordic_seq_item  req);
    int err_cycle=0;
    
    do begin
      @(vif.drv_cb);
    end while (vif.rstn !== 1'b1);
    
    @(vif.drv_cb);//c0
    vif.drv_cb.start<=req.start;
    vif.drv_cb.ang_mul<=req.ang_mul;
     `uvm_info(get_type_name(),
            $sformatf("[%0t] c0: start=%0b ang_mul=%0b",
                      $time, req.start, req.ang_mul),
            UVM_MEDIUM)
    
    @(vif.drv_cb);//c1
    vif.drv_cb.start<=0;
    vif.drv_cb.data_in<=req.inp[7:0];
    `uvm_info(get_type_name(),
            $sformatf("[%0t] c1: start=0 data_in(low byte)=0x%02h",
                      $time, req.inp[7:0]),
            UVM_MEDIUM)

    
    
    @(vif.drv_cb);//c2
    vif.drv_cb.data_in<=req.inp[15:8];
    `uvm_info(get_type_name(),
            $sformatf("[%0t] c2: data_in(high byte)=0x%02h",
                      $time, req.inp[15:8]),
            UVM_MEDIUM)
     
    
    @(vif.drv_cb);//c3
    if (req.data_inject)
     vif.drv_cb.data_in<= 8'hFF;
 
    if (req.mode_inject)
    vif.drv_cb.ang_mul <= ~req.ang_mul;
    
    if(req.err) begin
        vif.drv_cb.start<=1;
      err_cycle =  $urandom_range(1,19);
      
      repeat(err_cycle)
         @(vif.drv_cb);
       vif.drv_cb.start<=1;
      `uvm_info(get_type_name(),
              $sformatf("[%0t] ERROR INJECT: extra start will fire after %0d cycle(s)",
                        $time, err_cycle),
              UVM_MEDIUM)
       @(vif.drv_cb);
       vif.drv_cb.start<=0;
    end

    do begin
      @(vif.drv_cb);
  end while (vif.drv_cb.busy !== 1'b0);
    
  endtask
endclass
      
      

        
      
    
    
    
    
