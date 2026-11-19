class cordic_test extends uvm_test;
  `uvm_component_utils(cordic_test)
  cordic_env env;
  cordic_config cfg;
  
  function new(string name ="cordic_test",uvm_component parent);
    super.new(name, parent);
  endfunction
 
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg=cordic_config::type_id::create("cfg");
    if(!uvm_config_db #(virtual cordic_intf)::get(this,"","cordic_intf",cfg.vif))
      `uvm_fatal(get_type_name(),"Test failed");
    uvm_config_db #(cordic_config)::set(this,"*","cordic_config",cfg);
    env=cordic_env::type_id::create("env",this);
  endfunction
  
  
  
endclass
    

class angle_0 extends cordic_test;
 `uvm_component_utils(angle_0)
  cordic_sequence s0;
  function new(string name="angle_0",uvm_component parent=null);
	super.new(name,parent);
 endfunction
 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
 endfunction
 task run_phase(uvm_phase phase);
 phase.raise_objection(this);
   s0=cordic_sequence::type_id::create("s0");
   s0.start(env.agtin.seqr);
   phase.phase_done.set_drain_time(this, 1000ns); 
 phase.drop_objection(this);
 endtask 
endclass


class pos_pos_test extends cordic_test;
  `uvm_component_utils(pos_pos_test)
  pos_pos_seq s1;

  function new(string name="pos_pos_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s1 = pos_pos_seq::type_id::create("s1");
    s1.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


class err_test extends cordic_test;
  `uvm_component_utils(err_test)
  err_seq s2;

  function new(string name="err_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s2 = err_seq::type_id::create("s2");
    s2.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


class angle_sweep extends cordic_test;
  `uvm_component_utils(angle_sweep)
  angle_sweep_seq s1;

  function new(string name="angle_sweep", uvm_component parent=null);
    super.new(name, parent);
  endfunction
function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.set_timeout(1000000000, 0);
    endfunction
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s1 = angle_sweep_seq::type_id::create("s1");
    s1.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass
