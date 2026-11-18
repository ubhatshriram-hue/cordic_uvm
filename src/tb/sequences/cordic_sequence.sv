class cordic_sequence extends uvm_sequence#(cordic_seq_item);
  `uvm_object_utils(cordic_sequence)
  
  function new(string name="cordic_sequence");
    super.new(name);
  endfunction
  
  task body();
      `uvm_do_with(req, { start == 1; inp == 0; ang_mul==1; })   

  endtask

endclass
     
    
class pos_pos_seq extends uvm_sequence#(cordic_seq_item);
  `uvm_object_utils(pos_pos_seq)
  
  function new(string name="pos_pos_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_do_with(req, { start == 1;ang_mul==0; inp == 16'h0205; })   
  endtask

endclass

class err_seq extends uvm_sequence#(cordic_seq_item);
  `uvm_object_utils(err_seq)
  
  function new(string name="err_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_do_with(req, { start == 1;ang_mul==0; inp == 16'h0205;err ==1; })   
  endtask

endclass
