// BASE TEST
class cordic_test extends uvm_test;
  `uvm_component_utils(cordic_test)

  cordic_env env;
  cordic_config cfg;

  function new(string name="cordic_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = cordic_config::type_id::create("cfg");

    if(!uvm_config_db #(virtual cordic_intf)::get(this,"","cordic_intf",cfg.vif))
      `uvm_fatal(get_type_name(),"Test failed")

    uvm_config_db #(cordic_config)::set(this,"*","cordic_config",cfg);
    env = cordic_env::type_id::create("env",this);
  endfunction
endclass


// ANGLE 0
class angle_0 extends cordic_test;
  `uvm_component_utils(angle_0)
  cordic_sequence s0;

  function new(string name="angle_0", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s0 = cordic_sequence::type_id::create("s0");
    s0.start(env.agtin.seqr);
    phase.phase_done.set_drain_time(this,1000ns);
    phase.drop_objection(this);
  endtask
endclass


// POSITIVE * POSITIVE
class pos_pos_test extends cordic_test;
  `uvm_component_utils(pos_pos_test)
  pos_pos_seq s1;

  function new(string name="pos_pos_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s1 = pos_pos_seq::type_id::create("s1");
    s1.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// QUADRANT 1
class quad1_test extends cordic_test;
  `uvm_component_utils(quad1_test)
  quad1_seq s;

  function new(string name="quad1_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = quad1_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// QUADRANT 2
class quad2_test extends cordic_test;
  `uvm_component_utils(quad2_test)
  quad2_seq s;

  function new(string name="quad2_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = quad2_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// QUADRANT 3
class quad3_test extends cordic_test;
  `uvm_component_utils(quad3_test)
  quad3_seq s;

  function new(string name="quad3_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = quad3_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// QUADRANT 4
class quad4_test extends cordic_test;
  `uvm_component_utils(quad4_test)
  quad4_seq s;

  function new(string name="quad4_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = quad4_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// REPEAT SAME ANGLE
class repeat_same_test extends cordic_test;
  `uvm_component_utils(repeat_same_test)
  repeat_same_seq s;

  function new(string name="repeat_same_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = repeat_same_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// REPEAT DIFFERENT ANGLES
class repeat_diff_test extends cordic_test;
  `uvm_component_utils(repeat_diff_test)
  repeat_diff_seq s;

  function new(string name="repeat_diff_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = repeat_diff_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// NEGATIVE * NEGATIVE
class neg_neg_test extends cordic_test;
  `uvm_component_utils(neg_neg_test)
  neg_neg_seq s;

  function new(string name="neg_neg_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = neg_neg_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// POSITIVE * NEGATIVE
class pos_neg_test extends cordic_test;
  `uvm_component_utils(pos_neg_test)
  pos_neg_seq s;

  function new(string name="pos_neg_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = pos_neg_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// NEGATIVE * POSITIVE
class neg_pos_test extends cordic_test;
  `uvm_component_utils(neg_pos_test)
  neg_pos_seq s;

  function new(string name="neg_pos_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = neg_pos_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// REPEAT MULTIPLICATION
class repeat_mul_test extends cordic_test;
  `uvm_component_utils(repeat_mul_test)
  repeat_mul_seq s;

  function new(string name="repeat_mul_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = repeat_mul_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// ANGLE -> MULTIPLICATION -> ANGLE
class angle_mul_angle_test extends cordic_test;
  `uvm_component_utils(angle_mul_angle_test)
  angle_mul_angle_seq s;

  function new(string name="angle_mul_angle_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = angle_mul_angle_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// MULTIPLICATION -> ANGLE -> MULTIPLICATION
class mul_ang_mul_test extends cordic_test;
  `uvm_component_utils(mul_ang_mul_test)
  mul_ang_mul_seq s;

  function new(string name="mul_ang_mul_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = mul_ang_mul_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// RANDOM ANGLE
class random_angle_test extends cordic_test;
  `uvm_component_utils(random_angle_test)
  random_angle_seq s;

  function new(string name="random_angle_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = random_angle_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// RANDOM MULTIPLICATION
class random_mul_test extends cordic_test;
  `uvm_component_utils(random_mul_test)
  random_mul_seq s;

  function new(string name="random_mul_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = random_mul_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass



// ANGLE MAX
class angle_max_test extends cordic_test;
  `uvm_component_utils(angle_max_test)
  angle_max_seq s;

  function new(string name="angle_max_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = angle_max_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// ANGLE 270
class angle_270_test extends cordic_test;
  `uvm_component_utils(angle_270_test)
  angle_270_seq s;

  function new(string name="angle_270_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = angle_270_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// ANGLE 90
class angle_90_test extends cordic_test;
  `uvm_component_utils(angle_90_test)
  angle_90_seq s;

  function new(string name="angle_90_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = angle_90_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// ANGLE 180
class angle_180_test extends cordic_test;
  `uvm_component_utils(angle_180_test)
  angle_180_seq s;

  function new(string name="angle_180_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = angle_180_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass




// ZERO A
class zero_a_test extends cordic_test;
  `uvm_component_utils(zero_a_test)
  zero_a_seq s;

  function new(string name="zero_a_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = zero_a_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// ZERO B
class zero_b_test extends cordic_test;
  `uvm_component_utils(zero_b_test)
  zero_b_seq s;

  function new(string name="zero_b_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = zero_b_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// MAX POSITIVE
class max_pos_test extends cordic_test;
  `uvm_component_utils(max_pos_test)
  max_pos_seq s;

  function new(string name="max_pos_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = max_pos_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// MIN NEGATIVE
class min_neg_test extends cordic_test;
  `uvm_component_utils(min_neg_test)
  min_neg_seq s;

  function new(string name="min_neg_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = min_neg_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// MAX POSITIVE * MIN NEGATIVE
class max_min_test extends cordic_test;
  `uvm_component_utils(max_min_test)
  max_min_seq s;

  function new(string name="max_min_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = max_min_seq::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass


// BOUNDARY MULTIPLICATION
class boundary_test extends cordic_test;
  `uvm_component_utils(boundary_test)
  boundary_seq s;

  function new(string name="boundary_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = boundary_seq::type_id::create("s");
    s.start(env.agtin.seqr);
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

class multiplication_sweep extends cordic_test;
  `uvm_component_utils(multiplication_sweep)

  multiplication_sweep_seq s1;

  function new(string name = "multiplication_sweep",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.set_timeout(1000000000, 0);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    s1 = multiplication_sweep_seq::type_id::create("s1");
    s1.start(env.agtin.seqr);

    phase.drop_objection(this);
  endtask
endclass


class angle_90_test1 extends cordic_test;
  `uvm_component_utils(angle_90_test1)
  angle_90_seq1 s;

  function new(string name="angle_90_test1", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s = angle_90_seq1::type_id::create("s");
    s.start(env.agtin.seqr);
    phase.drop_objection(this);
  endtask
endclass
