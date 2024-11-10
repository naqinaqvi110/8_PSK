module top_level_module(input clk,rst,
                        input [2:0] select,
                        output [7:0] QPSK_wave,
								output [7:0] sine_out_2
);    
    

   

    wire [2:0] mux_out;
    wire [2:0] phase0,phase1,phase2,phase3,phase4,phase5,phase6,phase7;
    
    assign phase0 = 3'b000; // 0 phase
    assign phase1 = 3'b001; // 45 phase
    assign phase2 = 3'b010; // 90 phase
    assign phase3 = 3'b011; // 135 phase
    assign phase4 = 3'b100; // 180 phase
    assign phase5 = 3'b101; // 225 phase  
    assign phase6 = 3'b110; // 270 phase
    assign phase7 = 3'b111; // 315 phase

    Multiplexer Multiplexer_inst(
        .select(select),
        .phase0(phase0),
        .phase2(phase1),
        .phase3(phase2),
        .phase1(phase3),
        .phase4(phase4),
        .phase5(phase5),
        .phase6(phase6),
        .phase7(phase7),
        .mux_out(mux_out)
    );

    dds dds_inst(
        .clk(clk),
        .rst(rst),
        .phase_offset(mux_out),
        .sine_out(QPSK_wave),
		  .sine_out_2(sine_out_2)
    );
   

endmodule  





