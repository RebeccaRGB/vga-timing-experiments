module hvsync_generator(
	input wire [11:0] hdisplay,
	input wire [9:0] hfrontporch,
	input wire [9:0] hsynclength,
	input wire [9:0] hbackporch,
	input wire hsyncpolarity,
	input wire [11:0] vdisplay,
	input wire [7:0] vfrontporch,
	input wire [7:0] vsynclength,
	input wire [7:0] vbackporch,
	input wire vsyncpolarity,
	input wire clk,
	input wire reset,
	output reg hsync,
	output reg vsync,
	output wire display,
	output reg [11:0] hpos,
	output reg [11:0] vpos
);

	wire [11:0] hsyncstart = hdisplay + hfrontporch;
	wire [11:0] hsyncend = hdisplay + hfrontporch + hsynclength - 1;
	wire [11:0] hmax = hdisplay + hbackporch + hfrontporch + hsynclength - 1;
	wire [11:0] vsyncstart = vdisplay + vfrontporch;
	wire [11:0] vsyncend = vdisplay + vfrontporch + vsynclength - 1;
	wire [11:0] vmax = vdisplay + vbackporch + vfrontporch + vsynclength - 1;

	wire hmaxxed = (hpos == hmax) || reset;
	wire vmaxxed = (vpos == vmax) || reset;

	always @(posedge clk)
	begin
		hsync <= (hpos >= hsyncstart && hpos <= hsyncend) ^ hsyncpolarity;
		if (hmaxxed) hpos <= 0;
		else hpos <= hpos + 1;
	end

	always @(posedge clk)
	begin
		vsync <= (vpos >= vsyncstart && vpos <= vsyncend) ^ vsyncpolarity;
		if (hmaxxed) begin
			if (vmaxxed) vpos <= 0;
			else vpos <= vpos + 1;
		end
	end

	assign display = (hpos < hdisplay) && (vpos < vdisplay);

endmodule
