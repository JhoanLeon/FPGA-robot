
//=======================================================
//  MODULE Definition
//=======================================================
module CC_MUX81 #(parameter N_WIDTH = 17)
(
//////////// OUTPUTS //////////
	CC_MUX81_x_OutBus,
	CC_MUX81_y_OutBus,
	CC_MUX81_z_OutBus,
	
//////////// INPUTS //////////
	CC_MUX81_x1_InBus,
	CC_MUX81_x2_InBus,
	CC_MUX81_x3_InBus,
	CC_MUX81_x4_InBus,
	CC_MUX81_x5_InBus,
	CC_MUX81_x6_InBus,
	CC_MUX81_x7_InBus,
	CC_MUX81_x8_InBus,
	
	CC_MUX81_y1_InBus,
	CC_MUX81_y2_InBus,
	CC_MUX81_y3_InBus,
	CC_MUX81_y4_InBus,
	CC_MUX81_y5_InBus,
	CC_MUX81_y6_InBus,
	CC_MUX81_y7_InBus,
	CC_MUX81_y8_InBus,
	
	CC_MUX81_z1_InBus,
	CC_MUX81_z2_InBus,
	CC_MUX81_z3_InBus,
	CC_MUX81_z4_InBus,
	CC_MUX81_z5_InBus,
	CC_MUX81_z6_InBus,
	CC_MUX81_z7_InBus,
	CC_MUX81_z8_InBus,
	
	CC_MUX81_select_InBus
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output [N_WIDTH-1:0]	CC_MUX81_x_OutBus;
output [N_WIDTH-1:0]	CC_MUX81_y_OutBus;
output [N_WIDTH-1:0]	CC_MUX81_z_OutBus;

input [N_WIDTH-1:0]	CC_MUX81_x1_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x2_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x3_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x4_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x5_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x6_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x7_InBus;
input [N_WIDTH-1:0]	CC_MUX81_x8_InBus;
	
input [N_WIDTH-1:0]	CC_MUX81_y1_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y2_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y3_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y4_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y5_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y6_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y7_InBus;
input [N_WIDTH-1:0]	CC_MUX81_y8_InBus;

input [N_WIDTH-1:0]	CC_MUX81_z1_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z2_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z3_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z4_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z5_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z6_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z7_InBus;
input [N_WIDTH-1:0]	CC_MUX81_z8_InBus;
	
input [2:0]		CC_MUX81_select_InBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [N_WIDTH-1:0] x;
reg [N_WIDTH-1:0] y;
reg [N_WIDTH-1:0] z;

//=======================================================
//  Structural coding
//=======================================================

always @(*)
begin
	case(CC_MUX81_select_InBus)
	
		3'b000: begin
				  x = CC_MUX81_x1_InBus; 
				  y = CC_MUX81_y1_InBus; 
				  z = CC_MUX81_z1_InBus;
				  end
				  
		3'b001: begin
				  x = CC_MUX81_x2_InBus; 
				  y = CC_MUX81_y2_InBus; 
				  z = CC_MUX81_z2_InBus;
				  end
				  
		3'b010: begin
				  x = CC_MUX81_x3_InBus; 
				  y = CC_MUX81_y3_InBus; 
				  z = CC_MUX81_z3_InBus;
				  end
				  
		3'b011: begin
				  x = CC_MUX81_x4_InBus; 
				  y = CC_MUX81_y4_InBus; 
				  z = CC_MUX81_z4_InBus;
				  end
				  
		3'b100: begin
				  x = CC_MUX81_x5_InBus; 
				  y = CC_MUX81_y5_InBus; 
				  z = CC_MUX81_z5_InBus;
				  end
				  
		3'b101: begin
				  x = CC_MUX81_x6_InBus; 
				  y = CC_MUX81_y6_InBus; 
				  z = CC_MUX81_z6_InBus;
				  end
				  
		3'b110: begin
				  x = CC_MUX81_x7_InBus; 
				  y = CC_MUX81_y7_InBus; 
				  z = CC_MUX81_z7_InBus;
				  end
				  
		3'b111: begin 
				  x = CC_MUX81_x8_InBus; 
				  y = CC_MUX81_y8_InBus; 
				  z = CC_MUX81_z8_InBus;
				  end
				  
		default: begin
				  x = CC_MUX81_x1_InBus; 
				  y = CC_MUX81_y1_InBus; 
				  z = CC_MUX81_z1_InBus;
				  end
		
	endcase;
end

assign CC_MUX81_x_OutBus = x;
assign CC_MUX81_y_OutBus = y;
assign CC_MUX81_z_OutBus = z;

endmodule
