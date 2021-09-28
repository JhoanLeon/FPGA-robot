/*
Created by: Jhoan Esteban Leon je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library

This module computes inverse kinematic for velocities of each wheel, this is:
w1 = (1/r)*(vx - vy - k1*wz)
w2 = (1/r)*(vx + vy + k1*wz)
w3 = (1/r)*(vx + vy - k1*wz)
w4 = (1/r)*(vx - vy + k1*wz)

inputs and output results are all in [m/s] [rad/s] and fixed point 32b notation U(32,15) U(N,Q)
*/


//=======================================================
//  MODULE Definition
//=======================================================

module MOVEMENT_CONTROLLER
(

	//////////// INPUTS //////////
	MOVEMENT_CONTROLLER_CLOCK_50,
	MOVEMENT_CONTROLLER_RESET_InHigh,
	
	MOVEMENT_CONTROLLER_TARGETVX_InBus,
	MOVEMENT_CONTROLLER_TARGETVY_InBus,
	MOVEMENT_CONTROLLER_TARGETWZ_InBus,
	
	//////////// OUTPUTS //////////
	MOVEMENT_CONTROLLER_W1_OutBus,
	MOVEMENT_CONTROLLER_W2_OutBus,
	MOVEMENT_CONTROLLER_W3_OutBus,
	MOVEMENT_CONTROLLER_W4_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

//=======================================================
//  PORT declarations
//=======================================================
input	MOVEMENT_CONTROLLER_CLOCK_50;
input	MOVEMENT_CONTROLLER_RESET_InHigh;
	
input wire [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_TARGETVX_InBus;
input wire [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_TARGETVY_InBus;
input wire [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_TARGETWZ_InBus;

output [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_W1_OutBus;
output [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_W2_OutBus;
output [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_W3_OutBus;
output [N_WIDTH-1:0]	MOVEMENT_CONTROLLER_W4_OutBus;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================
wire start_multiplications;

/// for W1
wire [N_WIDTH-1:0] w1_first_result;

wire [N_WIDTH-1:0] w1_second_result;
wire [N_WIDTH-1:0] w1_reg_second_result;

wire [N_WIDTH-1:0] w1_third_result;

wire [N_WIDTH-1:0] w1_fourth_result;

wire w1_complete_mult1;
wire w1_complete_mult2;

/// for W2
wire [N_WIDTH-1:0] w2_first_result;

wire [N_WIDTH-1:0] w2_second_result;
wire [N_WIDTH-1:0] w2_reg_second_result;

wire [N_WIDTH-1:0] w2_third_result;

wire [N_WIDTH-1:0] w2_fourth_result;

wire w2_complete_mult1;
wire w2_complete_mult2;

/// for W3
wire [N_WIDTH-1:0] w3_first_result;

wire [N_WIDTH-1:0] w3_second_result;
wire [N_WIDTH-1:0] w3_reg_second_result;

wire [N_WIDTH-1:0] w3_third_result;

wire [N_WIDTH-1:0] w3_fourth_result;

wire w3_complete_mult1;
wire w3_complete_mult2;

/// for W4
wire [N_WIDTH-1:0] w4_first_result;

wire [N_WIDTH-1:0] w4_second_result;
wire [N_WIDTH-1:0] w4_reg_second_result;

wire [N_WIDTH-1:0] w4_third_result;

wire [N_WIDTH-1:0] w4_fourth_result;

wire w4_complete_mult1;
wire w4_complete_mult2;

//=======================================================
//  STRUCTURAL coding
//=======================================================

// state machine for mults, just generate start signals for multipliers every time
SC_STATEMACHINE_MULT  STATEMACHINE_u0
(
	.SC_STATEMACHINE_MULT_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_STATEMACHINE_MULT_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh),
	.SC_STATEMACHINE_MULT_done_InHigh(w1_complete_mult1),
	
	.SC_STATEMACHINE_MULT_start_Out(start_multiplications)
);	



////////////////////////////////////////////////////////// FOR W1 = (1/r)*(vx - vy - k1*wz)

qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w1_first // vx - vy
(
   .a(MOVEMENT_CONTROLLER_TARGETVX_InBus),
   .b({~MOVEMENT_CONTROLLER_TARGETVY_InBus[31], MOVEMENT_CONTROLLER_TARGETVY_InBus[30:0]}),
   .c(w1_first_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w1_first // k1*wz
(
	.i_multiplicand(MOVEMENT_CONTROLLER_TARGETWZ_InBus),
	.i_multiplier(32'b0_0000000000000000_001010100011111), // k1 = 0.165000
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w1_second_result),
	.o_complete(w1_complete_mult1),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w1_reg_u0 // reg(k1*wz)
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w1_complete_mult1), 
	.SC_REGGENERAL_data_InBus(w1_second_result),

	.SC_REGGENERAL_data_OutBUS(w1_reg_second_result)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w1_second // vx - vy - k1*wz 
(
   .a(w1_first_result),
   .b({~w1_reg_second_result[31], w1_reg_second_result[30:0]}),
   .c(w1_third_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w1_second // (vx - vy - k1*wz) * 1/r
(
	.i_multiplicand(w1_third_result),
	.i_multiplier(32'b0_0000000000011011_100101100001001), // 1/r = 27.586210
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w1_fourth_result),
	.o_complete(w1_complete_mult2),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w1_reg_u1 // reg[(vx - vy - k1*wz) * 1/r]
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w1_complete_mult2), 
	.SC_REGGENERAL_data_InBus(w1_fourth_result),

	.SC_REGGENERAL_data_OutBUS(MOVEMENT_CONTROLLER_W1_OutBus)
);



////////////////////////////////////////////////////////// FOR W2 = (1/r)*(vx + vy + k1*wz)

qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w2_first // vx + vy
(
   .a(MOVEMENT_CONTROLLER_TARGETVX_InBus),
   .b(MOVEMENT_CONTROLLER_TARGETVY_InBus),
   .c(w2_first_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w2_first // k1*wz
(
	.i_multiplicand(MOVEMENT_CONTROLLER_TARGETWZ_InBus),
	.i_multiplier(32'b0_0000000000000000_001010100011111), // k1 = 0.165000
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w2_second_result),
	.o_complete(w2_complete_mult1),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w2_reg_u0 // reg(k1*wz)
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w2_complete_mult1), 
	.SC_REGGENERAL_data_InBus(w2_second_result),

	.SC_REGGENERAL_data_OutBUS(w2_reg_second_result)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w2_second // vx + vy + k1*wz 
(
   .a(w2_first_result),
   .b(w2_reg_second_result),
   .c(w2_third_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w2_second // (vx + vy + k1*wz) * 1/r
(
	.i_multiplicand(w2_third_result),
	.i_multiplier(32'b0_0000000000011011_100101100001001), // 1/r = 27.586210
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w2_fourth_result),
	.o_complete(w2_complete_mult2),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w2_reg_u1 // reg[(vx + vy + k1*wz) * 1/r]
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w2_complete_mult2), 
	.SC_REGGENERAL_data_InBus(w2_fourth_result),

	.SC_REGGENERAL_data_OutBUS(MOVEMENT_CONTROLLER_W2_OutBus)
);



////////////////////////////////////////////////////////// FOR W3 = (1/r)*(vx + vy - k1*wz)

qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w3_first // vx + vy
(
   .a(MOVEMENT_CONTROLLER_TARGETVX_InBus),
   .b(MOVEMENT_CONTROLLER_TARGETVY_InBus),
   .c(w3_first_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w3_first // k1*wz
(
	.i_multiplicand(MOVEMENT_CONTROLLER_TARGETWZ_InBus),
	.i_multiplier(32'b0_0000000000000000_001010100011111), // k1 = 0.165000
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w3_second_result),
	.o_complete(w3_complete_mult1),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w3_reg_u0 // reg[k1*wz]
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w3_complete_mult1), 
	.SC_REGGENERAL_data_InBus(w3_second_result),

	.SC_REGGENERAL_data_OutBUS(w3_reg_second_result)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w3_second // vx + vy - k1*wz 
(
   .a(w3_first_result),
   .b({~w3_reg_second_result[31], w3_reg_second_result[30:0]}),
   .c(w3_third_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w3_second // (vx + vy - k1*wz) * 1/r
(
	.i_multiplicand(w3_third_result),
	.i_multiplier(32'b0_0000000000011011_100101100001001), // 1/r = 27.586210
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w3_fourth_result),
	.o_complete(w3_complete_mult2),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w3_reg_u1 // reg[(vx + vy - k1*wz) * 1/r]
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w3_complete_mult2), 
	.SC_REGGENERAL_data_InBus(w3_fourth_result),

	.SC_REGGENERAL_data_OutBUS(MOVEMENT_CONTROLLER_W3_OutBus)
);



////////////////////////////////////////////////////////// FOR W4 = (1/r)*(vx - vy + k1*wz)

qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w4_first // vx - vy
(
   .a(MOVEMENT_CONTROLLER_TARGETVX_InBus),
   .b({~MOVEMENT_CONTROLLER_TARGETVY_InBus[31], MOVEMENT_CONTROLLER_TARGETVY_InBus[30:0]}),
   .c(w4_first_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w4_first // k1*wz
(
	.i_multiplicand(MOVEMENT_CONTROLLER_TARGETWZ_InBus),
	.i_multiplier(32'b0_0000000000000000_001010100011111), // k1 = 0.165000
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w4_second_result),
	.o_complete(w4_complete_mult1),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w4_reg_u0 // reg(k1*wz)
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w4_complete_mult1), 
	.SC_REGGENERAL_data_InBus(w4_second_result),

	.SC_REGGENERAL_data_OutBUS(w4_reg_second_result)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) qadd_w4_second // vx - vy + k1*wz 
(
   .a(w4_first_result),
   .b(w4_reg_second_result),
   .c(w4_third_result)
);


qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) qmult_w4_second // (vx - vy + k1*wz) * 1/r
(
	.i_multiplicand(w4_third_result),
	.i_multiplier(32'b0_0000000000011011_100101100001001), // 1/r = 27.586210
	.i_start(start_multiplications),
	.i_clk(MOVEMENT_CONTROLLER_CLOCK_50),
	.o_result_out(w4_fourth_result),
	.o_complete(w4_complete_mult2),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) w4_reg_u1 // reg[(vx - vy + k1*wz) * 1/r]
(
	.SC_REGGENERAL_CLOCK_50(MOVEMENT_CONTROLLER_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(MOVEMENT_CONTROLLER_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~w4_complete_mult2), 
	.SC_REGGENERAL_data_InBus(w4_fourth_result),

	.SC_REGGENERAL_data_OutBUS(MOVEMENT_CONTROLLER_W4_OutBus)
);

endmodule
