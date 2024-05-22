module ps2_top (
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	rotate,
	left,
	right,
	
	HEX0,
	HEX1,
	HEX2

);



// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output reg rotate, left, right;
output [6:0] HEX0,HEX1,HEX2;



// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	data_received;
reg [3:0] score0, score1, score2;




always @(posedge CLOCK_50)
begin
	if (KEY[0] == 1'b0)
		data_received <= 8'h00;
	else if (ps2_key_pressed == 1'b1)
		data_received <= ps2_key_data;
	else
		data_received <= 8'h00;
end


always @(posedge CLOCK_50)
begin
 if (KEY[0] == 1'b0)
 begin 
 rotate <= 0;
 left <= 0;
 right <= 0;
 score0 <= 0;
 score1 <= 0;
 score2 <= 0;
 end
	else if (data_received == 8'h75)
	begin
		if (!rotate)
		begin
			rotate <= 1;
			score0 <= score0 + 1;
			end
		else
		begin
			rotate <= 0;
			score0 <= score0;
			end
	end
	else if (data_received == 8'h6B)
	begin
		if (!left)
		begin
			left <= 1;
			score1 <= score1 + 1;
			end
		else
		begin
			left <= 0;
			score1 <= score1;
			end
	end
	else if (data_received == 8'h74)
	begin
		if (!right)
		begin
			right <= 1;
			score2 <= score2 + 1;
			end
		else
		begin
			right <= 0;
			score2 <= score2;
			end
	end
	else
	begin
	 rotate <= rotate;
	 left <=   left ;
	 right <=  right ;
	 score0 <= score0;
	 score1 <= score1;
	 score2 <= score2;
	end
end

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

hex_decoder h0(score0, HEX0);
hex_decoder h1(score1, HEX1);
hex_decoder h2(score2, HEX2);



endmodule
