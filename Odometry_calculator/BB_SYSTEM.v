//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM (

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_Reset_InLow,
	
	BB_SYSTEM_SETBEGIN_InLow,
	BB_SYSTEM_W1_InBus,
	BB_SYSTEM_W2_InBus,
	BB_SYSTEM_W3_InBus,
	BB_SYSTEM_W4_InBus,
	BB_SYSTEM_THETA_InBus,

	//////////// OUTPUTS //////////
	BB_SYSTEM_POSX_OutBus, // position in global x in m notation fixed point 32b
	BB_SYSTEM_POSY_OutBus, // position in global y in m notation fixed point 32b
	BB_SYSTEM_THETA_OutBus  // rotation angle in degrees notation fixed point 32b
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
input BB_SYSTEM_CLOCK_50;
input BB_SYSTEM_Reset_InLow;

input BB_SYSTEM_SETBEGIN_InLow;
input [N_WIDTH-1:0] BB_SYSTEM_W1_InBus;
input [N_WIDTH-1:0] BB_SYSTEM_W2_InBus;
input [N_WIDTH-1:0] BB_SYSTEM_W3_InBus;
input [N_WIDTH-1:0] BB_SYSTEM_W4_InBus;
input [N_WIDTH-1:0] BB_SYSTEM_THETA_InBus;

output [N_WIDTH-1:0] BB_SYSTEM_POSX_OutBus;
output [N_WIDTH-1:0] BB_SYSTEM_POSY_OutBus;
output [N_WIDTH-1:0] BB_SYSTEM_THETA_OutBus;

//=======================================================
//  STRUCTURAL coding
//=======================================================

ODOM_CALCULATOR U0
(
	//////////// INPUTS //////////
	.ODOM_CALCULATOR_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.ODOM_CALCULATOR_Reset_InHigh(~BB_SYSTEM_Reset_InLow),
	
	.ODOM_CALCULATOR_SETBEGIN_InLow(BB_SYSTEM_SETBEGIN_InLow),
	.ODOM_CALCULATOR_W1_InBus(BB_SYSTEM_W1_InBus),
	.ODOM_CALCULATOR_W2_InBus(BB_SYSTEM_W2_InBus),
	.ODOM_CALCULATOR_W3_InBus(BB_SYSTEM_W3_InBus),
	.ODOM_CALCULATOR_W4_InBus(BB_SYSTEM_W4_InBus),
	.ODOM_CALCULATOR_THETA_InBus(BB_SYSTEM_THETA_InBus),

	//////////// OUTPUTS //////////
	.ODOM_CALCULATOR_POSX_OutBus(BB_SYSTEM_POSX_OutBus), // position in global x in m notation fixed point 32b
	.ODOM_CALCULATOR_POSY_OutBus(BB_SYSTEM_POSY_OutBus), // position in global y in m notation fixed point 32b
	.ODOM_CALCULATOR_THETA_OutBus(BB_SYSTEM_THETA_OutBus)  // rotation angle in degrees notation fixed point 32b
);

endmodule
