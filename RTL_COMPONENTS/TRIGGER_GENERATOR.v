/*
Created by: Jhoan Esteban Leon je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library

This module read obstacule distance from promity sensor hc-sr04
the measure of distance is done every 10ms and is in [cm/s] fixed point 17b notation U(17,8) U(N,Q)
*/

//=======================================================
//  MODULE Definition
//=======================================================

module TRIGGER_GENERATOR
(
	//////////// INPUTS //////////
	TRIGGER_GENERATOR_CLOCK_50,
	TRIGGER_GENERATOR_RESET_InHigh,
	
	//////////// OUTPUTS //////////
	TRIGGER_GENERATOR_TRIGGER_Out,
	TRIGGER_GENERATOR_LOADSIGNAL_OutLow
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
input	TRIGGER_GENERATOR_CLOCK_50;
input	TRIGGER_GENERATOR_RESET_InHigh;

output reg TRIGGER_GENERATOR_TRIGGER_Out;

output reg TRIGGER_GENERATOR_LOADSIGNAL_OutLow;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [19:0] counter_trigger = 20'd0;

//=======================================================
//  STRUCTURAL coding
//=======================================================

always @ (posedge TRIGGER_GENERATOR_CLOCK_50) 
begin
	counter_trigger = counter_trigger + 1'b1;
	
	if ((TRIGGER_GENERATOR_RESET_InHigh == 1'b1) || (counter_trigger == 20'd500000)) // 10ms for each measure (count = 500.000*20ns)
	begin
		counter_trigger = 20'd0; // reset the counter for trigger pulses
		TRIGGER_GENERATOR_TRIGGER_Out = 1'b0; // no trigger
		TRIGGER_GENERATOR_LOADSIGNAL_OutLow = 1'b1; // no load signal
	end
	
	else if (counter_trigger <= 20'd500) // 10us of trigger pulse = 500*20ns
	begin
		TRIGGER_GENERATOR_TRIGGER_Out = 1'b1; // trigger
		TRIGGER_GENERATOR_LOADSIGNAL_OutLow = 1'b1; // no load signal
	end
	
	else if (counter_trigger == 20'd499999)
	begin
		TRIGGER_GENERATOR_TRIGGER_Out = 1'b0; // no trigger
		TRIGGER_GENERATOR_LOADSIGNAL_OutLow = 1'b0; // load signal		
	end	
	
	else
	begin
		TRIGGER_GENERATOR_TRIGGER_Out = 1'b0; // no trigger
		TRIGGER_GENERATOR_LOADSIGNAL_OutLow = 1'b1; // no load signal
	end
	
end


endmodule
