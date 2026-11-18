class cordic_seqr extends uvm_sequencer#(cordic_seq_item);
  `uvm_component_utils(cordic_seqr)
  
  function new(string name="cordic_seqr", uvm_component parent );
    super.new(name, parent);
  endfunction
  
endclass
