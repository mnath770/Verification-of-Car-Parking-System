interface parking_if(input logic clk);
  //Declaring signals
  logic reset_n;
  logic sensor_entrance, sensor_exit;
  logic [1:0] password_1, password_2;

  logic GREEN_LED,RED_LED;
  logic [6:0] HEX_1, HEX_2;


  //Clocking blocks
  clocking driver_cb @(posedge clk);
    input GREEN_LED, RED_LED, HEX_1, HEX_2;
    output sensor_entrance, sensor_exit, password_1, password_2, reset_n;
  endclocking

  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    output GREEN_LED, RED_LED, HEX_1, HEX_2;
    input sensor_entrance, sensor_exit, password_1, password_2;
  endclocking

  //Modports
  modport DRIVER (clocking driver_cb,
                input clk,
                output sensor_entrance, sensor_exit, password_1, password_2);

  modport MONITOR (clocking monitor_cb,
                input clk,
                input sensor_entrance, sensor_exit, password_1, password_2);

endinterface
