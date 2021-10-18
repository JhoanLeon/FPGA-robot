//****************************************
// Made by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================
module WHEEL_CONTROLLER
(

	//////////// INPUTS //////////
	WHEEL_CONTROLLER_CLOCK,
	WHEEL_CONTROLLER_RESET_InHigh,
	
	WHEEL_CONTROLLER_TARGETW_InBus,
	
	WHEEL_CONTROLLER_ENCODERA_In,
	WHEEL_CONTROLLER_ENCODERB_In,
	
	//////////// OUTPUTS ////////// 
	WHEEL_CONTROLLER_DIR_OutBus,
	WHEEL_CONTROLLER_PWM_Out,
	WHEEL_CONTROLLER_RPM_OutBus,
	WHEEL_CONTROLLER_W_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter RPM_DATA = 8;
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

parameter N_COUNTER_TICK_167ms = 23; // with 23 (tick at 167.77216ms), with 20 -> tick at 20.97ms
parameter N_PRESCALER_82us = 11; // 12 for 20ms PWM period (clk=82us), 11 for 10ms PWM period (clk=41us)

//=======================================================
//  PORT declarations
//=======================================================
input						WHEEL_CONTROLLER_CLOCK;
input						WHEEL_CONTROLLER_RESET_InHigh;
	
input [N_WIDTH-1:0]	WHEEL_CONTROLLER_TARGETW_InBus;
	
input						WHEEL_CONTROLLER_ENCODERA_In;
input						WHEEL_CONTROLLER_ENCODERB_In;

output [1:0]				WHEEL_CONTROLLER_DIR_OutBus;
output						WHEEL_CONTROLLER_PWM_Out;
output [RPM_DATA-1:0]	WHEEL_CONTROLLER_RPM_OutBus;
output [N_WIDTH-1:0]		WHEEL_CONTROLLER_W_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire tick_167ms;

wire [RPM_DATA-1:0] pulsescount_bus;
wire current_direction_rot;

wire [N_WIDTH-1:0] rpm_out_32b;
wire [N_WIDTH-1:0] reg_rpm_out;

wire [16:0] setpoint_rpm_17b;

wire [16:0] error_rpm_17b;

wire clk_82us_period;
wire [RPM_DATA-1:0] pwm_control;

wire [N_WIDTH-1:0] rad_out_32b;
wire [N_WIDTH-1:0] reg_rad_out;

//=======================================================
//  STRUCTURAL coding
//=======================================================

///////////////////////////////////// DIRECTION DETERMINER

DIRECTION_DET DIRECTION_MOTOR_U0
(
	.DIRECTION_DET_W_InBus(WHEEL_CONTROLLER_TARGETW_InBus),

	.DIRECTION_DET_CONTROL_OutBus(WHEEL_CONTROLLER_DIR_OutBus) //Output bus to control direction
);

///////////////////////////////////// RPM CALCULATOR

SC_COUNTER #(.N(N_COUNTER_TICK_167ms)) COUNTER_TICK_167ms_U0 // N is the amount of bit for count, maximun number of flag and count is 2^(N)-1
(
	.SC_COUNTER_CLOCK(WHEEL_CONTROLLER_CLOCK),
	.SC_COUNTER_RESET_InHigh(WHEEL_CONTROLLER_RESET_InHigh),
	.SC_COUNTER_ENABLE_InLow(1'b0), // if this signal is low the counter works
	.SC_COUNTER_CLEAR_InLow(1'b1), // signal to clear the count
	
	.SC_COUNTER_REGCOUNT(), //Output bus for count
	.SC_COUNTER_FLAG_OutLow(), //Output flag InLow for specific number of count
	.SC_COUNTER_ENDCOUNT_OutLow(tick_167ms) // output flag InLow for end of total count
);


Encoder ENCODER_U0
(
	.clk(WHEEL_CONTROLLER_CLOCK), 
	.tick(tick_167ms), 
	.ChannelA(WHEEL_CONTROLLER_ENCODERA_In), 
	.ChannelB(WHEEL_CONTROLLER_ENCODERB_In), 
	
	.Count(pulsescount_bus), // pulses in the last 167ms interval of time
	.Dir(current_direction_rot) // measured direction (0 cw, 1 ccw) of motor based on encoder phases
);


qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) CONV_PUL2RPM
(
	 .i_multiplicand({1'b0, 8'b0, pulsescount_bus, 15'b0}),
	 .i_multiplier(32'b0_0000000000000100_110001001011010), // constant (4.768370) for conversion of pulses/tick to rev/min
	 .o_result(rpm_out_32b),
	 .ovr()
);

///////////////////////////////////// REG AT OUTPUT OF RPM CALCULATOR

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_U0
(
	.SC_REGGENERAL_CLOCK_50(WHEEL_CONTROLLER_CLOCK),
	.SC_REGGENERAL_RESET_InHigh(WHEEL_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(tick_167ms), 
	.SC_REGGENERAL_data_InBus(rpm_out_32b),
	//.SC_REGGENERAL_data_InBus(32'b0_0000000000000000_000000000000000), // 0rpms for test
	//.SC_REGGENERAL_data_InBus(32'b0_0000000000110010_000000000000000), // 50rpms for test
	
	.SC_REGGENERAL_data_OutBUS(reg_rpm_out)
);

///////////////////////////////////// CONVERSION OF INPUT RAD/S TO RPM FOR ERROR CALCULATOR 

qmult #(.Q(8), .N(17)) CONV_RAD2RPM
(
	.i_multiplicand({WHEEL_CONTROLLER_TARGETW_InBus[31], WHEEL_CONTROLLER_TARGETW_InBus[22:7]}),
	.i_multiplier(17'b0_00001001_10001100), // constant 9.54930 () for conversion of rad/s to rpm
	.o_result(setpoint_rpm_17b),
	.ovr()
);

///////////////////////////////////// ERROR CALCULATOR

qadd #(.Q(8), .N(17)) ERROR_CALCULATOR
(
	.a(setpoint_rpm_17b),
   .b({1'b1, reg_rpm_out[22:7]}), // it is: error(rpm) = setpoint(rpm) - current(rpm)
   .c(error_rpm_17b)
);

///////////////////////////////////// PI CONTROLLER

PI_control PI_CONTROLLER_U0
(
	.Prescaler_clk(~tick_167ms),  
	.Error_k(error_rpm_17b),
	.COMANDO_PWM(pwm_control)
);

///////////////////////////////////// PWM GENERATOR

PREESCALER #(.N_DATAWIDTH(N_PRESCALER_82us)) PREESCALER_82us
(
	.CLOCK_IN(WHEEL_CONTROLLER_CLOCK),
	
	.CLOCK_OUT(clk_82us_period)	
);

moduloPWM PWM_GENERATOR
(
	.clock(clk_82us_period), 
	.reset(WHEEL_CONTROLLER_RESET_InHigh), 
	.inPWM(pwm_control),  
	.outPWM(WHEEL_CONTROLLER_PWM_Out)
);

///////////////////////////////////// CONVERSION OF RPM TO RAD/S

qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) CONV_RPM2RAD
(
	 .i_multiplicand(reg_rpm_out),
	 .i_multiplier(32'b0_0000000000000000_000110101100111), // constant (0.10472) for conversion of rev/min to rad/s
	 .o_result(rad_out_32b),
	 .ovr()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_U1
(
	.SC_REGGENERAL_CLOCK_50(WHEEL_CONTROLLER_CLOCK),
	.SC_REGGENERAL_RESET_InHigh(WHEEL_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(tick_167ms), 
	.SC_REGGENERAL_data_InBus(rad_out_32b),

	.SC_REGGENERAL_data_OutBUS(reg_rad_out)
);


assign WHEEL_CONTROLLER_RPM_OutBus = reg_rpm_out[22:15]; // 8 bits for int number of rpms
//assign WHEEL_CONTROLLER_W_OutBus = {current_direction_rot, reg_rad_out[30:0]}; // this uses direction calculated from encoders
assign WHEEL_CONTROLLER_W_OutBus = {WHEEL_CONTROLLER_TARGETW_InBus[31], reg_rad_out[30:0]}; // this uses direction of setpoint velocity

endmodule
