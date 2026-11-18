class cordic_config extends uvm_object;

  `uvm_object_utils(cordic_config)

  uvm_active_passive_enum act_agt = UVM_ACTIVE;
  uvm_active_passive_enum pas_agt = UVM_PASSIVE;

  virtual cordic_intf vif;

  function new(string name = "cordic_config");
    super.new(name);
  endfunction

endclass
