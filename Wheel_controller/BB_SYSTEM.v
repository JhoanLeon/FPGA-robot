
//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM
(

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_RESET_InLow,
	
	BB_SYSTEM_TARGETW_InBus,
	
	BB_SYSTEM_ENCODERA_In,
	BB_SYSTEM_ENCODERB_In,
	
	//////////// OUTPUTS ////////// 
	BB_SYSTEM_DIR_OutBus,
	BB_SYSTEM_PWM_Out,
	BB_SYSTEM_RPM_OutBus,
	BB_SYSTEM_W_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter RPM_DATA = 8;
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

//=======================================================
//  PORT declarations
//=======================================================
input	BB_SYSTEM_CLOCK_50;
input	BB_SYSTEM_RESET_InLow;
	
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETW_InBus;
	
input	BB_SYSTEM_ENCODERA_In;
input	BB_SYSTEM_ENCODERB_In;
	
output [1:0]				BB_SYSTEM_DIR_OutBus;
output						BB_SYSTEM_PWM_Out;
output [RPM_DATA-1:0]	BB_SYSTEM_RPM_OutBus;
output [N_WIDTH-1:0]		BB_SYSTEM_W_OutBus;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

WHEEL_CONTROLLER WHEEL_CONTROLLER_I0
(

	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(BB_SYSTEM_TARGETW_InBus),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_ENCODERA_In),
	.WHEEL_CONTROLLER_ENCODERB_In(BB_SYSTEM_ENCODERB_In),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus(BB_SYSTEM_DIR_OutBus),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(BB_SYSTEM_RPM_OutBus),
	.WHEEL_CONTROLLER_W_OutBus(BB_SYSTEM_W_OutBus)

);

endmodule
