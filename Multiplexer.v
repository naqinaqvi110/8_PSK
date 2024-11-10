module Multiplexer(input [2:0] select,
                    input [2:0] phase0,
                    input [2:0] phase1,
                    input [2:0] phase2,
                    input [2:0] phase3,
                    input [2:0] phase4,
                    input [2:0] phase5,
                    input [2:0] phase6,
                    input [2:0] phase7,
                    output reg [2:0] mux_out);

    

    always@(*)
    begin
    case(select)
        3'b000: mux_out = phase0;
        3'b001: mux_out = phase1;
        3'b010: mux_out = phase2;
        3'b011: mux_out = phase3;
        3'b100: mux_out = phase4;
        3'b101: mux_out = phase5;
        3'b110: mux_out = phase6;
        3'b111: mux_out = phase7;
        default: mux_out = 3'b000;
    endcase
    end

endmodule


