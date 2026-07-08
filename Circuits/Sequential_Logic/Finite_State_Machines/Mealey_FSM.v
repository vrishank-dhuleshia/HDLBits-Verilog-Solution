module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 

    parameter [1:0] S1=2'b00, S2=2'b01, S3=2'b10;
    reg [1:0] state, next_state;
    
    always @(*) begin
        case (state) 
            S1 : next_state = x ? S2 : S1;
            S2 : next_state = ~x ? S3 : S2;
            S3 : next_state = x ? S2 : S1;
            default : next_state = S1;
        endcase
    end
    
    always @(posedge clk or negedge aresetn) begin
        if(!aresetn) begin
            state<=S1;
        end else begin
            state<=next_state;
        end
    end
    
    assign z = (state==S3 && x==1);
    
endmodule
