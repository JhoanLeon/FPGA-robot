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
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

parameter h1 = 32'b0_0000000000000000_000101000000000; // 0.078125m = 7.8cm de error para y
parameter h2 = 32'b0_0000000000000000_000101000000000; // 0.078125m = 7.8cm de error para x
parameter h3 = 32'b0_0000000000001010_000000000000000; // 10deg de error en theta

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
			ERROR_CONTROL_VX_OutBus <= ERROR_CONTROL_Y_InBus; // o una velocidad estandar
			ERROR_CONTROL_VY_OutBus <= 32'b0;
			ERROR_CONTROL_WZ_OutBus <= 32'b0;
		end
		
	else if ( (ERROR_CONTROL_Y_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_Y_InBus[N_WIDTH-2:0] > {h1[N_WIDTH-2:0]}) ) // si el error es negativo, vaya hacia atrás
		begin
			ERROR_CONTROL_VX_OutBus <= ERROR_CONTROL_Y_InBus; // o una velocidad estandar
			ERROR_CONTROL_VY_OutBus <= 32'b0;
			ERROR_CONTROL_WZ_OutBus <= 32'b0;
		end

	else // si el error Y está en los límites, entonces ya ajustó la coordenada Y
		begin
		
			if (ERROR_CONTROL_X_InBus > h2) // ajustar coordenada x positiva
				begin
					ERROR_CONTROL_VX_OutBus <= 32'b0;
					ERROR_CONTROL_VY_OutBus <= {~ERROR_CONTROL_X_InBus[N_WIDTH-1],ERROR_CONTROL_X_InBus[N_WIDTH-2:0]};
					ERROR_CONTROL_WZ_OutBus <= 32'b0;
				end
			
			else if ( (ERROR_CONTROL_X_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_X_InBus[N_WIDTH-2:0] > {h2[N_WIDTH-2:0]}) )
				begin
					ERROR_CONTROL_VX_OutBus <= 32'b0;
					ERROR_CONTROL_VY_OutBus <= {~ERROR_CONTROL_X_InBus[N_WIDTH-1],ERROR_CONTROL_X_InBus[N_WIDTH-2:0]};
					ERROR_CONTROL_WZ_OutBus <= 32'b0;			
				end

			else // si el error X está en los límites, entonces ya ajustó la coordenada X
				begin
			
					if (ERROR_CONTROL_Z_InBus > h3)
						begin
							ERROR_CONTROL_VX_OutBus <= 32'b0;
							ERROR_CONTROL_VY_OutBus <= 32'b0;
							ERROR_CONTROL_WZ_OutBus <= ERROR_CONTROL_Z_InBus;					
						end
			
					else if ( (ERROR_CONTROL_Z_InBus[N_WIDTH-1] == 1'b1) && (ERROR_CONTROL_Z_InBus[N_WIDTH-2:0] > {h3[N_WIDTH-2:0]}) )
						begin
							ERROR_CONTROL_VX_OutBus <= 32'b0;
							ERROR_CONTROL_VY_OutBus <= 32'b0;
							ERROR_CONTROL_WZ_OutBus <= ERROR_CONTROL_Z_InBus;
						end
			
					else // si el error Z está en los límites, entonces ya ajustó la rotación
						begin
							ERROR_CONTROL_VX_OutBus <= 32'b0; 
							ERROR_CONTROL_VY_OutBus <= 32'b0;
							ERROR_CONTROL_WZ_OutBus <= 32'b0;
						end				
			
				end
			
		end

end


endmodule
