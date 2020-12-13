Can Formal Outsmart Synthesis: Improving Synthesis Quality of Results through Formal Methods

These are the examples for the paper above.

The examples are:

    tinyalu
    pattern

They are run using the following commands:

     > make tinyalu
     > make pattern

for each example. Each example has a file list such as "tiny/tinyalu.filelist".

tinyalu

	shows removing specific operands from a CPU and then getting a report what logic to cull and what signals can be tied high or low.

pattern

	shows a system that buffers inputs and then based on input patterns makes some decisions. you can write sequential assertions to influence output.
