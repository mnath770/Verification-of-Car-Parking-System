`include "environment.sv"

program automatic test (parking_if parkif);

    class my_trans extends transaction;
      bit [1:0] count;
      function void pre_randomize();
        password_1.rand_mode(0);
        password_2.rand_mode(0);
        password_1 = 2'b01;
        password_2 = 2'b10;
        cnt++;
      endfunction
    endclass

    //declaring environment instance
    environment env;
    my_trans my_tr;

    //BEGIN
    initial begin
      //Variable declaration
      // int unsigned realSum;
      // RandomTable rantab;
      // rantab = new();
      // realSum = 16'h0000;
      $vcdpluson;
      $display("*************Start Test***************");

      //creating environment
      env = new(parkif);
      my_tr = new();

      //setting the repeat count of generator as 4, means to generate 4 packets
      env.gen.repeat_count = 10;

      env.gen.trans = my_tr;
      //calling run of env, it interns calls generator and driver main tasks.
      env.run();

      $finish;
    end
endprogram
