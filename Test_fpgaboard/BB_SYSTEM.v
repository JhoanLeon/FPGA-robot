//****************************************
// Author: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

// Anotations
/*
Reset button on board is pull-up , so signal is InLow
LEDs on board are active in Low.
*/

//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM 
(
	//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_Reset_InLow,

	BB_SYSTEM_Count_InLow,

	//////////// OUTPUTS ////////// 
	BB_SYSTEM_Count_OutBus,
	BB_SYSTEM_Button_Out
);

//=======================================================
//  PARAMETER declarations
//=======================================================

parameter N_COUNTER = 4;
parameter COUNTER_FLAG = 150;
parameter N_PREESCALER = 24;

//=======================================================
//  PORT declarations
//=======================================================

input 	BB_SYSTEM_CLOCK_50;
input		BB_SYSTEM_Reset_InLow;

input		BB_SYSTEM_Count_InLow;

output 	[N_COUNTER-1:0]	BB_SYSTEM_Count_OutBus;
output	BB_SYSTEM_Button_Out;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire button_out;
wire clock_counter_signal;
wire [N_COUNTER-1:0] count_outbus;

//=======================================================
//  STRUCTURAL coding
//=======================================================

SC_DEBOUNCE SC_DEBOUNCE_U0 
(
	.SC_DEBOUNCE_CLOCK_50(BB_SYSTEM_CLOCK_50), 
	.SC_DEBOUNCE_RESET_InHigh(~BB_SYSTEM_Reset_InLow), 
	.SC_DEBOUNCE_button_In(BB_SYSTEM_Count_InLow),				
	.SC_DEBOUNCE_button_Out(button_out)				
);


PREESCALER #(.N_DATAWIDTH(N_PREESCALER)) PREESCALER_U0
(
	.CLOCK_IN(BB_SYSTEM_CLOCK_50),
	.CLOCK_OUT(clock_counter_signal)	
);


SC_COUNTER #(.N(N_COUNTER), .flag(COUNTER_FLAG)) SC_COUNTER_U0
(
	//////////// INPUTS //////////
	.SC_COUNTER_CLOCK(clock_counter_signal),
	.SC_COUNTER_RESET_InHigh(~BB_SYSTEM_Reset_InLow),
	
	.SC_COUNTER_ENABLE_InLow(1'b0),//button_out),
	.SC_COUNTER_CLEAR_InLow(1'b1),
	
	//////////// OUTPUTS ////////// 
	.SC_COUNTER_REGCOUNT(count_outbus),//BB_SYSTEM_Count_OutBus), //Output bus for count
	.SC_COUNTER_FLAG_OutLow() //Output flag InLow for specific number of count

);


assign BB_SYSTEM_Button_Out = button_out;
assign BB_SYSTEM_Count_OutBus = ~count_outbus;

endmodule
