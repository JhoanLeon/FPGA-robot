/*
Created by: Jhoan Esteban Leon - je.leon.e@outlook.com
with libraries from https://github.com/freecores/verilog_fixed_point_math_library
*/

//=======================================================
//  MODULE Definition
//=======================================================

module ERROR_CONTROL 
(
	//////////// INPUTS //////////
	ERROR_CONTROL_X_InBus,
	ERROR_CONTROL_Y_InBus,
	ERROR_CONTROL_Z_InBus,
	
	//////////// OUTPUTS //////////
	ERROR_CONTROL_GOAL_FLAG, // FLAG INLOW to indicate that goal is reached
	
	ERROR_CONTROL_VX_OutBus, 
	ERROR_CONTROL_VY_OutBus, 
	ERROR_CONTROL_WZ_OutBus  
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;

//// CENTIMETERS
parameter h1 = 17'b0_00001010_00000000; // 10cm de error para y
parameter h2 = 17'b0_00001010_00000000; // 10cm de error para x
parameter h3 = 17'b0_00001010_00000000; // 10deg de error en theta [100deg-80deg]

parameter global_velocity_pos = 17'b0_00011110_00000000; // 30cm/s
parameter global_velocity_neg = 17'b1_00011110_00000000; // -30cm/s

//=======================================================
//  PORT declarations
//=======================================================
input [N_WIDTH-1:0]	ERROR_CONTROL_X_InBus;
input [N_WIDTH-1:0]	ERROR_CONTROL_Y_InBus;
input [N_WIDTH-1:0]	ERROR_CONTROL_Z_InBus;
	
output reg ERROR_CONTROL_GOAL_FLAG;	
	
output reg [N_WIDTH-1:0]	ERROR_CONTROL_VX_OutBus; 
output reg [N_WIDTH-1:0]	ERROR_CONTROL_VY_OutBus; 
output reg [N_WIDTH-1:0]	ERROR_CONTROL_WZ_OutBus;

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  STRUCTURAL coding
//=======================================================

always @(*)
begin

	if ( (ERROR_CONTROL_Y_InBus[N_WIDTH-1] == 1'b0) && (ERROR_CONTROL_Y_InBus[N_WIDTH-2:0] > h1[N_WIDTH-2:0]) ) // si el error es positivo, vaya hacia adelante
		begin
			ERROR_CONTROL_VX_OutBus = global_velocity_pos;
			ERROR_CONTROL_VY_OutBus = 17'b0;
			ERROR_CONTROL_WZ_OutBus = 17'b0;
			ERROR_CONTROL_GOAL_FLAG = 1'b1;
		end
		
	else if ( (ERROR_CONTROL_Y_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_Y_InBus[N_WIDTH-2:0] > h1[N_WIDTH-2:0]) ) // si el error es negativo, vaya hacia atras
		begin
			ERROR_CONTROL_VX_OutBus = global_velocity_neg;
			ERROR_CONTROL_VY_OutBus = 17'b0;
			ERROR_CONTROL_WZ_OutBus = 17'b0;
			ERROR_CONTROL_GOAL_FLAG = 1'b1;
		end

	else // ajuste coordenada Y realizado
		begin
		
			if ( (ERROR_CONTROL_X_InBus[N_WIDTH-1] == 1'b0) && (ERROR_CONTROL_X_InBus[N_WIDTH-2:0] > h2[N_WIDTH-2:0]) ) // ajustar coordenada x positiva
				begin
					ERROR_CONTROL_VX_OutBus = 17'b0;
					ERROR_CONTROL_VY_OutBus = global_velocity_neg;
					ERROR_CONTROL_WZ_OutBus = 17'b0;
					ERROR_CONTROL_GOAL_FLAG = 1'b1;
				end
			
			else if ( (ERROR_CONTROL_X_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_X_InBus[N_WIDTH-2:0] > h2[N_WIDTH-2:0]) ) // ajustar coordenada x negativa
				begin
					ERROR_CONTROL_VX_OutBus = 17'b0;
					ERROR_CONTROL_VY_OutBus = global_velocity_pos;
					ERROR_CONTROL_WZ_OutBus = 17'b0;	
					ERROR_CONTROL_GOAL_FLAG = 1'b1;		
				end

			else // ajuste coordenada X realizado
				begin
			
					if ( (ERROR_CONTROL_Z_InBus[N_WIDTH-1] == 1'b0) && (ERROR_CONTROL_Z_InBus[N_WIDTH-2:0] > h3[N_WIDTH-2:0]) )
						begin
							ERROR_CONTROL_VX_OutBus = 17'b0;
							ERROR_CONTROL_VY_OutBus = 17'b0;
							ERROR_CONTROL_WZ_OutBus = global_velocity_pos;					
							ERROR_CONTROL_GOAL_FLAG = 1'b1;
						end
			
					else if ( (ERROR_CONTROL_Z_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_Z_InBus[N_WIDTH-2:0] > h3[N_WIDTH-2:0]) )
						begin
							ERROR_CONTROL_VX_OutBus = 17'b0;
							ERROR_CONTROL_VY_OutBus = 17'b0;
							ERROR_CONTROL_WZ_OutBus = global_velocity_neg;
							ERROR_CONTROL_GOAL_FLAG = 1'b1;
						end
			
					else // ajuste de rotacion realizado
						begin
							ERROR_CONTROL_VX_OutBus = 17'b0; 
							ERROR_CONTROL_VY_OutBus = 17'b0;
							ERROR_CONTROL_WZ_OutBus = 17'b0;
							ERROR_CONTROL_GOAL_FLAG = 1'b0;
						end				
			
				end
			
		end

end


endmodule
