module onscreen
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		SW,
//		rotate, 
//		left, 
//		right,
		LEDR,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		KEY,							// On Board Keys
		PS2_CLK,
		PS2_DAT,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,
		FPGA_I2C_SDAT,

		// Outputs
		AUD_XCK,
		AUD_DACDAT,
		FPGA_I2C_SCLK
	);

	
	
	DE1_SoC_Audio_Example hahaha(
		// Inputs
		CLOCK_50,
		KEY,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		FPGA_I2C_SDAT,

		// Outputs
		AUD_XCK,
		AUD_DACDAT,

		FPGA_I2C_SCLK,
		SW
	);


	input				AUD_ADCDAT;

	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;
	output				FPGA_I2C_SCLK;
	
	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;	
	input [9:0] SW;
//	input rotate;
//	input left;
//	input right;
	
	inout	PS2_CLK;
	inout	PS2_DAT;
	
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;

	
	output [1:0] LEDR;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	wire black;
//	wire [3:0] xycood;
//	wire [2:0] col;
//	assign iplot = KEY[1];
//	assign plot = !iplot;
//	assign iblack = KEY[2];
	assign black = SW[9];
//	assign iload = KEY[3];
//	assign load = !iload;
//	assign xycood = SW[5:0];
//	assign col = SW[9:7];
	 //assign done = LEDR[0];
 wire [9:0] bg_0;
 wire [9:0] bg_1;
 wire [9:0] bg_2;
 wire [9:0] bg_3;
 wire [9:0] bg_4;
 wire [9:0] bg_5;
 wire [9:0] bg_6;
 wire [9:0] bg_7;
 wire [9:0] bg_8;
 wire [9:0] bg_9;
 wire [9:0] bg_10;
 wire [9:0] bg_11;
 wire [9:0] bg_12;
 wire [9:0] bg_13;
 wire [9:0] bg_14;
 wire [9:0] bg_15;
 wire [9:0] bg_16;
 wire [9:0] bg_17;
 wire [9:0] bg_18;
 wire [9:0] bg_19;
 wire [9:0] bg_20;
 wire [9:0] bg_21;
 wire [9:0] bg_22;
 
// assign bg_0  = 10'b0000100000;
// assign bg_1  = 10'b0000100000;
// assign bg_2  = 10'b0000100000;
// assign bg_3  = 10'b0000100000;
// assign bg_4  = 10'b0000100000;
// assign bg_5  = 10'b0000100000;
// assign bg_6  = 10'b0000100000;
// assign bg_7  = 10'b0000100000;
// assign bg_8  = 10'b0000100000;
// assign bg_9  = 10'b0000100000;
// assign bg_10 = 10'b0000100000;
// assign bg_11 = 10'b0000100000;
// assign bg_12 = 10'b0000100000;
// assign bg_13 = 10'b0000100000;
// assign bg_14 = 10'b0000100000;
// assign bg_15 = 10'b0000100000;
// assign bg_16 = 10'b0000100000;
// assign bg_17 = 10'b0000100000;
// assign bg_18 = 10'b0000100000;
// assign bg_19 = 10'b0000100000;
// assign bg_20 = 10'b0000100000;
// assign bg_21 = 10'b0000100000;
// assign bg_22 = 10'b0000100000;

	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
   wire [3:0] score;
   wire [3:0] time_up;
 wire [3:0] x_pos;
 wire [4:0] y_pos;
 wire [4:0] block_type;
 wire [7:0] y_transfer;
wire [7:0] block;
assign y_transfer = {3'b000, y_pos};
assign block = {3'b000, block_type};
//wire game_over;

	

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
vga_adapter START(
		.resetn(resetn),
		.clock(CLOCK_50),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(writeEn),
		/* Signals for the DAC to drive the monitor. */
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK));
	defparam START.RESOLUTION = "160x120";
	defparam START.MONOCHROME = "FALSE";
	defparam START.BITS_PER_COLOUR_CHANNEL = 1;
	defparam START.BACKGROUND_IMAGE = "tetris_vga_3bit.mif";
	
//vga_adapter OVER(
//		.resetn(resetn),
//		.clock(CLOCK_50),
//		.colour(colour),
//		.x(x),
//		.y(y),
//		.plot(game_over),
//		/* Signals for the DAC to drive the monitor. */
//		.VGA_R(VGA_R),
//		.VGA_G(VGA_G),
//		.VGA_B(VGA_B),
//		.VGA_HS(VGA_HS),
//		.VGA_VS(VGA_VS),
//		.VGA_BLANK(VGA_BLANK_N),
//		.VGA_SYNC(VGA_SYNC_N),
//		.VGA_CLK(VGA_CLK));
//	defparam OVER.RESOLUTION = "160x120";
//	defparam OVER.MONOCHROME = "FALSE";
//	defparam OVER.BITS_PER_COLOUR_CHANNEL = 1;
//	defparam OVER.BACKGROUND_IMAGE = "game_over_vga_3bit.mif";


	 
justvgadisplay b1(resetn, black, CLOCK_50,
	bg_0,
	bg_1,
	bg_2,
	bg_3,
	bg_4,
	bg_5,
	bg_6,
	bg_7,
	bg_8,
	bg_9,
	bg_10,
	bg_11,
	bg_12,
	bg_13,
	bg_14,
	bg_15,
	bg_16,
	bg_17,
	bg_18,
	bg_19,
	bg_20,
	bg_21,
	bg_22,
x,y,colour, writeEn);

demo_top d2(
CLOCK_50,
KEY[3:0],
SW[9:0],
//rotate,
//left,
//right,

PS2_CLK,
PS2_DAT,

score,
x_pos,
y_pos,
block_type,
time_up,
//game_over,
bg_0,
bg_1,
bg_2,
bg_3,
bg_4,
bg_5,
bg_6,
bg_7,
bg_8,
bg_9,
bg_10,
bg_11,
bg_12,
bg_13,
bg_14,
bg_15,
bg_16,
bg_17,
bg_18,
bg_19,
bg_20,
bg_21,
bg_22

);

hex_decoder h0(score, HEX0);
hex_decoder h1(y_transfer[3:0], HEX1);
hex_decoder h2(y_transfer[7:4], HEX2);
hex_decoder h3(x_pos, HEX3);
//hex_decoder h4(block[3:0], HEX4);
//hex_decoder h5(block[7:4], HEX5);
hex_decoder h5(time_up, HEX5);

	
endmodule

