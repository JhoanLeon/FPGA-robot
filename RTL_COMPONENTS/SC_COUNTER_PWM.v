//****************************************
// Code taken from book: FPGA PROTOTYPING BY VERILOG EXAMPLES - Pong P. Chu
// Adapted by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================

module SC_COUNTER_PWM #(parameter N = 8) // N is the amount of bit for count, maximun number of flag and count is 2^(N)-1
(

	//////////// INPUTS //////////
	input wire SC_COUNTER_PWM_CLOCK,
	input wire SC_COUNTER_PWM_RESET_InHigh,
	
	input wire SC_COUNTER_PWM_ENABLE_InLow, // if this signal is low the counter works
	input wire SC_COUNTER_PWM_CLEAR_InLow, // signal to clear the count
	
	input wire [N-1:0] SC_COUNTER_PWM_FLAGCOMP_InBus,
	
	//////////// OUTPUTS ////////// 
	output wire [N-1:0] SC_COUNTER_PWM_REGCOUNT, //Output bus for count
	output wire SC_COUNTER_PWM_FLAG_OutLow, //Output flag InLow for specific number of count
	output wire SC_COUNTER_PWM_ENDCOUNT_OutLow // output flag InLow for end of total count
	
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [N-1:0] R_Register = 0; //Registers for sequential part of counter
reg [N-1:0] R_Next = 0;

//=======================================================
//  STRUCTURAL coding
//=======================================================

//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_COUNTER_PWM_CLEAR_InLow == 1'b0)
		R_Next = 0;
	else if (SC_COUNTER_PWM_ENABLE_InLow == 1'b0)
		R_Next = R_Register + 1'b1; 
	else
		R_Next = R_Register;
end


//STATE REGISTER: SEQUENTIAL
always @(posedge SC_COUNTER_PWM_CLOCK, posedge SC_COUNTER_PWM_RESET_InHigh)
	if (SC_COUNTER_PWM_RESET_InHigh == 1'b1)
		R_Register <= 0; // reset to zero
	else
		R_Register <= R_Next;


//OUTPUT LOGIC: COMBINATIONAL
assign SC_COUNTER_PWM_REGCOUNT = R_Register;
assign SC_COUNTER_PWM_FLAG_OutLow = (R_Register == SC_COUNTER_PWM_FLAGCOMP_InBus) ? 1'b0 : 1'b1;
assign SC_COUNTER_PWM_ENDCOUNT_OutLow = (R_Register == 2**N - 1) ? 1'b0 : 1'b1;

endmodule
