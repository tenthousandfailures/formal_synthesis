/*------------------------------------------------------------------------------
 * File          : top.sv
 * Project       : formal_synthesis
 * Author        : eldon
 * Creation date : Nov 8, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
`timescale 1 ns / 1 ps

`ifndef SYNTHESIS

module top #(WIDTH=4, DEPTH=4) ();

	logic clk;
	logic reset_n;
	logic [WIDTH-1:0] data;
	wire [WIDTH-1:0] out;
	wire [$clog2(DEPTH):0] streak;
	wire unsigned [WIDTH:0] sum;
	wire integer unsigned prod;
	
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
		#1 data <= $urandom;
		// #1 data <= $urandom[WIDTH-1:0];
	end
	
	pattern pattern_inst(.*);
		
endmodule

`endif

module pattern #(WIDTH=4, DEPTH=4) (
	input	logic clk,
	input 	logic reset_n,
	input	logic [WIDTH-1:0] data,
	output  logic [WIDTH-1:0] out,
	output  logic unsigned [$clog2(DEPTH):0] streak,
	output  logic unsigned [WIDTH:0] sum,
	output 	integer unsigned prod
);

	logic [WIDTH-1:0] buffer [DEPTH-1:0];
	logic start0, start1;
		
	assign out = buffer[DEPTH-1];
	
	always @(posedge clk) begin
		if (!reset_n) begin
			sum <= '0;
			prod <= '0;
		end else begin
			if (streak > 4) begin
				$display("a bunch of streak > 4 logic");
			end
		
			if ((streak > 3) && (buffer[0] == 'h3)) begin
				$display("a bunch of streak > 3 and buffer[0] == 'h3");
			end
		
			if ((streak > 0) && (buffer[0] == 'h1)) begin
				$display("a bunch of streak > 0 and buffer[0] == 'h1");
			end
		
			sum <= buffer[0] + buffer[1];
			prod <= buffer[0] * buffer[1];
		
		end
		
	end
	
	always @(posedge clk) begin
		if (!reset_n) begin
			streak <= '0;
			start0 <= 1'h0;
			start1 <= 1'h0;
		end else begin
			if (start1 && (buffer[0] == buffer[1])) begin
				if (streak < (2 ** DEPTH) - 1) begin
					streak <= streak + 1;
				end
			end else begin
				start0 <= 1'h1;
				// need to register 2 cycles of valid data before you can compare
				if (start0 == 1'h1) begin
					start1 <= 1'h1;
				end
				streak <= '0;
			end
		end
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			reset_condition: foreach (buffer[N]) begin
				buffer[N] <= '0;
			end
		end else begin
			shift_in_condition: foreach (buffer[N]) begin
				if (N == 0) begin
					buffer[0] <= data;
					buffer[N+1] <= buffer[N];
				end else if (N < DEPTH) begin
					buffer[N+1] <= buffer[N];
					// $display("N value is %d", N);
				end
			end
		end
	end

endmodule

`ifndef SYNTHESIS

module pattern_sva #(WIDTH=4, DEPTH=4) (
	input	logic clk,
	input 	logic reset_n,
	input 	logic [WIDTH-1:0] buffer [DEPTH-1:0],
	input	logic [WIDTH-1:0] data,
	input  	logic unsigned [$clog2(DEPTH):0] streak
);

   	s_lte_4 : assume property ( @(posedge clk) disable iff(!reset_n) (streak <= 4));
	s_gt_3_b0_eq_3 : assume property ( @(posedge clk) disable iff(!reset_n) ((streak <= 3) && (buffer[0] != 'h3)));
	s_gt_0_b0_eq_3 : assume property ( @(posedge clk) disable iff(!reset_n) ((streak == 0) && (buffer[0] == 'h1)));

	even_only : assume property ( @(posedge clk) disable iff(!reset_n) (data[0] == 0));
	
	even_odd_p1 : assume property ( @(posedge clk) disable iff(!reset_n) (data[0] |=> ~data[0]));
	odd_even_p1 : assume property ( @(posedge clk) disable iff(!reset_n) (~data[0] |=> data[0]));

endmodule

bind pattern pattern_sva #(.WIDTH(WIDTH), .DEPTH(DEPTH)) i_pattern_bind (.*);

`endif
