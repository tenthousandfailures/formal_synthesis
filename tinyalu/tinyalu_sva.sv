/*------------------------------------------------------------------------------
 * File          : tinyalu_sva.sv
 * Project       : formal_synthesis
 * Author        : eldon
 * Creation date : Nov 10, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

`ifndef SYNTHESIS

module tinyalu_sva #() (
	input [7:0]  A,
	input [7:0]  B,
	input [2:0]  op,
	input 	     clk,
	input 	     reset_n,
	input 	     start,
	input 	     done,
	input [15:0] result
	);

always @(*) begin
	only_single_cycle_ops : assume (op != OP_MULT);
end

always @(*) begin
	only_mult_ops : assume (op == OP_MULT);
end
   
always @(*) begin
	only_even_input_A : assume (!(A[0]));
end

always @(*) begin
	only_even_input_B : assume (!(B[0]));
end

always @(*) begin
	only_odd_input_A : assume (A[0]);
end

always @(*) begin
	only_odd_input_B : assume (B[0]);
end
   
always @(*) begin
	only_add_ops : assume (op == OP_ADD);
end

always @(*) begin
	only_xor_ops : assume (op == OP_XOR);
end

always @(*) begin
	only_and_ops : assume (op == OP_AND);
end

endmodule

bind tinyalu tinyalu_sva #() i_tinyalu_bind (.*);

`endif
