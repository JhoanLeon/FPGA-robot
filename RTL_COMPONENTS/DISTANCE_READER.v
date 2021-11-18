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
	
	DISTANCE_READER_LOADSIGNAL_InLow,
	
	//////////// OUTPUTS //////////
	DISTANCE_READER_DISTANCE_OutBus
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;

//=======================================================
//  PORT declarations
//=======================================================
input	DISTANCE_READER_CLOCK_50;
input	DISTANCE_READER_RESET_InHigh;
	
input	DISTANCE_READER_ECHO_In;

input DISTANCE_READER_LOADSIGNAL_InLow;

output reg [N_WIDTH-1:0] DISTANCE_READER_DISTANCE_OutBus = 17'b0;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [3:0] counter_pulses_10 = 4'b0; // counter to reduce conversion rate to the precision

//=======================================================
//  STRUCTURAL coding
//=======================================================
always @ (posedge DISTANCE_READER_CLOCK_50) 
begin

	if (DISTANCE_READER_RESET_InHigh == 1'b1 || DISTANCE_READER_LOADSIGNAL_InLow == 1'b0)
	begin
		counter_pulses_10 = 4'd0; // reset the counter
		DISTANCE_READER_DISTANCE_OutBus = 17'b0; // reset the counter of echo time
	end

	else if (counter_pulses_10 < 4'd10)
	begin
		counter_pulses_10 = counter_pulses_10 + 4'd1;
	end
	
	else if ( (DISTANCE_READER_ECHO_In == 1'd1) && (counter_pulses_10 == 4'd10) )
	begin
		DISTANCE_READER_DISTANCE_OutBus = DISTANCE_READER_DISTANCE_OutBus + 17'b0_00000000_00000001; // 0.003432 cm/pulso (0.003906)
		counter_pulses_10 = 4'd0; // reset the counter
	end
	
	else
	begin
		counter_pulses_10 = 4'd0; // reset the counter
	end	
	
end


endmodule
