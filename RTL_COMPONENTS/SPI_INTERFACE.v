//****************************************
// Made by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================

module SPI_INTERFACE
(
	//////////// INPUTS //////////
	SPI_INTERFACE_CLOCK_50,
	SPI_INTERFACE_RESET_InHigh,
	SPI_INTERFACE_SS_InLow,
	SPI_INTERFACE_MOSI_In,
	SPI_INTERFACE_SCK_In,
	
	SPI_INTERFACE_POSX_InBus,
	SPI_INTERFACE_POSY_InBus,
	SPI_INTERFACE_THETA_InBus,
	
	SPI_INTERFACE_RPM1_InBus,
	SPI_INTERFACE_RPM2_InBus,
	SPI_INTERFACE_RPM3_InBus,
	SPI_INTERFACE_RPM4_InBus,
	
	SPI_INTERFACE_DIST1_InBus,
	SPI_INTERFACE_DIST2_InBus,
	SPI_INTERFACE_DIST3_InBus,
	SPI_INTERFACE_DIST4_InBus,
	
	SPI_INTERFACE_BEHAVIOR_InBus,
	
	SPI_INTERFACE_IMUX_InBus,
	SPI_INTERFACE_IMUY_InBus,
	SPI_INTERFACE_IMUZ_InBus,
	
	//////////// OUTPUTS ////////// 
	SPI_INTERFACE_MISO_Out,
	
	SPI_INTERFACE_WAYSELECT_OutBus,
	SPI_INTERFACE_STOPSIGNAL_OutLow,
	SPI_INTERFACE_BEGINSIGNAL_OutLow

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter INT_WIDTH = 8;
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

//=======================================================
//  PORT declarations
//=======================================================
input	SPI_INTERFACE_CLOCK_50;
input	SPI_INTERFACE_RESET_InHigh;
input	SPI_INTERFACE_SS_InLow;
input	SPI_INTERFACE_MOSI_In;
input	SPI_INTERFACE_SCK_In;
	
input [N_WIDTH-1:0]	SPI_INTERFACE_POSX_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_POSY_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_THETA_InBus;
	
input [INT_WIDTH-1:0]	SPI_INTERFACE_RPM1_InBus;
input [INT_WIDTH-1:0]	SPI_INTERFACE_RPM2_InBus;
input [INT_WIDTH-1:0]	SPI_INTERFACE_RPM3_InBus;
input [INT_WIDTH-1:0]	SPI_INTERFACE_RPM4_InBus;
	
input [N_WIDTH-1:0]	SPI_INTERFACE_DIST1_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_DIST2_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_DIST3_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_DIST4_InBus;
	
input [INT_WIDTH-1:0]	SPI_INTERFACE_BEHAVIOR_InBus;
	
input [N_WIDTH-1:0]	SPI_INTERFACE_IMUX_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_IMUY_InBus;
input [N_WIDTH-1:0]	SPI_INTERFACE_IMUZ_InBus;
	
	//////////// OUTPUTS ////////// 
output	SPI_INTERFACE_MISO_Out;
	
output [2:0]	SPI_INTERFACE_WAYSELECT_OutBus;
output	SPI_INTERFACE_STOPSIGNAL_OutLow;
output	SPI_INTERFACE_BEGINSIGNAL_OutLow;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================
wire flag_data_out;
wire [INT_WIDTH-1:0] data_bus_out;
wire [INT_WIDTH-1:0] data_bus_in;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SPI_SLAVE #(.DATAWIDTH_BUS(8), .STATE_SIZE(3)) SPI_U0
(
//////////// OUTPUTS ////////////
	.SPI_SLAVE_MISO_Out(SPI_INTERFACE_MISO_Out),
	.SPI_SLAVE_newData_Out(flag_data_out),
	.SPI_SLAVE_data_Out(data_bus_out),
//////////// INPUTS ////////////
	.SPI_SLAVE_CLOCK_50(SPI_INTERFACE_CLOCK_50),
	.SPI_SLAVE_RESET_InHigh(SPI_INTERFACE_RESET_InHigh),
	.SPI_SLAVE_SS_InLow(SPI_INTERFACE_SS_InLow),
	.SPI_SLAVE_MOSI_In(SPI_INTERFACE_MOSI_In),
	.SPI_SLAVE_SCK_In(SPI_INTERFACE_SCK_In),
	.SPI_SLAVE_data_In(data_bus_in)
);


MESSAGE_INTERPRETER MESSAGE_INT_U0
(
	//////////// INPUTS //////////
	.MESSAGE_INTERPRETER_CLOCK_50(SPI_INTERFACE_CLOCK_50),
	.MESSAGE_INTERPRETER_RESET_InHigh(SPI_INTERFACE_RESET_InHigh),
	
	.MESSAGE_INTERPRETER_FLAGDATAIN_In(flag_data_out),
	.MESSAGE_INTERPRETER_DATAIN_InBus(data_bus_out),
	
	.MESSAGE_INTERPRETER_POSX_InBus(SPI_INTERFACE_POSX_InBus),
	.MESSAGE_INTERPRETER_POSY_InBus(SPI_INTERFACE_POSY_InBus),
	.MESSAGE_INTERPRETER_THETA_InBus(SPI_INTERFACE_THETA_InBus),
	
	.MESSAGE_INTERPRETER_RPM1_InBus(SPI_INTERFACE_RPM1_InBus),
	.MESSAGE_INTERPRETER_RPM2_InBus(SPI_INTERFACE_RPM2_InBus),
	.MESSAGE_INTERPRETER_RPM3_InBus(SPI_INTERFACE_RPM3_InBus),
	.MESSAGE_INTERPRETER_RPM4_InBus(SPI_INTERFACE_RPM4_InBus),
	
	.MESSAGE_INTERPRETER_DIST1_InBus(SPI_INTERFACE_DIST1_InBus),
	.MESSAGE_INTERPRETER_DIST2_InBus(SPI_INTERFACE_DIST2_InBus),
	.MESSAGE_INTERPRETER_DIST3_InBus(SPI_INTERFACE_DIST3_InBus),
	.MESSAGE_INTERPRETER_DIST4_InBus(SPI_INTERFACE_DIST4_InBus),
	
	.MESSAGE_INTERPRETER_BEHAVIOR_InBus(SPI_INTERFACE_BEHAVIOR_InBus),
	
	.MESSAGE_INTERPRETER_IMUX_InBus(SPI_INTERFACE_IMUX_InBus),
	.MESSAGE_INTERPRETER_IMUY_InBus(SPI_INTERFACE_IMUY_InBus),
	.MESSAGE_INTERPRETER_IMUZ_InBus(SPI_INTERFACE_IMUZ_InBus),
	
	//////////// OUTPUTS ////////// 
	.MESSAGE_INTERPRETER_DATAOUT_OutBus(data_bus_in),
	
	.MESSAGE_INTERPRETER_WAYSELECT_OutBus(SPI_INTERFACE_WAYSELECT_OutBus),
	.MESSAGE_INTERPRETER_STOPSIGNAL_OutLow(SPI_INTERFACE_STOPSIGNAL_OutLow),
	.MESSAGE_INTERPRETER_BEGINSIGNAL_OutLow(SPI_INTERFACE_BEGINSIGNAL_OutLow)

);
endmodule
