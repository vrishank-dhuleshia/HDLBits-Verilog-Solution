module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    
    parameter [3:0] A=4'd0, F=4'd1, G=4'd2, CHECK_1=4'd3, CHECK_10=4'd4, CHECK_101=4'd5, CHECK_Y1=4'd6,
    G1=4'd7, G0=4'd8;
    reg [3:0] state, next_state;

    always @(posedge clk) begin
        if(~resetn) begin
            state<=A;
        end
        else begin
            state<=next_state;
        end
    end
    
    always @(*) begin
        case(state)
            A : next_state = resetn ? F:A;
            F : next_state = CHECK_1;
            CHECK_1 : next_state = x ? CHECK_10:CHECK_1;
            CHECK_10 : next_state = x ? CHECK_10:CHECK_101;
            CHECK_101 : next_state = x ? G:CHECK_1;
            G : next_state = CHECK_Y1;
            CHECK_Y1 : next_state = y ? G1:G0;
            G0 : next_state=G0;
            G1 : next_state=G1;
            default : next_state = A;
        endcase
    end
    
    assign f = (state==F);
    assign g = (state==G || state==CHECK_Y1 || state==G1);
    
endmodule
