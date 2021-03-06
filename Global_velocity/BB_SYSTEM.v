//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM (

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_Reset_InHigh,
	
	BB_SYSTEM_READY_In,
	BB_SYSTEM_VX_InBus, // local velocity vx in m/s (notation fixed point 32b)
	BB_SYSTEM_VY_InBus, // local velocity vy in m/s (in notation fixed point 32b)
	BB_SYSTEM_WZ_InBus, // local velocity wz in rad/s (in notation fixed point 32b)
	BB_SYSTEM_THETA_InBus, // rotation angle in degrees (in notation fixed point 32b)

	//////////// OUTPUTS //////////
	BB_SYSTEM_DONE_Out,
	BB_SYSTEM_VX_OutBus,
	BB_SYSTEM_VY_OutBus,
	BB_SYSTEM_WZ_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATAWIDTH_N = 32;
parameter FRACTIONAL_Q = 15;

//=======================================================
//  PORT declarations
//=======================================================
input BB_SYSTEM_CLOCK_50;
input BB_SYSTEM_Reset_InHigh;

input BB_SYSTEM_READY_In;
input [DATAWIDTH_N-1:0] BB_SYSTEM_VX_InBus;
input [DATAWIDTH_N-1:0] BB_SYSTEM_VY_InBus;
input [DATAWIDTH_N-1:0] BB_SYSTEM_WZ_InBus;
input [DATAWIDTH_N-1:0] BB_SYSTEM_THETA_InBus;

output BB_SYSTEM_DONE_Out;
output [DATAWIDTH_N-1:0] BB_SYSTEM_VX_OutBus;
output [DATAWIDTH_N-1:0] BB_SYSTEM_VY_OutBus;
output [DATAWIDTH_N-1:0] BB_SYSTEM_WZ_OutBus;

//=======================================================
//  STRUCTURAL coding
//=======================================================

GLOBAL_VELOCITY #(.N_WIDTH(DATAWIDTH_N), .Q_WIDTH(FRACTIONAL_Q)) GLOBAL_VELOCITY_u0 (

	.GLOBAL_VELOCITY_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.GLOBAL_VELOCITY_RESET_InHigh(BB_SYSTEM_Reset_InHigh),
	
	.GLOBAL_VELOCITY_READY_In(BB_SYSTEM_READY_In),
	.GLOBAL_VELOCITY_VX_LOCAL_InBus(BB_SYSTEM_VX_InBus),
	.GLOBAL_VELOCITY_VY_LOCAL_InBus(BB_SYSTEM_VY_InBus),
	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(BB_SYSTEM_WZ_InBus),
	.GLOBAL_VELOCITY_THETA_InBus(BB_SYSTEM_THETA_InBus),	
	
	.GLOBAL_VELOCITY_DONE_Out(BB_SYSTEM_DONE_Out),
	.GLOBAL_VELOCITY_VX_GLOBAL_OutBus(BB_SYSTEM_VX_OutBus),
	.GLOBAL_VELOCITY_VY_GLOBAL_OutBus(BB_SYSTEM_VY_OutBus),
	.GLOBAL_VELOCITY_WZ_GLOBAL_OutBus(BB_SYSTEM_WZ_OutBus)
);


endmodule
