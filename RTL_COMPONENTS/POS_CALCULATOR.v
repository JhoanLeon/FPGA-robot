//=======================================================
//  MODULE Definition
//=======================================================

module POS_CALCULATOR 
(

	//////////// INPUTS //////////
	POS_CALCULATOR_CLOCK_50,
	POS_CALCULATOR_Reset_InHigh,

	POS_CALCULATOR_SETBEGIN_InLow,	
	POS_CALCULATOR_VX_InBus, // global velocity vx in m/s (in notation fixed point 32b)
	POS_CALCULATOR_VY_InBus, // global velocity vy in m/s (in notation fixed point 32b)
	POS_CALCULATOR_WZ_InBus, // global velocity wz in rad/s (in notation fixed point 32b)
	
	//////////// OUTPUTS //////////
	POS_CALCULATOR_POSX_OutBus, // [m] fixed point 32b
	POS_CALCULATOR_POSY_OutBus, // [m] fixed point 32b
	POS_CALCULATOR_THETA_OutBus // [deg] fixed point 32b

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATAWIDTH_N = 32;
parameter FRACTIONAL_Q = 15;

//=======================================================
//  PORT declarations
//=======================================================
input POS_CALCULATOR_CLOCK_50;
input POS_CALCULATOR_Reset_InHigh;

input POS_CALCULATOR_SETBEGIN_InLow;
input [DATAWIDTH_N-1:0]	POS_CALCULATOR_VX_InBus;
input [DATAWIDTH_N-1:0]	POS_CALCULATOR_VY_InBus;
input [DATAWIDTH_N-1:0]	POS_CALCULATOR_WZ_InBus;

output [DATAWIDTH_N-1:0]	POS_CALCULATOR_POSX_OutBus;
output [DATAWIDTH_N-1:0]	POS_CALCULATOR_POSY_OutBus;
output [DATAWIDTH_N-1:0]	POS_CALCULATOR_THETA_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [19:0] counter_10ms = 20'b0;
reg flag_reg;
wire load_flag;

wire mult_start_flag;

wire [DATAWIDTH_N-1:0] result_mult_vx;
wire flag_complete_mult_vx;

wire [DATAWIDTH_N-1:0] reg_mult_vx;
wire [DATAWIDTH_N-1:0] sum_vx;


wire [DATAWIDTH_N-1:0] result_mult_vy;
wire flag_complete_mult_vy;

wire [DATAWIDTH_N-1:0] reg_mult_vy;
wire [DATAWIDTH_N-1:0] sum_vy;


wire [DATAWIDTH_N-1:0] result_mult_vz;
wire flag_complete_mult_vz;

wire [DATAWIDTH_N-1:0] reg_mult_vz;
wire [DATAWIDTH_N-1:0] sum_vz;

//=======================================================
//  STRUCTURAL coding
//=======================================================

always @(posedge POS_CALCULATOR_CLOCK_50)
begin
	counter_10ms <= counter_10ms + 1'b1;
	
	if (counter_10ms == 20'd500000)
	begin
		flag_reg <= 1'b0;
		counter_10ms <= 20'b0;
	end
	else
		flag_reg <= 1'b1;
end

assign load_flag = flag_reg;


SC_STATEMACHINE_MULT mult_machine
(
	.SC_STATEMACHINE_MULT_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_STATEMACHINE_MULT_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_STATEMACHINE_MULT_done_InHigh(flag_complete_mult_vx),
	.SC_STATEMACHINE_MULT_start_Out(mult_start_flag)
);	


//////////////////////////////////////////// FOR POSX

qmults #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) mult_vx
(
	.i_multiplicand(POS_CALCULATOR_VX_InBus),
	.i_multiplier(32'b0_0000000000000000_000000101001000), // 0.010 s = 10ms
	.i_start(mult_start_flag),
	.i_clk(POS_CALCULATOR_CLOCK_50),
	.o_result_out(result_mult_vx),
	.o_complete(flag_complete_mult_vx),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(DATAWIDTH_N)) register_mult_vx
(
	.SC_REGGENERAL_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(POS_CALCULATOR_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_complete_mult_vx), 
	.SC_REGGENERAL_data_InBus(result_mult_vx),
	.SC_REGGENERAL_data_OutBUS(reg_mult_vx)
);


qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) add_vx
(
    .a(reg_mult_vx),
    .b(POS_CALCULATOR_POSX_OutBus),
    .c(sum_vx)
);


SC_REGACC #(.REGACC_DATAWIDTH(DATAWIDTH_N), .INITIAL_VALUE(32'b0)) reg_accumulator_posx
(
	.SC_REGACC_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGACC_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_REGACC_clear_InLow(POS_CALCULATOR_SETBEGIN_InLow), // reset initial value with set begin signal
	.SC_REGACC_load_InLow(load_flag), // load new data every 10ms
	.SC_REGACC_data_InBUS(sum_vx),
	.SC_REGACC_data_OutBUS(POS_CALCULATOR_POSX_OutBus)
);


//////////////////////////////////////////// FOR POSY

qmults #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) mult_vy
(
	.i_multiplicand(POS_CALCULATOR_VY_InBus),
	.i_multiplier(32'b0_0000000000000000_000000101001000), // 0.010 s = 10ms
	.i_start(mult_start_flag),
	.i_clk(POS_CALCULATOR_CLOCK_50),
	.o_result_out(result_mult_vy),
	.o_complete(flag_complete_mult_vy),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(DATAWIDTH_N)) register_mult_vy
(
	.SC_REGGENERAL_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(POS_CALCULATOR_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_complete_mult_vy), 
	.SC_REGGENERAL_data_InBus(result_mult_vy),
	.SC_REGGENERAL_data_OutBUS(reg_mult_vy)
);


qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) add_vy
(
    .a(reg_mult_vy),
    .b(POS_CALCULATOR_POSY_OutBus),
    .c(sum_vy)
);

	
SC_REGACC #(.REGACC_DATAWIDTH(DATAWIDTH_N), .INITIAL_VALUE(32'b0)) reg_accumulator_posy
(
	.SC_REGACC_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGACC_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_REGACC_clear_InLow(POS_CALCULATOR_SETBEGIN_InLow), // reset initial value with set begin signal
	.SC_REGACC_load_InLow(load_flag), // load new data every 10ms
	.SC_REGACC_data_InBUS(sum_vy),
	.SC_REGACC_data_OutBUS(POS_CALCULATOR_POSY_OutBus)
);


//////////////////////////////////////////// FOR THETA

qmults #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) mult_vz
(
	.i_multiplicand(POS_CALCULATOR_WZ_InBus),
	.i_multiplier(32'b0_0000000000000000_100100101010111), // 0.010*180/pi = 0.572958

	.i_start(mult_start_flag),
	.i_clk(POS_CALCULATOR_CLOCK_50),
	.o_result_out(result_mult_vz),
	.o_complete(flag_complete_mult_vz),
	.o_overflow()
);


SC_REGGENERAL #(.REGGENERAL_DATAWIDTH(DATAWIDTH_N)) register_mult_vz
(
	.SC_REGGENERAL_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGGENERAL_RESET_InHigh(POS_CALCULATOR_Reset_InHigh), 
	.SC_REGGENERAL_load_InLow(~flag_complete_mult_vz), 
	.SC_REGGENERAL_data_InBus(result_mult_vz),
	.SC_REGGENERAL_data_OutBUS(reg_mult_vz)
);


qadd #(.Q(FRACTIONAL_Q), .N(DATAWIDTH_N)) add_vz
(
    .a(reg_mult_vz),
    .b(POS_CALCULATOR_THETA_OutBus),
    .c(sum_vz)
);


SC_REGACC #(.REGACC_DATAWIDTH(DATAWIDTH_N), .INITIAL_VALUE({1'b0,16'd90,15'b0})) reg_accumulator_theta
(
	.SC_REGACC_CLOCK_50(POS_CALCULATOR_CLOCK_50),
	.SC_REGACC_RESET_InHigh(POS_CALCULATOR_Reset_InHigh),
	.SC_REGACC_clear_InLow(POS_CALCULATOR_SETBEGIN_InLow), // reset initial value with set begin signal
	.SC_REGACC_load_InLow(load_flag), // load new data every 10ms
	.SC_REGACC_data_InBUS(sum_vz),
	.SC_REGACC_data_OutBUS(POS_CALCULATOR_THETA_OutBus)
);


endmodule
