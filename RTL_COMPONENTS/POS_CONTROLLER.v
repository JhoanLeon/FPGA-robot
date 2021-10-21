/*
Created by: Jhoan Esteban Leon - je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library

inputs and output are in fixed point 32b notation U(32,15) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module POS_CONTROLLER
(
	//////////// INPUTS //////////
	POS_CONTROLLER_TARGETX_InBus,
	POS_CONTROLLER_TARGETY_InBus,
	POS_CONTROLLER_TARGETTHETA_InBus,
	
	POS_CONTROLLER_CURRENTX_InBus,
	POS_CONTROLLER_CURRENTY_InBus,
	POS_CONTROLLER_CURRENTTHETA_InBus,
	
	//////////// OUTPUTS //////////
	POS_CONTROLLER_VX_OutBus,
	POS_CONTROLLER_VY_OutBus,
	POS_CONTROLLER_WZ_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

//=======================================================
//  PORT declarations
//=======================================================
input [N_WIDTH-1:0]	POS_CONTROLLER_TARGETX_InBus;
input [N_WIDTH-1:0]	POS_CONTROLLER_TARGETY_InBus;
input [N_WIDTH-1:0]	POS_CONTROLLER_TARGETTHETA_InBus;
	
input [N_WIDTH-1:0]	POS_CONTROLLER_CURRENTX_InBus;
input [N_WIDTH-1:0]	POS_CONTROLLER_CURRENTY_InBus;
input [N_WIDTH-1:0]	POS_CONTROLLER_CURRENTTHETA_InBus;
	
output [N_WIDTH-1:0]	POS_CONTROLLER_VX_OutBus;
output [N_WIDTH-1:0]	POS_CONTROLLER_VY_OutBus;
output [N_WIDTH-1:0]	POS_CONTROLLER_WZ_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [N_WIDTH-1:0] error_pos_x;
wire [N_WIDTH-1:0] error_pos_y;
wire [N_WIDTH-1:0] error_theta;

//=======================================================
//  STRUCTURAL coding
//=======================================================

qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) sub_error_x
(
    .a(POS_CONTROLLER_TARGETX_InBus),
    .b({~POS_CONTROLLER_CURRENTX_InBus[N_WIDTH-1],POS_CONTROLLER_CURRENTX_InBus[N_WIDTH-2:0]}),
    .c(error_pos_x)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) sub_error_y
(
    .a(POS_CONTROLLER_TARGETY_InBus),
    .b({~POS_CONTROLLER_CURRENTY_InBus[N_WIDTH-1],POS_CONTROLLER_CURRENTY_InBus[N_WIDTH-2:0]}),
    .c(error_pos_y)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) sub_error_theta
(
    .a(POS_CONTROLLER_TARGETTHETA_InBus),
    .b({~POS_CONTROLLER_CURRENTTHETA_InBus[N_WIDTH-1],POS_CONTROLLER_CURRENTTHETA_InBus[N_WIDTH-2:0]}),
    .c(error_theta)
);


ERROR_CONTROL error_mangmt
(
	//////////// INPUTS //////////
	.ERROR_CONTROL_X_InBus(error_pos_x),
	.ERROR_CONTROL_Y_InBus(error_pos_y),
	.ERROR_CONTROL_Z_InBus(error_theta),
	
	//////////// OUTPUTS //////////
	.ERROR_CONTROL_VX_OutBus(POS_CONTROLLER_VX_OutBus), 
	.ERROR_CONTROL_VY_OutBus(POS_CONTROLLER_VY_OutBus), 
	.ERROR_CONTROL_WZ_OutBus(POS_CONTROLLER_WZ_OutBus) 
);



endmodule
