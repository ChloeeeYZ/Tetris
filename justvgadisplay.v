module justvgadisplay(iResetn,iBlack,iClock,
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
	oX,oY,oColour,oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
	parameter X_START = 8'd60;
	parameter X_STOP = 8'd120;
   parameter Y_SCREEN_PIXELS = 7'd120;
	parameter BLOCK_SIZE = 4;

   input wire iResetn, iBlack;
//   input wire [2:0] iColour;
//   input wire [3:0] iXY_Coord;
   input wire 	     iClock;
	
	

   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	   oPlot;       // Pixel draw enable
	wire clock_out;
	
	input wire [9:0] bg_0;
	input wire [9:0] bg_1;
	input wire [9:0] bg_2;
	input wire [9:0] bg_3;
	input wire [9:0] bg_4;
	input wire [9:0] bg_5;
	input wire [9:0] bg_6;
	input wire [9:0] bg_7;
	input wire [9:0] bg_8;
	input wire [9:0] bg_9;
	input wire [9:0] bg_10;
	input wire [9:0] bg_11;
	input wire [9:0] bg_12;
	input wire [9:0] bg_13;
	input wire [9:0] bg_14;
	input wire [9:0] bg_15;
	input wire [9:0] bg_16;
	input wire [9:0] bg_17;
	input wire [9:0] bg_18;
	input wire [9:0] bg_19;
	input wire [9:0] bg_20;
	input wire [9:0] bg_21;
	input wire [9:0] bg_22;
	
	



//   wire black;
//	wire [7:0] x_count;
//	wire [6:0] y_count;
	
	//fsm f1(iClock, iResetn, iPlotBox, iBlack, iLoadX, x_count, y_count, x_ld, black, plot, oDone, en_count, oPlot);
//	rate_divider r1(iClock,clock_out);
	datapath d1(iClock, iResetn, 
//	iXY_Coord, 
//	iColour, 
//	iPlotBox, 
	iBlack,
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
	oX, oY, oColour, oPlot);
//#(.X_SCREEN_PIXELS(X_SCREEN_PIXELS), .Y_SCREEN_PIXELS(Y_SCREEN_PIXELS))
endmodule // part2

//
//
module datapath(
	input wire clock,
	input wire resetn,
//	input wire [5:0] xy_coord,
//	input wire [2:0] Col,
	//input wire x_ld,
//	input wire plot,
	input wire black,
//	input wire en_count,
	input wire [9:0] bg_0,
	input wire [9:0] bg_1,
	input wire [9:0] bg_2,
	input wire [9:0] bg_3,
	input wire [9:0] bg_4,
	input wire [9:0] bg_5,
	input wire [9:0] bg_6,
	input wire [9:0] bg_7,
	input wire [9:0] bg_8,
	input wire [9:0] bg_9,
	input wire [9:0] bg_10,
	input wire [9:0] bg_11,
	input wire [9:0] bg_12,
	input wire [9:0] bg_13,
	input wire [9:0] bg_14,
	input wire [9:0] bg_15,
	input wire [9:0] bg_16,
	input wire [9:0] bg_17,
	input wire [9:0] bg_18,
	input wire [9:0] bg_19,
	input wire [9:0] bg_20,
	input wire [9:0] bg_21,
	input wire [9:0] bg_22,
	output reg [7:0] x,
	output reg [6:0] y,
	output reg [2:0] colour,
	output reg oPlot
	);
	
	parameter X_SCREEN_PIXELS = 8'd160;
	parameter X_START = 8'd50;
	parameter X_STOP = 8'd110;
   parameter Y_SCREEN_PIXELS = 7'd120;
	parameter BLOCK_SIZE = 6;
	
	//internal registers
	//reg draw;
	reg [27:0] frame_count;
	reg [7:0] x_corner;
	reg [6:0] y_corner;
	reg [7:0] x_clear;
	reg [6:0] y_clear;
	reg [7:0] bg_x;
	reg [6:0] bg_y;
	reg [7:0] bg_x_corner;
	reg [6:0] bg_y_corner;
	reg [2:0] x_pixel, y_pixel, bg_x_pixel, bg_y_pixel;
	reg isfall;
	reg drawblock;
	reg clear;
	
	wire [9:0] bg [19:0];
	assign bg[0] = bg_3;
	assign bg[1] = bg_4;
	assign bg[2] = bg_5;
	assign bg[3] = bg_6;
	assign bg[4] = bg_7;
	assign bg[5] = bg_8;
	assign bg[6] = bg_9;
	assign bg[7] = bg_10;
	assign bg[8] = bg_11;
	assign bg[9] = bg_12;
	assign bg[10] = bg_13;
	assign bg[11] = bg_14;
	assign bg[12] = bg_15;
	assign bg[13] = bg_16;
	assign bg[14] = bg_17;
	assign bg[15] = bg_18;
	assign bg[16] = bg_19;
	assign bg[17] = bg_20;
	assign bg[18] = bg_21;
	assign bg[19] = bg_22;


	
	always@(posedge clock)
	begin
		if (!resetn)
		begin
			x <= X_START;
			y <= 0;
			colour <= 3'b000;
			x_corner <= 8'b0;
			y_corner <= 7'b0;
			x_clear <= 8'b0;
			y_clear <= 7'b0;
			bg_x_corner <= X_START;
			bg_y_corner <= 7'b0;
			bg_x <= 8'b0;
			bg_y <= 7'b0;
			frame_count <= 28'b0;
			isfall <= 1'b0;
			drawblock <= 1'b0;
			clear <= 1'b0;
			x_pixel <= 0;
			y_pixel <= 0;
			bg_x_pixel <= 0;
			bg_y_pixel <= 0;
			oPlot <= 1'b0;
		end
	
		else if(black)
		begin
			colour <= 3'b000;
			if (x < 8'd160 - 1) 
			begin
				x <= x + 1;
			end
			else 
			begin
				x <= 0;
				if (y < 7'd120 - 1)
				begin
					y <= y+1;
				end
				else
					y<= 0;
			end 
			oPlot <= 1'b1;
			 
		end
		
//		else if (plot)
//		begin
//			drawblock <= 1'b1;
//			x_corner <= 8'b0;
//			y_corner <= 7'b0;
//			x_clear <= X_START;
//			y_clear <= 7'b0;
//			x_pixel <= 0;
//			y_pixel <= 0;
//			bg_x <= 0;
//			bg_y <= 0;
//			bg_x_pixel <= 0;
//			bg_y_pixel <= 0;
//			bg_x_corner <= X_START;
//			bg_y_corner <= 0;
////			x <= X_START;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           _START;
////			y <= 0;
//			
//		end
		
		else 
		begin
//			colour <= 3'b111;
//			if (x_clear < X_STOP - 1 && x_clear > X_START - 1) 
//			begin
//				x_clear <= x_clear + 1;
//				y_clear <= y_clear;
//			end
//			else if (y_clear < 7'd120 - 1)
//			begin
//				x_clear <= X_START;
//				y_clear <= y_clear + 1;
//			end
//			else
//			begin				
//				drawblock <= 1;
//				clear <= 0;
//				x_clear <= X_START;
//				y_clear <= 7'b0;
//			end 
//			x <= x_clear;
//			y <= y_clear;
//			oPlot <= 1'b1;
			if(bg_x_corner < X_STOP - BLOCK_SIZE && bg_x_corner > X_START - 1)
			begin
				if(bg_x_pixel < BLOCK_SIZE - 1)
				begin
					bg_x_pixel <= bg_x_pixel +1;
					bg_y_pixel <= bg_y_pixel;
					//x_clear <= bg_x_corner + bg_x_pixel;
					//y_clear <= bg_y_corner + bg_y_pixel;
					if(bg[bg_y][bg_x] == 1)
						colour <= 3'b001;
					else
						colour <= 3'b111;
				end	
				else if (bg_y_pixel < BLOCK_SIZE - 1)
				begin 
					bg_x_pixel <= 0;
					bg_y_pixel <= bg_y_pixel + 1;	
					//x_clear <= bg_x_corner + bg_x_pixel;
					//y_clear <= bg_y_corner + bg_y_pixel;
				end
				else
				begin
					bg_x_pixel <= 0;
					bg_y_pixel <= 0;
					bg_x_corner <= bg_x_corner + BLOCK_SIZE; 
					bg_y_corner <= bg_y_corner;
					bg_x <= bg_x + 1;
					bg_y <= bg_y;
					//x_clear <= bg_x_corner + bg_x_pixel;
					//y_clear <= bg_y_corner + bg_y_pixel;
					
				end
			end
			else if(bg_x_corner == X_STOP - BLOCK_SIZE && bg_y_corner < 7'd120 - BLOCK_SIZE)
			begin
				if(bg_x_pixel < BLOCK_SIZE - 1)
				begin
					bg_x_pixel <= bg_x_pixel +1;
					bg_y_pixel <= bg_y_pixel;
					if(bg[bg_y][bg_x] == 1)
						colour <= 3'b001;
					else
						colour <= 3'b111;
				end	
				else if (bg_y_pixel < BLOCK_SIZE - 1)
				begin 
					bg_x_pixel <= 0;
					bg_y_pixel <= bg_y_pixel + 1;	
				end
				else
				begin
					bg_x_pixel <= 0;
					bg_y_pixel <= 0;
					bg_x_corner <= X_START; 
					bg_y_corner <= bg_y_corner +BLOCK_SIZE;
					bg_x <= 0;
					bg_y <= bg_y + 1;
				end	
			end
			else if(bg_x_corner == X_STOP - BLOCK_SIZE && bg_y_corner == 7'd120 - BLOCK_SIZE)
			begin
				if(bg_x_pixel < BLOCK_SIZE - 1)
				begin
					bg_x_pixel <= bg_x_pixel +1;
					bg_y_pixel <= bg_y_pixel;
					if(bg[bg_y][bg_x] == 1)
						colour <= 3'b001;
					else
						colour <= 3'b111;
				end	
				else if (bg_y_pixel < BLOCK_SIZE - 1)
				begin 
					bg_x_pixel <= 0;
					bg_y_pixel <= bg_y_pixel + 1;	
				end
				else
				begin
					drawblock <= 1;
					clear <= 0;
					bg_x_corner <= X_START;
					bg_y_corner <= 7'b0;
					bg_x <= 0;
					bg_y <= 0;
					bg_x_pixel <= 0;
					bg_y_pixel <= 0;
				end	
			end
			x <= bg_x_corner + bg_x_pixel;
			y <= bg_y_corner + bg_y_pixel;
			oPlot <= 1'b1;
		end
		
//		else if (drawblock)
//		begin		
//			if(x_pixel < BLOCK_SIZE - 1)
//			begin
//				x_pixel <= x_pixel +1;
//			end
//			else if (y_pixel < BLOCK_SIZE - 1)
//			begin 
//				x_pixel <= 0;
//				y_pixel <= y_pixel + 1;			
//			end
//			else
//			begin
//				drawblock <= 0;
//				isfall <= 1;	
//				x_pixel <= 0;
//				y_pixel <= 0;
//			end
//			x <= X_START +xy_coord*4 + x_pixel;
//			y <= y_corner + y_pixel;
//			colour <= Col;
//			oPlot <=1;
//			
//		end
//		
//		else if (isfall)
//		begin
//			if(frame_count < 28'd10000000) 
//			begin
//				frame_count <= frame_count+1;
////				x_corner <= 0;
////				y_corner <= 0;
//			end
//			else
//			begin				
//				if(y_corner < 7'd80 - BLOCK_SIZE)
//				begin
//					y_corner <= y_corner + 1;
//				end
//				frame_count <= 0;
//				clear <= 1;
//				isfall <= 0;
//				
//			end
//
//		end 
//		
//		else
//			oPlot <= 0;
		
	end


endmodule


