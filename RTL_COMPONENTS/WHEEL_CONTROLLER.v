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
	
	WHEEL_CONTROLLER_TICK167ms_In,
	WHEEL_CONTROLLER_CLK82us_In,
	
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
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
input						WHEEL_CONTROLLER_CLOCK;
input						WHEEL_CONTROLLER_RESET_InHigh;
	
input [N_WIDTH-1:0]	WHEEL_CONTROLLER_TARGETW_InBus;
	
input						WHEEL_CONTROLLER_ENCODERA_In;
input						WHEEL_CONTROLLER_ENCODERB_In;

input 					WHEEL_CONTROLLER_TICK167ms_In;
input						WHEEL_CONTROLLER_CLK82us_In;

output [1:0]				WHEEL_CONTROLLER_DIR_OutBus;
output						WHEEL_CONTROLLER_PWM_Out;
output [RPM_DATA-1:0]	WHEEL_CONTROLLER_RPM_OutBus;
output [N_WIDTH-1:0]		WHEEL_CONTROLLER_W_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [RPM_DATA-1:0] pulses_count_bus;
wire current_direction_rot;

wire [N_WIDTH-1:0] rpm_out_17b;
wire [N_WIDTH-1:0] reg_rpm_out;

wire [N_WIDTH-1:0] setpoint_rpm_17b;

wire [N_WIDTH-1:0] error_rpm_17b;

wire [RPM_DATA-1:0] pwm_control;

wire [N_WIDTH-1:0] rad_out_17b;

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

Encoder ENCODER_U0
(
	.clk(WHEEL_CONTROLLER_CLOCK), 
	.tick(WHEEL_CONTROLLER_TICK167ms_In), 
	.ChannelA(WHEEL_CONTROLLER_ENCODERA_In), 
	.ChannelB(WHEEL_CONTROLLER_ENCODERB_In), 
	
	.Count(pulses_count_bus), // pulses in the last 167.77ms interval of time
	.Dir(current_direction_rot) // measured direction (0 cw, 1 ccw) of motor based on encoder phases
);


qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) CONV_PUL2RPM
(
	 .i_multiplicand({1'b0, pulses_count_bus, 8'b0}),
	 .i_multiplier(17'b0_00000100_11000101), // constant 4.7684 (4.7695) for conversion of pulses/tick to rev/min
	 .o_result(rpm_out_17b),
	 .ovr()
);

///////////////////////////////////// REG AT OUTPUT OF RPM CALCULATOR

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_U0
(
	.SC_REGGENERAL_CLOCK_50(WHEEL_CONTROLLER_CLOCK),
	.SC_REGGENERAL_RESET_InHigh(WHEEL_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(WHEEL_CONTROLLER_TICK167ms_In), 
	.SC_REGGENERAL_data_InBus(rpm_out_17b),
	.SC_REGGENERAL_data_OutBUS(reg_rpm_out)
);

///////////////////////////////////// CONVERSION OF INPUT RAD/S TO RPM FOR ERROR CALCULATOR 

qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) CONV_RAD2RPM
(
	.i_multiplicand(WHEEL_CONTROLLER_TARGETW_InBus),
	.i_multiplier(17'b0_00001001_10001100), // constant 9.5493 (9.5469) for conversion of rad/s to rpm
	.o_result(setpoint_rpm_17b),
	.ovr()
);

///////////////////////////////////// ERROR CALCULATOR

qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) ERROR_CALCULATOR
(
	.a({1'b0, setpoint_rpm_17b[N_WIDTH-2:0]}), // does not matter sign of setpoint, just the value
   .b({1'b1, reg_rpm_out[N_WIDTH-2:0]}), // it is: error(rpm) = setpoint(rpm) - current(rpm)
   .c(error_rpm_17b)
);

///////////////////////////////////// PI CONTROLLER

PI_CONTROL PI_CONTROLLER_U0
(
	.Prescaler_clk(~WHEEL_CONTROLLER_TICK167ms_In),  
	.Error_k(error_rpm_17b),
	.COMANDO_PWM(pwm_control)
);

///////////////////////////////////// PWM GENERATOR

moduloPWM PWM_GENERATOR
(
	.clock(WHEEL_CONTROLLER_CLK82us_In), 
	.reset(WHEEL_CONTROLLER_RESET_InHigh), 
	.inPWM(pwm_control),  
	.outPWM(WHEEL_CONTROLLER_PWM_Out)
);

///////////////////////////////////// CONVERSION OF RPM TO RAD/S

qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) CONV_RPM2RAD
(
	 .i_multiplicand(reg_rpm_out),
	 .i_multiplier(17'b0_00000000_00011011), // constant 0.1047 (0.1055) for conversion of rev/min to rad/s
	 .o_result(rad_out_17b),
	 .ovr()
);


assign WHEEL_CONTROLLER_RPM_OutBus = reg_rpm_out[15:8]; // 8 bits for int number of rpms
assign WHEEL_CONTROLLER_W_OutBus = {WHEEL_CONTROLLER_TARGETW_InBus[N_WIDTH-1], rad_out_17b[N_WIDTH-2:0]}; // this uses direction of setpoint velocity


endmodule
