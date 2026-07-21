module top_module ( 
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);//

    always @(*) begin
        case(do_sub)
            1'd0 : out = a+b;
            1'd1 : out = a-b;
        endcase
        case(out)
            1'd0 : result_is_zero=1'd1;
            1'd1 : result_is_zero=1'd0;
        endcase
    end
        
endmodule
