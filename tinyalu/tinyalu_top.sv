/*------------------------------------------------------------------------------
 * File          : tinyalu_top.sv
 * Project       : formal_synthesis
 * Author        : eldon
 * Creation date : Nov 11, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

`timescale 1 ns / 1 ps

`ifndef SYNTHESIS

module top ();

logic clk;
logic reset_n;
logic [7:0] A,B;
opcode op;
logic       start;
wire        done;
wire [15:0] result;

initial begin
	reset_n = '0;
	#35ns;
	reset_n = '1;
end

initial begin
	clk = '0;
	forever begin
		#10ns;
		clk = ~clk;
	end
end

initial begin
	#1000ns;
	$finish();
end

always @(posedge clk) begin
	#1 start <= $urandom;
	#1 A <= $urandom;
	#1 B <= $urandom;
	#1 op <= $urandom;
end

tinyalu tinyalu_inst (.*);

endmodule

`endif