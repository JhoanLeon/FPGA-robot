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
	
	//////////// OUTPUTS ////////// 
	MESSAGE_INTERPRETER_DATAOUT_OutBus,
	
	MESSAGE_INTERPRETER_NEWSIGNAL_OutBus,
	
	MESSAGE_INTERPRETER_WAYSELECT_OutBus,
	MESSAGE_INTERPRETER_STOPSIGNAL_OutLow,
	MESSAGE_INTERPRETER_BEGINSIGNAL_OutLow
);

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter INT_WIDTH = 8;
parameter N_WIDTH = 17;
parameter Q_WIDTH = 8;

localparam waypoint1 = 8'd1;
localparam waypoint2 = 8'd2;
localparam waypoint3 = 8'd3;
localparam waypoint4 = 8'd4;
localparam waypoint5 = 8'd5;
localparam waypoint6 = 8'd6;
localparam waypoint7 = 8'd7;
localparam waypoint8 = 8'd8;
localparam stop_signal = 8'd9;
localparam begin_signal = 8'd10;

localparam x_i = 8'd20;
localparam y_i = 8'd21;
localparam theta_i = 8'd22;

localparam rpm_1 = 8'd30;
localparam rpm_2 = 8'd31;
localparam rpm_3 = 8'd32;
localparam rpm_4 = 8'd33;

localparam d_1 = 8'd40;
localparam d_2 = 8'd41;
localparam d_3 = 8'd42;
localparam d_4 = 8'd43;

localparam behavior = 8'd50;

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
	
	//////////// OUTPUTS ////////// 
output [INT_WIDTH-1:0]	MESSAGE_INTERPRETER_DATAOUT_OutBus;
	
output MESSAGE_INTERPRETER_NEWSIGNAL_OutBus;	
	
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

reg current_signal;
reg next_signal;

//=======================================================
//  STRUCTURAL coding
//=======================================================

//always @(MESSAGE_INTERPRETER_FLAGDATAIN_In, MESSAGE_INTERPRETER_DATAIN_InBus)
always @(*)
begin
	if (MESSAGE_INTERPRETER_FLAGDATAIN_In == 1'b1)
	begin
	
	case (MESSAGE_INTERPRETER_DATAIN_InBus)
	
	waypoint1: // waypoint 1
		begin
			next_select = 3'b000; // origin waypoint
			next_stop = 1'b1; // no stop
			next_begin = 1'b1; // no begin
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint2: // waypoint 2
		begin
			next_select = 3'b001; // 2 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint3: // waypoint 3
		begin
			next_select = 3'b010; // 3 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint4: // waypoint 4
		begin
			next_select = 3'b011; // 4 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint5: // waypoint 5
		begin
			next_select = 3'b100; // 5 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint6: // waypoint 6
		begin
			next_select = 3'b101; // 6 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint7: // waypoint 7
		begin
			next_select = 3'b110; // 7 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
		
	waypoint8: // waypoint 8
		begin
			next_select = 3'b111; // 8 channel mux
			next_stop = 1'b1;
			next_begin = 1'b1;
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end

	stop_signal: // stop
		begin
			next_select = current_select; // continue with the same waypoint
			next_stop = 1'b0; // stop signal active in low
			next_begin = 1'b1;
			next_signal = 1'b1; // no new signal
			next_data = current_data;
		end
	
	begin_signal: // begin
		begin
			next_select = 3'b000; // select waypoint origin
			next_stop = 1'b1;
			next_begin = 1'b0; // begin signal active in low
			next_signal = 1'b0; // new signal
			next_data = current_data;
		end
	
	
	x_i: // '20' for x_i
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_POSX_InBus[15:8];// uint8
		end	
		
	y_i: // '21' for y_i
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_POSY_InBus[15:8];// uint8
		end	
		
	theta_i: // '22' for theta_i
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_THETA_InBus[15:8]; // data, 8b u_int
		end	

		
	rpm_1: // '30' for rpm_1
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_RPM1_InBus; // data, 8b u_int
		end		

	rpm_2: // '31' for rpm_2
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_RPM2_InBus; // data, 8b u_int
		end		
		
	rpm_3: // '32' for rpm_3
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_RPM3_InBus; // data, 8b u_int
		end		
		
	rpm_4: // '33' for rpm_4
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_RPM4_InBus; // data, 8b u_int
		end		
		
		
	d_1: // '40' for dist_1
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_DIST1_InBus[15:8]; // data, 8b u_int
		end			

	d_2: // '41' for dist_2
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_DIST2_InBus[15:8]; // data, 8b u_int
		end	

	d_3: // '42' for dist_3
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_DIST3_InBus[15:8]; // data, 8b u_int
		end	

	d_4: // '43' for dist_4
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_DIST4_InBus[15:8]; // data, 8b u_int
		end			
		
		
	behavior: // '50' for behavior
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = 1'b1; // no new signal
			next_data = MESSAGE_INTERPRETER_BEHAVIOR_InBus; // data, 1 byte to decode behavior
		end	
		
	
	default:
		begin
			next_select = current_select;
			next_stop = current_stop;
			next_begin = current_begin;
			next_signal = current_signal;
			next_data = current_data;
		end	
	endcase	
	
	end
	
	else
	begin
		next_select = current_select;
		next_stop = current_stop;
		next_begin = current_begin;
		next_signal = current_signal;
		next_data = current_data;
	end
	
end


always @(posedge MESSAGE_INTERPRETER_CLOCK_50, posedge MESSAGE_INTERPRETER_RESET_InHigh)
begin
	if (MESSAGE_INTERPRETER_RESET_InHigh == 1'b1)
		begin
			current_select = 3'b000; // origin
			current_stop = 1'b1; 
			current_begin = 1'b1;
			current_signal = 1'b1; // no new signal
			current_data = 8'b00000000; // no data to send
		end
	else
		begin
			current_select <= next_select;
			current_stop <= next_stop;
			current_begin <= next_begin;
			current_signal <= next_signal;
			current_data <= next_data;
		end
end


assign MESSAGE_INTERPRETER_WAYSELECT_OutBus = current_select;
assign MESSAGE_INTERPRETER_STOPSIGNAL_OutLow = current_stop;
assign MESSAGE_INTERPRETER_BEGINSIGNAL_OutLow = current_begin;
assign MESSAGE_INTERPRETER_DATAOUT_OutBus = current_data;

assign MESSAGE_INTERPRETER_NEWSIGNAL_OutBus = current_signal; // current_select ^ next_select;
		
endmodule
