class cordic_sub extends uvm_subscriber #(cordic_seq_item);

  `uvm_component_utils(cordic_sub)

  cordic_seq_item in_mon_xn;

  covergroup input_cg;

    start_cp: coverpoint in_mon_xn.start {
      bins start_low  = {0};
      bins start_high = {1};
    }

    ang_mul_cp: coverpoint in_mon_xn.ang_mul {
      bins multiplication = {0};
      bins angle          = {1};
    }

    data_in_cp: coverpoint in_mon_xn.data_in {
      bins zero           = {8'h00};
      bins positive       = {[8'h01:8'h7E]};
      bins positive_max   = {8'h7F};
      bins negative_max   = {8'h80};
      bins negative       = {[8'h81:8'hFF]};
    }

    start_ang_mul_cross: cross start_cp, ang_mul_cp {
      bins start_mul = binsof(start_cp) intersect {1} &&
                       binsof(ang_mul_cp) intersect {0};

      bins start_angle = binsof(start_cp) intersect {1} &&
                         binsof(ang_mul_cp) intersect {1};
    }

    ang_mul_data_in_cross: cross ang_mul_cp, data_in_cp;

  endgroup

  function new(string name = "cordic_sub", uvm_component parent = null);
    super.new(name, parent);
    input_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void write(cordic_seq_item t);
    in_mon_xn = t;
    input_cg.sample();

    `uvm_info(get_name(), "[SUB]: INPUT RECEIVED", UVM_HIGH)
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    //`uvm_info(get_name(), $sformatf("INPUT COVERAGE = %0.2f%%", input_cg.get_coverage()), UVM_NONE)
  endfunction

endclass
