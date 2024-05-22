module clock_sec(
input clock,
input reset,
output reg clk
);


reg [27:0] count;
reg enable;
localparam FREQ = 25000000;


always@(posedge clock)
begin
	if (reset)
	begin
		count <= 0;
		enable <= 0;
		end
	else if (count == FREQ - 1)
	begin
		count <= 0;
		enable <= 1;
		end
	else
	begin
		count <= count + 1;
		enable <= 0;
	end
end

always@(posedge clock)
begin
	if (reset)
	begin
		clk <= 0;
		end
	else if (enable)
		clk <= ~clk;
end

endmodule
	
	
	
	
	
	