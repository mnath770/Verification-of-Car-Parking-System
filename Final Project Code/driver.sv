//gets the packet from generator and drive the transaction
//paket items into interface (interface is connected to DUT,
//so the items driven into interface signal will get driven
//in to DUT)

`define DRIV_IF parking_vif.DRIVER.driver_cb

class driver;
  //used to count the number of transactions
  int no_transactions;

  //creating virtual interface handle
  virtual parking_if parking_vif;

  //creating mailbox handle
  mailbox gen2driv;

  //constructor
   function new(virtual parking_if parking_vif, mailbox gen2driv);
     //getting the interface
     this.parking_vif = parking_vif;
     //getting the mailbox handles from  environment
     this.gen2driv = gen2driv;
   endfunction

   task idle_state_check();
     begin
     $display("*** IDLE STATE CHECK ***");
     assert(`DRIV_IF.GREEN_LED == 1'b0) $display("PASSED -> GREEN_LED: %b", `DRIV_IF.GREEN_LED);
     else $error("Green led issue");

     assert(`DRIV_IF.RED_LED == 1'b0) $display("PASSED -> RED_LED: %b", `DRIV_IF.RED_LED);
     else $display("Red led issue");

     assert(`DRIV_IF.HEX_1 == 7'b1111111) $display("PASSED -> HEX_1: %h", `DRIV_IF.HEX_1);
     else $display("HEX_1 issue");

     assert(`DRIV_IF.HEX_2 == 7'b1111111) $display("PASSED -> HEX_2: %h", `DRIV_IF.HEX_2);
     else $display("HEX_2 issue");
   end
   endtask

   task right_state_check();
     begin
       $display("*** RIGHT_PASS STATE CHECK ***");
       assert(`DRIV_IF.RED_LED == 1'b0) $display("PASSED -> RED_LED: %b", `DRIV_IF.RED_LED);
       else $error("Red led issue");

       assert(`DRIV_IF.HEX_1 == 7'b0000010) $display("PASSED -> HEX_1: %h", `DRIV_IF.HEX_1);
       else $display("HEX_1 issue");

       assert(`DRIV_IF.HEX_2 == 7'b1000000) $display("PASSED -> HEX_2: %h", `DRIV_IF.HEX_2);
       else $display("HEX_2 issue");
     end
   endtask


   task wait_state_check;
     $display("*** WAIT_PASSWORD STATE CHECK ***");
     assert(`DRIV_IF.GREEN_LED == 1'b0) $display("PASSED -> GREEN_LED: %b", `DRIV_IF.GREEN_LED);
     else $display("FAILED -> GREEN_LED: %b", `DRIV_IF.GREEN_LED);

     assert(`DRIV_IF.RED_LED == 1'b1) $display("PASSED -> RED_LED: %b", `DRIV_IF.RED_LED);
     else $display("Red led issue");

     assert(`DRIV_IF.HEX_1 == 7'b0000110) $display("PASSED -> HEX_1: %h", `DRIV_IF.HEX_1);
     else $display("HEX_1 issue");

     assert(`DRIV_IF.HEX_2 == 7'b0101011) $display("PASSED -> HEX_2: %h", `DRIV_IF.HEX_2);
     else $display("HEX_2 issue");
   endtask

    //Reset task, Reset the Interface signals to default/initial values
   task reset;
     @(posedge parking_vif.DRIVER.clk);
     parking_vif.reset_n <= 1;
     wait(parking_vif.reset_n);
     $display("--------- [DRIVER] Reset Started ---------");
     `DRIV_IF.sensor_entrance <= 0;
     `DRIV_IF.sensor_exit <= 0;
     `DRIV_IF.password_1 <= 2'b00;
     `DRIV_IF.password_2 <= 2'b00;
     parking_vif.reset_n <= 0;
     wait(!parking_vif.reset_n);
     $display("--------- [DRIVER] Reset Ended ---------");
   endtask

   //drivers the transaction items to interface signals
  task drive;
      transaction trans;

      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);

      //IDLE TEST
      `DRIV_IF.reset_n <= 1;
      $display("*************reset to one***************");

      repeat (3) @parking_vif.DRIVER.driver_cb;
      $display("==========A car is coming !");
      `DRIV_IF.sensor_entrance <= 1'b1;

      //WAIT_PASSWORD STATE
      repeat (3) @parking_vif.DRIVER.driver_cb;
      wait_state_check();

      //Entering password after 3 cycles
      repeat (3) @parking_vif.DRIVER.driver_cb;
      $display("==========Entering password");
      //`DRIV_IF.password_1 <= 2'b01;
      //`DRIV_IF.password_2 <= 2'b10;
      repeat (3) @parking_vif.DRIVER.driver_cb;
      `DRIV_IF.password_1 <= trans.password_1;
      `DRIV_IF.password_2 <= trans.password_2;

      //RIGHT_PASS STATE
      repeat (3) @parking_vif.DRIVER.driver_cb;
      right_state_check();

      //Car passing
      $display("==========Car is passing !");
      repeat (3) @parking_vif.DRIVER.driver_cb;
      `DRIV_IF.sensor_entrance <= 1'b0;
      `DRIV_IF.sensor_exit <= 1'b1;

      //IDLE STATE
      repeat (4) @parking_vif.DRIVER.driver_cb;
      idle_state_check();
      $display("==========Car entered !");

      repeat (3) @parking_vif.DRIVER.driver_cb;
      $display("-----------------------------------------");
      no_transactions++;
  endtask

  task main;
    forever begin
        drive();
    end
  endtask

endclass
