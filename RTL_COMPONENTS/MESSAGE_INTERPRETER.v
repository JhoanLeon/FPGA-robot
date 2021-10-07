//****************************************
// Made by: Jhoan Esteban León - je.leon.e@outlook.com
//****************************************

//=======================================================
//  MODULE Definition
//=======================================================

module MESSAGE_INTERPRETER
(
	//////////// INPUTS //////////
	MESSAGE_INTERPRETER_CLOCK_50,
	MESSAGE_INTERPRETER_RESET_InHigh,
	
	MESSAGE_INTERPRETER_FLAGDATAIN_In, // InHigh
	MESSAGE_INTERPRETER_DATAIN_InBus,
	
	MESSAGE_INTERPRETER_POSX_InBus,
	MESSAGE_INTERPRETER_POSY_InBus,
	MESSAGE_INTERPRETER_THETA_InBus,
	
	MESSAGE_INTERPRETER_RPM1_InBus,
	MESSAGE_INTERPRETER_RPM2_InBus,
	MESSAGE_INTERPRETER_RPM3_InBus,
	MESSAGE_INTERPRETER_RPM4_InBus,
	
	MESSAGE_INTERPRETER_DIST1_InBus,
	MESSAGE_INTERPRETER_DIST2_InBus,
	MESSAGE_INTERPRETER_DIST3_InBus,
	MESSAGE_INTERPRETER_DIST4_InBus,
	
	MESSAGE_INTERPRETER_BEHAVIOR_InBus,
	
	MESSAGE_INTERPRETER_IMUX_InBus,
	MESSAGE_INTERPRETER_IMUY_InBus,
	MESSAGE_INTERPRETER_IMUZ_InBus,
	
	//////////// OUTPUTS ////////// 
	MESSAGE_INTERPRETER_DATAOUT_OutBus,
	
	MESSAGE_INTERPRETER_WAYSELECT_OutBus,
	MESSAGE_INTERPRETER_STOPSIGNAL_OutLow,
	MESSAGE_INTERPRETER_BEGINSIGNAL_OutLow

);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter INT_WIDTH = 8;
parameter N_WIDTH = 32;
parameter Q_WIDTH = 15;

//=======================================================
//  PORT declarations
//=======================================================
input	MESSAGE_INTERPRETER_CLOCK_50;
input	MESSAGE_INTERPRETER_RESET_InHigh;
	
input	MESSAGE_INTERPRETER_FLAGDATAIN_In;
input [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_DATAIN_InBus;
	
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_POSX_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_POSY_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_THETA_InBus;
	
input [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_RPM1_InBus;
input [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_RPM2_InBus;
input [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_RPM3_InBus;
input [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_RPM4_InBus;
	
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_DIST1_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_DIST2_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_DIST3_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_DIST4_InBus;
	
input [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_BEHAVIOR_InBus;
	
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_IMUX_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_IMUY_InBus;
input [N_WIDTH-1:0]	MESSAGE_INTERPRETER_IMUZ_InBus;
	
	//////////// OUTPUTS ////////// 
output [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_DATAOUT_OutBus;
	
output [2:0]	MESSAGE_INTERPRETER_WAYSELECT_OutBus;
output MESSAGE_INTERPRETER_STOPSIGNAL_OutLow;
output MESSAGE_INTERPRETER_BEGINSIGNAL_OutLow;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [INT_WIDTH-1:0] current_data;
reg [INT_WIDTH-1:0] next_data;

reg [2:0] current_select;
reg [2:0] next_select; 

reg current_stop;
reg next_stop;

reg current_begin;
reg next_begin;

//=======================================================
//  STRUCTURAL coding
//=======================================================

///////////////// algorithm
/*
first receives the 10 commands, and interprets them properly to output signals



*/

assign MESSAGE_INTERPRETER_WAYSELECT_OutBus = current_select;
assign MESSAGE_INTERPRETER_STOPSIGNAL_OutLow = current_stop;
assign MESSAGE_INTERPRETER_BEGINSIGNAL_OutLow = current_begin;
assign MESSAGE_INTERPRETER_DATAOUT_OutBus = current_data;

always @(*)
begin
	if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000001) // waypoint 1
		begin
			next_select = 3'b000; // origin
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000010) // waypoint 2
		begin
			next_select = 3'b001; // 2 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000011) // waypoint 3
		begin
			next_select = 3'b010; // 3 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000100) // waypoint 4
		begin
			next_select = 3'b011; // 4 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000101) // waypoint 5
		begin
			next_select = 3'b100; // 5 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000110) // waypoint 6
		begin
			next_select = 3'b101; // 6 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00000111) // waypoint 7
		begin
			next_select = 3'b110; // 7 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00001000) // waypoint 8
		begin
			next_select = 3'b111; // 8 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end

	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00001001) // stop
		begin
			next_select = 3'b000; 
			next_stop = 1'b0; // stop signal active in low
			next_begin = 1'b1;
			next_data = 8'b00000000;
		end
	
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b00001010) // begin
		begin
			next_select = 3'b000;
			next_stop = 1'b1;
			next_begin = 1'b0; // begin signal active in low
			next_data = 8'b00000000;
		end
	
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b01110000) // 'p' for position
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin; // begin signal active in low
			next_data = MESSAGE_INTERPRETER_POSX_InBus[22:15]; // first data
		end	

	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b01110010) // 'r' for rpms
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin; // begin signal active in low
			next_data = MESSAGE_INTERPRETER_RPM1_InBus; // first data to send
		end		

	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b01100100) // 'd' for distances
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin; // begin signal active in low
			next_data = MESSAGE_INTERPRETER_DIST1_InBus[22:15]; // first data to send
		end			

	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b01100010) // 'b' for behavior
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin; // begin signal active in low
			next_data = MESSAGE_INTERPRETER_BEHAVIOR_InBus; // only one data, this is correct
		end	
	
	else if (MESSAGE_INTERPRETER_DATAIN_InBus == 8'b01101101) // 'm' for imu
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin; // begin signal active in low
			next_data = MESSAGE_INTERPRETER_IMUX_InBus[22:15]; // first data to send
		end			
	
	else
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_data = current_data;
		end	
end


always @(posedge MESSAGE_INTERPRETER_CLOCK_50, posedge MESSAGE_INTERPRETER_RESET_InHigh)
begin
	if (MESSAGE_INTERPRETER_RESET_InHigh == 1'b1)
		begin
			current_select = 3'b000; // origin
			current_stop = 1'b0; // begin in stop 
			current_begin = 1'b1;
			current_data = 8'b00000000; // no data to send
		end
	else
		begin
			current_select <= next_select;
			current_stop <= next_stop;
			current_begin <= next_begin;
			current_data <= next_data;
		end
end
		
		
endmodule
