//****************************************
// Made by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================

module DIRECTION_DET #(parameter N_DATAWIDTH = 17)
(

	//////////// INPUTS //////////
	input [N_DATAWIDTH-1:0] DIRECTION_DET_W_InBus,
	
	//////////// OUTPUTS ////////// 
	output reg [1:0] DIRECTION_DET_CONTROL_OutBus //Output bus to control direction
	
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

//INPUT LOGIC: COMBINATIONAL

always @(*)
begin
	if (DIRECTION_DET_W_InBus[N_DATAWIDTH-2:0] == 16'b0)
		DIRECTION_DET_CONTROL_OutBus = 2'b11; // fast stop for motor if goal velocity is zero rad/s
	else if (DIRECTION_DET_W_InBus[N_DATAWIDTH-1] == 1'b0)
		DIRECTION_DET_CONTROL_OutBus = 2'b01; // rotation in one direction
	else if (DIRECTION_DET_W_InBus[N_DATAWIDTH-1] == 1'b1)
		DIRECTION_DET_CONTROL_OutBus = 2'b10; // rotation in the other direction
	else
		DIRECTION_DET_CONTROL_OutBus = 2'b00; // motor idle
end

endmodule
