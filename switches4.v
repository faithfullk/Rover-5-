`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2021 03:47:42 PM
// Design Name: 
// Module Name: Main_Module_Color_Sensor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Main_Module_Color_Sensor(

    input clock,
    input colorsignal, //
    output reg [3:0] an,
    output reg [6:0] seg,
    output reg DRed,
    output reg DBlue,
    output reg DGreen,
    output s0,
    output s1,
    output S2,
    output S3

    );
    
    Color_Sensor u2(
    .clock(clock),
    .TopColor(TopColor),
    .colorsignal(colorsignal),
    .s2(S2),
    .s3(S3),
    .indicator(indicator)
    );
    
    frequency freq(
    .colorsignal(colorsignal),
    .clock(clock));
    
    
    //20% scaling frequency
    assign s0 = 1;
    assign s1 = 0;
    
    wire [1:0] LED_activating_counter;  //refresh

    
always @(*) begin
      case(LED_activating_counter)
        2'b00: begin
            an = 4'b0111; // activate LED1 and Deactivate LED2, LED3, LED4
            if (TopColor ) begin//red
                seg = 7'b0101111; // displays r for RED: 0101111
                DRed = 1;//red diode
                DBlue = 0;
                DGreen = 0;
                end
            else if (TopColor == 1) begin//green
                seg = 7'b0000010; //displays G for GREEN: 0000010
                DRed = 0;
                DBlue = 0;
                DGreen = 1;//green diode
                end
            else if (TopColor == 2)begin//blue
                seg = 7'b0000011; //displays B for BLUE: 0000011
                DRed = 0;
                DBlue = 1;//blue diode
                DGreen = 0;
                end
            else begin
                seg = 7'b1000000;//no color detected //displays 
                DRed = 0;
                DBlue = 0;
                DGreen = 0;
                end
            end
            
            /*2'b10: begin
            Anode_Activate = 4'b1101; // activate LED2 and Deactivate LED1, LED3, LED4
            if (amp == 0)
            LED_out = 7'b1110001; //makes second LED 0
            else
            LED_out = 7'b0100000;
            end
            */
            2'b11: begin
            an = 4'b1110; // activate LED2 and Deactivate LED1, LED3, LED4
            seg = 7'b1001111; //makes second LED 0
            end
            
        endcase
    
    //==================== 7 Segment Display: ====================    
      // This wire is driven by the 2 MSBs of the counter. We'll use it to
     // refresh the display.
//==================== ^7 Segment Display:^ ====================  
    
    end
endmodule