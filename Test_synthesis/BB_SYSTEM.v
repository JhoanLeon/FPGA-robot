
//=======================================================
//  MODULE Definition
//=======================================================

module BB_SYSTEM(

//////////// INPUTS ///////////
	
BB_SYSTEM_CLOCK_50,	  //Clock de todo el sistema 50MHz
BB_SYSTEM_RESET_InHigh,
BB_SYSTEM_START_InHigh,

//////////// OUTPUTS //////////

LED

);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================

input wire BB_SYSTEM_CLOCK_50;
input wire BB_SYSTEM_RESET_InHigh;
input wire BB_SYSTEM_START_InHigh;

output[7:0] LED;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire start_signal_wire; 
wire [31:0] global_vx;

//=======================================================
//  Structural coding
//=======================================================

SI_DEBOUNCE DB_START_u0	//Antirrebote para el botón de start
(

.SI_DEBOUNCE1_CLOCK_50(BB_SYSTEM_CLOCK_50), 
.SI_DEBOUNCE1_RESET_InLow(~BB_SYSTEM_RESET_InHigh), 
.SI_DEBOUNCE1_button_In(BB_SYSTEM_START_InHigh),
.SI_DEBOUNCE1_button_Out(start_signal_wire)	

);


SC_GLOBAL_VELOCITY Global_Velocity_u0 
(
	//////////// INPUTS //////////
.SC_GLOBAL_VELOCITY_CLOCK_50(BB_SYSTEM_CLOCK_50),
.SC_GLOBAL_VELOCITY_RESET_InHigh(BB_SYSTEM_RESET_InHigh),
	
.SC_GLOBAL_VELOCITY_READY_In(start_signal_wire), // input flag to start operations

.SC_GLOBAL_VELOCITY_VX_LOCAL_InBus({1'b1,16'd10,15'b0}), // local velocity in x direction [m/s]
.SC_GLOBAL_VELOCITY_VY_LOCAL_InBus({1'b1,16'd5,15'b0}), // local velocity in y direction [m/s]
.SC_GLOBAL_VELOCITY_WZ_LOCAL_InBus(32'b0), // local velocity in z direction [rad/s]
.SC_GLOBAL_VELOCITY_THETA_InBus({1'b0,16'd45,15'b0}), // theta angle to compute in notation 32b |S|IIIIIIIIIIIIIIII|FFFFFFFFFFFFFFF| [0°-90°]

	//////////// OUTPUTS //////////
.SC_GLOBAL_VELOCITY_DONE_Out(), // output flag to indicate complete results
.SC_GLOBAL_VELOCITY_VX_GLOBAL_OutBus(global_vx),
.SC_GLOBAL_VELOCITY_VY_GLOBAL_OutBus(),
.SC_GLOBAL_VELOCITY_WZ_GLOBAL_OutBus()
	
);

assign LED[7] = global_vx[31];
assign LED[6:2] = global_vx[19:15];
assign LED[1:0] = global_vx[14:13];

endmodule
