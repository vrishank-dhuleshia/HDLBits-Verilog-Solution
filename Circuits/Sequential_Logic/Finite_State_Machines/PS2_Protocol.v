module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); 

    parameter [1:0] B1=2'b00, B2=2'b01, B3=2'b10; 
    reg [1:0] state, next_state, previous_state;
    
    // State transition logic (combinational)
    always @(*) begin
        case (state)
            B1 : next_state = (in[3]==1) ? B2 : B1;
            B2 : next_state = B3;
            B3 : next_state = B1;
            default : next_state = B1;
        endcase
    end
    
    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset) begin
            state<=B1;
        end
        else begin
            state<=next_state;
            previous_state<=state;
        end
    end
    
    // Output logic
    assign done = (state==B1 && previous_state==B3); 
endmodule
