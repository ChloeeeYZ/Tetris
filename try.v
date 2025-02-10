reg enable;


always@(negedge clk)
begin
	if(reset)
	begin
		enable <= 0;
		counter <= 0;
		end
	else if (start)
	begin
		enable <= 0;
		counter <= 0;
	end
	else if(curr_state == S_WAIT)
	begin
		if (counter == 2'd3)
		begin
			counter <= 0;
			enable <= 1;
			end
		else
		begin
		counter <= counter + 1;
		enable <= 0;
		end
	end
	else
	begin
		counter <= counter;
		enable <= enable;
	end
end		

always @(posedge clk or posedge reset)
begin
	if (reset)
		time_up <= 4'b0000;
	else if (start)
		time_up <= 4'b0011;
	else if (enable)
		time_up <= time_up-4'b0001;
	else
		time_up <= time_up;
end
