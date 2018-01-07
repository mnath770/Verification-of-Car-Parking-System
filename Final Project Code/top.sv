`timescale 1ns/1ps
`include "parking_if.sv"
`include "test.sv"

module top;
  bit clk;
  bit reset;

  parameter clk_per=10; //clock period
  always #(clk_per/2) clk = ~ clk; //clock generation

  //reset Generation
  initial begin
    reset = 1;
    #5 reset = 0;
  end

  parking_if parkif(clk); //Interface
  test tst(parkif); //Test Program
  parking_system dut( //Design Under Test
    .clk(parkif.clk),
    .reset_n(parkif.reset_n),
    .sensor_entrance(parkif.sensor_entrance),
    .sensor_exit(parkif.sensor_exit),
    .password_1(parkif.password_1),
    .password_2(parkif.password_2),
    .GREEN_LED(parkif.GREEN_LED),
    .RED_LED(parkif.RED_LED),
    .HEX_1(parkif.HEX_1),
    .HEX_2(parkif.HEX_2)
    );
endmodule
