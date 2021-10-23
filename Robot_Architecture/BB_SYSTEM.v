
// This project contains the complete architecture of the FPGA-ROBOT

//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM
(
	//////////// INPUTS-OUTPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_RESET_InLow,
	
	// Motors
	BB_SYSTEM_PWM1_Out,
	BB_SYSTEM_IN11_Out,
	BB_SYSTEM_IN12_Out,
	BB_SYSTEM_PHASEA1_In,

	BB_SYSTEM_PWM2_Out,
	BB_SYSTEM_IN21_Out,
	BB_SYSTEM_IN22_Out,
	BB_SYSTEM_PHASEA2_In,
	
	BB_SYSTEM_PWM3_Out,
	BB_SYSTEM_IN31_Out,
	BB_SYSTEM_IN32_Out,
	BB_SYSTEM_PHASEA3_In,

	BB_SYSTEM_PWM4_Out,
	BB_SYSTEM_IN41_Out,
	BB_SYSTEM_IN42_Out,	
	BB_SYSTEM_PHASEA4_In,
	
	// Proximity sensors
	BB_SYSTEM_TRIG1_Out,
	BB_SYSTEM_ECHO1_In,

	BB_SYSTEM_TRIG2_Out,
	BB_SYSTEM_ECHO2_In,
	
	BB_SYSTEM_TRIG3_Out,
	BB_SYSTEM_ECHO3_In,

	BB_SYSTEM_TRIG4_Out,
	BB_SYSTEM_ECHO4_In,
	
	// I2C Master
	BB_SYSTEM_SCL_Out,
	BB_SYSTEM_SDA_InOut,	
	
	// SPI Slave
	BB_SYSTEM_SCLK_In,
	BB_SYSTEM_MISO_Out,
	BB_SYSTEM_MOSI_In,
	BB_SYSTEM_CS_In,
	
	//////////// DEBUG //////////
	BB_SYSTEM_LEDs_OutBus
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATA_WIDTH = 17;
parameter INT_WIDTH = 8;

parameter N_COUNTER_TICK_167ms = 23; // with 23 (tick at 167.77216ms), with 20 -> tick at 20.97ms
parameter N_PRESCALER_82us = 11; // 12 for 20ms PWM period (clk=82us), 11 for 10ms PWM period (clk=41us)

//=======================================================
//  PORT declarations
//=======================================================

	// Generics
input	BB_SYSTEM_CLOCK_50;
input	BB_SYSTEM_RESET_InLow;
	
	// Motors
output	BB_SYSTEM_PWM1_Out;
output	BB_SYSTEM_IN11_Out;
output	BB_SYSTEM_IN12_Out;
input		BB_SYSTEM_PHASEA1_In;

output	BB_SYSTEM_PWM2_Out;
output	BB_SYSTEM_IN21_Out;
output	BB_SYSTEM_IN22_Out;
input		BB_SYSTEM_PHASEA2_In;
	
output	BB_SYSTEM_PWM3_Out;
output	BB_SYSTEM_IN31_Out;
output	BB_SYSTEM_IN32_Out;
input		BB_SYSTEM_PHASEA3_In;

output	BB_SYSTEM_PWM4_Out;
output	BB_SYSTEM_IN41_Out;
output	BB_SYSTEM_IN42_Out;	
input		BB_SYSTEM_PHASEA4_In;
	
	// Proximity sensors
output	BB_SYSTEM_TRIG1_Out;
input		BB_SYSTEM_ECHO1_In;

output	BB_SYSTEM_TRIG2_Out;
input		BB_SYSTEM_ECHO2_In;
	
output	BB_SYSTEM_TRIG3_Out;
input		BB_SYSTEM_ECHO3_In;

output	BB_SYSTEM_TRIG4_Out;
input		BB_SYSTEM_ECHO4_In;
	
	// I2C Master
output	BB_SYSTEM_SCL_Out;
inout		BB_SYSTEM_SDA_InOut;	
	
	// SPI Slave
input		BB_SYSTEM_SCLK_In;
output	BB_SYSTEM_MISO_Out;
input		BB_SYSTEM_MOSI_In;
input		BB_SYSTEM_CS_In;
	
	// Debug
output [3:0]	BB_SYSTEM_LEDs_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [2:0] waypoint_selection;
wire stop_signal;
wire begin_signal;

wire [1:0] movement_selection; 

wire [DATA_WIDTH-1:0] distance_1;
wire [DATA_WIDTH-1:0] distance_2;
wire [DATA_WIDTH-1:0] distance_3;
wire [DATA_WIDTH-1:0] distance_4;

wire [DATA_WIDTH-1:0] target_vx;
wire [DATA_WIDTH-1:0] target_vy;
wire [DATA_WIDTH-1:0] target_wz;

wire [DATA_WIDTH-1:0] target_W1;
wire [DATA_WIDTH-1:0] target_W2;
wire [DATA_WIDTH-1:0] target_W3;
wire [DATA_WIDTH-1:0] target_W4;

wire [INT_WIDTH-1:0] rpms_1;
wire [INT_WIDTH-1:0] rpms_2;
wire [INT_WIDTH-1:0] rpms_3;
wire [INT_WIDTH-1:0] rpms_4;

wire [DATA_WIDTH-1:0] current_W1;
wire [DATA_WIDTH-1:0] current_W2;
wire [DATA_WIDTH-1:0] current_W3;
wire [DATA_WIDTH-1:0] current_W4;

wire [DATA_WIDTH-1:0] global_pos_x;
wire [DATA_WIDTH-1:0] global_pos_y;
wire [DATA_WIDTH-1:0] theta_angle;

wire [DATA_WIDTH-1:0] target_posx;
wire [DATA_WIDTH-1:0] target_posy;
wire [DATA_WIDTH-1:0] target_theta;

wire [DATA_WIDTH-1:0] velocity_x_posc;
wire [DATA_WIDTH-1:0] velocity_y_posc;
wire [DATA_WIDTH-1:0] velocity_z_posc;

wire [DATA_WIDTH-1:0] velocity_x_behavior;
wire [DATA_WIDTH-1:0] velocity_y_behavior;
wire [DATA_WIDTH-1:0] velocity_z_behavior;

wire TICK_167ms;
wire CLK_82us;

//=======================================================
//  STRUCTURAL coding
//=======================================================

//////////////////////////////////////////////////////////// FOR SPI COMMUNICATION

SPI_INTERFACE SPI_INTERFACE_U0
(
	//////////// INPUTS //////////
	.SPI_INTERFACE_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.SPI_INTERFACE_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	.SPI_INTERFACE_SS_InLow(BB_SYSTEM_CS_In),
	.SPI_INTERFACE_MOSI_In(BB_SYSTEM_MOSI_In),
	.SPI_INTERFACE_SCK_In(BB_SYSTEM_SCLK_In),
	
	.SPI_INTERFACE_POSX_InBus(global_pos_x),
	.SPI_INTERFACE_POSY_InBus(global_pos_y),
	.SPI_INTERFACE_THETA_InBus(theta_angle),
	
	.SPI_INTERFACE_RPM1_InBus(rpms_1),
	.SPI_INTERFACE_RPM2_InBus(rpms_2),
	.SPI_INTERFACE_RPM3_InBus(rpms_3),
	.SPI_INTERFACE_RPM4_InBus(rpms_4),
	
	.SPI_INTERFACE_DIST1_InBus(distance_1),
	.SPI_INTERFACE_DIST2_InBus(distance_2),
	.SPI_INTERFACE_DIST3_InBus(distance_3),
	.SPI_INTERFACE_DIST4_InBus(distance_4),
	
	.SPI_INTERFACE_BEHAVIOR_InBus(8'd0),
	
	.SPI_INTERFACE_IMUX_InBus(17'b0_11001000_00000000), // 200, 201, 202
	.SPI_INTERFACE_IMUY_InBus(17'b0_11001001_00000000),
	.SPI_INTERFACE_IMUZ_InBus(17'b0_11001010_00000000),
	
	//////////// OUTPUTS ////////// 
	.SPI_INTERFACE_MISO_Out(BB_SYSTEM_MISO_Out),
	
	.SPI_INTERFACE_WAYSELECT_OutBus(waypoint_selection),
	.SPI_INTERFACE_STOPSIGNAL_OutLow(stop_signal), // active in low
	.SPI_INTERFACE_BEGINSIGNAL_OutLow(begin_signal) // active in low
);


// LEDS FOR QUICKLY DEBUGGING OF WAYPOINTS FROM SPI COMMANDS
assign BB_SYSTEM_LEDs_OutBus[0] = ~waypoint_selection[0];
assign BB_SYSTEM_LEDs_OutBus[1] = ~waypoint_selection[1];
assign BB_SYSTEM_LEDs_OutBus[2] = ~waypoint_selection[2];
assign BB_SYSTEM_LEDs_OutBus[3] = stop_signal;


//////////////////////////////////////////////////////////// FOR PROXIMITY SENSORS

DISTANCE_READER SENSOR_1
(
	//////////// INPUTS //////////
	.DISTANCE_READER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.DISTANCE_READER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.DISTANCE_READER_ECHO_In(BB_SYSTEM_ECHO1_In),
	
	//////////// OUTPUTS //////////
	.DISTANCE_READER_TRIGGER_Out(BB_SYSTEM_TRIG1_Out),
	.DISTANCE_READER_DISTANCE_OutBus(distance_1)
);

DISTANCE_READER SENSOR_2
(
	//////////// INPUTS //////////
	.DISTANCE_READER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.DISTANCE_READER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.DISTANCE_READER_ECHO_In(BB_SYSTEM_ECHO2_In),
	
	//////////// OUTPUTS //////////
	.DISTANCE_READER_TRIGGER_Out(BB_SYSTEM_TRIG2_Out),
	.DISTANCE_READER_DISTANCE_OutBus(distance_2)
);

DISTANCE_READER SENSOR_3
(
	//////////// INPUTS //////////
	.DISTANCE_READER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.DISTANCE_READER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.DISTANCE_READER_ECHO_In(BB_SYSTEM_ECHO3_In),
	
	//////////// OUTPUTS //////////
	.DISTANCE_READER_TRIGGER_Out(BB_SYSTEM_TRIG3_Out),
	.DISTANCE_READER_DISTANCE_OutBus(distance_3)
);

DISTANCE_READER SENSOR_4
(
	//////////// INPUTS //////////
	.DISTANCE_READER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.DISTANCE_READER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.DISTANCE_READER_ECHO_In(BB_SYSTEM_ECHO4_In),
	
	//////////// OUTPUTS //////////
	.DISTANCE_READER_TRIGGER_Out(BB_SYSTEM_TRIG4_Out),
	.DISTANCE_READER_DISTANCE_OutBus(distance_4)
);


//////////////////////////////////////////////////////////// FOR MOTORS

CC_MUX81 CC_MUX81_U0 // velocities in m/s and rad/s
(
//////////// OUTPUTS //////////
	.CC_MUX81_x_OutBus(target_vx),
	.CC_MUX81_y_OutBus(target_vy),
	.CC_MUX81_z_OutBus(target_wz),
	
//////////// INPUTS //////////
	.CC_MUX81_x1_InBus(17'b0), // 0m/s
	.CC_MUX81_x2_InBus(17'b0_00000000_00100000), // 0.125m/s
	.CC_MUX81_x3_InBus(17'b0_00000000_01000000), // 0.25m/s
	.CC_MUX81_x4_InBus(17'b0_00000000_01100000), // 0.375m/s
	.CC_MUX81_x5_InBus(17'b0_00000000_10000000), // 0.5m/s
	.CC_MUX81_x6_InBus(17'b1_00000000_01100000), // -0.375m/s
	.CC_MUX81_x7_InBus(17'b0),
	.CC_MUX81_x8_InBus(17'b0),  
	
	.CC_MUX81_y1_InBus(17'b0), // 0m/s
	.CC_MUX81_y2_InBus(17'b0),
	.CC_MUX81_y3_InBus(17'b0),
	.CC_MUX81_y4_InBus(17'b0),
	.CC_MUX81_y5_InBus(17'b0),
	.CC_MUX81_y6_InBus(17'b0),
	.CC_MUX81_y7_InBus(17'b0_00000000_01100000), // +0.375m/s
	.CC_MUX81_y8_InBus(17'b1_00000000_01100000), // -0.375m/s
	
	.CC_MUX81_z1_InBus(17'b0), // 0rad/s
	.CC_MUX81_z2_InBus(17'b0),
	.CC_MUX81_z3_InBus(17'b0),
	.CC_MUX81_z4_InBus(17'b0),
	.CC_MUX81_z5_InBus(17'b0),
	.CC_MUX81_z6_InBus(17'b0),
	.CC_MUX81_z7_InBus(17'b0),
	.CC_MUX81_z8_InBus(17'b0),
	
	.CC_MUX81_select_InBus(waypoint_selection)
);


//CC_MUX41 CC_MUX41_U0 // velocities in m/s and rad/s
//(
//	//////////// OUTPUTS //////////
//	.CC_MUX41_x_OutBus(target_vx),
//	.CC_MUX41_y_OutBus(target_vy),
//	.CC_MUX41_z_OutBus(target_wz),
//	
//	//////////// INPUTS //////////
//	.CC_MUX41_x1_InBus(17'b0), // 0m/s
//	.CC_MUX41_x2_InBus(velocity_x_posc),
//	.CC_MUX41_x3_InBus(velocity_x_behavior),
//	.CC_MUX41_x4_InBus(17'b0), // 0m/s  
//	
//	.CC_MUX41_y1_InBus(17'b0), // 0m/s
//	.CC_MUX41_y2_InBus(velocity_y_posc),
//	.CC_MUX41_y3_InBus(velocity_y_behavior),
//	.CC_MUX41_y4_InBus(17'b0), // 0m/s
//	
//	.CC_MUX41_z1_InBus(17'b0), // 0rad/s
//	.CC_MUX41_z2_InBus(velocity_z_posc),
//	.CC_MUX41_z3_InBus(velocity_z_behavior),
//	.CC_MUX41_z4_InBus(17'b0), // 0rad/s
//	
//	.CC_MUX41_select_InBus(2'b01) //(movement_selection) original, but for tests it selects position controller
//);


MOVEMENT_CONTROLLER MOVEMENT_CONTROLLER_U0
(
	//////////// INPUTS //////////
	.MOVEMENT_CONTROLLER_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.MOVEMENT_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.MOVEMENT_CONTROLLER_TARGETVX_InBus(target_vx),
	.MOVEMENT_CONTROLLER_TARGETVY_InBus(target_vy),
	.MOVEMENT_CONTROLLER_TARGETWZ_InBus(target_wz),
	
	//////////// OUTPUTS //////////
	.MOVEMENT_CONTROLLER_W1_OutBus(target_W1),
	.MOVEMENT_CONTROLLER_W2_OutBus(target_W2),
	.MOVEMENT_CONTROLLER_W3_OutBus(target_W3),
	.MOVEMENT_CONTROLLER_W4_OutBus(target_W4)
);


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


WHEEL_CONTROLLER WHEEL_CONTROLLER_1
(
	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(target_W1),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA1_In),
	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
	
	.WHEEL_CONTROLLER_TICK167ms_In(TICK_167ms),
	.WHEEL_CONTROLLER_CLK82us_In(CLK_82us),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN11_Out, BB_SYSTEM_IN12_Out}),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM1_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(rpms_1),
	.WHEEL_CONTROLLER_W_OutBus(current_W1)
);


WHEEL_CONTROLLER WHEEL_CONTROLLER_2
(
	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(target_W2),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA2_In),
	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
	
	.WHEEL_CONTROLLER_TICK167ms_In(TICK_167ms),
	.WHEEL_CONTROLLER_CLK82us_In(CLK_82us),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN22_Out, BB_SYSTEM_IN21_Out}),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM2_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(rpms_2),
	.WHEEL_CONTROLLER_W_OutBus(current_W2)
);


WHEEL_CONTROLLER WHEEL_CONTROLLER_3
(
	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(target_W3),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA3_In),
	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
	
	.WHEEL_CONTROLLER_TICK167ms_In(TICK_167ms),
	.WHEEL_CONTROLLER_CLK82us_In(CLK_82us),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN31_Out, BB_SYSTEM_IN32_Out}),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM3_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(rpms_3),
	.WHEEL_CONTROLLER_W_OutBus(current_W3)
);


WHEEL_CONTROLLER WHEEL_CONTROLLER_4
(
	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(target_W4),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA4_In),
	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
	
	.WHEEL_CONTROLLER_TICK167ms_In(TICK_167ms),
	.WHEEL_CONTROLLER_CLK82us_In(CLK_82us),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN42_Out, BB_SYSTEM_IN41_Out}),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM4_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(rpms_4),
	.WHEEL_CONTROLLER_W_OutBus(current_W4)
);


//////////////////////////////////////////////////////////// FOR ODOMETRY

ODOM_CALCULATOR ODOMETRY_CALCULATOR
(
	//////////// INPUTS //////////
	.ODOM_CALCULATOR_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.ODOM_CALCULATOR_Reset_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.ODOM_CALCULATOR_SETBEGIN_InLow(begin_signal),
	.ODOM_CALCULATOR_W1_InBus(current_W1),
	.ODOM_CALCULATOR_W2_InBus(current_W2),
	.ODOM_CALCULATOR_W3_InBus(current_W3),
	.ODOM_CALCULATOR_W4_InBus(current_W4),
	.ODOM_CALCULATOR_THETA_InBus(theta_angle),

	//////////// OUTPUTS //////////
	.ODOM_CALCULATOR_POSX_OutBus(global_pos_x), // position in global x in m notation fixed point 17b
	.ODOM_CALCULATOR_POSY_OutBus(global_pos_y), // position in global y in m notation fixed point 17b
	.ODOM_CALCULATOR_THETA_OutBus(theta_angle)  // rotation angle in degrees notation fixed point 17b
);


//////////////////////////////////////////////////////////// FOR POSITION CONTROLLER

//CC_MUX81 CC_MUX81_U1 // 8 waypoints for position controller
//(
//	//////////// OUTPUTS //////////
//	.CC_MUX81_x_OutBus(target_posx),
//	.CC_MUX81_y_OutBus(target_posy),
//	.CC_MUX81_z_OutBus(target_theta),
//	
//	//////////// INPUTS //////////
//	.CC_MUX81_x1_InBus(17'b0), // 0m
//	.CC_MUX81_x2_InBus(17'b0),
//	.CC_MUX81_x3_InBus(17'b0_00000001_00000000), // 1m in X
//	.CC_MUX81_x4_InBus(17'b0), 
//	.CC_MUX81_x5_InBus(17'b1_00000001_00000000), // -1m in X
//	.CC_MUX81_x6_InBus(17'b0_00000000_10000000), // 0.5m in X
//	.CC_MUX81_x7_InBus(17'b1_00000000_10000000), // -0.5m in X
//	.CC_MUX81_x8_InBus(17'b0_00000000_01000000), // 0.25m in X 
//	
//	.CC_MUX81_y1_InBus(17'b0), // 0m
//	.CC_MUX81_y2_InBus(17'b0_00000001_00000000), // 1m in Y
//	.CC_MUX81_y3_InBus(17'b0),
//	.CC_MUX81_y4_InBus(17'b1_00000001_00000000), // -1m in Y
//	.CC_MUX81_y5_InBus(17'b0),
//	.CC_MUX81_y6_InBus(17'b0_00000000_10000000), // 0.5m in Y
//	.CC_MUX81_y7_InBus(17'b1_00000000_10000000), // -0.5m in Y
//	.CC_MUX81_y8_InBus(17'b0_00000000_11000000), // 0.75m in Y 
//	
//	.CC_MUX81_z1_InBus(17'b0_01011010_00000000), // 90deg
//	.CC_MUX81_z2_InBus(17'b0_01011010_00000000),
//	.CC_MUX81_z3_InBus(17'b0_01011010_00000000),
//	.CC_MUX81_z4_InBus(17'b0_01011010_00000000),
//	.CC_MUX81_z5_InBus(17'b0_01011010_00000000),
//	.CC_MUX81_z6_InBus(17'b0_01011010_00000000),
//	.CC_MUX81_z7_InBus(17'b0_01011010_00000000),
//	.CC_MUX81_z8_InBus(17'b0_01011010_00000000),
//	
//	.CC_MUX81_select_InBus(waypoint_selection)
//);
//
//
//POS_CONTROLLER POSITION_CONTROLLER
//(
//	//////////// INPUTS //////////
//	.POS_CONTROLLER_TARGETX_InBus(target_posx),
//	.POS_CONTROLLER_TARGETY_InBus(target_posy),
//	.POS_CONTROLLER_TARGETTHETA_InBus(target_theta),
//	
//	.POS_CONTROLLER_CURRENTX_InBus(global_pos_x),
//	.POS_CONTROLLER_CURRENTY_InBus(global_pos_y),
//	.POS_CONTROLLER_CURRENTTHETA_InBus(theta_angle),
//	
//	//////////// OUTPUTS //////////
//	.POS_CONTROLLER_VX_OutBus(velocity_x_posc),
//	.POS_CONTROLLER_VY_OutBus(velocity_y_posc),
//	.POS_CONTROLLER_WZ_OutBus(velocity_z_posc)
//
//);

endmodule
