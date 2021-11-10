///*######################################################################
//#	G0B1T: HDL EXAMPLES. 2018.
//######################################################################
//# Copyright (C) 2018. F.E.Segura-Quijano (FES) fsegura@uniandes.edu.co
//# 
//# This program is free software: you can redistribute it and/or modify
//# it under the terms of the GNU General Public License as published by
//# the Free Software Foundation, version 3 of the License.
//#
//# This program is distributed in the hope that it will be useful,
//# but WITHOUT ANY WARRANTY; without even the implied warranty of
//# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//# GNU General Public License for more details.
//#
//# You should have received a copy of the GNU General Public License
//# along with this program.  If not, see <http://www.gnu.org/licenses/>
//####################################################################*/

//=======================================================
//  MODULE Definition
//=======================================================
module SC_STATEMACHINE_MUX41 
(
	//////////// INPUTS //////////
	SC_STATEMACHINE_MUX41_CLOCK_50,
	SC_STATEMACHINE_MUX41_RESET_InHigh,
	
	SC_STATEMACHINE_MUX41_BEHAVIOR_In,
	SC_STATEMACHINE_NEWSIGNAL_InLow,
	SC_STATEMACHINE_MUX41_STOP_InLow,
	SC_STATEMACHINE_MUX41_FLAGGOAL_InLow,
	
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_MUX41_MUXSELECT_OutBus	
);	

//=======================================================
//  PARAMETER declarations
//=======================================================
localparam STATE_RESET_0									= 0;
localparam STATE_START_0									= 1;
localparam STATE_POSCONT_0									= 2;
localparam STATE_AVOIDCONT_0								= 3;
localparam STATE_STOP_0										= 4;

//=======================================================
//  PORT declarations
//=======================================================
input	SC_STATEMACHINE_MUX41_CLOCK_50;
input	SC_STATEMACHINE_MUX41_RESET_InHigh;

input SC_STATEMACHINE_MUX41_BEHAVIOR_In;
input SC_STATEMACHINE_NEWSIGNAL_InLow;
input	SC_STATEMACHINE_MUX41_STOP_InLow;
input	SC_STATEMACHINE_MUX41_FLAGGOAL_InLow;

output reg [1:0] SC_STATEMACHINE_MUX41_MUXSELECT_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [4:0] STATE_Register = 0;
reg [4:0] STATE_Signal = 0;

//=======================================================
//  STRUCTURAL coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
// NEXT STATE LOGIC : COMBINATIONAL
always @(*)
begin
	case (STATE_Register)
		STATE_RESET_0: STATE_Signal = STATE_START_0;
		
		STATE_START_0: if (SC_STATEMACHINE_MUX41_BEHAVIOR_In == 1'b1)
								STATE_Signal = STATE_POSCONT_0;
							else
								STATE_Signal = STATE_AVOIDCONT_0;
		
		STATE_POSCONT_0:	if (SC_STATEMACHINE_MUX41_STOP_InLow == 1'b0 || SC_STATEMACHINE_MUX41_FLAGGOAL_InLow == 1'b0)
									STATE_Signal = STATE_STOP_0;
								else
									STATE_Signal = STATE_POSCONT_0;
		
		STATE_AVOIDCONT_0:	if (SC_STATEMACHINE_MUX41_STOP_InLow == 1'b0 || SC_STATEMACHINE_MUX41_FLAGGOAL_InLow == 1'b0)
										STATE_Signal = STATE_STOP_0;
									else
										STATE_Signal = STATE_AVOIDCONT_0;
		
		STATE_STOP_0: 	if (SC_STATEMACHINE_NEWSIGNAL_InLow == 1'b0) // if there is a new signal, reestarted
								STATE_Signal = STATE_START_0;	
							else
								STATE_Signal = STATE_STOP_0;
				
		default: STATE_Signal = STATE_RESET_0;
	endcase
end

// STATE REGISTER : SEQUENTIAL
always @ (posedge SC_STATEMACHINE_MUX41_CLOCK_50 , posedge SC_STATEMACHINE_MUX41_RESET_InHigh)
begin
	if (SC_STATEMACHINE_MUX41_RESET_InHigh == 1'b1)
		STATE_Register <= STATE_RESET_0;
	else
		STATE_Register <= STATE_Signal;
end

//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
always @ (*)
begin
	case (STATE_Register)

	STATE_RESET_0 :	
		begin
			SC_STATEMACHINE_MUX41_MUXSELECT_OutBus = 2'b00; // initial stop
		end

	STATE_START_0 :	
		begin
			SC_STATEMACHINE_MUX41_MUXSELECT_OutBus = 2'b00; // initial stop
		end
		
	STATE_POSCONT_0 :	
		begin
			SC_STATEMACHINE_MUX41_MUXSELECT_OutBus = 2'b01; // selects position controller
		end
		
	STATE_AVOIDCONT_0 :	
		begin
			SC_STATEMACHINE_MUX41_MUXSELECT_OutBus = 2'b10; // selects avoid obstacles
		end

	STATE_STOP_0 :
		begin
			SC_STATEMACHINE_MUX41_MUXSELECT_OutBus = 2'b11; // selects stop
		end
			
//=========================================================
// DEFAULT
//=========================================================
	default :
		begin
			SC_STATEMACHINE_MUX41_MUXSELECT_OutBus = 2'b00;
		end
	endcase
end
endmodule
