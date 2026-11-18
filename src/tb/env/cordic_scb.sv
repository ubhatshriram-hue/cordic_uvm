class cordic_scb extends uvm_scoreboard;
  `uvm_component_utils(cordic_scb)
  
  uvm_tlm_analysis_fifo #(cordic_seq_item)inp_mon_fifo;
  uvm_tlm_analysis_fifo #(cordic_seq_item)out_mon_fifo;
  
  cordic_seq_item inp;
  cordic_seq_item out;
  
  bit expected_error;
 
  shortint signed expected_sin;
  shortint signed expected_cos;
  shortint signed expected_product;
 
  bit expected_ang_mul;
 
  shortint signed actual_sin;
  shortint signed actual_cos;
  shortint signed actual_product;
 
  int sin_diff;
  int cos_diff;
 
  real angle_rad;
  real angle_deg;
  real sin_value;
  real cos_value;
  
  function new( string name="cordic_scb",uvm_component parent);
    super.new(name,parent);
    inp_mon_fifo=new("inp_mon_fifo",this);
    out_mon_fifo= new("out_mon_fifo",this);
 endfunction
  
 task run_phase(uvm_phase phase);
  forever 
    begin
      inp_mon_fifo.get(inp);
      out_mon_fifo.get(out);
      predict(inp);
      compare(out);
    end
 endtask
  
  task predict(cordic_seq_item inp);
    if(inp.err==1) begin
      expected_error = inp.err;
      `uvm_info(get_type_name(), "start asserted while busy", UVM_MEDIUM)end
    else begin
      expected_error = 1'b0;
      expected_ang_mul = inp.ang_mul;
      
      if (inp.ang_mul == 1'b1) begin
        angle_deg = (real'(inp.inp) * 360.0) / 65536.0;
        angle_rad = angle_deg * 3.141592653589793 / 180.0;
        sin_value = $sin(angle_rad);
        cos_value = $cos(angle_rad);
        expected_sin = $rtoi(sin_value * 16384.0);
        expected_cos = $rtoi(cos_value * 16384.0);
         `uvm_info(get_type_name(),$sformatf("Expected SIN = %0d COS = %0d",expected_sin, expected_cos),UVM_MEDIUM)
      end
      else begin
        expected_product =$signed(inp.inp[7:0]) * $signed(inp.inp[15:8]);
        `uvm_info(get_type_name(),$sformatf("Expected PRODUCT = %0d",expected_product),UVM_MEDIUM)
      end 
    end
  endtask
  
  task compare(cordic_seq_item out);
    if (expected_error || out.error)
      begin
      if(expected_error == out.error) 
        `uvm_info(get_type_name(),"ERROR TRANSACTION MATCHED",UVM_LOW)
      else 
        `uvm_error(get_type_name(), $sformatf("ERROR MISMATCH: Expected = %0b Actual = %0b",expected_error, out.error))
      end
        
    else begin
      if (expected_ang_mul == 1'b1) begin
        actual_cos = $signed({out.out[1], out.out[0]});
        actual_sin = $signed({out.out[3], out.out[2]});
        sin_diff = actual_sin - expected_sin;
        cos_diff = actual_cos - expected_cos;
        if (sin_diff < 0)
          sin_diff = -sin_diff;
        if (cos_diff < 0)
          cos_diff = -cos_diff;
        if ((sin_diff <= 5) && (cos_diff <= 5)) begin
          `uvm_info(get_type_name(), "ANGLE MODE: SIN AND COS MATCHED",UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),
                     $sformatf("ANGLE MISMATCH: SIN diff=%0d COS diff=%0d",
                     sin_diff, cos_diff))
        end
      end
      else begin
        actual_product = $signed({out.out[1], out.out[0]});
        if (actual_product == expected_product) begin
          `uvm_info(get_type_name(),"MULTIPLICATION RESULT MATCHED",UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),
                     $sformatf("PRODUCT MISMATCH: Expected=%0d Actual=%0d",
                     expected_product, actual_product))
        end
        end
 
    end
 
  endtask
endclass 
