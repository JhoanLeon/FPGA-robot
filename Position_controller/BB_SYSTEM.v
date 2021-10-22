
//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM
(
	//////////// INPUTS //////////	
	BB_SYSTEM_TARGETX_InBus,
	BB_SYSTEM_TARGETY_InBus,
	BB_SYSTEM_TARGETTHETA_InBus,
	
	BB_SYSTEM_CURRENTX_InBus,
	BB_SYSTEM_CURRENTY_InBus,
	BB_SYSTEM_CURRENTTHETA_InBus,
	
	//////////// OUTPUTS //////////
	BB_SYSTEM_VX_OutBus,
	BB_SYSTEM_VY_OutBus,
	BB_SYSTEM_WZ_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETX_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETY_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_TARGETTHETA_InBus;
	
input [N_WIDTH-1:0]	BB_SYSTEM_CURRENTX_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_CURRENTY_InBus;
input [N_WIDTH-1:0]	BB_SYSTEM_CURRENTTHETA_InBus;
	
output [N_WIDTH-1:0]	BB_SYSTEM_VX_OutBus;
output [N_WIDTH-1:0]	BB_SYSTEM_VY_OutBus;
output [N_WIDTH-1:0]	BB_SYSTEM_WZ_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

POS_CONTROLLER U0
(
	//////////// INPUTS //////////	
	.POS_CONTROLLER_TARGETX_InBus(BB_SYSTEM_TARGETX_InBus),
	.POS_CONTROLLER_TARGETY_InBus(BB_SYSTEM_TARGETY_InBus),
	.POS_CONTROLLER_TARGETTHETA_InBus(BB_SYSTEM_TARGETTHETA_InBus),
	
	.POS_CONTROLLER_CURRENTX_InBus(BB_SYSTEM_CURRENTX_InBus),
	.POS_CONTROLLER_CURRENTY_InBus(BB_SYSTEM_CURRENTY_InBus),
	.POS_CONTROLLER_CURRENTTHETA_InBus(BB_SYSTEM_CURRENTTHETA_InBus),
	
	//////////// OUTPUTS //////////
	.POS_CONTROLLER_VX_OutBus(BB_SYSTEM_VX_OutBus),
	.POS_CONTROLLER_VY_OutBus(BB_SYSTEM_VY_OutBus),
	.POS_CONTROLLER_WZ_OutBus(BB_SYSTEM_WZ_OutBus)
);

endmodule
