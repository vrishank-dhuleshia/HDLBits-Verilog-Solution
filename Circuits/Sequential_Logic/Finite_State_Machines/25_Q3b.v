module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);

    parameter [2:0] S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4=3'd4;
    reg [2:0] state, next_state;
    
    always @(*) begin
        case(state)
            S0: next_state = x ? S1:S0;
            S1: next_state = x ? S4:S1;
            S2: next_state = x ? S1:S2;
            S3: next_state = x ? S2:S1;
            S4: next_state = x ? S4:S3;
            default: next_state = S0;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=S0;
        end
        else begin
            state<=next_state;
        end
    end
    
    assign z = (state==S3 || state==S4);
    
endmodule
