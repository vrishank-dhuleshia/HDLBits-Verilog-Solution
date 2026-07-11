module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

    parameter [1:0] A=2'b00, B1=2'b01, B2=2'b10, B3=2'b11;
    reg [1:0] state, next_state,count;

        
    always @(*) begin
        case(state) 
            A : next_state = s ? B1:A;
            B1 : next_state = B2;
            B2 : next_state = B3;
            B3 : next_state = B1;
            default : next_state = A;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=A;
            count<=2'b0;
        end else begin
            state<=next_state;
            if(state==B1) begin
                if(w) begin
                    count<=2'b01;
                end
                else begin
                    count<=2'b0;
                end
            end
            else if(state==B2) begin
                if(w) begin
                    count<=count+1;
                end
            end
            else if(state==B3) begin
                if(w) begin
                    count<=count+1;
                end
            end     
        end
    end

    assign z = (count==2'b10 && state==B1) ? 1'b1:1'b0;
                
endmodule
