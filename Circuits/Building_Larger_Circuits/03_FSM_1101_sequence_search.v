module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);

    parameter [2:0] S1=3'd0, S2=3'd1, S3=3'd2, S4=3'd3, END=3'd4;
    reg [2:0] state, next_state;
    
    always @(*) begin
        case(state) 
            S1 : next_state = data ? S2:S1;
            S2 : next_state = data ? S3:S1;
            S3 : next_state = data ? S3:S4;
            S4 : next_state = data ? END:S1;
            END : next_state = reset ? S1:END;
            default : next_state = S1;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=S1;
        end
        else begin
            state<=next_state;
        end
    end
    
    assign start_shifting = (state==END);
endmodule
