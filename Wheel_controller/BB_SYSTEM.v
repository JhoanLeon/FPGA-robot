
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
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

parameter N_COUNTER_TICK_167ms = 23; // with 23 (tick at 167.77216ms), with 20 -> tick at 20.97ms
parameter N_PRESCALER_82us = 11; // 12 for 20ms PWM period (clk=82us), 11 for 10ms PWM period (clk=41us)

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
wire TICK_167ms;
wire CLK_82us;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_COUNTER #(.N(N_COUNTER_TICK_167ms)) COUNTER_TICK_167ms // N is the amount of bit for count, maximun number of flag and count is 2^(N)-1
(
	.SC_COUNTER_CLOCK(BB_SYSTEM_CLOCK_50),
	.SC_COUNTER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	.SC_COUNTER_ENABLE_InLow(1'b0), // if this signal is low the counter works
	.SC_COUNTER_CLEAR_InLow(1'b1), // signal to clear the count
	
	.SC_COUNTER_REGCOUNT(), //Output bus for count
	.SC_COUNTER_FLAG_OutLow(), //Output flag InLow for specific number of count
	.SC_COUNTER_ENDCOUNT_OutLow(TICK_167ms) // output flag InLow for end of total count
);


PREESCALER #(.N_DATAWIDTH(N_PRESCALER_82us)) PREESCALER_82us
(
	.CLOCK_IN(BB_SYSTEM_CLOCK_50),
	.CLOCK_OUT(CLK_82us)	
);


WHEEL_CONTROLLER U0
(
	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(BB_SYSTEM_TARGETW_InBus),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_ENCODERA_In),
	.WHEEL_CONTROLLER_ENCODERB_In(BB_SYSTEM_ENCODERB_In),
	
	.WHEEL_CONTROLLER_TICK167ms_In(TICK_167ms),
	.WHEEL_CONTROLLER_CLK82us_In(CLK_82us),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus(BB_SYSTEM_DIR_OutBus),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(BB_SYSTEM_RPM_OutBus),
	.WHEEL_CONTROLLER_W_OutBus(BB_SYSTEM_W_OutBus)
);

endmodule
