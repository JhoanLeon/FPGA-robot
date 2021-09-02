//****************************************
// Code taken from book: FPGA PROTOTYPING BY VERILOG EXAMPLES - Pong P. Chu
// Adapted by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

module PREESCALER #(parameter N_DATAWIDTH = 4)
(
	//////////// INPUT //////////
	CLOCK_IN,
	
	//////////// OUTPUT //////////
	CLOCK_OUT	
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//Frecuencia de salida f = f(in)/2^N
//Periodo de salida T = 2^N*T(clock de entrada)

//Clock incial 50 MHZ 20ns

//N=1		25 MHz		40 ns
//N=2		12.5 MHz		80 ns
//N=3		6.25 MHz		160 ns
//N=4		3.125 MHz	320 ns
//and so on

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK IN //////////
input wire CLOCK_IN;

//////////// CLOCK OUT //////////
output wire CLOCK_OUT;

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [N_DATAWIDTH-1:0] COUNT = 0;

//=======================================================
//  Structural coding
//=======================================================

//STATE REGISTER: SEQUENTIAL
always @(posedge CLOCK_IN)
 begin 
  COUNT <= COUNT + 1'b1;
 end


//OUTPUT LOGIC: COMBINATIONAL
assign CLOCK_OUT = COUNT[N_DATAWIDTH-1];


endmodule
