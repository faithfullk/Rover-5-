`timescale 1ns / 1ps
//Rice Rodriguez Frequency counter
module frequency(
     // The inputs are...
     input clock,          // 100 MHz clock signal from the Basys3 oscillator
     input enable,       // Enable bit to turn this module ON from another module //basically flag
     input colorsignal, // The signal we're counting the frequency of //IN for Rice's source
     // The outputs are...
     output reg [32:0] freq = 33'b0,    // The frequency we found for the input signal
     output reg done_count = 0 // Done flag so that we can tell that this module has finished counting the frequency of the signal

          
      ); 
      
     // Create a register for the clock signal edge counter. This register will
     // hold the number of positive edges of the clock we've seen. We will use
     // this to know how much time has passed since we started counting our signal.
     reg[32:0] clock_edge_count = 33'b0;
     // Create a register for the signal edge counter. This register will hold the
     // number of positive edges of the input signal we're trying to find the
     // frequency of. We will use this to count how many signal cycles have passed.
     reg [32:0] signal_edge_count = 33'b0;
     // Create a register for the D flip-flop (D-FF). This is the output Q of the
     // D-FF. We're using this to store the state of the input signal (high or low).
     // We do this so we can compare the last known state of the input signal to the
     // current state of the signal.
     reg last_state = 0; //last

     // 100 million / 16 = 6250k
     localparam max = 'd6250000;

     // Flip-flop stores last value in register. We'll be using this to detect
     // the positive edges of the incoming signal
     always @(posedge clock)
          last_state <= colorsignal;

     always @ (posedge clock)
     begin
     done_count = 0;
          if(~enable) begin //when the frequency sub module is not called, make everything ZERO       
               freq = 0;
               signal_edge_count = 0;
               clock_edge_count = 0;
               done_count = 0;
          end
          else begin
               if (clock_edge_count < max)
               begin
                    clock_edge_count <= clock_edge_count + 1;
                    // If value was 0 and is now 1, positive edge detected. Use
                    // this instead of always @ posedge var to prevent
                    // unnecessarily using the clock
                    if(~last_state & colorsignal)
                         signal_edge_count <= signal_edge_count + 1;
               end
               else begin
                    // Reset the frequency variable
                    freq = 0;
                    // Multiply the value counted so far by 16 because it's only
                    // been 1/16th of a second so far
                    freq = signal_edge_count;
                    // Reset the edge count
                    signal_edge_count = 0;
                    // Reset the 1/16th second counter
                    clock_edge_count = 0;
                    // We're done, so set the flag on
                    done_count = 1;
               end
               end
               end
endmodule