module datapath(
	input clk,
	input reset,
	input start,
	input new_en,
	input move_en,
	input checkgame_en,
	input remove_en,
	input clear_en,
	input left,
	input right,
	input rotate,
//	input down_en,
	input [4:0] seed,
	output reg [4:0] block_type,
	//10 columns
	output reg [3:0] x_pos,
	//23 rows
	output reg [4:0] y_pos,
	output reg stop_en,
	output reg game_over,
	output reg remove,
	output reg done,
	output reg [3:0] score,
	output wire [9:0] bg_0,
	output wire [9:0] bg_1,
	output wire [9:0] bg_2,
	output wire [9:0] bg_3,
	output wire [9:0] bg_4,
	output wire [9:0] bg_5,
	output wire [9:0] bg_6,
	output wire [9:0] bg_7,
	output wire [9:0] bg_8,
	output wire [9:0] bg_9,
	output wire [9:0] bg_10,
	output wire [9:0] bg_11,
	output wire [9:0] bg_12,
	output wire [9:0] bg_13,
	output wire [9:0] bg_14,
	output wire [9:0] bg_15,
	output wire [9:0] bg_16,
	output wire [9:0] bg_17,
	output wire [9:0] bg_18,
	output wire [9:0] bg_19,
	output wire [9:0] bg_20,
	output wire [9:0] bg_21,
	output wire [9:0] bg_22
	
);
	parameter O_1 = 5'b00000,
				 Z_1 = 5'b00001,
				 Z_2 = 5'b00010,
				 S_1 = 5'b00011,
				 S_2 = 5'b00100,
				 J_1 = 5'b00101,
				 J_2 = 5'b00110,
				 J_3 = 5'b00111,
				 J_4 = 5'b01000,
				 L_1 = 5'b01001,
				 L_2 = 5'b01010,
				 L_3 = 5'b01011,
				 L_4 = 5'b01100,
				 T_1 = 5'b01101,
				 T_2 = 5'b01110,
				 T_3 = 5'b01111,
				 T_4 = 5'b10000,
				 I_1 = 5'b10001,
				 I_2 = 5'b10010;

	reg left_en, right_en, rotate_en, score_en;
	reg [9:0] bg [22:0];
	reg [4:0] next_block;
	reg left_carry, right_carry, rotate_carry;
	
	 assign bg_0 = bg[0];
	 assign bg_1 = bg[1];
	 assign bg_2 = bg[2];
	 assign bg_3 = bg[3];
	 assign bg_4 = bg[4];
	 assign bg_5 = bg[5];
	 assign bg_6 = bg[6];
	 assign bg_7 = bg[7];
	 assign bg_8 = bg[8];
	 assign bg_9 = bg[9];
	 assign bg_10 = bg[10];
	 assign bg_11 = bg[11];
	 assign bg_12 = bg[12];
	 assign bg_13 = bg[13];
	 assign bg_14 = bg[14];
	 assign bg_15 = bg[15];
	 assign bg_16 = bg[16];
	 assign bg_17 = bg[17];
	 assign bg_18 = bg[18];
	 assign bg_19 = bg[19];
	 assign bg_20 = bg[20];
	 assign bg_21 = bg[21];
	 assign bg_22 = bg[22];
	
	
//new_block	
always@(posedge clk, posedge reset)
begin
	if (reset)
		block_type <= O_1;
		else if (new_en)
		begin
		case(seed)
			 5'b00000: block_type <= O_1;
			 5'b00001: block_type <= Z_1;
			 5'b00010: block_type <= Z_2;
			 5'b00011: block_type <= S_1;
			 5'b00100: block_type <= S_2;
			 5'b00101: block_type <= J_1;
			 5'b00110: block_type <= J_2;
			 5'b00111: block_type <= J_3;
			 5'b01000: block_type <= J_4;
			 5'b01001: block_type <= L_1;
			 5'b01010: block_type <= L_2;
			 5'b01011: block_type <= L_3;
			 5'b01100: block_type <= L_4;
			 5'b01101: block_type <= T_1;
			 5'b01110: block_type <= T_2;
			 5'b01111: block_type <= T_3;
			 5'b10000: block_type <= T_4;
			 5'b10001: block_type <= I_1;
			 5'b10010: block_type <= I_2;
			 default: block_type <= O_1;
			 endcase
			 end
			 
		//after rotate
		else if(rotate_carry)
			block_type <= next_block;
			 
		else
		block_type <= block_type;

