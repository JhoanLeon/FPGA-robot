//****************************************
// Code taken from: https://github.com/FranzLuepke/Robocol_Traction_HW  
// Modified by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//Genera la senal de PWM a partir de un numero de 8 bits, entre 0 y 255
module moduloPWM(reset, clock, inPWM, outPWM);

//INPUTS AND OUTPUTS
input reset;//Reset
input clock;//Clock preescalado a 82us porque 82us * 255 flancos = 20ms (periodo de la señal de PWM)
input [7:0] inPWM;//PWM solicitado
output outPWM;//Senal

//REGS
reg salidaActual = 1'b0;//Salida
reg salidaFutura = 1'b0;//Salida

//WIRES
wire flagSubida;
wire flagBajada;

//MODULOS

// La modulacion se realiza con un solo contador que permite generar flags para subir o bajar la senal

SC_COUNTER_PWM #(.N(8)) contador // N is the amount of bit for count, maximun number of flag and count is 2^(N)-1
(
	.SC_COUNTER_PWM_CLOCK(clock),
	.SC_COUNTER_PWM_RESET_InHigh(reset),
	
	.SC_COUNTER_PWM_ENABLE_InLow(1'b0), // if this signal is low the counter works
	.SC_COUNTER_PWM_CLEAR_InLow(1'b1), // signal to clear the count

	.SC_COUNTER_PWM_FLAGCOMP_InBus(inPWM),
	
	.SC_COUNTER_PWM_REGCOUNT(), //Output bus for count
	.SC_COUNTER_PWM_FLAG_OutLow(flagBajada), //Output flag InLow for specific number of count
	.SC_COUNTER_PWM_ENDCOUNT_OutLow(flagSubida) // output flag InLow for end of total count
);


//Lógica Combinacional
always@(*) // inPWM, outPWM, flagSubida, flagBajada)//Maquina de estados que traduce los flags en la senal
begin
	if( inPWM >= 8'd250 )
		salidaFutura <= 1'b1; // saturacion por arriba
	
	else if( flagSubida == 1'b0 ) // flags are active in low
			salidaFutura <= 1'b1;
	
	else if( flagBajada == 1'b0 )
			salidaFutura <= 1'b0;
	
	else
			salidaFutura <= salidaActual;
end


// Lógica secuencial MAQUINA DE ESTADOS
always @(posedge clock, posedge reset)
begin
	if (reset == 1'b1)
		salidaActual <= 1'b0;
	else
		salidaActual <= salidaFutura; // actual es la futura anterior
end


assign outPWM = salidaActual; // Asignacion de la salida


endmodule
