//######################################################################
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
//#####################################################################

//=======================================================
//  MODULE Definition
//=======================================================
module SC_REGSHIFTER #(parameter REGSHIFTER_DATAWIDTH=8)(
	//////////// OUTPUTS //////////
	SC_REGSHIFTER_data_OutBUS,
	//////////// INPUTS //////////
	SC_REGSHIFTER_CLOCK_50,
	SC_REGSHIFTER_RESET_InHigh,
	SC_REGSHIFTER_clear_InLow, 
	SC_REGSHIFTER_load_InLow, 
	SC_REGSHIFTER_shiftselection_In,
	SC_REGSHIFTER_data_InBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output	[REGSHIFTER_DATAWIDTH-1:0]	SC_REGSHIFTER_data_OutBUS;
input		SC_REGSHIFTER_CLOCK_50;
input		SC_REGSHIFTER_RESET_InHigh;
input		SC_REGSHIFTER_clear_InLow;
input		SC_REGSHIFTER_load_InLow;	
input		[1:0] SC_REGSHIFTER_shiftselection_In;
input		[REGSHIFTER_DATAWIDTH-1:0]	SC_REGSHIFTER_data_InBUS;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [REGSHIFTER_DATAWIDTH-1:0] REGSHIFTER_Register;
reg [REGSHIFTER_DATAWIDTH-1:0] REGSHIFTER_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_REGSHIFTER_clear_InLow == 1'b0)
		REGSHIFTER_Signal = 0;
	else if (SC_REGSHIFTER_load_InLow == 1'b0)
		REGSHIFTER_Signal = SC_REGSHIFTER_data_InBUS;
	else if (SC_REGSHIFTER_shiftselection_In == 2'b01)
		REGSHIFTER_Signal = REGSHIFTER_Register << 1'b1;   
		//REGSHIFTER_Signal = {REGSHIFTER_Register[DATAWIDTH_BUS-2:0],0}
	else if (SC_REGSHIFTER_shiftselection_In== 2'b10)
		REGSHIFTER_Signal = REGSHIFTER_Register >> 1'b1;   
		//REGSHIFTER_Signal = {0,REGSHIFTER_Register[DATAWIDTH_BUS-1:1]}
	else
		REGSHIFTER_Signal = REGSHIFTER_Register;
	end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_REGSHIFTER_CLOCK_50, posedge SC_REGSHIFTER_RESET_InHigh)
begin
	if (SC_REGSHIFTER_RESET_InHigh == 1'b1)
		REGSHIFTER_Register <= 0;
	else
		REGSHIFTER_Register <= REGSHIFTER_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_REGSHIFTER_data_OutBUS = REGSHIFTER_Register;

endmodule
