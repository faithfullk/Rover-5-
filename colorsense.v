`timescale 1ns / 1ps




module work_PWM1(
//PWM part
    input [2:0] signal,
    input altsig,
   
    //input switch,
    //input leftsig,
    //input rightsig,
    input clock,
 // input reset, 
//    input [1:0] JB,
    input irsense,
    //input test,
        //8 switches
  //  input [7:0] SW, //SW[0] TO SW[7] 
    input colorsignal,
    output S0,
    output S1,
    output reg S2,
    output reg S3,
   input switch,
    output LED13,
    output LED12,
    output LED11,
    output LED10,
    //output LED8,
    //output [3:0] IN,
output reg [3:0] IN,

   output ENA,ENB, 
    
//instantions



    
//7-Segment initialization   
    output reg [3:0] an,      // DIGITS
    output reg [6:0] seg
    

    );

    initial begin     
    IN[0] = 0;
    IN[1] = 0;
    IN[2] = 0;
    IN[3] = 0;
  end
    // duty cycle use in PWM:
    reg [20:0] count;// 2^(21) = 2,097,152
    reg [20:0] width;
    reg PWM;
 
    initial begin
        count = 0;
        width = 0;
        PWM = 0;
     end 
     
 //assign display_count = refresh [19:18]; 
always@(posedge clock)begin
        if(count > 2097152) //resets the counter to 0 or increments
            count <= 0;
         else
            count <= count +1;
       
        if(count < width) begin
            PWM <= 1;
            end
            
        else begin
            PWM <=0;
         end    

end
     
    always@(clock)begin
   
//if (state <= St0) begin
//case(~signal)  //idle state           
//                 //25% Duty Cycle
//                //Both Backward (IN4 & IN1):
//                3'b010: width = 21'd0; // Forward 25%
//                3'b011: width = 21'd0; 
//                3'b110: width = 21'd0; 
//                3'b001: width = 21'd0; 
//                3'b100: width = 21'd0; 
//                3'b111: width = 21'd0;
//                3'b101: width = 21'd0;
//                default: width = 21'd0;


//endcase
//end
//else if (state <= St1) begin
 case(~signal)
                3'b010: width = 21'd524288;// Forward 25%
                3'b011: width = 21'd1048576;
                3'b110: width = 21'd1048576; 
                3'b001: width = 21'd1048576; 
                3'b100: width = 21'd1048576; 
                3'b111: width = 21'd1048576;
                3'b101: width = 21'd1048576;
                 default: width = 21'd0;
          
endcase
end
//else if (state <= St3) begin
// case(~signal)
//                3'b010: width = 21'd524288;// Forward 25%
//                3'b011: width = 21'd524288;
//                3'b110: width = 21'd524288; 
//                3'b001: width = 21'd524288; 
//                3'b100: width = 21'd524288; 
//                3'b111: width = 21'd524288;
//                3'b101: width = 21'd524288;
//                 default: width = 21'd0;
          
//endcase

// end    
        
// end


 //num == 1 RED 
 // num == 2 green  
 // num == 3 blue 

parameter   St0          =     5'b00001, //State 0, Initial State 
            St1          =     5'b00010,
            St2          =     5'b00100,
            St3          =     5'b01000,
			St4          = 	  5'b10000; // State 4, Final State

// Must do the state initialization to a known state so that behavioral simulation 
//gate level result matches
//Synchronous FSM. Only need to have one state variable 
reg [4:0]   state  =     St0; 
//reg [2:0]outt ;

//assign OUT = ~OUT_b; // output for LED0

//use always block to implment the next state logic 
//use positive edge of clock in the sensitivity list
//case statement and conditional statement to decide next state logic
always @(posedge clock) begin
  case(state)
    St0: begin // Case state 0 //red 
      if (num == 2) state <= St1; // jump to state 1
      else    state <= St0; // stay in state 0
    end
    St1: begin // Case state 1 //green
      if (num==1) state <= St0; // go back to state 0
      else    state <= St2; //  jump to state 2
    end
    St2: begin // Case state 2
      if (num==3) state <= St3; //  go back to state 1
      else    state <= St1; // if input is 0, jump to state 3
    end
    St3: begin // Case state 3 //blue 
      if (num==2) state <= St1; // if input is 1, jump to state 4
      else    state <= St4; // if input is 0, stay in state 3
    end
	 St4: begin  // Case state 4 // 
	       if (num== 1) state <= S0; // if input is 1, go back to state 0
     else state <= S3; // if input is 0, go back to state 1
    end
    default: begin // default case to avoid error for unreachable state as there are 16 possible states
      state = St0; // always go to state 0
    end
  endcase
end


//use output to assign output in each state
//always make the output to be 0 unless the final state is reached
//always @(posedge clk) begin
//  case(state)
//    S0: begin // state 0 
//      OUT_b = 0; //output is 0
//    end
//    S1: begin // state 1
//      OUT_b = 0; // output is 0
//    end
//    S2: begin // state 2
//      OUT_b = 0; //output is 0
//    end
//	 S3: begin // state 3 
//      OUT_b = 0; // output is 0
//    end
//    S4: begin // state 4
//      if (IN) OUT_b = 0; //if iput is 1, output is 0
//      else    OUT_b = 1; //if input is 0, output is 1
//    end
//    default: begin // default for unreacheable state
//      OUT_b = 0; // output is 0
//    end
//  endcase
//end


parameter   Stat0          =     5'b00001, //State 0, Initial State 
            Stat1          =     5'b00010,
            Stat2          =     5'b00100,
            Stat3          =     5'b01000,
			Stat4          = 	  5'b10000; // State 4, Final State

// Must do the state initialization to a known state so that behavioral simulation 
//gate level result matches
//Synchronous FSM. Only need to have one state variable 
reg [4:0]   statete  =     St0; 
//reg [2:0]outt ;

//assign OUT = ~OUT_b; // output for LED0

//use always block to implment the next state logic 
//use positive edge of clock in the sensitivity list
//case statement and conditional statement to decide next state logic
always @(posedge clock) begin
  case(statete)
    Stat0: begin // Case state 0 //red 
      if (irsense && ~altsig) statete <= Stat1; // jump to state 1
      else    statete <= St0; // stay in state 0
    end
    Stat1: begin // Case state 1 //green
      if (~signal[2]) statete <= Stat0; // go back to state 0
      else    statete <= St1; //  jump to state 2
    end
//    Stat2: begin // Case state 2
//      if () statete <= St3; //  go back to state 1
//      else    state <= St1; // if input is 0, jump to state 3
//    end
//    St3: begin // Case state 3 //blue 
//      if (num==2) state <= St1; // if input is 1, jump to state 4
//      else    state <= St4; // if input is 0, stay in state 3
//    end
//	 S4: begin  // Case state 4 // 
//	       if (num== 1) state <= S0; // if input is 1, go back to state 0
//     else state <= S3; // if input is 0, go back to state 1
//    end
    default: begin // default case to avoid error for unreachable state as there are 16 possible states
      statete = Stat0; // always go to state 0
    end
  endcase
end


always@(posedge clock) begin 


if (statete <= Stat0) begin
case(~signal)
//3'b000: IN = 4'b0000;   // Rover not move
3'b010: IN = 4'b1001;   //rover forward
3'b011: IN = 4'b0101;   // rover right
3'b001: IN = 4'b0101;   // rover right 
3'b110: IN = 4'b1010;    // rover left
3'b100: IN = 4'b1010;    
3'b111: IN = 4'b1001;   // rover left
3'b101: IN = 4'b1001;
default: IN = 0;
endcase
end
else if (statete <= Stat1) begin
case(~signal)
//3'b000: IN = 4'b0101;   // Rover not move
3'b010: IN = 4'b1010;  //rover forward
3'b011: IN = 4'b1010;   // rover right
3'b001: IN = 4'b1010;   // rover right 
3'b110: IN = 4'b1010;    // rover left
3'b100: IN = 4'b1010;    
3'b111: IN = 4'b1010;   // rover left
3'b101: IN = 4'b1010;
default: IN = 0;
endcase
end





end





 
// if ((irsense && ~signal[0] && ~signal[1] && ~signal[2] ) || (irsense && ~signal[1] && ~signal[2]) ||(irsense && ~signal[2]))
//    IN = 4'b0101;
    
// end
 

 






 





   assign LED10 = ~ irsense;
//  assign LED15 = (JB[0]) ? 1:0;
//Sending PWM to Enables to make motors move

assign ENA = PWM;
assign ENB = PWM;
 //  assign ENA =  {irsense == 1}? 1'b0: 1'b1 ;
   // assign ENB = {irsense == 1} ? 1'b0: 1'b1 ;
    assign LED13 = ~ signal[0];
    assign LED12 = ~ signal[1];
    assign LED11 = ~ signal[2];
//    assign ENA = {signal == 1} ? 8'b10010010 : 2'b00;
//     assign ENB = {signal == 1} ? 8'b10010010 : 2'b00;

 parameter bluestate = 0;
    parameter greenstate = 1;
    parameter redstate = 2;
    parameter clearstate = 3;
    parameter displaystate = 4;
    
    reg [4:0] colorstate = bluestate; //2^4 = 16 //starting from BLUE filter
//===================== START of Registers for BLUE Color ===========================    
    reg [32:0] freq = 33'b0; //Initialize registers
    reg last; //to contain last state
    reg flag;
    reg [32:0] edgecount = 33'b0; //to count the positive edges of the frequency of the color sensor
    reg finish = 0;
    reg [32:0] val = 33'b0;
//===================== END of Registers for BLUE Color =========================== 
//===================== START of Registers for GREEN Color ===========================       
    reg [32:0]edgecount1 = 33'b0;
    reg flag1;
    reg finish1 = 0;
    reg [32:0]val1 = 33'b0;
    reg [32:0] freq1 = 33'b0;
 //===================== END of Registers for GREEN Color =========================== 
 //===================== START of Registers for RED Color ===========================    
    reg [32:0]edgecount2=33'b0;
    reg flag2;
    reg finish2 = 0;
    reg [32:0]val2 = 33'b0;
    reg [32:0] freq2 = 33'b0;
 //===================== END of Registers for RED Color =========================== 
 //===================== START of Registers for CLEAR Color ===========================    
    reg [32:0] edgecount3 = 33'b0;
    reg flag3;
    reg finish3 = 0;
    reg [32:0] val3 = 33'b0;
    reg [32:0] freq3 = 33'b0;
 //===================== END of Registers for CLEAR Color ===========================     
 
    reg [32:0] greenfreq = 33'b0;
    reg [32:0] redfreq = 33'b0;
    reg [32:0] bluefreq = 33'b0;
    reg [32:0] clearfreq = 33'b0;
    
    reg [6:0] num; //to loght up the LEDs. 1: RED; 2: GREEN; 3: BLUE; 4: CLEAR
    
    assign S0 = 1;
    assign S1 = 0; //20% scaling frequency
    
    always @ (posedge clock)
        last <= colorsignal;
        
 //--------------------START of B L U E-----------------------   
always@(posedge clock)
    if(~flag) //NOT flag //resetting
        begin
            freq=0;
            edgecount=0;
            val=0;
            finish=0;
        end
    
    else 
    begin
        if(val<6250000)//6,250,000
            begin
                val<=val+1;
                if(~last & colorsignal)
                begin
                    edgecount<=edgecount+1;
            end
    end

    else 
    begin
        freq = 0;
        freq = edgecount*30; //blue
        edgecount = 0;
        val = 0;
        finish = 1;
    end
end
//--------------------END of B L U E-----------------------
//--------------------START of G R E E N-----------------------
always@(posedge clock)
    if(~flag1)
        begin
            freq1=0;
            edgecount1=0;
            val1=0;
            finish1=0;
        end
    else 
    begin
        if(val1 < 6250000)
        begin
            val1 <= val1+1;
            if(~last & colorsignal)
            begin
                edgecount1 <= edgecount1+1;
            end
        end
    else 
        begin
            freq1=0;
            freq1=edgecount1*36; //green
            edgecount1=0;
            val1=0;
            finish1=1;
        end
end
//--------------------END of G R E E N-----------------------
//--------------------START of R E D-----------------------
always@(posedge clock)
    if(~flag2)
    begin
        freq2=0;
        edgecount2=0;
        val2=0;
        finish2=0;
    end
    else 
    begin
    if(val2<6250000)
    begin
        val2<=val2+1;
        if(~last & colorsignal)
        begin
            edgecount2<=edgecount2 + 1;//red
        end
    end
    else begin
        freq2=0;
        freq2=edgecount2*21; //RED
        edgecount2=0;
        val2=0;
        finish2=1;
    end
end
//--------------------END of R E D-----------------------
//--------------------START of C L E A R-----------------------
always@(posedge clock)
    if(~flag3)
    begin
        freq3=0;
        edgecount3=0;
        val3=0;
        finish3=0;
    end
    else 
    begin
        if(val3<6250000)
        begin
            val3<=val3+1;
            if(~last & colorsignal)
            begin
                edgecount3<=edgecount3+1;
            end
        end
    else 
    begin
        freq3=0;
        freq3=edgecount3*12;
        edgecount3=0;
        val3=0;
        finish3=1;
    end
end
//--------------------END of C L E A R-----------------------
//--------------------- T O P  M O D U L E -------------------------
//    parameter bluestate=0,greenstate=1,redstate=2,displaystate=3;     
always@(posedge clock)
    case(colorstate)
    bluestate:
    begin
       S2 <= 0;
       S3 <= 1;
       flag = 1;
       if(finish == 1)
       begin
            bluefreq <= freq;
            flag=0;
            colorstate = greenstate; //Starts from Blue and goes to the next state which is GREEN
       end
    end
    
    greenstate:
    begin
       S2<=1;
       S3<=1;
       flag1=1;
       if(finish1==1)
       begin
            greenfreq<=freq1;
            flag1=0;
            colorstate=redstate;
       end
    end
    
    redstate:
    begin
       S2<=0;
       S3<=0;
       flag2=1;
       if(finish2==1)
       begin   //parameter redstate=0,greenstate=1,bluestate=2,displaystate=3;
            redfreq<=freq2;
            flag2=0;
            colorstate=clearstate;
       end
    end
    
    clearstate:
    begin
       S2<=1;
       S3<=0;
       flag3=1;
       if(finish3==1)
       begin
            clearfreq<=freq3;
            flag3=0;
            colorstate=displaystate;
       end
    end
       
    displaystate:
    begin
       if( (redfreq > greenfreq) && (redfreq > bluefreq) && (redfreq > clearfreq) )
       begin
            num = 1;
            colorstate = bluestate;
       end
       else if( (greenfreq > redfreq) && (greenfreq > bluefreq) && (greenfreq > clearfreq) )
       begin
            num = 2;  
            colorstate = bluestate;
       end
       else if( (bluefreq > redfreq) && (bluefreq > greenfreq) && (bluefreq > clearfreq) )
       begin
            num = 3;  
            colorstate = bluestate;
       end   
       else begin
            num = 4;
            colorstate = bluestate;
       end
       end
    endcase
    
 //----------- T O P  M O D U L E --------------------   
always@(posedge clock)
begin
    if(num == 1)
    begin

        an = 4'b0111;
        seg = 7'b0101111; // displays r for RED: 0101111
    end
    else if(num == 2)
    begin

        an = 4'b0111;
        seg = 7'b0010000; //displays g for GREEN: 0000010
    end
    else if(num == 3)
    begin

        an = 4'b0111;
        seg = 7'b0000011; //displays b for BLUE: 0000011
    end
    else if(num == 4)
    begin

        an = 4'b0111;
        seg = 7'b0111111; // displays - for CLEAR: 0101111
    end
end
endmodule