
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
	BB_SYSTEM_PHASEB1_In,

	BB_SYSTEM_PWM2_Out,
	BB_SYSTEM_IN21_Out,
	BB_SYSTEM_IN22_Out,
	BB_SYSTEM_PHASEA2_In,
	BB_SYSTEM_PHASEB2_In,
	
	BB_SYSTEM_PWM3_Out,
	BB_SYSTEM_IN31_Out,
	BB_SYSTEM_IN32_Out,
	BB_SYSTEM_PHASEA3_In,
	BB_SYSTEM_PHASEB3_In,

	BB_SYSTEM_PWM4_Out,
	BB_SYSTEM_IN41_Out,
	BB_SYSTEM_IN42_Out,	
	BB_SYSTEM_PHASEA4_In,
	BB_SYSTEM_PHASEB4_In,
	
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
	BB_SYSTEM_LEDs_OutBus,
	BB_SYSTEM_SELECT_InBus
	
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATA_WIDTH = 32;
parameter INT_WIDTH = 8;

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
input		BB_SYSTEM_PHASEB1_In;

output	BB_SYSTEM_PWM2_Out;
output	BB_SYSTEM_IN21_Out;
output	BB_SYSTEM_IN22_Out;
input		BB_SYSTEM_PHASEA2_In;
input		BB_SYSTEM_PHASEB2_In;
	
output	BB_SYSTEM_PWM3_Out;
output	BB_SYSTEM_IN31_Out;
output	BB_SYSTEM_IN32_Out;
input		BB_SYSTEM_PHASEA3_In;
input		BB_SYSTEM_PHASEB3_In;

