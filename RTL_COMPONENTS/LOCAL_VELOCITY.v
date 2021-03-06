/*
Created by: Jhoan Esteban Leon - je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library

This module computes the forward kinematic for local velocities, this is:
vx_local = (w1 + w2 + w3 + w4)*(r/4)
vy_local = (-w1 + w2 + w3 - w4)*(r/4)
wz_local = (-w1 + w2 - w3 + w4)*(r/(4*(lx+ly)))

inputs velocities are in [rad/s] and output results are in [m/s] fixed point 32b notation U(32,15) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module LOCAL_VELOCITY 
(
	//////////// INPUTS //////////
	LOCAL_VELOCITY_CLOCK_50,
	LOCAL_VELOCITY_Reset_InHigh,
	
	LOCAL_VELOCITY_W1_InBus,
	LOCAL_VELOCITY_W2_InBus,
	LOCAL_VELOCITY_W3_InBus,
	LOCAL_VELOCITY_W4_InBus,

	//////////// OUTPUTS //////////
	LOCAL_VELOCITY_VX_OutBus, // local velocity vx in m/s (notation fixed point 32b)
	LOCAL_VELOCITY_VY_OutBus, // local velocity vy in m/s (in notation fixed point 32b)
	LOCAL_VELOCITY_WZ_OutBus  // local velocity wz in rad/s (in notation fixed point 32b)
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATAWIDTH_N = 32;
parameter FRACTIONAL_Q = 15;

//=======================================================
//  PORT declarations
//=======================================================
input LOCAL_VELOCITY_CLOCK_50;
input LOCAL_VELOCITY_Reset_InHigh;

input [DATAWIDTH_N-1:0] LOCAL_VELOCITY_W1_InBus;
input [DATAWIDTH_N-1:0] LOCAL_VELOCITY_W2_InBus;
input [DATAWIDTH_N-1:0] LOCAL_VELOCITY_W3_InBus;
input [DATAWIDTH_N-1:0] LOCAL_VELOCITY_W4_InBus;

output [DATAWIDTH_N-1:0] LOCAL_VELOCITY_VX_OutBus;
output [DATAWIDTH_N-1:0] LOCAL_VELOCITY_VY_OutBus;
output [DATAWIDTH_N-1:0] LOCAL_VELOCITY_WZ_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire start_flag;

wire [DATAWIDTH_N-1:0] result_add_w1_w2;
wire [DATAWIDTH_N-1:0] result_add_w1_w2_w3;
wire [DATAWIDTH_N-1:0] result_add_w1_w2_w3_w4;
wire flag_result_vx;
wire [DATAWIDTH_N-1:0] result_vx;

wire [DATAWIDTH_N-1:0] result_sub_w1_w2;
wire [DATAWIDTH_N-1:0] result_sub_w1_w2_w3;
wire [DATAWIDTH_N-1:0] result_sub_w1_w2_w3_w4;
wire flag_result_vy;
wire [DATAWIDTH_N-1:0] result_vy;

wire [DATAWIDTH_N-1:0] result_tri_w1_w2;
wire [DATAWIDTH_N-1:0] result_tri_w1_w2_w3;
wire [DATAWIDTH_N-1:0] result_tri_w1_w2_w3_w4;
wire flag_result_wz;
wire [DATAWIDTH_N-1:0] result_wz;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_STATEMACHINE_MULT MULT_MACHINE
(
	.SC_STATEMACHINE_MULT_CLOCK_50(LOCAL_VELOCITY_CLOCK_50),
	.SC_STATEMACHINE_MULT_RESET_InHigh(LOCAL_VELOCITY_Reset_InHigh),
	.SC_STATEMACHINE_MULT_done_InHigh(flag_result_vx),
	
	.SC_STATEMACHINE_MULT_start_Out(start_flag)
);	

///////////////////////////// FOR VX = (w1 + w2 + w3 + w4)*(r/4)

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) add_w1_w2
(
    .a(LOCAL_VELOCITY_W1_InBus),
    .b(LOCAL_VELOCITY_W2_InBus),
    .c(result_add_w1_w2)
);

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) add_w1_w2_w3
(
    .a(result_add_w1_w2),
    .b(LOCAL_VELOCITY_W3_InBus),
    .c(result_add_w1_w2_w3)
);

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) add_w1_w2_w3_w4
(
    .a(result_add_w1_w2_w3),
    .b(LOCAL_VELOCITY_W4_InBus),
    .c(result_add_w1_w2_w3_w4)
);

qmults #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) mult_vx
(
	.i_multiplicand(result_add_w1_w2_w3_w4),
	.i_multiplier(32'b0_0000000000000000_000000100101001),
	.i_start(start_flag),
	.i_clk(LOCAL_VELOCITY_CLOCK_50),
	.o_result_out(result_vx),
	.o_complete(flag_result_vx),
	.o_overflow()
);

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(DATAWIDTH_N)) reg_vx
(
	.SC_REGGENERAL_CLOCK_50(LOCAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(LOCAL_VELOCITY_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_result_vx), 
	.SC_REGGENERAL_data_InBus(result_vx),
	.SC_REGGENERAL_data_OutBUS(LOCAL_VELOCITY_VX_OutBus)
);

///////////////////////////// FOR VY = (-w1 + w2 + w3 - w4)*(r/4)

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) sub_w1_w2
(
    .a({~LOCAL_VELOCITY_W1_InBus[DATAWIDTH_N-1],LOCAL_VELOCITY_W1_InBus[DATAWIDTH_N-2:0]}),
    .b(LOCAL_VELOCITY_W2_InBus),
    .c(result_sub_w1_w2)
);

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) sub_w1_w2_w3
(
    .a(result_sub_w1_w2),
    .b(LOCAL_VELOCITY_W3_InBus),
    .c(result_sub_w1_w2_w3)
);

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) sub_w1_w2_w3_w4
(
    .a(result_sub_w1_w2_w3),
    .b({~LOCAL_VELOCITY_W4_InBus[DATAWIDTH_N-1],LOCAL_VELOCITY_W4_InBus[DATAWIDTH_N-2:0]}),
    .c(result_sub_w1_w2_w3_w4)
);

qmults #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) mult_vy
(
	.i_multiplicand(result_sub_w1_w2_w3_w4),
	.i_multiplier(32'b0_0000000000000000_000000100101001),
	.i_start(start_flag),
	.i_clk(LOCAL_VELOCITY_CLOCK_50),
	.o_result_out(result_vy),
	.o_complete(flag_result_vy),
	.o_overflow()
);

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(DATAWIDTH_N)) reg_vy
(
	.SC_REGGENERAL_CLOCK_50(LOCAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(LOCAL_VELOCITY_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_result_vy), 
	.SC_REGGENERAL_data_InBus(result_vy),
	.SC_REGGENERAL_data_OutBUS(LOCAL_VELOCITY_VY_OutBus)
);


///////////////////////////// FOR WZ = (-w1 + w2 - w3 + w4)*(r/(4*(lx+ly)))

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) tri_w1_w2
(
    .a({~LOCAL_VELOCITY_W1_InBus[DATAWIDTH_N-1],LOCAL_VELOCITY_W1_InBus[DATAWIDTH_N-2:0]}),
    .b(LOCAL_VELOCITY_W2_InBus),
    .c(result_tri_w1_w2)
);

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) tri_w1_w2_w3
(
    .a(result_tri_w1_w2),
    .b({~LOCAL_VELOCITY_W3_InBus[DATAWIDTH_N-1],LOCAL_VELOCITY_W3_InBus[DATAWIDTH_N-2:0]}),
    .c(result_tri_w1_w2_w3)
);

qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) tri_w1_w2_w3_w4
(
    .a(result_tri_w1_w2_w3),
    .b(LOCAL_VELOCITY_W4_InBus),
    .c(result_tri_w1_w2_w3_w4)
);

qmults #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) mult_wz
(
	.i_multiplicand(result_tri_w1_w2_w3_w4),
	.i_multiplier(32'b0_0000000000000000_000011100001000),
	.i_start(start_flag),
	.i_clk(LOCAL_VELOCITY_CLOCK_50),
	.o_result_out(result_wz),
	.o_complete(flag_result_wz),
	.o_overflow()
);

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(DATAWIDTH_N)) reg_wz
(
	.SC_REGGENERAL_CLOCK_50(LOCAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(LOCAL_VELOCITY_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_result_wz), 
	.SC_REGGENERAL_data_InBus(result_wz),
	.SC_REGGENERAL_data_OutBUS(LOCAL_VELOCITY_WZ_OutBus)
);

endmodule
