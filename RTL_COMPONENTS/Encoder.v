//****************************************
// Code taken from: https://github.com/FranzLuepke/Robocol_Traction_HW  
// Modified by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//Modulo que cuenta flancos en un encoder de cuadratura
//El giro hacia un lado del encoder suma a la variable Count, hacia el otro lado le resta

module Encoder(clk, tick, ChannelA, ChannelB, Count, Dir);

input clk, tick, ChannelA, ChannelB;
output [7:0] Count;
output Dir; // 0 = cw - 1 = ccw

reg [7:0] counter = 0;
reg [2:0] ChannelA_delayed, ChannelB_delayed;

always @(posedge clk) ChannelA_delayed <= {ChannelA_delayed[1:0], ChannelA};	//Seniales de los encoders retrasadas en el tiempo (1 muestreo)
always @(posedge clk) ChannelB_delayed <= {ChannelB_delayed[1:0], ChannelB};	//Seniales de los encoders retrasadas en el tiempo (1 muestreo)

wire Count_enable = ChannelA_delayed[1] ^ ChannelA_delayed[2] ^ ChannelB_delayed[1] ^ ChannelB_delayed[2];//XOR entre todas las seniales

assign Dir = ChannelA_delayed[1] ^ ChannelB_delayed[2];	//Direccion del giro (otro XOR)

//La logica de los XOR puede ser vista en la tabla de verdad de los encoders de cuadratura
//Las senales retrasadas ayudan a disminuir el ruido en la cuenta


always @(posedge clk)
begin
	if (tick == 1'b0) // tick of counter at 167.77ms to reset the count of the pulses
		counter <= 0;
	else if(Count_enable) // Cuenta cuando se debe
		counter <= counter + 1'b1;
end

assign Count = {1'b0, counter[7:1]};

endmodule
