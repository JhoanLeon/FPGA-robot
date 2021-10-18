//****************************************
// Code taken from: https://github.com/FranzLuepke/Robocol_Traction_HW  
// Modified by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//Modulo de control PI para los RPM de los motores del robot

//`define _32B
`define _17B

module PI_control(Prescaler_clk, Error_k, COMANDO_PWM);

`ifdef _32B
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;
`endif

`ifdef _17B
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;
`endif

input Prescaler_clk;		// Clock prescalado a 82us para calculos del controlador
input wire [N_WIDTH-1:0] Error_k;	// Error actual de las RPM para el controlador

output [7:0] COMANDO_PWM;	// PWM en 8 bits, entre 0 y 255
reg [7:0] COMANDO_PWM = 0;


reg [N_WIDTH-1:0] Error_k1 = 0; 	// Variable para error en k-1
 
reg [N_WIDTH-1:0] Control_k1 = 0; // Señal de control en k-1

wire [N_WIDTH-1:0] first_res;  // 
wire [N_WIDTH-1:0] second_res; // 
wire [N_WIDTH-1:0] third_res;  // 
wire [31:0] Control_k;  // 32 bits to detect overflow, Señal de control en k 


`ifdef _32B
parameter K_P = 32'b0_0000000000000000_100110011001101; // este valor es el calibrado en software 0.60
parameter K_I = 32'b0_0000000000000000_000101000111101; // este valor es el calibrado en software 0.08
`endif

`ifdef _17B
// caso en el que no llega a los setpoints, no oscila
parameter K_P = 17'b0_00000000_00010100; // este valor debe ser calibrado 0.0781
parameter K_I = 17'b0_00000000_00010100; // este valor debe ser calibrado 0.0781

// caso en el que oscila para velocidades 0.125, 0.25 y 0.375, para 0.5 funciona preciso
//parameter K_P = 17'b0_00000000_11011001; // este valor debe ser calibrado 0.8477
//parameter K_I = 17'b0_00000000_11011001; // este valor debe ser calibrado 0.8477
`endif


// computes the control output CONTROL_k = CONTROL_k1 + K_P*Error_k + K_I*Error_k1;
qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) MULT_KP_ERRORK
(
	.i_multiplicand(K_P),
	.i_multiplier(Error_k),
	.o_result(first_res),
	.ovr()
);


qmult #(.Q(Q_WIDTH), .N(N_WIDTH)) MULT_KI_ERRORK1
(
	.i_multiplicand(K_I),
	.i_multiplier(Error_k1),
	.o_result(second_res),
	.ovr()
);


qadd #(.Q(Q_WIDTH), .N(N_WIDTH)) first_add
(
   .a(first_res),
   .b(second_res),
   .c(third_res)
);


qadd #(.Q(15), .N(32)) second_add // 32 bit to detect overflow and cut overshoot of controller
(
   .a({third_res[N_WIDTH-1], 8'b0, third_res[N_WIDTH-2:0], 7'b0}),
   .b({Control_k1[N_WIDTH-1], 8'b0, Control_k1[N_WIDTH-2:0], 7'b0}),
   .c(Control_k)
);


`ifdef _17B
always @(posedge Prescaler_clk)
begin
	if ( Control_k[30:15] >= 16'd250 ) //Caso de saturacion del controlador por arriba (parte entera del número)
		COMANDO_PWM <= 8'd255;
	else if ( (Control_k[30:15] <= 16'd5) || (Control_k[31] == 1'b1) ) //Caso de saturacion del controlador por abajo
		COMANDO_PWM <= 8'd0;
	else
		COMANDO_PWM <= Control_k[22:15];	// Caso sin saturacion, solo parte entera del numero
		
	// Actualiza el (k-1) para la siguiente iteración k 
	Error_k1 <= Error_k;
	Control_k1 <= {Control_k[31], COMANDO_PWM, Control_k[14:7]};
end
`endif




`ifdef _32B
always @(posedge Prescaler_clk)
begin
	if ( Control_k[22:15]  >= 8'd250 ) //Caso de saturacion del controlador por arriba
		COMANDO_PWM <= 8'd255;
	else if ( Control_k[22:15] <= 8'd5 ) //Caso de saturacion del controlador por abajo
		COMANDO_PWM <= 8'd0;
	else
		COMANDO_PWM <= Control_k[22:15];	// Caso sin saturacion 32b
		
	// Actualiza el (k-1) para la siguiente iteración k 
	Error_k1 <= Error_k;
	Control_k1 <= Control_k;
end
`endif

endmodule
