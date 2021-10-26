/*
Created by: Jhoan Esteban Leon - je.leon.e@outlook.com
inputs velocities are in [rad/s] and output results are in [m] fixed point 17b notation U(32,15) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module ODOM_CALCULATOR 
(
	//////////// INPUTS //////////
	ODOM_CALCULATOR_CLOCK_50,
	ODOM_CALCULATOR_Reset_InHigh,
	
	ODOM_CALCULATOR_SETBEGIN_InLow,
	ODOM_CALCULATOR_TICKLOAD_InLow,
	ODOM_CALCULATOR_W1_InBus,
	ODOM_CALCULATOR_W2_InBus,
	ODOM_CALCULATOR_W3_InBus,
	ODOM_CALCULATOR_W4_InBus,
	ODOM_CALCULATOR_THETA_InBus,

	//////////// OUTPUTS //////////
	ODOM_CALCULATOR_POSX_OutBus, // position in global x in m notation fixed point 17b
	ODOM_CALCULATOR_POSY_OutBus, // position in global y in m notation fixed point 17b
	ODOM_CALCULATOR_THETA_OutBus  // rotation angle in degrees notation fixed point 17b
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
input ODOM_CALCULATOR_CLOCK_50;
input ODOM_CALCULATOR_Reset_InHigh;

input ODOM_CALCULATOR_SETBEGIN_InLow;
input ODOM_CALCULATOR_TICKLOAD_InLow;
input [N_WIDTH-1:0] ODOM_CALCULATOR_W1_InBus;
input [N_WIDTH-1:0] ODOM_CALCULATOR_W2_InBus;
input [N_WIDTH-1:0] ODOM_CALCULATOR_W3_InBus;
input [N_WIDTH-1:0] ODOM_CALCULATOR_W4_InBus;
input [N_WIDTH-1:0] ODOM_CALCULATOR_THETA_InBus;

output [N_WIDTH-1:0] ODOM_CALCULATOR_POSX_OutBus;
output [N_WIDTH-1:0] ODOM_CALCULATOR_POSY_OutBus;
output [N_WIDTH-1:0] ODOM_CALCULATOR_THETA_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [N_WIDTH-1:0] local_vx;
wire [N_WIDTH-1:0] local_vy;
wire [N_WIDTH-1:0] local_wz;

wire [N_WIDTH-1:0] global_vx;
wire [N_WIDTH-1:0] global_vy;
wire [N_WIDTH-1:0] global_wz;

//=======================================================
//  STRUCTURAL coding
//=======================================================

LOCAL_VELOCITY U0
(
	//////////// INPUTS //////////
	.LOCAL_VELOCITY_CLOCK_50(ODOM_CALCULATOR_CLOCK_50),
	.LOCAL_VELOCITY_Reset_InHigh(ODOM_CALCULATOR_Reset_InHigh),
	
	.LOCAL_VELOCITY_W1_InBus(ODOM_CALCULATOR_W1_InBus),
	.LOCAL_VELOCITY_W2_InBus(ODOM_CALCULATOR_W2_InBus),
	.LOCAL_VELOCITY_W3_InBus(ODOM_CALCULATOR_W3_InBus),
	.LOCAL_VELOCITY_W4_InBus(ODOM_CALCULATOR_W4_InBus),

	//////////// OUTPUTS //////////
	.LOCAL_VELOCITY_VX_OutBus(local_vx), // local velocity vx in m/s (notation fixed point 17b)
	.LOCAL_VELOCITY_VY_OutBus(local_vy), // local velocity vy in m/s (in notation fixed point 17b)
	.LOCAL_VELOCITY_WZ_OutBus(local_wz)  // local velocity wz in rad/s (in notation fixed point 17b)
);


GLOBAL_VELOCITY U1 
(
	//////////// INPUTS //////////
	.GLOBAL_VELOCITY_CLOCK_50(ODOM_CALCULATOR_CLOCK_50),
	.GLOBAL_VELOCITY_RESET_InHigh(ODOM_CALCULATOR_Reset_InHigh),
	
	.GLOBAL_VELOCITY_READY_In(1'b1), // input flag in high to start operations
	
	.GLOBAL_VELOCITY_VX_LOCAL_InBus(local_vx), // local velocity in x direction [m/s]
	.GLOBAL_VELOCITY_VY_LOCAL_InBus(local_vy), // local velocity in y direction [m/s]
	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(local_wz), // local velocity in z direction [rad/s]
	.GLOBAL_VELOCITY_THETA_InBus(ODOM_CALCULATOR_THETA_InBus), // theta angle to compute in notation 17b |S|IIIIIIII|FFFFFFFF| [0°-90°]

	//////////// OUTPUTS //////////
	.GLOBAL_VELOCITY_DONE_Out(), // output flag to indicate complete results
	.GLOBAL_VELOCITY_VX_GLOBAL_OutBus(global_vx), // global velocity in x direction [m/s]
	.GLOBAL_VELOCITY_VY_GLOBAL_OutBus(global_vy), // global velocity in y direction [m/s]
	.GLOBAL_VELOCITY_WZ_GLOBAL_OutBus(global_wz) // global velocity in z direction [rad/s]
);


POS_CALCULATOR U2
(
	//////////// INPUTS //////////
	.POS_CALCULATOR_CLOCK_50(ODOM_CALCULATOR_CLOCK_50),
	.POS_CALCULATOR_Reset_InHigh(ODOM_CALCULATOR_Reset_InHigh),

	.POS_CALCULATOR_SETBEGIN_InLow(ODOM_CALCULATOR_SETBEGIN_InLow),
	.POS_CALCULATOR_TICKLOAD_InLow(ODOM_CALCULATOR_TICKLOAD_InLow), // tick at 167.77ms to update position	
	.POS_CALCULATOR_VX_InBus(global_vx), // global velocity vx in m/s (in notation fixed point 17b)
	.POS_CALCULATOR_VY_InBus(global_vy), // global velocity vy in m/s (in notation fixed point 17b)
	.POS_CALCULATOR_WZ_InBus(global_wz), // global velocity wz in rad/s (in notation fixed point 17b)
	
	//////////// OUTPUTS //////////
	.POS_CALCULATOR_POSX_OutBus(ODOM_CALCULATOR_POSX_OutBus), // [m] fixed point 17b
	.POS_CALCULATOR_POSY_OutBus(ODOM_CALCULATOR_POSY_OutBus), // [m] fixed point 17b
	.POS_CALCULATOR_THETA_OutBus(ODOM_CALCULATOR_THETA_OutBus) // [deg] fixed point 17b
);


//assign ODOM_CALCULATOR_POSX_OutBus = global_vx;
//assign ODOM_CALCULATOR_POSY_OutBus = global_vy;

endmodule
