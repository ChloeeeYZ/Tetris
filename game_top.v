module game_top(
//input CLOCK_50,
//input [1:0] KEY,
//input [4:0] SW,

//
//inout	PS2_CLK,
//inout	PS2_DAT,

input clk,
input reset,
input start,
input [4:0] seed,
input left, 
input right, 
input rotate,

output [3:0]score,
output [239:0] bg_out,
output [3:0] time_up,
output wire [3:0] x_pos,
output wire [4:0] y_pos
);





//wire clk, reset;
wire new_en, move_en, transform_en, remove_en, clear_en;
wire [4:0] block_type;
//wire [3:0] x_pos;
//wire [4:0] y_pos;
wire stop;
wire game_over;
wire remove;
wire done;





assign reset = ~KEY[0];

clock_sec c0(CLOCK_50, reset, clk);



ps2_top p0(

	CLOCK_50,
	KEY[0],

	PS2_CLK,
	PS2_DAT,
	
	rotate,
	left,
	right

);


datapath n0(
	clk,
	reset,
	new_en,
	move_en,
	transform_en,
	remove_en,
	clear_en,
	left,
	right,
	rotate,
	seed,
	
	
	
	block_type,
	x_pos,
	y_pos,
	stop,
	game_over,
	remove,
	done,
	score,
	bg_out
);


 game_state g0(
clk,
reset,
start,
stop,
remove,
game_over,
done,
new_en,
move_en,
transform_en,
remove_en,
clear_en,
time_up
);



endmodule

