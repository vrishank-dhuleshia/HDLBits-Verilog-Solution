module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); 
    
    parameter [2:0] START=3'd0, COUNTING=3'd1, IN_CHECK=3'd2, DONE=3'd3, WAIT=3'd4, PARITY_CHECK=3'd5;
    
    reg [2:0] state, next_state;
    reg [3:0] count;
    reg odd;
    reg [7:0] out_byte_reg;
    
    //combinational logic
    always @(*) begin
        case(state)
            START : next_state = in ? START : COUNTING;
            COUNTING : next_state = (count==4'd8) ? PARITY_CHECK : COUNTING;
            PARITY_CHECK : next_state = IN_CHECK;
            IN_CHECK : next_state = in ? DONE : WAIT;
            DONE : next_state = in ? START : COUNTING;
            WAIT : next_state = in ? START : WAIT;
            default : next_state = START;
        endcase
    end
    
    //flip flop
    always @(posedge clk) begin
        if(reset) begin
            state<=START;
        end
        else begin
            state<=next_state;
        end
    end

    //datapath 
    always @(posedge clk) begin
        if(reset) begin
            out_byte_reg<=8'b0;
        end
        else begin
            if(state==COUNTING) begin
                out_byte_reg[count-1]<=in;
            end
        end
    end
    
    //counter
    always @(posedge clk) begin
        if(reset) begin
            count<=4'd0;
        end
        else begin
            if(next_state==COUNTING || next_state==PARITY_CHECK) begin
                count<=count+1'd1;
            end
            else begin
                count<=4'd0;
            end
        end
    end
    
    //count1
    always @(posedge clk) begin
        if(reset) begin
            odd<=1'd0;
        end
        else begin
            if(state==COUNTING || state==PARITY_CHECK) begin
                case(in)
                    1'b1 : odd<=~odd;
                    1'b0 : odd<=odd;
                endcase
            end
            else if(state==IN_CHECK) begin
                odd<=odd;
            end
            else begin
                odd<=1'd0;
            end
        end
    end
    
    assign done = (state==DONE && odd);
    assign out_byte = (state==DONE && odd) ? out_byte_reg : 8'b0;

endmodule
