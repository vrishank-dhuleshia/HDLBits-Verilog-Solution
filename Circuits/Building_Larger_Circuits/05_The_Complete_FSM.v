module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );

    
    parameter [2:0] CHK_1=3'd0, CHK_11=3'd1, CHK_110=3'd2, CHK_1101=3'd3, COUNT4=3'd4, WAIT_COUNT=3'd5, TIME_OUT=3'd6;
    reg [2:0] state, next_state;
    
    reg [2:0] count;
    
    always @(*) begin
        case(state)
            CHK_1 : next_state = data ? CHK_11 : CHK_1;
            CHK_11 : next_state = data ? CHK_110 : CHK_1;
            CHK_110 : next_state = data ? CHK_110 : CHK_1101;
            CHK_1101 : next_state = data ? COUNT4 : CHK_1;
            COUNT4 : next_state = (count==3'd4) ? WAIT_COUNT : COUNT4;
            WAIT_COUNT : next_state = (done_counting) ? TIME_OUT : WAIT_COUNT;
            TIME_OUT : next_state = (ack) ? CHK_1 : TIME_OUT;
            default : next_state =CHK_1;
        endcase
    end

    always @(posedge clk) begin
        if(reset) begin
            state<=CHK_1;
        end
    	else begin
            state<=next_state;
            if(next_state==COUNT4)begin
                count<=count+1;
            end
            else begin
               count<=3'd0;
            end
        end
    end
    
    assign shift_ena = (state==COUNT4);
    assign counting = (state==WAIT_COUNT);
    assign done = (state==TIME_OUT);
        
endmodule
