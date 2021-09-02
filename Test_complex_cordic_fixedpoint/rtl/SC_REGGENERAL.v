/*######################################################################
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
module SC_REGGENERAL #(parameter REGGENERAL_DATAWIDTH=32)(

	//////////// INPUTS //////////
	SC_REGGENERAL_CLOCK_50,
	SC_REGGENERAL_RESET_InHigh, 
	SC_REGGENERAL_load_InLow, 
	SC_REGGENERAL_data_InBus,
	//////////// OUTPUTS //////////
	SC_REGGENERAL_data_OutBUS
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
input		SC_REGGENERAL_CLOCK_50;
input		SC_REGGENERAL_RESET_InHigh;
input		SC_REGGENERAL_load_InLow;	
input		[REGGENERAL_DATAWIDTH-1:0]	SC_REGGENERAL_data_InBus;

output	[REGGENERAL_DATAWIDTH-1:0]	SC_REGGENERAL_data_OutBUS;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [REGGENERAL_DATAWIDTH-1:0] REGGENERAL_Register;
reg [REGGENERAL_DATAWIDTH-1:0] REGGENERAL_Signal;

//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_REGGENERAL_load_InLow == 1'b0)
		REGGENERAL_Signal = SC_REGGENERAL_data_InBus;
	else
		REGGENERAL_Signal = REGGENERAL_Register;
	end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_REGGENERAL_CLOCK_50, posedge SC_REGGENERAL_RESET_InHigh)
begin
	if (SC_REGGENERAL_RESET_InHigh == 1'b1)
		REGGENERAL_Register <= 0;
	else
		REGGENERAL_Register <= REGGENERAL_Signal;
end

//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_REGGENERAL_data_OutBUS = REGGENERAL_Register;

endmodule
