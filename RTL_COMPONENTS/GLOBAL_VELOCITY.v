
/*
Created by: Jhoan Esteban Leon - je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library
and https://github.com/freecores/verilog_cordic_core

This module computes geometry transformations for local to global velocities, this is:
vx_global = vx_local*cos(theta) - vy_local*sin(theta)
vy_global = vx_local*sin(theta) + vy_local*cos(theta)
wz_global = wz_local

inputs and output results are all in [m/s] [rad/s] and fixed point 17b notation U(17,8) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module GLOBAL_VELOCITY 
(
	//////////// INPUTS //////////
	GLOBAL_VELOCITY_CLOCK_50,
	GLOBAL_VELOCITY_RESET_InHigh,
	
	GLOBAL_VELOCITY_READY_In, // input flag in high to start operations
	
	GLOBAL_VELOCITY_VX_LOCAL_InBus, // local velocity in x direction [m/s]
	GLOBAL_VELOCITY_VY_LOCAL_InBus, // local velocity in y direction [m/s]
	GLOBAL_VELOCITY_WZ_LOCAL_InBus, // local velocity in z direction [rad/s]
	GLOBAL_VELOCITY_THETA_InBus, // theta angle to compute in notation 32b |S|IIIIIIIIIIIIIIII|FFFFFFFFFFFFFFF| [0°-90°]

	//////////// OUTPUTS //////////
	GLOBAL_VELOCITY_DONE_Out, // output flag to indicate complete results
	GLOBAL_VELOCITY_VX_GLOBAL_OutBus, // global velocity in x direction [m/s]
	GLOBAL_VELOCITY_VY_GLOBAL_OutBus, // global velocity in y direction [m/s]
	GLOBAL_VELOCITY_WZ_GLOBAL_OutBus // global velocity in z direction [rad/s]
	
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

localparam THETA_BITS = 17;
localparam XY_BITS_WIDTH = 17;
localparam CORDIC_CTE = 17'd19899;

//=======================================================
//  PORT declarations
//=======================================================
input	GLOBAL_VELOCITY_CLOCK_50;
input	GLOBAL_VELOCITY_RESET_InHigh;

input GLOBAL_VELOCITY_READY_In;
	
input [N_WIDTH-1:0]	GLOBAL_VELOCITY_VX_LOCAL_InBus;
input	[N_WIDTH-1:0]	GLOBAL_VELOCITY_VY_LOCAL_InBus;
input	[N_WIDTH-1:0]	GLOBAL_VELOCITY_WZ_LOCAL_InBus;
input	[N_WIDTH-1:0]	GLOBAL_VELOCITY_THETA_InBus;

output 	GLOBAL_VELOCITY_DONE_Out;

output	[N_WIDTH-1:0]	GLOBAL_VELOCITY_VX_GLOBAL_OutBus;
output	[N_WIDTH-1:0]	GLOBAL_VELOCITY_VY_GLOBAL_OutBus;
output	[N_WIDTH-1:0]	GLOBAL_VELOCITY_WZ_GLOBAL_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [XY_BITS_WIDTH-1:0] cos_17_to_32;
wire [XY_BITS_WIDTH-1:0] signed_cos_17_to_32;
wire [N_WIDTH-1:0] cos_output_32;

wire [XY_BITS_WIDTH-1:0] sin_17_to_32;
wire [N_WIDTH-1:0] sin_output_32;

wire [N_WIDTH-1:0] vx_cos_result;
wire [N_WIDTH-1:0] vy_sin_result;
wire [N_WIDTH-1:0] vx_sin_result;
wire [N_WIDTH-1:0] vy_cos_result;

wire sign_change_operand;

wire valid_out_cordic_to_machine;
wire complete_out_mult_to_machine;

wire init_cordic;
wire valid_input_cordic;
wire start_multiply;

wire [N_WIDTH-1:0] vx_add_result;
wire [N_WIDTH-1:0] vy_add_result;

wire [N_WIDTH-1:0] theta_cordic;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_STATEMACHINE_GLOBAL_VEL STATEMACHINE_u0 
(
	.SC_STATEMACHINE_GLOBAL_VEL_CLOCK_50(GLOBAL_VELOCITY_CLOCK_50),
	.SC_STATEMACHINE_GLOBAL_VEL_RESET_InHigh(GLOBAL_VELOCITY_RESET_InHigh),
	.SC_STATEMACHINE_GLOBAL_VEL_ready_InHigh(GLOBAL_VELOCITY_READY_In),
	.SC_STATEMACHINE_GLOBAL_VEL_valid_cordic_InHigh(valid_out_cordic_to_machine),
	.SC_STATEMACHINE_GLOBAL_VEL_complete_InHigh(complete_out_mult_to_machine),

	.SC_STATEMACHINE_GLOBAL_VEL_init_cordic_Out(init_cordic),
	.SC_STATEMACHINE_GLOBAL_VEL_validin_cordic_Out(valid_input_cordic),
	.SC_STATEMACHINE_GLOBAL_VEL_start_multiply_Out(start_multiply),
	.SC_STATEMACHINE_GLOBAL_VEL_done_Out(GLOBAL_VELOCITY_DONE_Out)
);	


assign theta_cordic = ((GLOBAL_VELOCITY_THETA_InBus > {1'b0,16'd90,15'b0}) && (GLOBAL_VELOCITY_THETA_InBus <= {1'b0,16'd180,15'b0})) ? ({1'b0,16'd180,15'b0}-GLOBAL_VELOCITY_THETA_InBus): GLOBAL_VELOCITY_THETA_InBus;
assign cos_17_to_32 = ((GLOBAL_VELOCITY_THETA_InBus > {1'b0,16'd90,15'b0}) && (GLOBAL_VELOCITY_THETA_InBus <= {1'b0,16'd180,15'b0})) ? {~signed_cos_17_to_32[XY_BITS_WIDTH-1],signed_cos_17_to_32[XY_BITS_WIDTH-2:0]}: signed_cos_17_to_32;


cordic cordic_core_u0 
(
  .clk(GLOBAL_VELOCITY_CLOCK_50),
  .rst(GLOBAL_VELOCITY_RESET_InHigh),
  
  .init(init_cordic), // signal to load data on cordic system
  .valid_in(valid_input_cordic), // input in high for iniciate iterations of cordic algorithm
  .x_i(CORDIC_CTE),
  .y_i(17'd0),
  .theta_i({theta_cordic[N_WIDTH-1], theta_cordic[22:7]}), // theta angle to compute in notation 17b |S|IIIIIIII|FFFFFFFF| [0°-90°]
  
  .valid_out(valid_out_cordic_to_machine), // output flag flag that indicates final result of iterations in cordic core
  
  .x_o(signed_cos_17_to_32), // output cos(theta) 17b |S|I|FFFFFFFFFFFFFFF|
  .y_o(sin_17_to_32), // output sin(theta) 17b |S|I|FFFFFFFFFFFFFFF|
  .theta_o() // don't care this signal
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_u0 
(
	.SC_REGGENERAL_CLOCK_50(GLOBAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(GLOBAL_VELOCITY_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~valid_out_cordic_to_machine), 
	.SC_REGGENERAL_data_InBus({cos_17_to_32[XY_BITS_WIDTH-1], 15'b0, cos_17_to_32[XY_BITS_WIDTH-2:0]}), // |S|000000000000000I|FFFFFFFFFFFFFFF| 17b 
	.SC_REGGENERAL_data_OutBUS(cos_output_32)
);

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_u1 
(
	.SC_REGGENERAL_CLOCK_50(GLOBAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(GLOBAL_VELOCITY_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~valid_out_cordic_to_machine), 
	.SC_REGGENERAL_data_InBus({sin_17_to_32[XY_BITS_WIDTH-1], 15'b0, sin_17_to_32[XY_BITS_WIDTH-2:0]}), // |S|000000000000000I|FFFFFFFFFFFFFFF| 17b
	.SC_REGGENERAL_data_OutBUS(sin_output_32)
);


qmults #(.N(N_WIDTH), .Q(Q_WIDTH)) multiplier_vx_cos 
(
	.i_multiplicand(GLOBAL_VELOCITY_VX_LOCAL_InBus),
	.i_multiplier(cos_output_32),
	.i_start(start_multiply),
	.i_clk(GLOBAL_VELOCITY_CLOCK_50),
	.o_result_out(vx_cos_result),
	.o_complete(complete_out_mult_to_machine),
	.o_overflow()
);

qmults #(.N(N_WIDTH), .Q(Q_WIDTH)) multiplier_vy_sin 
(
	.i_multiplicand(GLOBAL_VELOCITY_VY_LOCAL_InBus),
	.i_multiplier(sin_output_32),
	.i_start(start_multiply),
	.i_clk(GLOBAL_VELOCITY_CLOCK_50),
	.o_result_out(vy_sin_result),
	.o_complete(),
	.o_overflow()
);

qmults #(.N(N_WIDTH), .Q(Q_WIDTH)) multiplier_vx_sin 
(
	.i_multiplicand(GLOBAL_VELOCITY_VX_LOCAL_InBus),
	.i_multiplier(sin_output_32),
	.i_start(start_multiply),
	.i_clk(GLOBAL_VELOCITY_CLOCK_50),
	.o_result_out(vx_sin_result),
	.o_complete(),
	.o_overflow()
);

qmults #(.N(N_WIDTH), .Q(Q_WIDTH)) multiplier_vy_cos 
(
	.i_multiplicand(GLOBAL_VELOCITY_VY_LOCAL_InBus),
	.i_multiplier(cos_output_32),
	.i_start(start_multiply),
	.i_clk(GLOBAL_VELOCITY_CLOCK_50),
	.o_result_out(vy_cos_result),
	.o_complete(),
	.o_overflow()
);


qadd #(.N(N_WIDTH), .Q(Q_WIDTH)) adder_vx 
(
	.a(vx_cos_result),
   .b({sign_change_operand, vy_sin_result[N_WIDTH-2:0]}),
   .c(vx_add_result)
);

qadd #(.N(N_WIDTH), .Q(Q_WIDTH)) adder_vy 
(
	.a(vx_sin_result),
   .b(vy_cos_result),
   .c(vy_add_result)
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_u2 (
	.SC_REGGENERAL_CLOCK_50(GLOBAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(GLOBAL_VELOCITY_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~complete_out_mult_to_machine), 
	.SC_REGGENERAL_data_InBus(vx_add_result),
	.SC_REGGENERAL_data_OutBUS(GLOBAL_VELOCITY_VX_GLOBAL_OutBus)
);

SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) REGGENERAL_u3 (
	.SC_REGGENERAL_CLOCK_50(GLOBAL_VELOCITY_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(GLOBAL_VELOCITY_RESET_InHigh), 
	.SC_REGGENERAL_load_InLow(~complete_out_mult_to_machine), 
	.SC_REGGENERAL_data_InBus(vy_add_result),
	.SC_REGGENERAL_data_OutBUS(GLOBAL_VELOCITY_VY_GLOBAL_OutBus)
);
																								                  
									
assign sign_change_operand = ~vy_sin_result[N_WIDTH-1];
									
assign GLOBAL_VELOCITY_WZ_GLOBAL_OutBus = GLOBAL_VELOCITY_WZ_LOCAL_InBus;

endmodule