end



//block_moving
always@(posedge clk, posedge reset)
begin
	if (reset)
	begin
		x_pos <= 4'b0100;
		y_pos <= 5'b00001;
		end
	else if (new_en)
	begin
		x_pos <= 4'b0100;
		y_pos <= 5'b00001;
		end
	
	else if (move_en)
	begin
		if(stop_en)
		begin
			x_pos <= x_pos;
			y_pos <= y_pos;
			end
		else if(left_en)	
		begin
			x_pos <= x_pos - 4'd1;
			y_pos <= y_pos;
			end
			
		else if(right_en)	
		begin
			x_pos <= x_pos + 4'd1;
			y_pos <= y_pos;
			end
			
		else if(rotate_en)	
		begin
			x_pos <= x_pos;
			y_pos <= y_pos;
			end
			
		else
		begin
			x_pos <= x_pos;
			y_pos <= y_pos + 5'd1;
			end
	end
	else
	begin
		x_pos <= x_pos;
		y_pos <= y_pos;
	end
end



//when left
always@(*)
begin
	if(reset)
	left_en = 0;

	else if (move_en && left)
	begin
	case (block_type)	
	O_1: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-4'd1] || bg[y_pos+5'd1][x_pos-4'd1])
				left_en = 0;
			else
				left_en = 1;
		end
   Z_1: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-4'd2] || bg[y_pos+1][x_pos-2] || bg[y_pos-1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
   Z_2: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
   S_1: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos])
				left_en <= 0;
			else
				left_en <= 1;
		end
   S_2: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos-1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
   J_1: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos-2])
				left_en <= 0;
			else
				left_en <= 1;
		end
	J_2: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos+1][x_pos])
				left_en <= 0;
			else
				left_en <= 1;
		end
	J_3: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	J_4: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos-1][x_pos-2])
				left_en <= 0;
			else
				left_en <= 1;
		end
	L_1: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	L_2: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos-1][x_pos])
				left_en <= 0;
			else
				left_en <= 1;
		end
	L_3: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-2] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	L_4: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos+1][x_pos-2])
				left_en <= 0;
			else
				left_en <= 1;
		end
	T_1: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos-1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	T_2: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	T_3: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-2] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	T_4: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	I_1: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-1] || bg[y_pos-1][x_pos-1] || bg[y_pos+1][x_pos-1] || bg[y_pos+2][x_pos-1])
				left_en <= 0;
			else
				left_en <= 1;
		end
	I_2: begin
			if (x_pos<4'd2 || bg[y_pos][x_pos-4'd2])
				left_en <= 0;
			else
				left_en <= 1;
		end
	
	default: left_en <= 0;
	
	endcase
	end
	
	else
	left_en <= 0;
	
