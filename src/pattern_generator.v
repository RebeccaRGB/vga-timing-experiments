module pattern_generator(
	input wire [11:0] hpos,
	input wire [11:0] vpos,
	input wire [4:0] pattern,
	input wire [5:0] color_in,
	output reg [5:0] color_out
);

	always @(*)
	begin
		case (pattern)
			5'd0: color_out = color_in; // solid color

			5'd1: color_out = (hpos[0] ^ vpos[0]) ? (color_in ^ 6'b111111) : color_in; // 1x1 checker
			5'd2: color_out = (hpos[1] ^ vpos[1]) ? (color_in ^ 6'b111111) : color_in; // 2x2 checker
			5'd3: color_out = (hpos[2] ^ vpos[2]) ? (color_in ^ 6'b111111) : color_in; // 4x4 checker
			5'd4: color_out = (hpos[3] ^ vpos[3]) ? (color_in ^ 6'b111111) : color_in; // 8x8 checker
			5'd5: color_out = (hpos[4] ^ vpos[4]) ? (color_in ^ 6'b111111) : color_in; // 16x16 checker
			5'd6: color_out = (hpos[5] ^ vpos[5]) ? (color_in ^ 6'b111111) : color_in; // 32x32 checker
			5'd7: color_out = (hpos[6] ^ vpos[6]) ? (color_in ^ 6'b111111) : color_in; // 64x64 checker

			5'd8: color_out = (hpos[2:0] == 0 || hpos[2:0] == 3'b111 || vpos[2:0] == 0 || vpos[2:0] == 3'b111) ? (color_in ^ 6'b111111) : color_in; // 8x8 grid
			5'd9: color_out = (hpos[3:0] == 0 || hpos[3:0] == 4'b1111 || vpos[3:0] == 0 || vpos[3:0] == 4'b1111) ? (color_in ^ 6'b111111) : color_in; // 16x16 grid
			5'd10: color_out = (hpos[4:0] == 0 || hpos[4:0] == 5'b11111 || vpos[4:0] == 0 || vpos[4:0] == 5'b11111) ? (color_in ^ 6'b111111) : color_in; // 32x32 grid
			5'd11: color_out = (hpos[5:0] == 0 || hpos[5:0] == 6'b111111 || vpos[5:0] == 0 || vpos[5:0] == 6'b111111) ? (color_in ^ 6'b111111) : color_in; // 64x64 grid

			5'd12: color_out = {vpos[2], hpos[2], vpos[1:0], hpos[1:0]}; // 1x1 color blocks
			5'd13: color_out = {vpos[3], hpos[3], vpos[2:1], hpos[2:1]}; // 2x2 color blocks
			5'd14: color_out = {vpos[4], hpos[4], vpos[3:2], hpos[3:2]}; // 4x4 color blocks
			5'd15: color_out = {vpos[5], hpos[5], vpos[4:3], hpos[4:3]}; // 8x8 color blocks
			5'd16: color_out = {vpos[6], hpos[6], vpos[5:4], hpos[5:4]}; // 16x16 color blocks
			5'd17: color_out = {vpos[7], hpos[7], vpos[6:5], hpos[6:5]}; // 32x32 color blocks

			5'd18: color_out = hpos[5:0] + vpos[5:0]; // 1x1 color blocks
			5'd19: color_out = hpos[6:1] + vpos[6:1]; // 2x2 color blocks
			5'd20: color_out = hpos[7:2] + vpos[7:2]; // 4x4 color blocks
			5'd21: color_out = hpos[8:3] + vpos[8:3]; // 8x8 color blocks
			5'd22: color_out = hpos[9:4] + vpos[9:4]; // 16x16 color blocks
			5'd23: color_out = hpos[10:5] + vpos[10:5]; // 32x32 color blocks

			5'd24: color_out = hpos[5:0] - vpos[5:0]; // 1x1 color blocks
			5'd25: color_out = hpos[6:1] - vpos[6:1]; // 2x2 color blocks
			5'd26: color_out = hpos[7:2] - vpos[7:2]; // 4x4 color blocks
			5'd27: color_out = hpos[8:3] - vpos[8:3]; // 8x8 color blocks
			5'd28: color_out = hpos[9:4] - vpos[9:4]; // 16x16 color blocks
			5'd29: color_out = hpos[10:5] - vpos[10:5]; // 32x32 color blocks

			5'd30: color_out = {~vpos[6], ~vpos[6], ~vpos[7], ~vpos[7], ~vpos[5], ~vpos[5]}; // horizontal color bars
			5'd31: color_out = {~hpos[6], ~hpos[6], ~hpos[7], ~hpos[7], ~hpos[5], ~hpos[5]}; // vertical color bars
		endcase
	end

endmodule
