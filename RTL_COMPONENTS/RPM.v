//****************************************
// Code taken from: https://github.com/FranzLuepke/Robocol_Traction_HW  
// Modified by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//Este modulo calcula las rpms de un motor basado en los pulsos contados del encoder 
//Los pulsos del encoder se cuentan en intervales de 350ms, la salida está RPMs

module RPM(Prescaler_clk, pulsos, RPM_Medidos);


input Prescaler_clk; //Clock escalado a 320ms de periodo
input [7:0] pulsos; //Cuenta de pulsos del encoder en este intervalo
output [7:0] RPM_Medidos; //Velocidad en RPM

reg [31:0] conversion = 0;

//LOGICA SECUENCIAL
always @(posedge Prescaler_clk)
begin
  conversion <= (pulsos * 228571)/100000; // aplica la conversión de pulsos/tick a rev/min
end

assign RPM_Medidos = conversion[7:0];

endmodule
