class cordic_scb extends uvm_scoreboard;
  `uvm_component_utils(cordic_scb)
  uvm_tlm_analysis_fifo #(cordic_seq_item)inp_mon_fifo;
  uvm_tlm_analysis_fifo #(cordic_seq_item)out_mon_fifo;
  cordic_seq_item inp;
  cordic_seq_item out;
  cordic_seq_item expected;
 
  shortint signed expected_sin;
  shortint signed expected_cos;
  shortint signed expected_product;
  shortint signed actual_sin;
  shortint signed actual_cos;
  shortint signed actual_product;
   bit [7:0] actual_bytes[4];
  int sin_diff;
  int cos_diff;
  real angle_rad;
  real angle_deg;
  real sin_value;
  real cos_value;
  int pass=0;
  int fail=0;
  ///
  function new( string name="cordic_scb",uvm_component parent);
    super.new(name,parent);
    inp_mon_fifo=new("inp_mon_fifo",this);
    out_mon_fifo= new("out_mon_fifo",this);
    expected=cordic_seq_item::type_id::create("expected");
endfunction
task run_phase(uvm_phase phase);
  forever 
    begin
      inp_mon_fifo.get(inp);
      out_mon_fifo.get(out);
       if(inp.start && !out.busy) begin
        expected.ang_mul=inp.ang_mul;//c0
         inp_mon_fifo.get(inp);
         out_mon_fifo.get(out);
         expected.inp[7:0]=inp.data_in;//c1
         inp_mon_fifo.get(inp);
         out_mon_fifo.get(out);
         expected.inp[15:8]=inp.data_in;//c2
         predict(expected);
         do begin
           inp_mon_fifo.get(inp);
           out_mon_fifo.get(out);
         end
         while(out.done!==1);
         actual_bytes[0] = out.data_out;
         if(expected.ang_mul)begin
           for(int i=1;i<4;i++)
             begin
               inp_mon_fifo.get(inp);
               out_mon_fifo.get(out);
               actual_bytes[i]=out.data_out;
             end
         end
         else begin
           for(int i=1;i<2;i++)
             begin
               inp_mon_fifo.get(inp);
               out_mon_fifo.get(out);
               actual_bytes[i]=out.data_out;
             end
         end
       compare(out);
    end
    end
endtask
task predict(cordic_seq_item t);
 
  if (t.ang_mul == 1'b1) begin
    angle_deg    = (real'(t.inp) * 360.0) / 65536.0;
    angle_rad    = angle_deg * 3.141592653589793 / 180.0;
    sin_value    = $sin(angle_rad);
    cos_value    = $cos(angle_rad);
    expected_sin = $rtoi(sin_value * 16384.0);
    expected_cos = $rtoi(cos_value * 16384.0);
    `uvm_info(get_type_name(),
              $sformatf("Expected SIN = %0d COS = %0d for ANGLE=%0d degree inp=%0d", expected_sin, expected_cos,angle_deg,t.inp),
      UVM_MEDIUM)
  end
  else begin
    expected_product = $signed(t.inp[7:0]) * $signed(t.inp[15:8]);
    `uvm_info(get_type_name(),
      $sformatf("Expected PRODUCT = %0d", expected_product),
      UVM_MEDIUM)
  end
endtask
function void compare(cordic_seq_item o);
 
  if (expected.ang_mul == 1'b1) begin
    actual_cos = $signed({actual_bytes[1], actual_bytes[0]});
    actual_sin = $signed({actual_bytes[3], actual_bytes[2]});
 
    sin_diff = actual_sin - expected_sin;
    cos_diff = actual_cos - expected_cos;
    if (sin_diff < 0) sin_diff = -sin_diff;
    if (cos_diff < 0) cos_diff = -cos_diff;
 
    if (sin_diff <= 5 && cos_diff <= 5) begin
      `uvm_info(get_type_name(),
        $sformatf("ANGLE MATCHED: SIN=%0d COS=%0d (diff sin=%0d cos=%0d)",
                  actual_sin, actual_cos, sin_diff, cos_diff),
        UVM_LOW)
        pass++;
    end
    else begin
      `uvm_error(get_type_name(),
        $sformatf("ANGLE MISMATCH: exp SIN=%0d COS=%0d, act SIN=%0d COS=%0d (diff sin=%0d cos=%0d)",
                  expected_sin, expected_cos, actual_sin, actual_cos, sin_diff, cos_diff))
      fail++;
    end
  end
  else begin
    actual_product = $signed({actual_bytes[1], actual_bytes[0]});
 
    if (actual_product == expected_product) begin
      `uvm_info(get_type_name(),
        $sformatf("PRODUCT MATCHED: %0d", actual_product),
        UVM_LOW)
      pass++;
    end
    else begin
      `uvm_error(get_type_name(),
        $sformatf("PRODUCT MISMATCH: Expected=%0d Actual=%0d",
                  expected_product, actual_product))
      fail++;
    end
  end
 
  if (o.enable == 8'b00111000)
    `uvm_info(get_type_name(), "ENABLE MATCHED", UVM_LOW)
  else
    `uvm_error(get_type_name(),
      $sformatf("ENABLE MISMATCH: exp=%b act=%b", 8'b00111000, o.enable))
 
endfunction

    function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
      $sformatf("SCOREBOARD SUMMARY: PASSED = %0d FAILED = %0d TOTAL = %0d",
                pass, fail, pass+fail),
      UVM_NONE)
  endfunction
endclass
