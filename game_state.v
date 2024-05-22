module game_state(
input clk,
input reset,
input start,
input stop,
input remove,
input game_over,
input done,
//output reg curr_state,
output reg new_en,
output reg move_en,
output reg transform_en,
output reg remove_en,
output reg clear_en,
output reg [1:0] time_up
);

	parameter S_READY = 4'b0000,
				 S_WAIT = 4'b0001,
				 S_NEW = 4'b0010,
				 S_MOVE = 4'b0011,
//				 S_IFSTOP = 4'b0011,
				 S_STOP = 4'b0100,
				 S_IFREMOVE = 4'b0101,
				 S_REMOVE = 4'b0110,
				 S_OVER = 4'b0111,
				 S_CLEAR = 4'b1000,
				 S_FINISH = 4'b1001;

	
	reg [3:0] curr_state, next_state;
	
	reg [1:0] counter;
		
always@(*)
begin
	case(curr_state)
		S_READY: begin
					if(reset)
						next_state <= S_READY;
					else if (start)
						next_state <= S_WAIT;
					else
					   next_state <= S_READY;
					end		
		S_WAIT:begin
				if(reset)
					next_state <= S_READY;
				 else if (time_up == 0)
						next_state <= S_NEW;
				else
						next_state <= S_WAIT;
					end
		S_NEW: begin
				 if(reset)
						next_state <= S_READY;
				 else
						next_state <= S_MOVE;
					end
		S_MOVE: begin
				 if(reset)
						next_state <= S_READY;
					else if (stop)
						next_state <= S_STOP;
					else 
						next_state <= S_MOVE;
					end
//		S_IFSTOP: begin
//					if(reset)
//						next_state <= S_READY;
//					else if (stop)
//						next_state <= S_STOP;
//					else 
//						next_state <= S_MOVE;
//					end
		S_STOP: begin
				  if(reset)
						next_state <= S_READY;
				  else
						next_state <= S_IFREMOVE;
				  end
		S_IFREMOVE: begin
					  if(reset)
							next_state <= S_READY;
					  else if (remove)
							next_state <= S_REMOVE;
						else if (game_over)
							next_state <= S_OVER;
						else
							next_state <= S_NEW;
					  end
		S_REMOVE: begin
				  if(reset)
						next_state <= S_READY;
				  else if (remove)
						next_state <= S_REMOVE;
					else if (game_over)
						next_state <= S_OVER;
					else
						next_state <= S_NEW;
				  end
		S_OVER:begin
				  if(reset)
						next_state <= S_READY;
				  else
						next_state <= S_CLEAR;
				  end
		S_CLEAR: begin
				  if(reset)
						next_state <= S_READY;
				  else if(done)
						next_state <= S_FINISH;
				  else
						next_state <= S_CLEAR;
				  end
		S_FINISH:
				  begin
				  if(reset)
						next_state <= S_READY;
				  else if(start)
						next_state <= S_NEW;
				  else
						next_state <= S_FINISH;
				  end
		default: next_state <= S_READY;
		
	endcase
end

always@(*)
begin
new_en = 0;
move_en = 0;
transform_en = 0;
remove_en = 0;
clear_en = 0;


 case(curr_state)
//	 S_READY:
	 S_NEW: new_en = 1;
	 S_MOVE: move_en = 1;
//	 S_IFSTOP:
	 S_STOP: transform_en = 1;
	 S_REMOVE: remove_en = 1;
//	 S_OVER:
	 S_CLEAR: clear_en = 1;

	 
	 default:
	 begin
		new_en = 0;
		move_en = 0;
		transform_en = 0;
		remove_en = 0;
		clear_en = 0;
		end


	endcase

end


always@(negedge clk, posedge reset)
begin
	if(reset)
	begin
		time_up <= 2'd0;
		counter <= 0;
		end
	else if (start)
	begin
		time_up <= 2'd3;
		counter <= 0;
	end
	else if(curr_state == S_WAIT)
	begin
		if (counter == 2'd3)
		begin
			counter <= 0;
			time_up <= time_up - 1;
			end
		else
		begin
		counter <= counter + 1;
		time_up <= time_up;
		end
	end
end		


always@(posedge clk, posedge reset)
begin
	if (reset)
		curr_state <= S_READY;
	else
		curr_state <= next_state;
end



endmodule
