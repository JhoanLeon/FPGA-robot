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
module CC_MUX41 #(parameter MUX41_SELECTWIDTH=2,parameter MUX41_DATAWIDTH=4)(
//////////// OUTPUTS //////////
	CC_MUX41_z_Out,
//////////// INPUTS //////////
	CC_MUX41_select_InBUS,
	CC_MUX41_data_InBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output	CC_MUX41_z_Out;
input 	[MUX41_SELECTWIDTH-1:0] CC_MUX41_select_InBUS;
input 	[MUX41_DATAWIDTH-1:0] CC_MUX41_data_InBUS;
//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  Structural coding
//=======================================================
assign CC_MUX41_z_Out = CC_MUX41_data_InBUS[CC_MUX41_select_InBUS];

endmodule

