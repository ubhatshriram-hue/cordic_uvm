interface cordic_intf( input bit clk, input bit rstn);
  logic start;
  logic ang_mul;
  logic [7:0] data_in;
  logic busy;
  logic done;
  logic error;
  logic [7:0] enable;
  logic [7:0] data_out;
  
  clocking drv_cb @(posedge clk);
    default input #1 output #0;
    output start,ang_mul,data_in;
    input busy;
  endclocking
  
  clocking mon_in_cb @(posedge clk);
    default input #1 output #0;
    input start,ang_mul,data_in;
    input busy, error, enable, data_out,done;
  endclocking
  
  clocking mon_out_cb @(posedge clk);
    default input #1 output #0;
     input start,ang_mul,data_in;
     input busy, error, enable, data_out,done;
  endclocking
  
  modport drv(clocking drv_cb,input rstn);
  modport mon_in(clocking mon_in_cb,input rstn); 
  modport mon_out(clocking mon_out_cb,input rstn);
    
endinterface

