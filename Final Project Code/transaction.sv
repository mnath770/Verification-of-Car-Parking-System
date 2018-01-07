class transaction;
  //declaring the transaction items
   // bit            reset_n = 0
   // bit       sensor_entrance, sensor_exit;
   randc bit [1:0] password_1, password_2;

   //rand bit       GREEN_LED,RED_LED;
   //rand bit       [6:0] HEX_1, HEX_2;
   bit [1:0] cnt;

  //constaint, to generate any one among write and read
  constraint password_c {

 };

  //postrandomize function, displaying randomized values of items
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    $display("\t password_1  = %h", password_1);
    $display("\t password_2  = %h", password_2);
    $display("---------------------------------------");
  endfunction

  //deep copy method
  function transaction do_copy();
    transaction trans;
    trans = new();
    trans.password_1 = this.password_1;
    trans.password_2 = this.password_2;
    return trans;
  endfunction
endclass
