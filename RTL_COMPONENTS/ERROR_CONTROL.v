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
	ERROR_CONTROL_VX_OutBus, 
	ERROR_CONTROL_VY_OutBus, 
	ERROR_CONTROL_WZ_OutBus  
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

parameter h1 = 17'b0_00000000_00010100; // 0.078125m = 7.8cm de error para y
parameter h2 = 17'b0_00000000_00010100; // 0.078125m = 7.8cm de error para x
parameter h3 = 17'b0_00001010_00000000; // 10deg de error en theta

//=======================================================
//  PORT declarations
//=======================================================
input [N_WIDTH-1:0]	ERROR_CONTROL_X_InBus;
input [N_WIDTH-1:0]	ERROR_CONTROL_Y_InBus;
input [N_WIDTH-1:0]	ERROR_CONTROL_Z_InBus;
	
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

	if (ERROR_CONTROL_Y_InBus > h1) // si el error es positivo, vaya hacia adelante
		begin
			ERROR_CONTROL_VX_OutBus = 17'b0_00000000_01100000;//ERROR_CONTROL_Y_InBus; // o una velocidad estandar
			ERROR_CONTROL_VY_OutBus = 17'b0;
			ERROR_CONTROL_WZ_OutBus = 17'b0;
		end
		
	else if ( (ERROR_CONTROL_Y_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_Y_InBus[N_WIDTH-2:0] > {h1[N_WIDTH-2:0]}) ) // si el error es negativo, vaya hacia atras
		begin
			ERROR_CONTROL_VX_OutBus = 17'b1_00000000_01100000;//ERROR_CONTROL_Y_InBus; // o una velocidad estandar
			ERROR_CONTROL_VY_OutBus = 17'b0;
			ERROR_CONTROL_WZ_OutBus = 17'b0;
		end

	else // ajuste coordenada Y realizado
		begin
		
			if (ERROR_CONTROL_X_InBus > h2) // ajustar coordenada x positiva
				begin
					ERROR_CONTROL_VX_OutBus = 17'b0;
					ERROR_CONTROL_VY_OutBus = 17'b1_00000000_01100000;//{~ERROR_CONTROL_X_InBus[N_WIDTH-1],ERROR_CONTROL_X_InBus[N_WIDTH-2:0]};
					ERROR_CONTROL_WZ_OutBus = 17'b0;
				end
			
			else if ( (ERROR_CONTROL_X_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_X_InBus[N_WIDTH-2:0] > {h2[N_WIDTH-2:0]}) )
				begin
					ERROR_CONTROL_VX_OutBus = 17'b0;
					ERROR_CONTROL_VY_OutBus = 17'b0_00000000_01100000;//{~ERROR_CONTROL_X_InBus[N_WIDTH-1],ERROR_CONTROL_X_InBus[N_WIDTH-2:0]};
					ERROR_CONTROL_WZ_OutBus = 17'b0;			
				end

			else // ajuste coordenada X realizado
				begin
			
					if (ERROR_CONTROL_Z_InBus > h3)
						begin
							ERROR_CONTROL_VX_OutBus = 17'b0;
							ERROR_CONTROL_VY_OutBus = 17'b0;
							ERROR_CONTROL_WZ_OutBus = 17'b0_00000000_01100000;//ERROR_CONTROL_Z_InBus;					
						end
			
					else if ( (ERROR_CONTROL_Z_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_Z_InBus[N_WIDTH-2:0] > {h3[N_WIDTH-2:0]}) )
						begin
							ERROR_CONTROL_VX_OutBus = 17'b0;
							ERROR_CONTROL_VY_OutBus = 17'b0;
							ERROR_CONTROL_WZ_OutBus = 17'b1_00000000_01100000;//ERROR_CONTROL_Z_InBus;
						end
			
					else // ajuste de rotacion realizado
						begin
							ERROR_CONTROL_VX_OutBus = 17'b0; 
							ERROR_CONTROL_VY_OutBus = 17'b0;
							ERROR_CONTROL_WZ_OutBus = 17'b0;
						end				
			
				end
			
		end

end


endmodule
