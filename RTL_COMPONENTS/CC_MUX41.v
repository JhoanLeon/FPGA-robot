//****************************************
// Made by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================
module CC_MUX41 #(parameter N_WIDTH = 17)
(
//////////// OUTPUTS //////////
	CC_MUX41_x_OutBus,
	CC_MUX41_y_OutBus,
	CC_MUX41_z_OutBus,
	
//////////// INPUTS //////////
	CC_MUX41_x1_InBus,
	CC_MUX41_x2_InBus,
	CC_MUX41_x3_InBus,
	CC_MUX41_x4_InBus,
	
	CC_MUX41_y1_InBus,
	CC_MUX41_y2_InBus,
	CC_MUX41_y3_InBus,
	CC_MUX41_y4_InBus,
	
	CC_MUX41_z1_InBus,
	CC_MUX41_z2_InBus,
	CC_MUX41_z3_InBus,
	CC_MUX41_z4_InBus,
	
	CC_MUX41_select_InBus
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output [N_WIDTH-1:0]	CC_MUX41_x_OutBus;
output [N_WIDTH-1:0]	CC_MUX41_y_OutBus;
output [N_WIDTH-1:0]	CC_MUX41_z_OutBus;

input [N_WIDTH-1:0]	CC_MUX41_x1_InBus;
input [N_WIDTH-1:0]	CC_MUX41_x2_InBus;
input [N_WIDTH-1:0]	CC_MUX41_x3_InBus;
input [N_WIDTH-1:0]	CC_MUX41_x4_InBus;
	
input [N_WIDTH-1:0]	CC_MUX41_y1_InBus;
input [N_WIDTH-1:0]	CC_MUX41_y2_InBus;
input [N_WIDTH-1:0]	CC_MUX41_y3_InBus;
input [N_WIDTH-1:0]	CC_MUX41_y4_InBus;

input [N_WIDTH-1:0]	CC_MUX41_z1_InBus;
input [N_WIDTH-1:0]	CC_MUX41_z2_InBus;
input [N_WIDTH-1:0]	CC_MUX41_z3_InBus;
input [N_WIDTH-1:0]	CC_MUX41_z4_InBus;
	
input [1:0]		CC_MUX41_select_InBus;

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
	case(CC_MUX41_select_InBus)
	
		2'b00: begin
				  x = CC_MUX41_x1_InBus; 
				  y = CC_MUX41_y1_InBus; 
				  z = CC_MUX41_z1_InBus;
				  end
				  
		2'b01: begin
				  x = CC_MUX41_x2_InBus; 
				  y = CC_MUX41_y2_InBus; 
				  z = CC_MUX41_z2_InBus;
				  end
				  
		2'b10: begin
				  x = CC_MUX41_x3_InBus; 
				  y = CC_MUX41_y3_InBus; 
				  z = CC_MUX41_z3_InBus;
				  end
				  
		2'b11: begin
				  x = CC_MUX41_x4_InBus; 
				  y = CC_MUX41_y4_InBus; 
				  z = CC_MUX41_z4_InBus;
				  end
				  
		default: begin
				  x = CC_MUX41_x1_InBus; 
				  y = CC_MUX41_y1_InBus; 
				  z = CC_MUX41_z1_InBus;
				  end
		
	endcase;
end

assign CC_MUX41_x_OutBus = x;
assign CC_MUX41_y_OutBus = y;
assign CC_MUX41_z_OutBus = z;

endmodule
