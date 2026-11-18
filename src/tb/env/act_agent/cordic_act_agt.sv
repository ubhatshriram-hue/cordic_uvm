class cordic_act_agt extends uvm_agent;

  `uvm_component_utils(cordic_act_agt)

  cordic_drv drv;
  cordic_seqr seqr;
  cordic_inp_mon moni;

  cordic_config cfg;

  function new(string name = "cordic_act_agt", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(cordic_config)::get(this, "", "cordic_config", cfg))
      `uvm_fatal(get_type_name(), "Configuration not found")

    if (cfg.act_agt == UVM_ACTIVE) begin
      drv  = cordic_drv::type_id::create("drv", this);
      seqr = cordic_seqr::type_id::create("seqr", this);
    end

    moni = cordic_inp_mon::type_id::create("moni", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (cfg.act_agt == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass

