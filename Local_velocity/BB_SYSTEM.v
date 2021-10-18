//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM (

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_Reset_InLow,
	
	BB_SYSTEM_W1_InBus,
	BB_SYSTEM_W2_InBus,
	BB_SYSTEM_W3_InBus,
	BB_SYSTEM_W4_InBus,

	//////////// OUTPUTS //////////
	BB_SYSTEM_VX_OutBus, // local velocity vx in m/s (notation fixed point 32b)
	BB_SYSTEM_VY_OutBus, // local velocity vy in m/s (in notation fixed point 32b)
	BB_SYSTEM_WZ_OutBus  // local velocity wz in rad/s (in notation fixed point 32b)
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
input BB_SYSTEM_Reset_InLow;

input [DATAWIDTH_N-1:0] BB_SYSTEM_W1_InBus;
input [DATAWIDTH_N-1:0] BB_SYSTEM_W2_InBus;
input [DATAWIDTH_N-1:0] BB_SYSTEM_W3_InBus;
input [DATAWIDTH_N-1:0] BB_SYSTEM_W4_InBus;

output [DATAWIDTH_N-1:0] BB_SYSTEM_VX_OutBus;
output [DATAWIDTH_N-1:0] BB_SYSTEM_VY_OutBus;
output [DATAWIDTH_N-1:0] BB_SYSTEM_WZ_OutBus;

//=======================================================
//  STRUCTURAL coding
//=======================================================

LOCAL_VELOCITY U0
(
	//////////// INPUTS //////////
	.LOCAL_VELOCITY_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.LOCAL_VELOCITY_Reset_InHigh(~BB_SYSTEM_Reset_InLow),
	
	.LOCAL_VELOCITY_W1_InBus(BB_SYSTEM_W1_InBus),
	.LOCAL_VELOCITY_W2_InBus(BB_SYSTEM_W2_InBus),
	.LOCAL_VELOCITY_W3_InBus(BB_SYSTEM_W3_InBus),
	.LOCAL_VELOCITY_W4_InBus(BB_SYSTEM_W4_InBus),

	//////////// OUTPUTS //////////
	.LOCAL_VELOCITY_VX_OutBus(BB_SYSTEM_VX_OutBus), // local velocity vx in m/s (notation fixed point 32b)
	.LOCAL_VELOCITY_VY_OutBus(BB_SYSTEM_VY_OutBus), // local velocity vy in m/s (in notation fixed point 32b)
	.LOCAL_VELOCITY_WZ_OutBus(BB_SYSTEM_WZ_OutBus)  // local velocity wz in rad/s (in notation fixed point 32b)
);

endmodule
