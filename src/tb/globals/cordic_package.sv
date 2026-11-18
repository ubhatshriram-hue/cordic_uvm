
package cordic_package;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Globals
  `include "cordic_config.sv"
  `include "cordic_seq_item.sv"

  // Sequences
  `include "../sequences/cordic_sequence.sv"

  // Active Agent
  `include "../env/act_agent/cordic_seqr.sv"
  `include "../env/act_agent/cordic_drv.sv"
  `include "../env/act_agent/cordic_inp_mon.sv"
  `include "../env/act_agent/cordic_act_agt.sv"

  // Passive Agent
  `include "../env/pass_agent/cordic_out_mon.sv"
  `include "../env/pass_agent/cordic_pas_agt.sv"

  // Environment
  `include "../env/cordic_scb.sv"
  `include "../env/cordic_sub.sv"
  `include "../env/cordic_env.sv"

  // Tests
  `include "../test/cordic_test.sv"

endpackage : cordic_package

