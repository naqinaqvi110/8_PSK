`timescale 1ns / 1ps

module top_level_module_tb;
    reg clk;
    reg rst;
	 reg [2:0] select;
    wire [7:0] QPSK_wave;
	 wire [7:0] sine_out_2;

    // Instantiate the top level module
    top_level_module uut (
        .clk(clk),
        .rst(rst),
		  .select(select),
        .QPSK_wave(QPSK_wave),
		  .sine_out_2(sine_out_2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;  // 10ns period clock (100 MHz)
    end

    // Test stimulus
    initial begin
         // Allow the system to run for several clock cycles
       
              
		// Reset the system
        rst = 1;
        #20;
        rst = 0;
		  
		  
		   select = 3'b000;
		  #20
		   select = 3'b001;
		  #20
		   select = 3'b010;
		  #20
		   select = 3'b011;
		  #20
		   select = 3'b100;
		  #20
		   select = 3'b101;
		  #20
		   select = 3'b110;
		  #20
		   select = 3'b111;
		  #20
		    select = 3'b000;
		  #200
		   select = 3'b001;
		  #200
		   select = 3'b010;
		  #200
		   select = 3'b011;
		  #200
		   select = 3'b100;
		  #200
		   select = 3'b101;
		  #200
		   select = 3'b110;
		  #200
		   select = 3'b111;
		  #200
        
       

       // #322000;// Run the simulation for 5000ns
        $stop; // Stop the simulation
    end
endmodule