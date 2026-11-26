`include "cordic_intf.sv"
`include "dut.v"

module cordic_top;

  import uvm_pkg::*;
  import cordic_package::*;

  bit clk;
  bit rstn;

  always #5 clk = ~clk;

  initial begin
    rstn = 0;
    #1;
    rstn = 1;
    repeat(4) @(posedge clk);
    rstn = 0;
    repeat(2) @(posedge clk);
    rstn = 1;
    
    /*repeat(26) @(posedge clk);
    rstn = 0;
    repeat(2) @(posedge clk);
    rstn = 0;
     repeat(2) @(posedge clk);
    rstn = 0;
    repeat(2) @(posedge clk);
    rstn = 0;
    @(posedge clk);
    rstn = 1;

    repeat(38) @(posedge clk);
    rstn = 0;
    @(posedge clk);
    rstn = 1;
  */
  end

  cordic_intf vif (.clk(clk), .rstn(rstn));

  CORDIC DUT (
    .CLK      (vif.clk),
    .RSTn     (vif.rstn),
    .START    (vif.start),
    .ANG_MUL  (vif.ang_mul),
    .DATA_IN  (vif.data_in),
    .BUSY     (vif.busy),
    .DONE     (vif.done),
    .ERROR    (vif.error),
    .ENABLE   (vif.enable),
    .DATA_OUT (vif.data_out)
  );

  initial begin
    clk = 0;
    uvm_config_db#(virtual cordic_intf)::set(
      null, "uvm_test_top", "cordic_intf", vif
    );
    $dumpfile("dump.vcd");
    $dumpvars(0, cordic_top);
  end

  initial begin
    run_test("");
  end

endmodule
