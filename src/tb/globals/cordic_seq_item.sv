class cordic_seq_item extends uvm_sequence_item;
  rand bit start;
  rand bit ang_mul;
  rand bit [7:0] data_in;
  bit busy;
  bit done;
  bit error;
  bit [7:0] enable;
  bit [7:0] data_out;
  rand bit err;
  rand bit data_inject;
  rand bit mode_inject;
  rand bit [15:0] inp;
  bit [7:0] out[4];
    bit rst;
  constraint c1{
    soft data_inject==0;
    soft mode_inject ==0;
    soft err==0;
  }
  
 `uvm_object_utils_begin(cordic_seq_item)
  `uvm_field_int(rst,UVM_ALL_ON)
  `uvm_field_int(start,UVM_ALL_ON)
  `uvm_field_int(ang_mul,UVM_ALL_ON)
  `uvm_field_int(data_in,UVM_ALL_ON)
  `uvm_field_int(busy,UVM_ALL_ON)
  `uvm_field_int(done,UVM_ALL_ON)
  `uvm_field_int(error,UVM_ALL_ON)
  `uvm_field_int(enable,UVM_ALL_ON)
  `uvm_field_int(data_out,UVM_ALL_ON)
  `uvm_field_int(err,UVM_ALL_ON)
  `uvm_field_int(inp,UVM_ALL_ON)

`uvm_object_utils_end
  
  function new(string name="cordic_seq_item");
    super.new(name);
  endfunction
endclass
