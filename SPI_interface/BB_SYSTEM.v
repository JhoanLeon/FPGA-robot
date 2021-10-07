
//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM
(
	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_RESET_InHigh,
	BB_SYSTEM_SS_InLow,
	BB_SYSTEM_MOSI_In,
	BB_SYSTEM_SCK_In,
	
	BB_SYSTEM_POSX_InBus,
	BB_SYSTEM_POSY_InBus,
	BB_SYSTEM_THETA_InBus,
	
	BB_SYSTEM_RPM1_InBus,
	BB_SYSTEM_RPM2_InBus,
	BB_SYSTEM_RPM3_InBus,
	BB_SYSTEM_RPM4_InBus,
	
	BB_SYSTEM_DIST1_InBus,
	BB_SYSTEM_DIST2_InBus,
	BB_SYSTEM_DIST3_InBus,
	BB_SYSTEM_DIST4_InBus,
	
	BB_SYSTEM_BEHAVIOR_InBus,
	
	BB_SYSTEM_IMUX_InBus,
	BB_SYSTEM_IMUY_InBus,
	BB_SYSTEM_IMUZ_InBus,
	
	//////////// OUTPUTS ////////// 
	BB_SYSTEM_MISO_Out,
	
	BB_SYSTEM_WAYSELECT_OutBus,
	BB_SYSTEM_STOPSIGNAL_OutLow,
	BB_SYSTEM_BEGINSIGNAL_OutLow

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
input	BB_SYSTEM_CLOCK_50;
input	BB_SYSTEM_RESET_InHigh;
input	BB_SYSTEM_SS_InLow;
input	BB_SYSTEM_MOSI_In;
input	BB_SYSTEM_SCK_In;
	
input [N_WIDTH-1:0]	BB_SYSTEM_POSX_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_POSY_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_THETA_InBus;
	
input [INT_WIDTH-1:0]	BB_SYSTEM_RPM1_InBus;
input [INT_WIDTH-1:0]	BB_SYSTEM_RPM2_InBus;
input [INT_WIDTH-1:0]	BB_SYSTEM_RPM3_InBus;
input [INT_WIDTH-1:0]	BB_SYSTEM_RPM4_InBus;
	
input [N_WIDTH-1:0]	BB_SYSTEM_DIST1_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_DIST2_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_DIST3_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_DIST4_InBus;
	
input [INT_WIDTH-1:0]	BB_SYSTEM_BEHAVIOR_InBus;
	
input [N_WIDTH-1:0]	BB_SYSTEM_IMUX_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_IMUY_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_IMUZ_InBus;
	
	//////////// OUTPUTS ////////// 
output	BB_SYSTEM_MISO_Out;
	
output [2:0]	BB_SYSTEM_WAYSELECT_OutBus;
output	BB_SYSTEM_STOPSIGNAL_OutLow;
output	BB_SYSTEM_BEGINSIGNAL_OutLow;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

SPI_INTERFACE SPI_INTERFACE_U0
(	
	//////////// INPUTS //////////
	.SPI_INTERFACE_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.SPI_INTERFACE_RESET_InHigh(BB_SYSTEM_RESET_InHigh),
	.SPI_INTERFACE_SS_InLow(BB_SYSTEM_SS_InLow),
	.SPI_INTERFACE_MOSI_In(BB_SYSTEM_MOSI_In),
	.SPI_INTERFACE_SCK_In(BB_SYSTEM_SCK_In),
	
	.SPI_INTERFACE_POSX_InBus(BB_SYSTEM_POSX_InBus),
	.SPI_INTERFACE_POSY_InBus(BB_SYSTEM_POSY_InBus),
	.SPI_INTERFACE_THETA_InBus(BB_SYSTEM_THETA_InBus),
	
	.SPI_INTERFACE_RPM1_InBus(BB_SYSTEM_RPM1_InBus),
	.SPI_INTERFACE_RPM2_InBus(BB_SYSTEM_RPM2_InBus),
	.SPI_INTERFACE_RPM3_InBus(BB_SYSTEM_RPM3_InBus),
	.SPI_INTERFACE_RPM4_InBus(BB_SYSTEM_RPM4_InBus),
	
	.SPI_INTERFACE_DIST1_InBus(BB_SYSTEM_DIST1_InBus),
	.SPI_INTERFACE_DIST2_InBus(BB_SYSTEM_DIST2_InBus),
	.SPI_INTERFACE_DIST3_InBus(BB_SYSTEM_DIST3_InBus),
	.SPI_INTERFACE_DIST4_InBus(BB_SYSTEM_DIST4_InBus),
	
	.SPI_INTERFACE_BEHAVIOR_InBus(BB_SYSTEM_BEHAVIOR_InBus),
	
	.SPI_INTERFACE_IMUX_InBus(BB_SYSTEM_IMUX_InBus),
	.SPI_INTERFACE_IMUY_InBus(BB_SYSTEM_IMUY_InBus),
	.SPI_INTERFACE_IMUZ_InBus(BB_SYSTEM_IMUZ_InBus),
	
	//////////// OUTPUTS ////////// 
	.SPI_INTERFACE_MISO_Out(BB_SYSTEM_MISO_Out),
	
	.SPI_INTERFACE_WAYSELECT_OutBus(BB_SYSTEM_WAYSELECT_OutBus),
	.SPI_INTERFACE_STOPSIGNAL_OutLow(BB_SYSTEM_STOPSIGNAL_OutLow),
	.SPI_INTERFACE_BEGINSIGNAL_OutLow(BB_SYSTEM_BEGINSIGNAL_OutLow)

);

endmodule
