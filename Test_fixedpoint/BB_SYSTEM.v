// Module top level entity

module BB_SYSTEM (

/// Inputs
BB_SYSTEM_CLOCK_50,
BB_SYSTEM_Reset_InHigh,

BB_SYSTEM_Start_Mult_InHigh,
BB_SYSTEM_Start_Div_InHigh,

BB_SYSTEM_Aop_BusIn,
BB_SYSTEM_Bop_BusIn,

/// Outputs
BB_SYSTEM_AddResult_BusOut,
BB_SYSTEM_MultResult_BusOut,
BB_SYSTEM_DivResult_BusOut,

BB_SYSTEM_Mult_Comp_Out,
BB_SYSTEM_Mult_Over_Out,

BB_SYSTEM_Div_Comp_Out,
BB_SYSTEM_Div_Over_Out

);


//parameter DATAWIDTH_N = 16;
//parameter FRACTIONAL_Q = 7;
parameter DATAWIDTH_N = 32;
parameter FRACTIONAL_Q = 15;

input BB_SYSTEM_CLOCK_50;
input BB_SYSTEM_Reset_InHigh;

input BB_SYSTEM_Start_Mult_InHigh;
input BB_SYSTEM_Start_Div_InHigh;

input [DATAWIDTH_N-1:0] BB_SYSTEM_Aop_BusIn;
input [DATAWIDTH_N-1:0] BB_SYSTEM_Bop_BusIn;

output [DATAWIDTH_N-1:0] BB_SYSTEM_AddResult_BusOut;
output [DATAWIDTH_N-1:0] BB_SYSTEM_MultResult_BusOut;
output [DATAWIDTH_N-1:0] BB_SYSTEM_DivResult_BusOut;

output BB_SYSTEM_Mult_Comp_Out;
output BB_SYSTEM_Mult_Over_Out;

output BB_SYSTEM_Div_Comp_Out;
output BB_SYSTEM_Div_Over_Out;


/// MODULES

/*
This module works fine, doesn't have overflow flag, but it's ok
*/
qadd #(.N(DATAWIDTH_N), .Q(FRACTIONAL_Q)) my_adder_u0 (
	.a(BB_SYSTEM_Aop_BusIn),
   .b(BB_SYSTEM_Bop_BusIn),
   .c(BB_SYSTEM_AddResult_BusOut)
);


/*
This module uses shift algorithm, an it's a good alternative
*/
qmults #(.N(DATAWIDTH_N), .Q(FRACTIONAL_Q)) my_multiplier_u0 (
	.i_multiplicand(BB_SYSTEM_Aop_BusIn),
	.i_multiplier(BB_SYSTEM_Bop_BusIn),
	.i_start(BB_SYSTEM_Start_Mult_InHigh),
	.i_clk(BB_SYSTEM_CLOCK_50),
	.o_result_out(BB_SYSTEM_MultResult_BusOut),
	.o_complete(BB_SYSTEM_Mult_Comp_Out),
	.o_overflow(BB_SYSTEM_Mult_Over_Out)
);


/*
This module doesn't have divison by zero detection
*/
qdiv #(.N(DATAWIDTH_N), .Q(FRACTIONAL_Q)) my_divider_u0 (
	.i_dividend(BB_SYSTEM_Aop_BusIn),
	.i_divisor(BB_SYSTEM_Bop_BusIn),
	.i_start(BB_SYSTEM_Start_Div_InHigh),
	.i_clk(BB_SYSTEM_CLOCK_50),
	.o_quotient_out(BB_SYSTEM_DivResult_BusOut),
	.o_complete(BB_SYSTEM_Div_Comp_Out),
	.o_overflow(BB_SYSTEM_Div_Over_Out)
);

endmodule
