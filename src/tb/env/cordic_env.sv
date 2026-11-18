class cordic_env extends uvm_env;

  `uvm_component_utils(cordic_env)

  cordic_act_agt agtin;
  cordic_pas_agt agtout;
  cordic_scb sb;
  cordic_sub sc;

  function new(string name = "cordic_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agtin  = cordic_act_agt::type_id::create("agtin", this);
    agtout = cordic_pas_agt::type_id::create("agtout", this);
    sb     = cordic_scb::type_id::create("sb", this);
    sc     = cordic_sub::type_id::create("sc", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agtin.moni.ap.connect(sb.inp_mon_fifo.analysis_export);
    agtout.mono.ap.connect(sb.out_mon_fifo.analysis_export);
    agtin.moni.ap.connect(sc.analysis_export);

  endfunction

endclass
