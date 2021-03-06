
//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM
(

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_RESET_InLow,
	
	BB_SYSTEM_TARGETVX_InBus,
	BB_SYSTEM_TARGETVY_InBus,
	BB_SYSTEM_TARGETWZ_InBus,
	
	//////////// OUTPUTS //////////
	BB_SYSTEM_W1_OutBus,
	BB_SYSTEM_W2_OutBus,
	BB_SYSTEM_W3_OutBus,
	BB_SYSTEM_W4_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

//=======================================================
//  PORT declarations
//=======================================================
input	BB_SYSTEM_CLOCK_50;
input	BB_SYSTEM_RESET_InLow;
	
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETVX_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETVY_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETWZ_InBus;
	
	//////////// OUTPUTS //////////
output [N_WIDTH-1:0]	BB_SYSTEM_W1_OutBus;
output [N_WIDTH-1:0]	BB_SYSTEM_W2_OutBus;
output [N_WIDTH-1:0]	BB_SYSTEM_W3_OutBus;
output [N_WIDTH-1:0]	BB_SYSTEM_W4_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

MOVEMENT_CONTROLLER u0
(
	.MOVEMENT_CONTROLLER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.MOVEMENT_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.MOVEMENT_CONTROLLER_TARGETVX_InBus(BB_SYSTEM_TARGETVX_InBus),
	.MOVEMENT_CONTROLLER_TARGETVY_InBus(BB_SYSTEM_TARGETVY_InBus),
	.MOVEMENT_CONTROLLER_TARGETWZ_InBus(BB_SYSTEM_TARGETWZ_InBus),
	
	.MOVEMENT_CONTROLLER_W1_OutBus(BB_SYSTEM_W1_OutBus),
	.MOVEMENT_CONTROLLER_W2_OutBus(BB_SYSTEM_W2_OutBus),
	.MOVEMENT_CONTROLLER_W3_OutBus(BB_SYSTEM_W3_OutBus),
	.MOVEMENT_CONTROLLER_W4_OutBus(BB_SYSTEM_W4_OutBus)
);

endmodule
