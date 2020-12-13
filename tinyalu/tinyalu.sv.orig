`timescale 1 ns / 1 ps

`ifndef OP_CODES
`include "tinyalu_typedef.sv"
`endif

module tinyalu (
	input  [7:0]  A,
	input  [7:0]  B,
	input  [2:0]  op,
	input         clk,
	input         reset_n,
	input         start,
	output        done,
	output [15:0] result
);

wire [15:0] 		result_aax, result_mult;
wire 				start_single, start_mult;
wire 				done_aax, done_mult;

assign start_single = start && ((op == OP_AND) || (op == OP_ADD) || (op == OP_XOR));
assign start_mult   = start && (op == OP_MULT);

single_cycle and_add_xor (
	.A,
	.B,
	.op,
	.clk,
	.reset_n,
	.start (start_single),
	.done  (done_aax    ),
	.result(result_aax  )
);

three_cycle mult (
	.A,
	.B,
	.op,
	.clk,
	.reset_n,
	.start (start_mult ),
	.done  (done_mult  ),
	.result(result_mult)
);


assign done = (op == OP_MULT) ? done_mult : done_aax;
assign result = (op == OP_MULT) ? result_mult :  result_aax;

endmodule


module single_cycle (
	input        [7:0]  A,
	input        [7:0]  B,
	input        [2:0]  op,
	input               clk,
	input               reset_n,
	input               start,
	output logic        done,
	output logic [15:0] result
);

always @(posedge clk) begin
	if (!reset_n) begin
		result <= '0;
	end else begin
		case(op)
			OP_ADD : result <= A + B;
			OP_AND : result <= A & B;
			OP_XOR : result <= A ^ B;
		endcase // case (op)
	end
end

always @(posedge clk) begin
	if (!reset_n) begin
		done <= 1'b0;
	end else begin
		done <=  ((start == 1'b1) && (op != OP_NULL));
	end
end
endmodule : single_cycle


module three_cycle (
	input        [7:0]  A,
	input        [7:0]  B,
	input        [2:0]  op,
	input               clk,
	input               reset_n,
	input               start,
	output logic        done,
	output logic [15:0] result
);

logic [7:0] 	a_int, b_int;
logic [15:0]	mult1, mult2;
logic			done1, done2, done3;

always @(posedge clk)
	if (!reset_n) begin
		done  <= 1'b0;
		done3 <= 1'b0;
		done2 <= 1'b0;
		done1 <= 1'b0;
		a_int <= '0;
		b_int <= '0;
		mult1 <= '0;
		mult2 <= '0;
		result<= '0;
	end else begin
		if (start) begin
			a_int  <= A;
			b_int  <= B;
			mult1  <= a_int * b_int;
			mult2  <= mult1;
			result <= mult2;
			done3  <= start & !done;
			done2  <= done3 & !done;
			done1  <= done2 & !done;
			done   <= done1 & !done;
		end
	end

endmodule : three_cycle

