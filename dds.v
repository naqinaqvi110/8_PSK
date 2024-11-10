module dds(
    input wire clk,           // System clock
    input wire rst,           // Reset signal
    input wire [2:0] phase_offset, // Phase offset for 8-PSK
    output reg [7:0] sine_out,
	 output reg [7:0] sine_out_2
	  // Output sine wave (8-bit)
);

    reg [7:0] sine_lut [255:0];   // 256-entry LUT for one cycle of sine wave
    reg [31:0] phase_acc;         // 32-bit phase accumulator for high resolution
	 reg [31:0] phase_acc_non_mod;
    parameter freq_control = 32'd42949673; // Frequency control for desired output frequency

    // Initialize LUT with sine wave values

    
    // Precomputed sine values (for 0-255, one cycle)
    initial begin
       // Precomputed sine values (for 0-255, one cycle) within 8-bit unsigned range
   
        sine_lut[0]   = 8'd128; sine_lut[1]   = 8'd131; sine_lut[2]   = 8'd134; sine_lut[3]   = 8'd137;
        sine_lut[4]   = 8'd140; sine_lut[5]   = 8'd144; sine_lut[6]   = 8'd147; sine_lut[7]   = 8'd150;
        sine_lut[8]   = 8'd153; sine_lut[9]   = 8'd156; sine_lut[10]  = 8'd159; sine_lut[11]  = 8'd162;
        sine_lut[12]  = 8'd165; sine_lut[13]  = 8'd168; sine_lut[14]  = 8'd171; sine_lut[15]  = 8'd174;
        sine_lut[16]  = 8'd177; sine_lut[17]  = 8'd179; sine_lut[18]  = 8'd182; sine_lut[19]  = 8'd185;
        sine_lut[20]  = 8'd188; sine_lut[21]  = 8'd191; sine_lut[22]  = 8'd193; sine_lut[23]  = 8'd196;
        sine_lut[24]  = 8'd199; sine_lut[25]  = 8'd201; sine_lut[26]  = 8'd204; sine_lut[27]  = 8'd206;
        sine_lut[28]  = 8'd209; sine_lut[29]  = 8'd211; sine_lut[30]  = 8'd213; sine_lut[31]  = 8'd216;
        sine_lut[32]  = 8'd218; sine_lut[33]  = 8'd220; sine_lut[34]  = 8'd222; sine_lut[35]  = 8'd224;
        sine_lut[36]  = 8'd226; sine_lut[37]  = 8'd228; sine_lut[38]  = 8'd230; sine_lut[39]  = 8'd232;
        sine_lut[40]  = 8'd234; sine_lut[41]  = 8'd235; sine_lut[42]  = 8'd237; sine_lut[43]  = 8'd239;
        sine_lut[44]  = 8'd240; sine_lut[45]  = 8'd241; sine_lut[46]  = 8'd243; sine_lut[47]  = 8'd244;
        sine_lut[48]  = 8'd245; sine_lut[49]  = 8'd246; sine_lut[50]  = 8'd248; sine_lut[51]  = 8'd249;
        sine_lut[52]  = 8'd250; sine_lut[53]  = 8'd250; sine_lut[54]  = 8'd251; sine_lut[55]  = 8'd252;
        sine_lut[56]  = 8'd253; sine_lut[57]  = 8'd253; sine_lut[58]  = 8'd254; sine_lut[59]  = 8'd254;
        sine_lut[60]  = 8'd254; sine_lut[61]  = 8'd255; sine_lut[62]  = 8'd255; sine_lut[63]  = 8'd255;
        sine_lut[64]  = 8'd255; sine_lut[65]  = 8'd255; sine_lut[66]  = 8'd255; sine_lut[67]  = 8'd255;
        sine_lut[68]  = 8'd254; sine_lut[69]  = 8'd254; sine_lut[70]  = 8'd254; sine_lut[71]  = 8'd253;
        sine_lut[72]  = 8'd253; sine_lut[73]  = 8'd252; sine_lut[74]  = 8'd251; sine_lut[75]  = 8'd250;
        sine_lut[76]  = 8'd250; sine_lut[77]  = 8'd249; sine_lut[78]  = 8'd248; sine_lut[79]  = 8'd246;
        sine_lut[80]  = 8'd245; sine_lut[81]  = 8'd244; sine_lut[82]  = 8'd243; sine_lut[83]  = 8'd241;
        sine_lut[84]  = 8'd240; sine_lut[85]  = 8'd239; sine_lut[86]  = 8'd237; sine_lut[87]  = 8'd235;
        sine_lut[88]  = 8'd234; sine_lut[89]  = 8'd232; sine_lut[90]  = 8'd230; sine_lut[91]  = 8'd228;
        sine_lut[92]  = 8'd226; sine_lut[93]  = 8'd224; sine_lut[94]  = 8'd222; sine_lut[95]  = 8'd220;
        sine_lut[96]  = 8'd218; sine_lut[97]  = 8'd216; sine_lut[98]  = 8'd213; sine_lut[99]  = 8'd211;
        sine_lut[100] = 8'd209; sine_lut[101] = 8'd206; sine_lut[102] = 8'd204; sine_lut[103] = 8'd201;
        sine_lut[104] = 8'd199; sine_lut[105] = 8'd196; sine_lut[106] = 8'd193; sine_lut[107] = 8'd191;
        sine_lut[108] = 8'd188; sine_lut[109] = 8'd185; sine_lut[110] = 8'd182; sine_lut[111] = 8'd179;
        sine_lut[112] = 8'd177; sine_lut[113] = 8'd174; sine_lut[114] = 8'd171; sine_lut[115] = 8'd168;
        sine_lut[116] = 8'd165; sine_lut[117] = 8'd162; sine_lut[118] = 8'd159; sine_lut[119] = 8'd156;
        sine_lut[120] = 8'd153; sine_lut[121] = 8'd150; sine_lut[122] = 8'd147; sine_lut[123] = 8'd144;
        sine_lut[124] = 8'd140; sine_lut[125] = 8'd137; sine_lut[126] = 8'd134; sine_lut[127] = 8'd131;
        sine_lut[128] = 8'd128; sine_lut[129] = 8'd125; sine_lut[130] = 8'd122; sine_lut[131] = 8'd119;
        sine_lut[132] = 8'd116; sine_lut[133] = 8'd112; sine_lut[134] = 8'd109; sine_lut[135] = 8'd106;
        sine_lut[136] = 8'd103; sine_lut[137] = 8'd100; sine_lut[138] = 8'd97;  sine_lut[139] = 8'd94;
        sine_lut[140] = 8'd91;  sine_lut[141] = 8'd88;  sine_lut[142] = 8'd85;  sine_lut[143] = 8'd82;
        sine_lut[144] = 8'd79;  sine_lut[145] = 8'd77;  sine_lut[146] = 8'd74;  sine_lut[147] = 8'd71;
        sine_lut[148] = 8'd68;  sine_lut[149] = 8'd65;  sine_lut[150] = 8'd63;  sine_lut[151] = 8'd60;
        sine_lut[152] = 8'd57;  sine_lut[153] = 8'd55;  sine_lut[154] = 8'd52;  sine_lut[155] = 8'd50;
        sine_lut[156] = 8'd47;  sine_lut[157] = 8'd45;  sine_lut[158] = 8'd43;  sine_lut[159] = 8'd40;
        sine_lut[160] = 8'd38;  sine_lut[161] = 8'd36;  sine_lut[162] = 8'd34;  sine_lut[163] = 8'd32;
        sine_lut[164] = 8'd30;  sine_lut[165] = 8'd28;  sine_lut[166] = 8'd26;  sine_lut[167] = 8'd24;
        sine_lut[168] = 8'd22;  sine_lut[169] = 8'd21;  sine_lut[170] = 8'd19;  sine_lut[171] = 8'd17;
        sine_lut[172] = 8'd16;  sine_lut[173] = 8'd15;  sine_lut[174] = 8'd13;  sine_lut[175] = 8'd12;
        sine_lut[176] = 8'd11;  sine_lut[177] = 8'd10;  sine_lut[178] = 8'd8;   sine_lut[179] = 8'd7;
        sine_lut[180] = 8'd6;   sine_lut[181] = 8'd6;   sine_lut[182] = 8'd5;   sine_lut[183] = 8'd4;
        sine_lut[184] = 8'd3;   sine_lut[185] = 8'd3;   sine_lut[186] = 8'd2;   sine_lut[187] = 8'd2;
        sine_lut[188] = 8'd2;   sine_lut[189] = 8'd1;   sine_lut[190] = 8'd1;   sine_lut[191] = 8'd1;
        sine_lut[192] = 8'd1;   sine_lut[193] = 8'd1;   sine_lut[194] = 8'd1;   sine_lut[195] = 8'd1;
        sine_lut[196] = 8'd2;   sine_lut[197] = 8'd2;   sine_lut[198] = 8'd2;   sine_lut[199] = 8'd3;
        sine_lut[200] = 8'd3;   sine_lut[201] = 8'd4;   sine_lut[202] = 8'd5;   sine_lut[203] = 8'd6;
        sine_lut[204] = 8'd6;   sine_lut[205] = 8'd7;   sine_lut[206] = 8'd8;   sine_lut[207] = 8'd10;
        sine_lut[208] = 8'd11;  sine_lut[209] = 8'd12;  sine_lut[210] = 8'd13;  sine_lut[211] = 8'd15;
        sine_lut[212] = 8'd16;  sine_lut[213] = 8'd17;  sine_lut[214] = 8'd19;  sine_lut[215] = 8'd21;
        sine_lut[216] = 8'd22;  sine_lut[217] = 8'd24;  sine_lut[218] = 8'd26;  sine_lut[219] = 8'd28;
        sine_lut[220] = 8'd30;  sine_lut[221] = 8'd32;  sine_lut[222] = 8'd34;  sine_lut[223] = 8'd36;
        sine_lut[224] = 8'd38;  sine_lut[225] = 8'd40;  sine_lut[226] = 8'd43;  sine_lut[227] = 8'd45;
        sine_lut[228] = 8'd47;  sine_lut[229] = 8'd50;  sine_lut[230] = 8'd52;  sine_lut[231] = 8'd55;
        sine_lut[232] = 8'd57;  sine_lut[233] = 8'd60;  sine_lut[234] = 8'd63;  sine_lut[235] = 8'd65;
        sine_lut[236] = 8'd68;  sine_lut[237] = 8'd71;  sine_lut[238] = 8'd74;  sine_lut[239] = 8'd77;
        sine_lut[240] = 8'd79;  sine_lut[241] = 8'd82;  sine_lut[242] = 8'd85;  sine_lut[243] = 8'd88;
        sine_lut[244] = 8'd91;  sine_lut[245] = 8'd94;  sine_lut[246] = 8'd97;  sine_lut[247] = 8'd100;
        sine_lut[248] = 8'd103; sine_lut[249] = 8'd106; sine_lut[250] = 8'd109; sine_lut[251] = 8'd112;
        sine_lut[252] = 8'd116; sine_lut[253] = 8'd119; sine_lut[254] = 8'd122; sine_lut[255] = 8'd125;
   

    // Continue populating up to sine_lut[255] with symmetry for the full 256 samples.
end


        // Populate sine LUT here up to sine_lut[255]


    // Phase accumulator and phase offset addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            phase_acc <= 32'd0;
				phase_acc_non_mod <= 32'd0; 
				end
        else  begin
            phase_acc <= phase_acc + freq_control + {phase_offset, 29'd0}; // Add phase offset for 8-PSK
				phase_acc_non_mod <= phase_acc_non_mod + freq_control; // For non-modulated signal, no offset
				 
    end 
	 end

    // Output sine value based on phase accumulator MSBs
    always @(posedge clk) begin
        sine_out <= sine_lut[phase_acc[31:24]];
		  sine_out_2 <= sine_lut[phase_acc_non_mod[31:24]];
		   // Use top 8 bits to index LUT
    end

endmodule