/*
 * Copyright (c) 2024 Rebecca G. Bettencourt
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_rebeccargb_vga_timing_experiments (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // VGA timing parameters
  reg [11:0] hdisplay;
  reg [9:0] hfrontporch;
  reg [9:0] hsynclength;
  reg [9:0] hbackporch;
  reg hsyncpolarity;
  reg [11:0] vdisplay;
  reg [7:0] vfrontporch;
  reg [7:0] vsynclength;
  reg [7:0] vbackporch;
  reg vsyncpolarity;

  // VGA signals
  wire hsync;
  wire vsync;
  wire display;
  wire [11:0] hpos;
  wire [11:0] vpos;
  wire [1:0] R;
  wire [1:0] G;
  wire [1:0] B;

  // TinyVGA PMOD
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  // Unused outputs assigned to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Suppress unused signals warning
  wire _unused_ok = &{ena, ui_in, uio_in};

  hvsync_generator hvsync_gen(
    .hdisplay(hdisplay),
    .hfrontporch(hfrontporch),
    .hsynclength(hsynclength),
    .hbackporch(hbackporch),
    .hsyncpolarity(hsyncpolarity),
    .vdisplay(vdisplay),
    .vfrontporch(vfrontporch),
    .vsynclength(vsynclength),
    .vbackporch(vbackporch),
    .vsyncpolarity(vsyncpolarity),
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display(display),
    .hpos(hpos),
    .vpos(vpos)
  );

  reg [4:0] pattern;
  reg [5:0] color_in;
  wire [5:0] color_out;

  pattern_generator pat(
    .hpos(hpos),
    .vpos(vpos),
    .pattern(pattern),
    .color_in(color_in),
    .color_out(color_out)
  );

  assign R = display ? color_out[5:4] : 2'b00;
  assign G = display ? color_out[3:2] : 2'b00;
  assign B = display ? color_out[1:0] : 2'b00;

  always @(posedge ui_in[7])
  begin
    case (ui_in[3:0])
      4'd0: begin
        hdisplay <= 640;
        hfrontporch <= 16;
        hsynclength <= 96;
        hbackporch <= 48;
        hsyncpolarity <= 0;
        vdisplay <= 480;
        vfrontporch <= 10;
        vsynclength <= 2;
        vbackporch <= 33;
        vsyncpolarity <= 0;
        pattern <= 5'd31;
        color_in <= 0;
      end
      4'd1: pattern <= pattern + 1;
      4'd2: pattern <= pattern - 1;
      4'd3: pattern <= uio_in[4:0];
      4'd4: hdisplay <= {1'b0, ui_in[6:4], uio_in};
      4'd5: hfrontporch <= {ui_in[5:4], uio_in};
      4'd6: {hsyncpolarity, hsynclength} <= {ui_in[6], ui_in[5:4], uio_in};
      4'd7: hbackporch <= {ui_in[5:4], uio_in};
      4'd8: vdisplay <= {1'b0, ui_in[6:4], uio_in};
      4'd9: vfrontporch <= uio_in;
      4'd10: {vsyncpolarity, vsynclength} <= {ui_in[6], uio_in};
      4'd11: vbackporch <= uio_in;
      4'd12: color_in <= uio_in[5:0];
      4'd13: color_in <= color_in + 1;
      4'd14: color_in <= color_in - 1;
      4'd15: begin
        hdisplay <= 640;
        hfrontporch <= 16;
        hsynclength <= 96;
        hbackporch <= 48;
        hsyncpolarity <= 0;
        vdisplay <= 480;
        vfrontporch <= 10;
        vsynclength <= 2;
        vbackporch <= 33;
        vsyncpolarity <= 0;
        pattern <= 5'd31;
        color_in <= 0;
      end
    endcase
  end

endmodule