output	BB_SYSTEM_PWM4_Out;
output	BB_SYSTEM_IN41_Out;
output	BB_SYSTEM_IN42_Out;	
input		BB_SYSTEM_PHASEA4_In;
input		BB_SYSTEM_PHASEB4_In;
	
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
input  [2:0]	BB_SYSTEM_SELECT_InBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [2:0] waypoint_selection;
wire stop_signal;
wire begin_signal;

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
	
	.SPI_INTERFACE_POSX_InBus(32'b0),
	.SPI_INTERFACE_POSY_InBus(32'b0),
	.SPI_INTERFACE_THETA_InBus(32'b0),
	
	.SPI_INTERFACE_RPM1_InBus(8'b0),
	.SPI_INTERFACE_RPM2_InBus(8'b0),
	.SPI_INTERFACE_RPM3_InBus(8'b0),
	.SPI_INTERFACE_RPM4_InBus(8'b0),
	
	.SPI_INTERFACE_DIST1_InBus(32'b0),
	.SPI_INTERFACE_DIST2_InBus(32'b0),
	.SPI_INTERFACE_DIST3_InBus(32'b0),
	.SPI_INTERFACE_DIST4_InBus(32'b0),
	
	.SPI_INTERFACE_BEHAVIOR_InBus(8'd130), //for testing rpms_1 to monitoring
	
	.SPI_INTERFACE_IMUX_InBus(32'b0),
	.SPI_INTERFACE_IMUY_InBus(32'b0),
	.SPI_INTERFACE_IMUZ_InBus(32'b0),
	
	//////////// OUTPUTS ////////// 
	.SPI_INTERFACE_MISO_Out(BB_SYSTEM_MISO_Out),
	
	.SPI_INTERFACE_WAYSELECT_OutBus(waypoint_selection),
	.SPI_INTERFACE_STOPSIGNAL_OutLow(stop_signal), // active in low
	.SPI_INTERFACE_BEGINSIGNAL_OutLow(begin_signal) // active in low

);

assign BB_SYSTEM_LEDs_OutBus[0] = ~waypoint_selection[0];
assign BB_SYSTEM_LEDs_OutBus[1] = ~waypoint_selection[1];
assign BB_SYSTEM_LEDs_OutBus[2] = ~waypoint_selection[2];
assign BB_SYSTEM_LEDs_OutBus[3] = stop_signal;

//////////////////////////////////////////////////////////// FOR MOTORS

CC_MUX81 CC_MUX81_U0 // velocities in m/s and rad/s
(
//////////// OUTPUTS //////////
	.CC_MUX81_x_OutBus(target_vx),
	.CC_MUX81_y_OutBus(target_vy),
	.CC_MUX81_z_OutBus(target_wz),
	
//////////// INPUTS //////////
	.CC_MUX81_x1_InBus(32'b0), // 0m/s
	.CC_MUX81_x2_InBus(32'b0_0000000000000000_001000000000000), // 0.125m/s
	.CC_MUX81_x3_InBus(32'b0_0000000000000000_010000000000000), // 0.25m/s
	.CC_MUX81_x4_InBus(32'b0_0000000000000000_011000000000000), // 0.375m/s
	.CC_MUX81_x5_InBus(32'b0_0000000000000000_100000000000000), // 0.5m/s
	.CC_MUX81_x6_InBus(32'b1_0000000000000000_100000000000000), // -0.5m/s
	.CC_MUX81_x7_InBus(32'b0),
	.CC_MUX81_x8_InBus(32'b0),  
	
	.CC_MUX81_y1_InBus(32'b0), // 0m/s
	.CC_MUX81_y2_InBus(32'b0),
	.CC_MUX81_y3_InBus(32'b0),
	.CC_MUX81_y4_InBus(32'b0),
	.CC_MUX81_y5_InBus(32'b0),
	.CC_MUX81_y6_InBus(32'b0),
	.CC_MUX81_y7_InBus(32'b0_0000000000000000_100000000000000), // +0.5m/s
	.CC_MUX81_y8_InBus(32'b1_0000000000000000_100000000000000), // -0.5m/s
	
	.CC_MUX81_z1_InBus(32'b0), // 0rad/s
	.CC_MUX81_z2_InBus(32'b0),
	.CC_MUX81_z3_InBus(32'b0),
	.CC_MUX81_z4_InBus(32'b0),
	.CC_MUX81_z5_InBus(32'b0),
	.CC_MUX81_z6_InBus(32'b0),
	.CC_MUX81_z7_InBus(32'b0),
	.CC_MUX81_z8_InBus(32'b0),
	
	.CC_MUX81_select_InBus(BB_SYSTEM_SELECT_InBus)
);


//assign BB_SYSTEM_LEDs_OutBus[0] = BB_SYSTEM_SELECT_InBus[0];
//assign BB_SYSTEM_LEDs_OutBus[1] = BB_SYSTEM_SELECT_InBus[1];
//assign BB_SYSTEM_LEDs_OutBus[2] = BB_SYSTEM_SELECT_InBus[2];


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


WHEEL_CONTROLLER WHEEL_CONTROLLER_1
(
	//////////// INPUTS //////////
	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
	
	.WHEEL_CONTROLLER_TARGETW_InBus(target_W1),
	
	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA1_In),
	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
	
	//////////// OUTPUTS ////////// 
	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN11_Out, BB_SYSTEM_IN12_Out}),
	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM1_Out),
	.WHEEL_CONTROLLER_RPM_OutBus(rpms_1),
	.WHEEL_CONTROLLER_W_OutBus(current_W1)
);


//WHEEL_CONTROLLER WHEEL_CONTROLLER_2
//(
//	//////////// INPUTS //////////
//	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
//	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
//	
//	.WHEEL_CONTROLLER_TARGETW_InBus(target_W2),
//	
//	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA2_In),
//	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
//	
//	//////////// OUTPUTS ////////// 
//	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN22_Out, BB_SYSTEM_IN21_Out}),
//	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM2_Out),
//	.WHEEL_CONTROLLER_RPM_OutBus(rpms_2),
//	.WHEEL_CONTROLLER_W_OutBus(current_W2)
//);
//
//
//WHEEL_CONTROLLER WHEEL_CONTROLLER_3
//(
//	//////////// INPUTS //////////
//	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
//	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
//	
//	.WHEEL_CONTROLLER_TARGETW_InBus(target_W3),
//	
//	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA3_In),
//	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
//	
//	//////////// OUTPUTS ////////// 
//	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN32_Out, BB_SYSTEM_IN31_Out}),
//	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM3_Out),
//	.WHEEL_CONTROLLER_RPM_OutBus(rpms_3),
//	.WHEEL_CONTROLLER_W_OutBus(current_W3)
//);
//
//
//WHEEL_CONTROLLER WHEEL_CONTROLLER_4
//(
//	//////////// INPUTS //////////
//	.WHEEL_CONTROLLER_CLOCK(BB_SYSTEM_CLOCK_50),
//	.WHEEL_CONTROLLER_RESET_InHigh(~BB_SYSTEM_RESET_InLow),
//	
//	.WHEEL_CONTROLLER_TARGETW_InBus(target_W4),
//	
//	.WHEEL_CONTROLLER_ENCODERA_In(BB_SYSTEM_PHASEA4_In),
//	.WHEEL_CONTROLLER_ENCODERB_In(1'b0),
//	
//	//////////// OUTPUTS ////////// 
//	.WHEEL_CONTROLLER_DIR_OutBus({BB_SYSTEM_IN42_Out, BB_SYSTEM_IN41_Out}),
//	.WHEEL_CONTROLLER_PWM_Out(BB_SYSTEM_PWM4_Out),
//	.WHEEL_CONTROLLER_RPM_OutBus(rpms_4),
//	.WHEEL_CONTROLLER_W_OutBus(current_W4)
//);






endmodule