end
	
	
	
	
//when right
always@(*)
begin
	if(reset)
	right_en = 0;
	
	else if (move_en && right)
	begin
	case (block_type)	
	O_1: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+2] || bg[y_pos+1][x_pos+2])
				right_en = 0;
			else
				right_en = 1;
		end
   Z_1: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos+1] || bg[y_pos-1][x_pos+1] || bg[y_pos+1][x_pos])
				right_en <= 0;
			else
				right_en <= 1;
		end
		
   Z_2: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+1] || bg[y_pos+1][x_pos+2])
				right_en <= 0;
			else
				right_en <= 1;
		end
		
   S_1: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+2] || bg[y_pos-1][x_pos+1] || bg[y_pos+1][x_pos+2])
				right_en <= 0;
			else
				right_en <= 1;
		end

   S_2: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+1] || bg[y_pos-1][x_pos+2])
				right_en <= 0;
			else
				right_en <= 1;
		end

   J_1: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos+1] || bg[y_pos-1][x_pos+1] || bg[y_pos+1][x_pos+1])
				right_en <= 0;
			else
				right_en <= 1;
		end

	J_2: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+2] || bg[y_pos+1][x_pos+2])
				right_en <= 0;
			else
				right_en <= 1;
		end
	J_3: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+1] || bg[y_pos-1][x_pos+2] || bg[y_pos+1][x_pos+1])
				right_en <= 0;
			else
				right_en <= 1;
		end

	J_4: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+2] || bg[y_pos-1][x_pos])
				right_en <= 0;
			else
				right_en <= 1;
		end
	L_1: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+1] || bg[y_pos-1][x_pos+1] || bg[y_pos+1][x_pos+2])
				right_en <= 0;
			else
				right_en <= 1;
		end

	L_2: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+4'd2] || bg[y_pos-5'd1][x_pos+4'd2])
				right_en <= 0;
			else
				right_en <= 1;
		end
			

	L_3: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos+4'd1] || bg[y_pos-5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				right_en <= 0;
			else
				right_en <= 1;
		end


	L_4: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+4'd2] || bg[y_pos+5'd1][x_pos])
				right_en <= 0;
			else
				right_en <= 1;
		end
			

	T_1: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+4'd2] || bg[y_pos-5'd1][x_pos+4'd1])
				right_en <= 0;
			else
				right_en <= 1;
		end

	T_2: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos+4'd1] || bg[y_pos-5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				right_en <= 0;
			else
				right_en <= 1;
		end

	T_3: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+4'd2] || bg[y_pos+5'd1][x_pos+4'd1])
				right_en <= 0;
			else
				right_en <= 1;
		end
			

	T_4: begin
			if (x_pos>4'd7 || bg[y_pos][x_pos+4'd2] || bg[y_pos-5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				right_en <= 0;
			else
				right_en <= 1;
		end
			

	I_1: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos+4'd1] || bg[y_pos-5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd1] || bg[y_pos+5'd2][x_pos+4'd1])
				right_en <= 0;
			else
				right_en <= 1;
		end

		
		
	I_2: begin
			if (x_pos>4'd6 || bg[y_pos][x_pos+4'd3])
				right_en <= 0;
			else
				right_en <= 1;
		end
		
	
	default: right_en <= 0;
	
	endcase
	end
	
	else
	right_en <= 0;
end
	
	
	
	
//when rotate
always@(*)
begin
	if(reset)
	rotate_en <= 0;
	
	else if(move_en && rotate)
	begin
	case(block_type)
	O_1: rotate_en <= 0;
	
	Z_1: begin
			if (x_pos>4'd8 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
		
	Z_2: begin
			if (bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos-5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	S_1: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-4'd1] || bg[y_pos-5'd1][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	S_2: begin
			if (bg[y_pos+5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	J_1: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos-4'd1] || bg[y_pos][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	J_2: begin
			if (bg[y_pos-5'd1][x_pos] || bg[y_pos-5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	J_3: begin
			if (x_pos<4'd1 || bg[y_pos-5'd1][x_pos-4'd1] || bg[y_pos][x_pos-4'd1] || bg[y_pos][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	J_4: begin
			if (bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos-5'd1][x_pos] || bg[y_pos+5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	L_1: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-4'd1] || bg[y_pos][x_pos+4'd1] || bg[y_pos-5'd1][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	L_2: begin
			if (bg[y_pos-5'd1][x_pos-4'd1] || bg[y_pos-5'd1][x_pos] || bg[y_pos+5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	L_3: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos-4'd1] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	L_4: begin
			if (bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos+4'd1] || bg[y_pos-5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	T_1: begin
			if (bg[y_pos+5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	T_2: begin
			if (x_pos>4'd8 || bg[y_pos][x_pos+4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	T_3: begin
			if (bg[y_pos-5'd1][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	T_4: begin
			if (x_pos<4'd1 || bg[y_pos][x_pos-4'd1])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	I_1: begin
			if (x_pos<4'd1 || x_pos>4'd7 || bg[y_pos][x_pos-4'd1] || bg[y_pos][x_pos+4'd1] || bg[y_pos][x_pos+4'd2])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	I_2: begin
			if (y_pos>5'd20 || bg[y_pos-5'd1][x_pos] || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd2][x_pos])
				rotate_en <= 0;
			else
				rotate_en <= 1;
		end
	default: rotate_en <= 0;
	endcase
	end

	else
	rotate_en <= 0;
	
end



//block type after rotation
always@(*)
begin

	case(block_type)
	O_1: next_block = O_1;
	Z_1: next_block = Z_2;
	Z_2: next_block = Z_1;
	S_1: next_block = S_2;
	S_2: next_block = S_1;
	J_1: next_block = J_2;
	J_2: next_block = J_3;
	J_3: next_block = J_4;
	J_4: next_block = J_1;
	L_1: next_block = L_2;
	L_2: next_block = L_3;
	L_3: next_block = L_4;
	L_4: next_block = L_1;
	T_1: next_block = T_2;
	T_2: next_block = T_3;
	T_3: next_block = T_4;
	T_4: next_block = T_1;
	I_1: next_block = I_2;
	I_2: next_block = I_1;
	default: next_block = O_1;
	endcase


end



//check stop
always@(*)
begin

if(reset)
	stop_en = 0;
	else if (rotate_carry == 0)
	begin
	case(block_type)
		O_1: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd2][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
   	Z_1: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd2][x_pos-4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		Z_2: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd2][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		S_1: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd2][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		S_2: begin
			if (y_pos == 5'd22 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		J_1: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd2][x_pos-4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		J_2: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd2][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		J_3: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		J_4: begin
			if (y_pos == 5'd22 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		L_1: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd2][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		L_2: begin
			if (y_pos == 5'd22 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		L_3: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos][x_pos-4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		L_4: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd2][x_pos-4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		T_1: begin
			if (y_pos == 5'd22 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		T_2: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd1][x_pos-4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		T_3: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd1][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
		T_4: begin
			if (y_pos == 5'd21 || bg[y_pos+5'd2][x_pos] || bg[y_pos+5'd1][x_pos+4'd1])
				stop_en = 1;
			else
				stop_en = 0;
		end
   	I_1: begin
			if (y_pos == 5'd20 || bg[y_pos+5'd3][x_pos])
				stop_en = 1;
			else
				stop_en = 0;
		end
   	I_2: begin
			if (y_pos == 5'd22 || bg[y_pos+5'd1][x_pos] || bg[y_pos+5'd1][x_pos-4'd1] || bg[y_pos+5'd1][x_pos+4'd1] || bg[y_pos+5'd1][x_pos+4'd2])
				stop_en = 1;
			else
				stop_en = 0;
		end
		
		default: stop_en = 0;
		endcase
	end
	else
		stop_en = 0;
end






always @(posedge clk)
begin
	if (reset)
	begin
		left_carry <= 0;
		right_carry <= 0;
		rotate_carry <= 0;
	end
	 else if (left_en)
	 begin
		left_carry <= 1;
		right_carry <= 0;
		rotate_carry <= 0;
	end
	 else if (right_en)
	 begin
		left_carry <= 0;
		right_carry <= 1;
		rotate_carry <= 0;
	end
	 else if (rotate_en)
	 begin
		left_carry <= 0;
		right_carry <= 0;
		rotate_carry <= 1;
	end
	else
	 begin
		left_carry <= 0;
		right_carry <= 0;
		rotate_carry <= 0;
	end

end
//after stop
integer i, j, k;

always@(posedge clk, posedge reset)
begin
	if(reset)
	
	begin
	done <= 0;
	score_en <= 0;
		
		for(i=0; i<=22; i=i+1)
		begin
			for(j=0; j<=9; j=j+1)
			bg [i][j] <= 0;
			end
		end
		
		
		else if(remove_en)
		begin
		done = 0;
		if(&bg[5])
			begin
			for (k=5; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[6])
			begin
			for (k=6; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[7])
			begin
			for (k=7; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[8])
			begin
			for (k=8; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[9])
			begin
			for (k=9; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[10])
			begin
			for (k=10; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[11])
			begin
			for (k=11; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[12])
			begin
			for (k=12; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[13])
			begin
			for (k=13; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[14])
			begin
			for (k=14; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[15])
			begin
			for (k=15; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[16])
			begin
			for (k=16; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[17])
			begin
			for (k=17; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[18])
			begin
			for (k=18; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[19])
			begin
			for (k=19; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[20])
			begin
			for (k=20; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[21])
			begin
			for (k=21; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end
		else if(&bg[22])
			begin
			for (k=22; k>=4; k=k-1)
			begin
				bg[k] = bg[k-1];
				end
			score_en <= 1;
			end

		else if(clear_en)
		begin
			done <= 1;
			score_en <= 0;
			for(i=0; i<=22; i=i+1)
			begin
				for(j=0; j<=9; j=j+1)
				bg [i][j] <= 0;
				end
			end
		end
		//
		else if (move_en)
		begin
		done <= 0;
		score_en <= 0;
		case (block_type)
		O_1: begin
				for(i=0; i<=22; i=i+1)
				begin
					for(j=0; j<=9; j=j+1)
					begin
					if((i == y_pos && j == x_pos)||(i == y_pos+5'd1 && j == x_pos)||(i == y_pos && j == x_pos+4'd1)||(i == y_pos+5'd1 && j == x_pos+4'd1))
					begin
					bg [i][j] <= 1;
					end
					else if (left_carry &&((i == y_pos && j == x_pos+4'd2)||(i == y_pos+5'd1 && j == x_pos+4'd2)))
						begin
							bg [i][j] <= 0;
						end
					else if (right_carry &&((i == y_pos && j == x_pos-4'd1)||(i == y_pos+5'd1 && j == x_pos-4'd1)))
					begin
							bg [i][j] <= 0;
						end
					else if (left_carry == 0 && right_carry == 0 && ((i == y_pos-5'd1 && j == x_pos)||(i == y_pos-5'd1 && j == x_pos+4'd1)))
						bg [i][j] <= 0;
					else
						bg [i][j] <= bg [i][j];
						
					end
				end

			  end
	   Z_1: begin
				for(i=0; i<=22; i=i+1)
				begin
					for(j=0; j<=9; j=j+1)
					begin
					if (rotate_carry &&((i == y_pos && j == x_pos)||(i == y_pos && j == x_pos-4'd1)||(i == y_pos+5'd1 && j == x_pos)||(i == y_pos+5'd1 && j == x_pos+4'd1)))
						bg [i][j] <= 1;
					else if (rotate_carry &&((i == y_pos-5'd1 && j == x_pos)||(i == y_pos+5'd1 && j == x_pos-4'b1)))
						bg [i][j] <= 0;
					else if((i == y_pos && j == x_pos)||(i == y_pos-5'd1 && j == x_pos)||(i == y_pos && j == x_pos-4'd1)||(i == y_pos+5'd1 && j == x_pos-4'd1))
						bg [i][j] <= 1;
					else if (left_carry &&((i == y_pos-5'd1 && j == x_pos+4'd1)||(i == y_pos && j == x_pos+4'd1)||(i == y_pos+5'd1 && j == x_pos)))
						begin
							bg [i][j] <= 0;
						end
					else if (right_carry &&((i == y_pos-5'd1 && j == x_pos-4'd1)||(i == y_pos+5'd1 && j == x_pos-4'd2)||(i == y_pos && j == x_pos-4'd2)))
					begin
							bg [i][j] <= 0;
						end
					
					else if (left_carry == 0 && right_carry == 0 && rotate_carry == 0 && ((i == y_pos-5'd2 && j == x_pos) || (i == y_pos-5'd1 && j == x_pos-4'd1)))
						bg [i][j] <= 0;
					else
						bg [i][j] <= bg [i][j];
						
					end
				end

			  end
	   Z_2: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos+1][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos+1][x_pos+1] = 1;
			  end
	   S_1: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos][x_pos+1] = 1;
				bg [y_pos+1][x_pos+1] = 1;
			  end
	   S_2: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos-1][x_pos+1] = 1;
				bg [y_pos][x_pos-1] = 1;
			  end
	   J_1: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos+1][x_pos] = 1;
				bg [y_pos+1][x_pos-1] = 1;
			  end
	   J_2: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos][x_pos+1] = 1;
				bg [y_pos+1][x_pos+1] = 1;
			  end
	   J_3: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos+1][x_pos] = 1;
				bg [y_pos-1][x_pos+1] = 1;
			  end
	   J_4: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos][x_pos+1] = 1;
				bg [y_pos-1][x_pos-1] = 1;
			  end
	   L_1: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos+1][x_pos] = 1;
				bg [y_pos+1][x_pos+1] = 1;
			  end
	   L_2: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos+1] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos][x_pos+1] = 1;
			  end
	   L_3: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos+1][x_pos] = 1;
				bg [y_pos-1][x_pos-1] = 1;
			  end
	   L_4: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos][x_pos+1] = 1;
				bg [y_pos+1][x_pos-1] = 1;
			  end
	   T_1: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos][x_pos+1] = 1;
			  end
	   T_2: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos+1][x_pos] = 1;
			  end
	   T_3: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos][x_pos-1] = 1;
				bg [y_pos][x_pos+1] = 1;
				bg [y_pos+1][x_pos] = 1;
			  end
	   T_4: begin
				bg [y_pos][x_pos] = 1;
				bg [y_pos-1][x_pos] = 1;
				bg [y_pos+1][x_pos] = 1;
				bg [y_pos][x_pos+1] = 1;
			  end
	   I_1: begin
				for(i=0; i<=22; i=i+1)
				begin
					for(j=0; j<=9; j=j+1)
					begin
					if (rotate_carry &&((i == y_pos && j == x_pos)||(i == y_pos && j == x_pos-4'd1)||(i == y_pos && j == x_pos+4'd1)||(i == y_pos && j == x_pos+4'd2)))
						bg [i][j] <= 1;
					else if (rotate_carry &&((i == y_pos-5'd1 && j == x_pos)||(i == y_pos+5'd1 && j == x_pos)||(i == y_pos+5'd2 && j == x_pos)))
						bg [i][j] <= 0;
					else if((i == y_pos && j == x_pos)||(i == y_pos-5'd1 && j == x_pos)||(i == y_pos+5'd1 && j == x_pos)||(i == y_pos+5'd2 && j == x_pos))
					bg [i][j] <= 1;
					else if (left_carry &&((i == y_pos && j == x_pos+4'd1)||(i == y_pos-5'd1 && j == x_pos+4'd1)||(i == y_pos+5'd1 && j == x_pos+4'd1)||(i == y_pos+5'd2 && j == x_pos+4'd1)))
						begin
							bg [i][j] <= 0;
						end
					else if (right_carry &&((i == y_pos && j == x_pos-4'd1)||(i == y_pos-5'd1 && j == x_pos-4'd1)||(i == y_pos+5'd1 && j == x_pos-4'd1)||(i == y_pos+5'd2 && j == x_pos-4'd1)))
					begin
							bg [i][j] <= 0;
						end
					
					else if (left_carry == 0 && right_carry == 0 && rotate_carry == 0 && (i == y_pos-5'd2 && j == x_pos))
						bg [i][j] <= 0;
					else
						bg [i][j] <= bg [i][j];
						
					end
				end
			  end
	   I_2: begin
				for(i=0; i<=22; i=i+1)
				begin
					for(j=0; j<=9; j=j+1)
					begin
					if (rotate_carry &&((i == y_pos && j == x_pos-4'd1)||(i == y_pos && j == x_pos+4'd1)||(i == y_pos && j == x_pos+4'd2)))
						bg [i][j] <= 0;
					else if (rotate_carry &&((i == y_pos && j == x_pos)||(i == y_pos-5'd1 && j == x_pos)||(i == y_pos+5'd1 && j == x_pos)||(i == y_pos+5'd2 && j == x_pos)))
						bg [i][j] <= 1;
					else if((i == y_pos && j == x_pos)||(i == y_pos && j == x_pos-4'd1)||(i == y_pos && j == x_pos+4'd1)||(i == y_pos && j == x_pos+4'd2))
						bg [i][j] <= 1;
					else if (left_carry &&(i == y_pos && j == x_pos+4'd3))
						begin
							bg [i][j] <= 0;
						end
					else if (right_carry &&(i == y_pos && j == x_pos-4'd2))
					begin
							bg [i][j] <= 0;
						end

					else if (left_carry == 0 && right_carry == 0 && rotate_carry == 0 && ((i == y_pos-5'd1 && j == x_pos) || (i == y_pos-5'd1 && j == x_pos-4'd1) || (i == y_pos-5'd1 && j == x_pos+4'd1) || (i == y_pos-5'd1 && j == x_pos+4'd2)))
						bg [i][j] <= 0;
					else
						bg [i][j] <= bg [i][j];
						end
					end
			  end
		default: 
		begin
			for(i=0; i<=22; i=i+1)
			begin
				for(j=0; j<=9; j=j+1)
					bg [i][j] = bg [i][j];
				end
			end

		endcase
		end
		

		else
		begin
			done <= 1;
			score_en <= 0;
			for(i=0; i<=22; i=i+1)
			begin
				for(j=0; j<=9; j=j+1)
					bg [i][j] <= bg [i][j];
				end
			end
		
end


//score
always@(negedge clk, posedge reset)
begin
if (reset)
	score <= 0;
	else if (start)
	score <= 0;
	else if (score_en)
	score <= score+1;
	else 
	score <= score;

end


//game_over
always@(*)
begin
	if(reset)
		game_over = 0;
	else if (checkgame_en && (bg[3] != 10'b0))
		game_over = 1;
	else
		game_over = game_over;
end



//ifremove
always@(*)
begin
	if(reset)
		remove = 0;
	else if (stop_en &&(&bg[4] || &bg[5] || &bg[6] || &bg[7] || &bg[8] || &bg[9] || &bg[10] || &bg[11] || &bg[12] || &bg[13] || &bg[14] || &bg[15] || &bg[16] || &bg[17] || &bg[18] || &bg[19] || &bg[20] || &bg[21] || &bg[22]))
		remove = 1;
	 else
		remove = 0;

end




endmodule
		wire [9:0] bg [22:0];
	assign bg[0] = 10'b0000000000;
	assign bg[1] = 10'b0000000000;
	assign bg[2] = 10'b0000000000;
	assign bg[3] = 10'b0000000000;
	assign bg[4] = 10'b0000000000;
	assign bg[5] = 10'b0000000000;
	assign bg[6] = 10'b0000000000;
	assign bg[7] = 10'b0000000000;
	assign bg[8] = 10'b0000000000;
	assign bg[9] = 10'b0000000000;
	assign bg[10] = 10'b0000000000;
	assign bg[11] = 10'b0000000000;
	assign bg[12] = 10'b0000000000;
	assign bg[13] = 10'b0000000000;
	assign bg[14] = 10'b0000000000;
	assign bg[15] = 10'b0000000000;
	assign bg[16] = 10'b0000000000;
	assign bg[17] = 10'b0000000000;
	assign bg[18] = 10'b0000000000;
	assign bg[19] = 10'b0000000001;
	assign bg[20] = 10'b0000000001;
	assign bg[21] = 10'b0000100001;
	assign bg[22] = 10'b0000111001;
