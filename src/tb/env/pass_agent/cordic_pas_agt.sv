class cordic_pas_agt extends uvm_agent;

  `uvm_component_utils(cordic_pas_agt)

  cordic_out_mon mono;
  cordic_config cfg;

  function new(string name = "cordic_pas_agt", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(cordic_config)::get(this, "", "cordic_config", cfg))
      `uvm_fatal(get_type_name(), "Configuration not found")

    mono = cordic_out_mon::type_id::create("mono", this);

  endfunction

endclass
