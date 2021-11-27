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
wire signal_behavior;
wire time_count_flag;
wire enable_time;
wire clear_time;

reg [N_WIDTH-1:0] velocity_x;
reg [N_WIDTH-1:0] velocity_y;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_STATEMACHINE_MUX41 STATEMACHINE_MUX
(
	//////////// INPUTS //////////
	.SC_STATEMACHINE_MUX41_CLOCK_50(DECISION_CONTROLLER_CLOCK_50),
	.SC_STATEMACHINE_MUX41_RESET_InHigh(DECISION_CONTROLLER_RESET_InHigh),
	
	.SC_STATEMACHINE_MUX41_BEHAVIOR_In(signal_behavior), // 1'b1 to select pos_controller
	.SC_STATEMACHINE_NEWSIGNAL_InLow(DECISION_CONTROLLER_NEWSIGNAL_InLow),
	.SC_STATEMACHINE_MUX41_STOP_InLow(DECISION_CONTROLLER_STOP_InLow),
	.SC_STATEMACHINE_MUX41_FLAGGOAL_InLow(DECISION_CONTROLLER_FLAGGOAL_InLow),
	
	//////////// OUTPUTS //////////
	.SC_STATEMACHINE_MUX41_MUXSELECT_OutBus(DECISION_CONTROLLER_MUXSELECT_OutBus)	
);


SC_STATEMACHINE_DESC STATEMACHINE_DECISION 
(
	//////////// INPUTS //////////
	.SC_STATEMACHINE_DESC_CLOCK_50(DECISION_CONTROLLER_CLOCK_50),
	.SC_STATEMACHINE_DESC_RESET_InHigh(DECISION_CONTROLLER_RESET_InHigh),
	
	.SC_STATEMACHINE_DESC_DIST1_InBus(DECISION_CONTROLLER_DIST1_InBus),
	.SC_STATEMACHINE_DESC_DIST2_InBus(DECISION_CONTROLLER_DIST2_InBus),
	.SC_STATEMACHINE_DESC_DIST3_InBus(DECISION_CONTROLLER_DIST3_InBus),
	.SC_STATEMACHINE_DESC_DIST4_InBus(DECISION_CONTROLLER_DIST4_InBus),
	
	.SC_STATEMACHINE_DESC_ERRORX_InBus(DECISION_CONTROLLER_ERRORX_InBus),
	.SC_STATEMACHINE_DESC_ERRORY_InBus(DECISION_CONTROLLER_ERRORY_InBus),
	
	.SC_STATEMACHINE_DESC_TIMEFLAG_InLow(time_count_flag),
	
	//////////// OUTPUTS //////////
	.SC_STATEMACHINE_DESC_VELX_OutBus(DECISION_CONTROLLER_VELX_OutBus),
	.SC_STATEMACHINE_DESC_VELY_OutBus(DECISION_CONTROLLER_VELY_OutBus),
	
	.SC_STATEMACHINE_DESC_ENABLETIME_OutLow(enable_time),
	.SC_STATEMACHINE_DESC_CLEARTIME_OutLow(clear_time),
	
	.SC_STATEMACHINE_DESC_BEHAVIOR_Out(signal_behavior),
	.SC_STATEMACHINE_DESC_CURRENTBEH_OutBus(DECISION_CONTROLLER_CURRENTBEH_OutBus)
);


SC_COUNTER #(.N(24)) COUNTER_TIME // N=24 -> 335ms
(
	.SC_COUNTER_CLOCK(DECISION_CONTROLLER_CLOCK_50),
	.SC_COUNTER_RESET_InHigh(DECISION_CONTROLLER_RESET_InHigh),
	.SC_COUNTER_ENABLE_InLow(enable_time), // if this signal is low the counter works
	.SC_COUNTER_CLEAR_InLow(clear_time), // signal to clear the count
	
	.SC_COUNTER_REGCOUNT(), // Output bus for count
	.SC_COUNTER_FLAG_OutLow(), // Output flag InLow for specific number of count
	.SC_COUNTER_ENDCOUNT_OutLow(time_count_flag) // output flag InLow for end of total count
);

endmodule
