
class cordic_sequence extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(cordic_sequence)

  function new(string name="cordic_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; inp==0; ang_mul==1; err==0;})
  endtask
endclass


// POSITIVE * POSITIVE
class pos_pos_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(pos_pos_seq)

  function new(string name="pos_pos_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h0205; err==0;})
  endtask
endclass


// QUADRANT 1
class quad1_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(quad1_seq)

  function new(string name="quad1_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd2731;  err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd5461;  err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd10923; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd13653; err==0;})
  endtask
endclass


// QUADRANT 2
class quad2_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(quad2_seq)

  function new(string name="quad2_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd19115; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd21845; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd27307; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd30037; err==0;})
  endtask
endclass


// QUADRANT 3
class quad3_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(quad3_seq)

  function new(string name="quad3_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd35499; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd38229; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd43691; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd46421; err==0;})
  endtask
endclass


// QUADRANT 4
class quad4_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(quad4_seq)

  function new(string name="quad4_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd51883; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd54613; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd60075; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'd62805; err==0;})
  endtask
endclass


// REPEAT SAME ANGLE
class repeat_same_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(repeat_same_seq)

  function new(string name="repeat_same_seq");
    super.new(name);
  endfunction

  task body();
    repeat(4)
      `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h4000; err==0;})
  endtask
endclass


// REPEAT DIFFERENT ANGLES
class repeat_diff_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(repeat_diff_seq)

  function new(string name="repeat_diff_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h0000; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h4000; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h8000; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'hC000; err==0;})
  endtask
endclass


// NEGATIVE * NEGATIVE
class neg_neg_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(neg_neg_seq)

  function new(string name="neg_neg_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'hF9FB; err==0;})
  endtask
endclass


// POSITIVE * NEGATIVE
class pos_neg_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(pos_neg_seq)

  function new(string name="pos_neg_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'hF905; err==0;})
  endtask
endclass


// NEGATIVE * POSITIVE
class neg_pos_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(neg_pos_seq)

  function new(string name="neg_pos_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h07FB; err==0;})
  endtask
endclass


// REPEAT MULTIPLICATION
class repeat_mul_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(repeat_mul_seq)

  function new(string name="repeat_mul_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h0205; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h0304; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'hF905; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'hF9FB; err==0;})
  endtask
endclass






// ANGLE -> MULTIPLICATION -> ANGLE
class angle_mul_angle_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(angle_mul_angle_seq)

  function new(string name="angle_mul_angle_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h4000; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h0205; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'hC000; err==0;})
  endtask
endclass


// MULTIPLICATION -> ANGLE -> MULTIPLICATION
class mul_ang_mul_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(mul_ang_mul_seq)

  function new(string name="mul_ang_mul_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h0205; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h4000; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'hF9FB; err==0;})
  endtask
endclass


// RANDOM ANGLES
class random_angle_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(random_angle_seq)

  function new(string name="random_angle_seq");
    super.new(name);
  endfunction

  task body();
    repeat(100) begin
      `uvm_do_with(req, {start==1; ang_mul==1; inp inside {[0:65535]}; err==0;})
    end
  endtask
endclass


// RANDOM MULTIPLICATION
class random_mul_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(random_mul_seq)

  function new(string name="random_mul_seq");
    super.new(name);
  endfunction

  task body();
    repeat(100) begin
      `uvm_do_with(req, {start==1; ang_mul==0; err==0;})
    end
  endtask
endclass


// ANGLE MAX: 0xFFFF
class angle_max_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(angle_max_seq)

  function new(string name="angle_max_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'hFFFF; err==0;})
  endtask
endclass


// ANGLE 270 DEGREE
class angle_270_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(angle_270_seq)

  function new(string name="angle_270_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'hC000; err==0;})
  endtask
endclass


// ANGLE 90 DEGREE
class angle_90_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(angle_90_seq)

  function new(string name="angle_90_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h4000; err==0;})
  endtask
endclass


// ANGLE 180 DEGREE
class angle_180_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(angle_180_seq)

  function new(string name="angle_180_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==1; inp==16'h8000; err==0;})
  endtask
endclass


// ZERO A
class zero_a_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(zero_a_seq)

  function new(string name="zero_a_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h1900; err==0;})
  endtask
endclass


// ZERO B
class zero_b_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(zero_b_seq)

  function new(string name="zero_b_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h0019; err==0;})
  endtask
endclass


// MAX POSITIVE
class max_pos_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(max_pos_seq)

  function new(string name="max_pos_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h7F7F; err==0;})
  endtask
endclass


// MIN NEGATIVE
class min_neg_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(min_neg_seq)

  function new(string name="min_neg_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h8080; err==0;})
  endtask
endclass


// MAX POSITIVE * MIN NEGATIVE
class max_min_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(max_min_seq)

  function new(string name="max_min_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h807F; err==0;})
  endtask
endclass


// BOUNDARY MULTIPLICATION
class boundary_seq extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(boundary_seq)

  function new(string name="boundary_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h7E7E; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h7F7F; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h8080; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h8181; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'hFF01; err==0;})
    `uvm_do_with(req, {start==1; ang_mul==0; inp==16'h01FF; err==0;})
  endtask
endclass



   class angle_sweep_seq extends uvm_sequence#(cordic_seq_item);
  `uvm_object_utils(angle_sweep_seq)
 
  function new(string name="angle_sweep_seq");
    super.new(name);
  endfunction
 
  task body();
    for(int i=0;i<65536;i++) begin
      `uvm_do_with(req, {ang_mul==1; inp==i;start==1;})
    end
  endtask
endclass
