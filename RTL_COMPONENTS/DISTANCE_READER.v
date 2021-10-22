
/*
Created by: Jhoan Esteban Leon je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library

This module read obstacule distance from promity sensor hc-sr04
the measure of distance is done every 10ms and is in [cm/s] fixed point 17b notation U(17,8) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module DISTANCE_READER
(

	//////////// INPUTS //////////
	DISTANCE_READER_CLOCK_50,
	DISTANCE_READER_RESET_InHigh,
	
	DISTANCE_READER_ECHO_In,
	
	//////////// OUTPUTS //////////
	DISTANCE_READER_TRIGGER_Out,
	DISTANCE_READER_DISTANCE_OutBus

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

//=======================================================
//  PORT declarations
//=======================================================
input	DISTANCE_READER_CLOCK_50;
input	DISTANCE_READER_RESET_InHigh;
	
input	DISTANCE_READER_ECHO_In;

output reg	DISTANCE_READER_TRIGGER_Out;
output [N_WIDTH-1:0]	DISTANCE_READER_DISTANCE_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [19:0] counter_trigger = 20'b0;
reg [N_WIDTH-1:0] counter_echo = 17'b0;
reg [3:0] counter_pulses_10 = 4'b0;

//=======================================================
//  STRUCTURAL coding
//=======================================================

always @ (posedge DISTANCE_READER_CLOCK_50) 
begin
	counter_trigger <= counter_trigger + 1'b1;
	
	if (counter_pulses_10 < 4'd10)
		counter_pulses_10 <= counter_pulses_10 + 1'b1;
		
	else if ( (DISTANCE_READER_ECHO_In == 1'd1) && (counter_pulses_10 == 4'd10) )
		begin
			counter_echo <= counter_echo + 17'b0_00000000_00000001; // 0.003432 cm/pulso (0.003906)
			counter_pulses_10 <= 4'd0; // reset the counter of pulses
		end
		
	else
		counter_pulses_10 <= 4'd0; // reset the counter of pulses
		
	
	if ((DISTANCE_READER_RESET_InHigh == 1'b1) || (counter_trigger == 20'd500000)) // 10ms for each measure (count = 500.000*20ns)
	begin
		counter_trigger <= 20'd0;
		counter_echo <= 17'd0;
		counter_pulses_10 <= 4'd0;
	end
	else if (counter_trigger <= 20'd500) // 10us of trigger pulse = 500*20ns
		DISTANCE_READER_TRIGGER_Out <= 1'b1;

	else if (counter_trigger > 20'd500) 
		DISTANCE_READER_TRIGGER_Out <= 1'd0;
end


assign DISTANCE_READER_DISTANCE_OutBus = counter_echo;


endmodule
