/*
Created by: Jhoan Esteban Leon - je.leon.e@outlook.com
inputs velocities are in [rad/s] and output results are in [m] fixed point 17b notation U(32,15) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module POS_CALCULATOR 
(
	//////////// INPUTS //////////
	POS_CALCULATOR_CLOCK_50,
	POS_CALCULATOR_Reset_InHigh,

	POS_CALCULATOR_SETBEGIN_InLow,
	POS_CALCULATOR_TICKLOAD_InLow,
	POS_CALCULATOR_VX_InBus, // global velocity vx in m/s (in notation fixed point 17b)
	POS_CALCULATOR_VY_InBus, // global velocity vy in m/s (in notation fixed point 17b)
	POS_CALCULATOR_WZ_InBus, // global velocity wz in rad/s (in notation fixed point 17b)
	
	//////////// OUTPUTS //////////
	POS_CALCULATOR_POSX_OutBus, // [m] fixed point 17b
	POS_CALCULATOR_POSY_OutBus, // [m] fixed point 17b
	POS_CALCULATOR_THETA_OutBus // [deg] fixed point 17b
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
input POS_CALCULATOR_CLOCK_50;
input POS_CALCULATOR_Reset_InHigh;

input POS_CALCULATOR_SETBEGIN_InLow;
input POS_CALCULATOR_TICKLOAD_InLow;
input [N_WIDTH-1:0]	POS_CALCULATOR_VX_InBus;
input [N_WIDTH-1:0]	POS_CALCULATOR_VY_InBus;
input [N_WIDTH-1:0]	POS_CALCULATOR_WZ_InBus;

output [N_WIDTH-1:0]	POS_CALCULATOR_POSX_OutBus;
output [N_WIDTH-1:0]	POS_CALCULATOR_POSY_OutBus;
output [N_WIDTH-1:0]	POS_CALCULATOR_THETA_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire mult_start_flag;

wire [N_WIDTH-1:0] result_mult_vx;
wire flag_complete_mult_vx;

wire [N_WIDTH-1:0] reg_mult_vx;
wire [N_WIDTH-1:0] sum_vx;


wire [N_WIDTH-1:0] result_mult_vy;
wire flag_complete_mult_vy;

wire [N_WIDTH-1:0] reg_mult_vy;
wire [N_WIDTH-1:0] sum_vy;


wire [N_WIDTH-1:0] result_mult_vz;
wire flag_complete_mult_vz;

wire [N_WIDTH-1:0] reg_mult_vz;
wire [N_WIDTH-1:0] sum_vz;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_STATEMACHINE_MULT mult_machine
(
	.SC_STATEMACHINE_MULT_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_STATEMACHINE_MULT_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_STATEMACHINE_MULT_done_InHigh(flag_complete_mult_vx),
	.SC_STATEMACHINE_MULT_start_Out(mult_start_flag)
);	


//////////////////////////////////////////// FOR POSX

qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) mult_vx
(
	.i_multiplicand(POS_CALCULATOR_VX_InBus),
	.i_multiplier(17'b0_00000000_00001011), // 0.041940 (0.04297) //17'b0_00000000_00010101), // 0.083886 (0.0820)
	.i_start(mult_start_flag),
	.i_clk(POS_CALCULATOR_CLOCK_50),
	.o_result_out(result_mult_vx),
	.o_complete(flag_complete_mult_vx),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) register_mult_vx
(
	.SC_REGGENERAL_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(POS_CALCULATOR_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_complete_mult_vx), 
	.SC_REGGENERAL_data_InBus(result_mult_vx),
	.SC_REGGENERAL_data_OutBUS(reg_mult_vx)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) add_vx
(
    .a(reg_mult_vx),
    .b(POS_CALCULATOR_POSX_OutBus),
    .c(sum_vx)
);


SC_REGACC #(.REGACC_DATAWIDTH(N_WIDTH), .INITIAL_VALUE(17'b0)) reg_accumulator_posx
(
	.SC_REGACC_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGACC_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_REGACC_clear_InLow(POS_CALCULATOR_SETBEGIN_InLow), // reset initial value with set begin signal
	.SC_REGACC_load_InLow(POS_CALCULATOR_TICKLOAD_InLow), // load new data every 167.77ms
	.SC_REGACC_data_InBUS(sum_vx),
	.SC_REGACC_data_OutBUS(POS_CALCULATOR_POSX_OutBus)
);


//////////////////////////////////////////// FOR POSY

qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) mult_vy
(
	.i_multiplicand(POS_CALCULATOR_VY_InBus),
	.i_multiplier(17'b0_00000000_00001011), // 0.041940 (0.04297) //17'b0_00000000_00010101), // 0.083886 (0.0820) // 17'b0_00000000_00101011), // 167.77ms (167.9688)
	.i_start(mult_start_flag),
	.i_clk(POS_CALCULATOR_CLOCK_50),
	.o_result_out(result_mult_vy),
	.o_complete(flag_complete_mult_vy),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) register_mult_vy
(
	.SC_REGGENERAL_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(POS_CALCULATOR_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_complete_mult_vy), 
	.SC_REGGENERAL_data_InBus(result_mult_vy),
	.SC_REGGENERAL_data_OutBUS(reg_mult_vy)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) add_vy
(
    .a(reg_mult_vy),
    .b(POS_CALCULATOR_POSY_OutBus),
    .c(sum_vy)
);

	
SC_REGACC #(.REGACC_DATAWIDTH(N_WIDTH), .INITIAL_VALUE(17'b0)) reg_accumulator_posy
(
	.SC_REGACC_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGACC_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_REGACC_clear_InLow(POS_CALCULATOR_SETBEGIN_InLow), // reset initial value with set begin signal
	.SC_REGACC_load_InLow(POS_CALCULATOR_TICKLOAD_InLow), // load new data every 167.77ms
	.SC_REGACC_data_InBUS(sum_vy),
	.SC_REGACC_data_OutBUS(POS_CALCULATOR_POSY_OutBus)
);


//////////////////////////////////////////// FOR THETA

qmults #(.Q(Q_WIDTH), .N(N_WIDTH)) mult_vz
(
	.i_multiplicand(POS_CALCULATOR_WZ_InBus),
	.i_multiplier(17'b0_00000010_01100111), // 2.403159 (2.4023) //17'b0_00000100_11001110), // 4.806318 (4.8047)

	.i_start(mult_start_flag),
	.i_clk(POS_CALCULATOR_CLOCK_50),
	.o_result_out(result_mult_vz),
	.o_complete(flag_complete_mult_vz),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(N_WIDTH)) register_mult_vz
(
	.SC_REGGENERAL_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(POS_CALCULATOR_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_complete_mult_vz), 
	.SC_REGGENERAL_data_InBus(result_mult_vz),
	.SC_REGGENERAL_data_OutBUS(reg_mult_vz)
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) add_vz
(
    .a(reg_mult_vz),
    .b(POS_CALCULATOR_THETA_OutBus),
    .c(sum_vz)
);


SC_REGACC #(.REGACC_DATAWIDTH(N_WIDTH), .INITIAL_VALUE({1'b0,8'd90,8'b0})) reg_accumulator_theta
(
	.SC_REGACC_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGACC_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_REGACC_clear_InLow(POS_CALCULATOR_SETBEGIN_InLow), // reset initial value with set begin signal
	.SC_REGACC_load_InLow(POS_CALCULATOR_TICKLOAD_InLow), // load new data every 41.94ms
	.SC_REGACC_data_InBUS(sum_vz),
	.SC_REGACC_data_OutBUS(POS_CALCULATOR_THETA_OutBus)
);


endmodule
