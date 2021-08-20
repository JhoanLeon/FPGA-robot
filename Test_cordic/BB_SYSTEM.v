//=======================================================
//  MODULE Definition
//=======================================================
module BB_SYSTEM (

/// Inputs
BB_SYSTEM_CLOCK_50,
BB_SYSTEM_Reset_InHigh,

BB_SYSTEM_init_InHigh, // signal to load data on system  
BB_SYSTEM_theta_i_InBus, // angle to compute in notation 17b |S|IIIIIIII|FFFFFFFF|

BB_SYSTEM_valid_In,  // input in high for iniciate iterations of algorithm

/// Outputs
BB_SYSTEM_valid_Out, // flag that indicates final result of iterations

BB_SYSTEM_xout_OutBus, // cos(theta_i) in notation 17b |S|I|FFFFFFFFFFFFFFF|
BB_SYSTEM_yout_OutBus  // sin(theta_i) in notation 17b |S|I|FFFFFFFFFFFFFFF|

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter XY_BITS = 16;
parameter THETA_BITS = 16;
parameter CORDIC_1 = 17'd19899;

//=======================================================
//  PORT declarations
//=======================================================
input BB_SYSTEM_CLOCK_50;
input BB_SYSTEM_Reset_InHigh;

input BB_SYSTEM_init_InHigh;
input [THETA_BITS:0] BB_SYSTEM_theta_i_InBus;

input BB_SYSTEM_valid_In;
output BB_SYSTEM_valid_Out;

output [XY_BITS:0] BB_SYSTEM_xout_OutBus;
output [XY_BITS:0] BB_SYSTEM_yout_OutBus;

//=======================================================
//  STRUCTURAL coding
//=======================================================
cordic cordic_u0(

  .clk(BB_SYSTEM_CLOCK_50),
  .rst(BB_SYSTEM_Reset_InHigh),
  .init(BB_SYSTEM_init_InHigh),
  .x_i(CORDIC_1), // constant parameter to obtain sin and cos
  .y_i(17'd0), // equal to zero for function of sin and cos
  .theta_i(BB_SYSTEM_theta_i_InBus), //angle in notation 17b [0°-90°]
  
  .valid_in(BB_SYSTEM_valid_In),
  
  .valid_out(BB_SYSTEM_valid_Out),
  
  .x_o(BB_SYSTEM_xout_OutBus), //output cos(theta_i)
  .y_o(BB_SYSTEM_yout_OutBus), //output sin(theta_i)
  .theta_o()

);

endmodule
