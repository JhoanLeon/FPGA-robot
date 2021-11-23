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
module SC_STATEMACHINE_DESC 
(
	//////////// INPUTS //////////
	SC_STATEMACHINE_DESC_CLOCK_50,
	SC_STATEMACHINE_DESC_RESET_InHigh,
	
	SC_STATEMACHINE_DESC_DIST1_InBus,
	SC_STATEMACHINE_DESC_DIST2_InBus,
	SC_STATEMACHINE_DESC_DIST3_InBus,
	SC_STATEMACHINE_DESC_DIST4_InBus,
	
	SC_STATEMACHINE_DESC_ERRORX_InBus,
	SC_STATEMACHINE_DESC_ERRORY_InBus,
	
	SC_STATEMACHINE_DESC_TIMEFLAG_InLow,
	
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_DESC_VELX_OutBus,
	SC_STATEMACHINE_DESC_VELY_OutBus,
	
	SC_STATEMACHINE_DESC_ENABLETIME_OutLow,
	SC_STATEMACHINE_DESC_CLEARTIME_OutLow,
	
	SC_STATEMACHINE_DESC_BEHAVIOR_Out,
	SC_STATEMACHINE_DESC_CURRENTBEH_OutBus
);	

//=======================================================
//  PARAMETER declarations
//=======================================================
localparam STATE_RESET_0									= 0;
localparam STATE_START_0									= 1;
localparam STATE_GOAL_0										= 2;
localparam STATE_AVOID_0									= 3;
localparam STATE_AVOID_01									= 4;
localparam STATE_AVOID_1									= 5;
localparam STATE_AVOID_11									= 6;
localparam STATE_AVOID_2									= 7;
localparam STATE_AVOID_21									= 8;
localparam STATE_AVOID_22									= 9;
localparam STATE_AVOID_23									= 10;
localparam STATE_AVOID_3									= 11;
localparam STATE_AVOID_31									= 12;
localparam STATE_AVOID_32									= 13;
localparam STATE_AVOID_33									= 14;
localparam STATE_TIME0_0									= 15;
localparam STATE_TIME1_0									= 16;
localparam STATE_TIME0_1									= 17;
localparam STATE_TIME1_1									= 18;
localparam STATE_TIME0_2									= 19;
localparam STATE_TIME1_2									= 20;
localparam STATE_TIME0_23									= 21;
localparam STATE_TIME1_23									= 22;
localparam STATE_TIME0_3									= 23;
localparam STATE_TIME1_3									= 24;
localparam STATE_TIME0_33									= 25;
localparam STATE_TIME1_33									= 26;

parameter N_WIDTH = 17;
parameter B_WIDTH = 8;

parameter h = 17'b0_00001010_00000000; // 10cm de error para X y Y
parameter safe_dist = 17'b0_00001111_00000000; // 15cm de distancia segura a los obstaculos

parameter vel_pos = 17'b0_00110010_00000000; // +50cm/s
parameter vel_neg = 17'b1_00110010_00000000; // -50cm/s

//=======================================================
//  PORT declarations
//=======================================================

input	SC_STATEMACHINE_DESC_CLOCK_50;
input	SC_STATEMACHINE_DESC_RESET_InHigh;
	
