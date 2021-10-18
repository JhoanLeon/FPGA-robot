
//=======================================================
//  MODULE Definition
//=======================================================

module SC_REGACC #(parameter REGACC_DATAWIDTH=32, parameter INITIAL_VALUE=32'b0)
(
	//////////// OUTPUTS //////////
	SC_REGACC_data_OutBUS,
	//////////// INPUTS //////////
	SC_REGACC_CLOCK_50,
	SC_REGACC_RESET_InHigh,
	SC_REGACC_clear_InLow, 
	SC_REGACC_load_InLow, 
	SC_REGACC_data_InBUS
);

//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output	[REGACC_DATAWIDTH-1:0]	SC_REGACC_data_OutBUS;
input		SC_REGACC_CLOCK_50;
input		SC_REGACC_RESET_InHigh;
input		SC_REGACC_clear_InLow;
input		SC_REGACC_load_InLow;	
input		[REGACC_DATAWIDTH-1:0]	SC_REGACC_data_InBUS;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [REGACC_DATAWIDTH-1:0] REGACC_Register = INITIAL_VALUE;
reg [REGACC_DATAWIDTH-1:0] REGACC_Signal = INITIAL_VALUE;

//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_REGACC_clear_InLow == 1'b0)
		REGACC_Signal = INITIAL_VALUE;
	else if (SC_REGACC_load_InLow == 1'b0)
		REGACC_Signal = SC_REGACC_data_InBUS;
	else
		REGACC_Signal = REGACC_Register;
	end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_REGACC_CLOCK_50, posedge SC_REGACC_RESET_InHigh)
begin
	if (SC_REGACC_RESET_InHigh == 1'b1)
		REGACC_Register <= INITIAL_VALUE;
	else
		REGACC_Register <= REGACC_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_REGACC_data_OutBUS = REGACC_Register;

endmodule
