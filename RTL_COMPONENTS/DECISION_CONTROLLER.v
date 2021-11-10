//****************************************
// Made by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================

module DECISION_CONTROLLER
(
	//////////// INPUTS //////////
	DECISION_CONTROLLER_CLOCK_50,
	DECISION_CONTROLLER_RESET_InHigh,
	
	DECISION_CONTROLLER_DIST1_InBus,
	DECISION_CONTROLLER_DIST2_InBus,
	DECISION_CONTROLLER_DIST3_InBus,
	DECISION_CONTROLLER_DIST4_InBus,
	
	DECISION_CONTROLLER_NEWSIGNAL_InLow,
	DECISION_CONTROLLER_STOP_InLow,
	DECISION_CONTROLLER_FLAGGOAL_InLow,
	
	DECISION_CONTROLLER_ERRORX_InBus,
	DECISION_CONTROLLER_ERRORY_InBus,
	
	//////////// OUTPUTS ////////// 
	DECISION_CONTROLLER_CURRENTBEH_OutBus,
	
	DECISION_CONTROLLER_MUXSELECT_OutBus,
	
	DECISION_CONTROLLER_VELX_OutBus,
	DECISION_CONTROLLER_VELY_OutBus
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter B_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
	//////////// INPUTS //////////
input	DECISION_CONTROLLER_CLOCK_50;
input	DECISION_CONTROLLER_RESET_InHigh;
	
input [N_WIDTH-1:0]	DECISION_CONTROLLER_DIST1_InBus;
input [N_WIDTH-1:0]	DECISION_CONTROLLER_DIST2_InBus;
input [N_WIDTH-1:0]	DECISION_CONTROLLER_DIST3_InBus;
input [N_WIDTH-1:0]	DECISION_CONTROLLER_DIST4_InBus;
	
input DECISION_CONTROLLER_NEWSIGNAL_InLow;	
input	DECISION_CONTROLLER_STOP_InLow;
input	DECISION_CONTROLLER_FLAGGOAL_InLow;
	
input [N_WIDTH-1:0]	DECISION_CONTROLLER_ERRORX_InBus;
input [N_WIDTH-1:0]	DECISION_CONTROLLER_ERRORY_InBus;
	
	//////////// OUTPUTS ////////// 
output [B_WIDTH-1:0]	DECISION_CONTROLLER_CURRENTBEH_OutBus;
	
output [1:0]	DECISION_CONTROLLER_MUXSELECT_OutBus;
	
output [N_WIDTH-1:0]	DECISION_CONTROLLER_VELX_OutBus;
output [N_WIDTH-1:0]	DECISION_CONTROLLER_VELY_OutBus;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================


//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_STATEMACHINE_MUX41 STATEMACHINE_MUX
(
	//////////// INPUTS //////////
	.SC_STATEMACHINE_MUX41_CLOCK_50(DECISION_CONTROLLER_CLOCK_50),
	.SC_STATEMACHINE_MUX41_RESET_InHigh(DECISION_CONTROLLER_RESET_InHigh),
	
	.SC_STATEMACHINE_MUX41_BEHAVIOR_In(1'b1), // 1 to select pos_controller
	.SC_STATEMACHINE_NEWSIGNAL_InLow(DECISION_CONTROLLER_NEWSIGNAL_InLow),
	.SC_STATEMACHINE_MUX41_STOP_InLow(DECISION_CONTROLLER_STOP_InLow),
	.SC_STATEMACHINE_MUX41_FLAGGOAL_InLow(DECISION_CONTROLLER_FLAGGOAL_InLow),
	
	//////////// OUTPUTS //////////
	.SC_STATEMACHINE_MUX41_MUXSELECT_OutBus(DECISION_CONTROLLER_MUXSELECT_OutBus)	
);


assign DECISION_CONTROLLER_CURRENTBEH_OutBus = 8'd105;

assign DECISION_CONTROLLER_VELX_OutBus = 17'b0;
assign DECISION_CONTROLLER_VELY_OutBus = 17'b0;

endmodule
