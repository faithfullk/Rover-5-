`timescale 1ns / 1ps
module Color_Sensor(
  // The inputs are...
     input clock,          // 100 MHz clock signal from the Basys3 oscillator
     input colorsignal,   // The signal we're counting the frequency of
  // The outputs are...
     output reg [2:0] indicator = 3'b000, //It's a variable that just states which filter or state the color sensor is at
     
    
//     output reg [31:0] Red = 32'b0,
//     output reg [31:0] Green = 32'b0,
//     output reg [31:0] Blue = 32'b0,
     
     output reg [2:0] TopColor,
//     output reg enable = 0, //To turn on the sub module
     output reg s3,
     output reg s2
    ); 
    
//    reg s2 = 0;
//    assign S2 = s2;
    
//    reg s3 = 0;
//    assign S3 = s3;
    
      reg [32:0] rfreq = 33'b0;
      reg [32:0] bfreq = 33'b0;
      reg [32:0] gfreq = 33'b0;
      reg [32:0] cfreq = 33'b0;
      reg enable = 0;
    
    
    wire [19:0] freq;
    wire done_count;
     
    frequency u1(
        .clock(clock),
        .colorsignal(colorsignal),
        .enable(enable),
        .done_count(done_count),
        .freq(freq[19:0])
    );

    always @ (posedge clock)
        begin
            case (indicator)
                  //RED FILTER: 
                3'b000: //red: S2 = L; S3 = L
                begin
                    s2 = 0;
                    s3 = 0;
                    enable = 1; //enable is turning  on the sub module
                    if(done_count == 1)
                    begin
//                        Red = Red + 1;
                        rfreq = freq*21;
                        enable = 0;
                        indicator = 3'b001; //goes to the next state
                    end  
                end
 //              blue FILTER
                3'b001: //blue
                begin //blue
                    s2 = 0;
                    s3 = 1;
                    enable = 1;
                    if(done_count == 1)
                    begin
//                        Blue = Blue + 1;
                        bfreq = freq*30; //blue frequency is assigned to the frequency of the signal
                        enable = 0;
                        indicator = 3'b010;
                    end   
                end        
     //GREEN FILTER          
                3'b010: //green
                begin
                    s2 = 1;
                    s3 = 1;
                    enable = 1;
                    if(done_count == 1)
                    begin
                        //Green = Green + 1;
                        gfreq = freq*36;
                        enable = 0;
                        indicator = 3'b011;
                    end   
                end

                3'b011: //clear state
                begin
                    s2 = 1;
                    s3 = 0;
                    enable = 1;
                    if(done_count == 1)
                    begin

                        cfreq = freq * 12;
                        enable = 0;
                        indicator =3'b100;
                    end   
                end
//                begin
//                    if (4200 >= rfreq && rfreq <= 8000)
//                        TopColor = 0;//red
//                    else if ( 2500 <= gfreq && 3300 <= gfreq)
//                        TopColor = 1;//green
//                    else if (3300 <= bfreq && 3700 <= bfreq)
//                        TopColor = 2;//blue
//                    else
//                        TopColor = 3;//none
//                    indicator = 2'b00; //restart
//                end 
                3'b100: //display state
                begin
                    if ( (rfreq > gfreq) && (rfreq > bfreq) && (rfreq > cfreq) )begin //R E D
                        TopColor = 0;//red
                        indicator = 3'b000; //go back to the starting state
                        end
                    else if ( (gfreq > rfreq) && (gfreq > bfreq) && (rfreq > cfreq)) begin//G R E E N
                        TopColor = 1;//green
                        indicator = 3'b000; //go back to the starting state
                        end
                    else if ( (bfreq > gfreq) && (bfreq > rfreq)&& (bfreq > cfreq)) begin//B L U E
                        TopColor = 2;//blue 
                        indicator = 3'b000;//go back to the starting state
                        end
                    else
                    begin
                        TopColor = 3;//none
                        indicator = 3'b000; //restart
                    end
                end
        endcase
    end
endmodule