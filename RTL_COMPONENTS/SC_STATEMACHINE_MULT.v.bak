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
module SC_STATEMACHINE_BASE (

	//////////// INPUTS //////////
	SC_STATEMACHINE_BASE_CLOCK_50,
	SC_STATEMACHINE_BASE_RESET_InHigh,
	
	
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_BASE_done_Out
	
);	

//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam STATE_RESET_0									= 0;
localparam STATE_START_0									= 1;
localparam STATE_CHECK_0									= 2;

//=======================================================
//  PORT declarations
//=======================================================
input	SC_STATEMACHINE_BASE_CLOCK_50;
input	SC_STATEMACHINE_BASE_RESET_InHigh;

output reg  SC_STATEMACHINE_BASE_done_Out;

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
		
		STATE_START_0: STATE_Signal = STATE_CHECK_0;
		
		STATE_CHECK_0: STATE_Signal = STATE_CHECK_0;
				
		default: STATE_Signal = STATE_CHECK_0;
	endcase
end

// STATE REGISTER : SEQUENTIAL
always @ ( posedge SC_STATEMACHINE_BASE_CLOCK_50 , posedge SC_STATEMACHINE_BASE_RESET_InHigh)
begin
	if (SC_STATEMACHINE_BASE_RESET_InHigh == 1'b1)
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
			SC_STATEMACHINE_BASE_done_Out = 1'b0;
		end

	STATE_START_0 :	
		begin
			SC_STATEMACHINE_BASE_done_Out = 1'b0;
		end

	STATE_CHECK_0 :
		begin
			SC_STATEMACHINE_BASE_done_Out = 1'b0;
		end
			
//=========================================================
// DEFAULT
//=========================================================
	default :
		begin
			SC_STATEMACHINE_BASE_done_Out = 1'b0;
		end
	endcase
end
endmodule