input [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_DIST1_InBus;
input [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_DIST2_InBus;
input [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_DIST3_InBus;
input [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_DIST4_InBus;
	
input [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_ERRORX_InBus;
input [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_ERRORY_InBus;

input SC_STATEMACHINE_DESC_TIMEFLAG_InLow;
	
output reg [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_VELX_OutBus;
output reg [N_WIDTH-1:0]	SC_STATEMACHINE_DESC_VELY_OutBus;
	
output reg	SC_STATEMACHINE_DESC_ENABLETIME_OutLow;
output reg	SC_STATEMACHINE_DESC_CLEARTIME_OutLow;
	
output reg			 		 SC_STATEMACHINE_DESC_BEHAVIOR_Out;	
output reg [B_WIDTH-1:0] SC_STATEMACHINE_DESC_CURRENTBEH_OutBus;

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
		
		STATE_START_0: STATE_Signal = STATE_GOAL_0;
		
		STATE_GOAL_0:	if ( (SC_STATEMACHINE_DESC_DIST1_InBus <= safe_dist) || (SC_STATEMACHINE_DESC_DIST2_InBus <= safe_dist) || (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist) || (SC_STATEMACHINE_DESC_DIST4_InBus <= safe_dist) )
								STATE_Signal = STATE_AVOID_0; // obstacle detected
							else
								STATE_Signal = STATE_GOAL_0; // no obstacle, go-to-goal
		
		
		
		STATE_AVOID_0:	if ( (SC_STATEMACHINE_DESC_ERRORY_InBus[N_WIDTH-1] == 1'b0) && (SC_STATEMACHINE_DESC_ERRORY_InBus[N_WIDTH-2:0] > h[N_WIDTH-2:0]) && (SC_STATEMACHINE_DESC_DIST1_InBus <= safe_dist) )
								STATE_Signal = STATE_AVOID_01;
							else
								STATE_Signal = STATE_AVOID_1;
								
		STATE_AVOID_01:	if (SC_STATEMACHINE_DESC_DIST1_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_01; // si todavia hay obstaculo, muevase a la derecha
								else
									STATE_Signal = STATE_TIME0_0; // si ya no hay obstaculos, vaya a la meta, pero despues de un tiempo
									
		STATE_TIME0_0:	if (SC_STATEMACHINE_DESC_TIMEFLAG_InLow == 1'b0)
								STATE_Signal = STATE_TIME1_0;
							else
								STATE_Signal = STATE_TIME0_0;
		
		STATE_TIME1_0: STATE_Signal = STATE_GOAL_0;
		
		
		
		STATE_AVOID_1:	if ( (SC_STATEMACHINE_DESC_ERRORY_InBus[N_WIDTH-1] == 1'b1) && (SC_STATEMACHINE_DESC_ERRORY_InBus[N_WIDTH-2:0] > h[N_WIDTH-2:0]) && (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist) )
								STATE_Signal = STATE_AVOID_11;
							else
								STATE_Signal = STATE_AVOID_2;
	
		STATE_AVOID_11:	if (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_11; // si todavia hay obstaculo, muevase a la derecha
								else
									STATE_Signal = STATE_TIME0_1; // si ya no hay obstaculos, vaya a la meta, pero despues de un tiempo

		STATE_TIME0_1:	if (SC_STATEMACHINE_DESC_TIMEFLAG_InLow == 1'b0)
								STATE_Signal = STATE_TIME1_1;
							else
								STATE_Signal = STATE_TIME0_1;
		
		STATE_TIME1_1: STATE_Signal = STATE_GOAL_0;
									
				
									
		STATE_AVOID_2:	if ( (SC_STATEMACHINE_DESC_ERRORX_InBus[N_WIDTH-1] == 1'b0) && (SC_STATEMACHINE_DESC_ERRORY_InBus[N_WIDTH-2:0] <= h[N_WIDTH-2:0]) && (SC_STATEMACHINE_DESC_DIST2_InBus <= safe_dist) && (SC_STATEMACHINE_DESC_ERRORX_InBus[N_WIDTH-2:0] > h[N_WIDTH-2:0]) )
								STATE_Signal = STATE_AVOID_21;
							else
								STATE_Signal = STATE_AVOID_3;		
		
		STATE_AVOID_21:	if (SC_STATEMACHINE_DESC_DIST2_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_21; // si todavia hay obstaculo lateral, muevase hacia adelante
								else
									STATE_Signal = STATE_TIME0_2; // si ya no hay obstaculos lateral, vaya a la derecha, pero despues de un tiempo

		STATE_TIME0_2:	if (SC_STATEMACHINE_DESC_TIMEFLAG_InLow == 1'b0)
								STATE_Signal = STATE_TIME1_2;
							else
								STATE_Signal = STATE_TIME0_2;
		
		STATE_TIME1_2: STATE_Signal = STATE_AVOID_22;
		
		STATE_AVOID_22: if (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_23; // si detecto obstaculo atrás, esquivelo a la derecha
							 else
									STATE_Signal = STATE_AVOID_22; // si no detecta obstaculo, vaya a la derecha
		
		STATE_AVOID_23: if (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_23; // si todavia hay obstaculo atrás, muevase a la derecha
							 else
									STATE_Signal = STATE_TIME0_23; // si ya no hay obstaculos, vaya a la meta, pero despues de un tiempo
	
		STATE_TIME0_23:	if (SC_STATEMACHINE_DESC_TIMEFLAG_InLow == 1'b0)
								STATE_Signal = STATE_TIME1_23;
							else
								STATE_Signal = STATE_TIME0_23;
		
		STATE_TIME1_23: STATE_Signal = STATE_GOAL_0;	
		
		
		
		STATE_AVOID_3:	if ( (SC_STATEMACHINE_DESC_ERRORX_InBus[N_WIDTH-1] == 1'b1) && (SC_STATEMACHINE_DESC_ERRORY_InBus[N_WIDTH-2:0] <= h[N_WIDTH-2:0]) && (SC_STATEMACHINE_DESC_DIST4_InBus <= safe_dist) && (SC_STATEMACHINE_DESC_ERRORX_InBus[N_WIDTH-2:0] > h[N_WIDTH-2:0]) )
								STATE_Signal = STATE_AVOID_31;
							else
								STATE_Signal = STATE_GOAL_0;		
		
		STATE_AVOID_31:	if (SC_STATEMACHINE_DESC_DIST4_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_31; // si todavia hay obstaculo lateral, muevase hacia adelante
								else
									STATE_Signal = STATE_TIME0_3; // si ya no hay obstaculos, vaya a la izquierda, pero despues de un tiempo

		STATE_TIME0_3:	if (SC_STATEMACHINE_DESC_TIMEFLAG_InLow == 1'b0)
								STATE_Signal = STATE_TIME1_3;
							else
								STATE_Signal = STATE_TIME0_3;
		
		STATE_TIME1_3: STATE_Signal = STATE_AVOID_32;	
	
		STATE_AVOID_32: if (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_33; // si detecto obstaculo atrás, esquivelo a la izquierda
							 else
									STATE_Signal = STATE_AVOID_32; // si no detecta obstaculo, vaya a la izquierda
									
		STATE_AVOID_33: if (SC_STATEMACHINE_DESC_DIST3_InBus <= safe_dist)
									STATE_Signal = STATE_AVOID_33; // si todavia hay obstaculo atrás, muevase a la izquierda
							 else
									STATE_Signal = STATE_TIME0_33; // si ya no hay obstaculos, vaya a la meta, pero despues de un tiempo
		
		STATE_TIME0_33:	if (SC_STATEMACHINE_DESC_TIMEFLAG_InLow == 1'b0)
									STATE_Signal = STATE_TIME1_33;
							   else
									STATE_Signal = STATE_TIME0_33;
		
		STATE_TIME1_33: STATE_Signal = STATE_GOAL_0;
		
		
				
		default: STATE_Signal = STATE_RESET_0;
	endcase
end

// STATE REGISTER : SEQUENTIAL
always @ (posedge SC_STATEMACHINE_DESC_CLOCK_50 , posedge SC_STATEMACHINE_DESC_RESET_InHigh)
begin
	if (SC_STATEMACHINE_DESC_RESET_InHigh == 1'b1)
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
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50; // current behavior
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end

	STATE_START_0 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
		
	STATE_GOAL_0 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
	
	
	STATE_AVOID_0 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end		
	
	STATE_AVOID_01 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
		
	STATE_TIME0_0 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b0; // start counting the waiting time
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
		
	STATE_TIME1_0 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b0; // clear time for a new count
		end
	
	STATE_AVOID_1 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end	

	STATE_AVOID_11 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end	
	
	STATE_TIME0_1 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b0; // start counting the waiting time
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end

	STATE_TIME1_1 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b0; // clear time for a new count
		end		
		
	STATE_AVOID_2 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end		
		
	STATE_AVOID_21 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = vel_pos; // move forward
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end		
	
	STATE_TIME0_2 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = vel_pos; // move forward
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b0;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end	
	
	STATE_TIME1_2 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = vel_pos; // move forward
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b0;
		end	
	
	STATE_AVOID_22 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end	
	
	STATE_AVOID_23 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
	
	STATE_TIME0_23 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b0;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
	
	STATE_TIME1_23 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_neg; // move to right
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b0;
		end	

	
	STATE_AVOID_3 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end		
		
	STATE_AVOID_31 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = vel_pos; // move forward
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end

	STATE_TIME0_3 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = vel_pos; // move forward
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b0;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
	
	STATE_TIME1_3 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = vel_pos; // move forward
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b0;
		end	
	
	STATE_AVOID_32 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_pos; // move to left
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end	
	
	STATE_AVOID_33 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_pos; // move to left
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end	

	STATE_TIME0_33 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_pos; // move to left
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b0;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
	
	STATE_TIME1_33 :	
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b0; // avoid obstacle
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd100;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = vel_pos; // move to left
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b0;
		end	
	
//=========================================================
// DEFAULT
//=========================================================
	default :
		begin
			SC_STATEMACHINE_DESC_BEHAVIOR_Out = 1'b1; // go to goal
			SC_STATEMACHINE_DESC_CURRENTBEH_OutBus = 8'd50;
			SC_STATEMACHINE_DESC_VELX_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_VELY_OutBus = 17'b0;
			SC_STATEMACHINE_DESC_ENABLETIME_OutLow = 1'b1;
			SC_STATEMACHINE_DESC_CLEARTIME_OutLow = 1'b1;
		end
	endcase
end

endmodule
