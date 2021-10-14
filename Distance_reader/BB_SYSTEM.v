
//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM
(

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_RESET_InLow,
	
	BB_SYSTEM_ECHO_In,
	
	//////////// OUTPUTS //////////
	BB_SYSTEM_TRIGGER_Out,
	BB_SYSTEM_DISTANCE_OutBus

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
	
input	BB_SYSTEM_ECHO_In;

output	BB_SYSTEM_TRIGGER_Out;
output [N_WIDTH-1:0]	BB_SYSTEM_DISTANCE_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

DISTANCE_READER U0
(
	//////////// INPUTS //////////
	.DISTANCE_READER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.DISTANCE_READER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.DISTANCE_READER_ECHO_In(BB_SYSTEM_ECHO_In),
	
	//////////// OUTPUTS //////////
	.DISTANCE_READER_TRIGGER_Out(BB_SYSTEM_TRIGGER_Out),
	.DISTANCE_READER_DISTANCE_OutBus(BB_SYSTEM_DISTANCE_OutBus)

);

endmodule
