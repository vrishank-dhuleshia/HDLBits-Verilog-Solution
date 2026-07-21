module top_module (input a, input b, input c, output out);
    wire and_out;

    andgate inst1 (
        .a(a),
        .b(b),
        .c(c),
        .d(1'd1),
        .e(1'd1),
        .out(out1)
    );

    assign out = ~(and_out);
    
endmodule
