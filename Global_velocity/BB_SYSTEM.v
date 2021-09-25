//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM (

	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_Reset_InHigh,
	
	BB_SYSTEM_READY_In,
//	BB_SYSTEM_VX_InBus, // local velocity vx in m/s (notation fixed point 32b)
//	BB_SYSTEM_VY_InBus, // local velocity vy in m/s (in notation fixed point 32b)
//	BB_SYSTEM_WZ_InBus, // local velocity wz in rad/s (in notation fixed point 32b)
//	BB_SYSTEM_THETA_InBus, // rotation angle in degrees (in notation fixed point 32b)

	//////////// OUTPUTS //////////
	BB_SYSTEM_DONE_Out
//	BB_SYSTEM_VX_OutBus,
//	BB_SYSTEM_VY_OutBus,
//	BB_SYSTEM_WZ_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATAWIDTH_N = 32;
parameter FRACTIONAL_Q = 15;

//=======================================================
//  PORT declarations
//=======================================================
input BB_SYSTEM_CLOCK_50;
input BB_SYSTEM_Reset_InHigh;

input BB_SYSTEM_READY_In;
//input [DATAWIDTH_N-1:0] BB_SYSTEM_VX_InBus;
//input [DATAWIDTH_N-1:0] BB_SYSTEM_VY_InBus;
//input [DATAWIDTH_N-1:0] BB_SYSTEM_WZ_InBus;
//input [DATAWIDTH_N-1:0] BB_SYSTEM_THETA_InBus;

output BB_SYSTEM_DONE_Out;
//output [DATAWIDTH_N-1:0] BB_SYSTEM_VX_OutBus;
//output [DATAWIDTH_N-1:0] BB_SYSTEM_VY_OutBus;
//output [DATAWIDTH_N-1:0] BB_SYSTEM_WZ_OutBus;

//=======================================================
//  STRUCTURAL coding
//=======================================================

GLOBAL_VELOCITY #(.N_WIDTH(DATAWIDTH_N), .Q_WIDTH(FRACTIONAL_Q)) GLOBAL_VELOCITY_u0 (

	.GLOBAL_VELOCITY_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.GLOBAL_VELOCITY_RESET_InHigh(BB_SYSTEM_Reset_InHigh),
	
	.GLOBAL_VELOCITY_READY_In(BB_SYSTEM_READY_In),
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus(BB_SYSTEM_VX_InBus),
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus(BB_SYSTEM_VY_InBus),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(BB_SYSTEM_WZ_InBus),
//	.GLOBAL_VELOCITY_THETA_InBus(BB_SYSTEM_THETA_InBus),

	// CHECK: VX = 0.0 , VY = 0.0 ; VX = 0.0 , VY = 0.0
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus(32'b0), // |S|IIIIIIIIIIIIIIII|FFFFFFFFFFFFFFF|
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_THETA_InBus(32'b0),

	// CHECK: VX = 10.0 , VY = 0.0 ; VX = 9.999084 , VY = 0.000610
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b0,16'd10,15'b0}),
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_THETA_InBus(32'b0),

	// CHECK: VX = 0.0 , VY = 10.0 ; VX = 0.000610 , VY = 9.999084
	.GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b0,16'd10,15'b0}),
	.GLOBAL_VELOCITY_VY_LOCAL_InBus(32'b0),
	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
	.GLOBAL_VELOCITY_THETA_InBus({1'b0,16'd89,15'd32767}), // this is all precison bits at ones

	// CHECK: VX = 10.0 , VY = 5.0 ; VX = 9.998779 , VY =	5.000153
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b0,16'd10,15'b0}),
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus({1'b0,16'd5,15'b0}),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_THETA_InBus(32'b0),

	// CHECK: VX = 3.535534 , VY = 10.606602 ; VX = 3.534393 , VY = 10.605469
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b0,16'd10,15'b0}),
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus({1'b0,16'd5,15'b0}),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_THETA_InBus({1'b0,16'd45,15'b0}),
	
	// CHECK: VX = -3.535534 , VY = -10.606602 ; VX = -3.534393 , VY = -10.605469
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b1,16'd10,15'b0}),
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus({1'b1,16'd5,15'b0}),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_THETA_InBus({1'b0,16'd45,15'b0}),
	
	// CHECK: VX = 10.0 , VY = -5.0 ; VX = 9.999389 , VY = -4.998931
//	.GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b0,16'd10,15'b0}),
//	.GLOBAL_VELOCITY_VY_LOCAL_InBus({1'b1,16'd5,15'b0}),
//	.GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0),
//	.GLOBAL_VELOCITY_THETA_InBus(32'b0),
	
	
	.GLOBAL_VELOCITY_DONE_Out(BB_SYSTEM_DONE_Out),
	.GLOBAL_VELOCITY_VX_GLOBAL_OutBus(),
	.GLOBAL_VELOCITY_VY_GLOBAL_OutBus(),
	.GLOBAL_VELOCITY_WZ_GLOBAL_OutBus()
);


endmodule
