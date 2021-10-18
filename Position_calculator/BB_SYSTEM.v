//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM (

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_Reset_InLow,

	BB_SYSTEM_SETBEGIN_InLow,
	BB_SYSTEM_VX_InBus, // global velocity vx in m/s (in notation fixed point 32b)
	BB_SYSTEM_VY_InBus, // global velocity vy in m/s (in notation fixed point 32b)
	BB_SYSTEM_WZ_InBus, // global velocity wz in rad/s (in notation fixed point 32b)
	
	//////////// OUTPUTS //////////
	BB_SYSTEM_POSX_OutBus, // [m] fixed point 32b
	BB_SYSTEM_POSY_OutBus, // [m] fixed point 32b
	BB_SYSTEM_THETA_OutBus // [deg] fixed point 32b

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

input BB_SYSTEM_SETBEGIN_InLow;
input [DATAWIDTH_N-1:0]	BB_SYSTEM_VX_InBus;
input [DATAWIDTH_N-1:0]	BB_SYSTEM_VY_InBus;
input [DATAWIDTH_N-1:0]	BB_SYSTEM_WZ_InBus;

output [DATAWIDTH_N-1:0]	BB_SYSTEM_POSX_OutBus;
output [DATAWIDTH_N-1:0]	BB_SYSTEM_POSY_OutBus;
output [DATAWIDTH_N-1:0]	BB_SYSTEM_THETA_OutBus;

//=======================================================
//  STRUCTURAL coding
//=======================================================

POS_CALCULATOR U0
(
	//////////// INPUTS //////////
	.POS_CALCULATOR_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.POS_CALCULATOR_Reset_InHigh(~BB_SYSTEM_Reset_InLow),

	.POS_CALCULATOR_SETBEGIN_InLow(BB_SYSTEM_SETBEGIN_InLow),
	.POS_CALCULATOR_VX_InBus(BB_SYSTEM_VX_InBus), // global velocity vx in m/s (in notation fixed point 32b)
	.POS_CALCULATOR_VY_InBus(BB_SYSTEM_VY_InBus), // global velocity vy in m/s (in notation fixed point 32b)
	.POS_CALCULATOR_WZ_InBus(BB_SYSTEM_WZ_InBus), // global velocity wz in rad/s (in notation fixed point 32b)
	
	//////////// OUTPUTS //////////
	.POS_CALCULATOR_POSX_OutBus(BB_SYSTEM_POSX_OutBus), // [m] fixed point 32b
	.POS_CALCULATOR_POSY_OutBus(BB_SYSTEM_POSY_OutBus), // [m] fixed point 32b
	.POS_CALCULATOR_THETA_OutBus(BB_SYSTEM_THETA_OutBus) // [deg] fixed point 32b
);

endmodule
