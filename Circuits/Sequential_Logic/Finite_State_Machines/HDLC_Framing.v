module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

    parameter [3:0] 
    	IDLE=4'b0000,
    	B0=4'b0001,
    	B1=4'b0010,
    	B2=4'b0011,
    	B3=4'b0100,
    	B4=4'b0101,
    	B5=4'b0110,
    	ERROR=4'b0111;
    
    reg [3:0] state, next_state;
    reg discard_reg, flag_reg, err_reg;
    
    always @(*) begin
        case (state) 
            IDLE : next_state = in ? B0:IDLE; //first 1
            B0 : next_state = in ? B1:IDLE;	//second 1
            B1 : next_state = in ? B2:IDLE;	//third 1
            B2 : next_state = in ? B3:IDLE;	//fourth 1
            B3 : next_state = in ? B4:IDLE;	//fifth 1
            B4 : next_state = in ? B5:IDLE; //sixth 1
            B5 : next_state = in ? ERROR:IDLE;	//seventh 1
            ERROR : next_state = in ? ERROR:IDLE;
            default : next_state = IDLE;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=IDLE;
            discard_reg<=1'b0;
            flag_reg<=1'b0;
            err_reg<=1'b0;
        end
        else begin
            state<=next_state;
            discard_reg<=(state==B4 && next_state==IDLE);
            flag_reg<=(state==B5 && next_state==IDLE);
            err_reg<=(next_state==ERROR);
        end
    end
  
	assign disc = discard_reg; 
    assign flag = flag_reg;
    assign err = err_reg;
  
endmodule

