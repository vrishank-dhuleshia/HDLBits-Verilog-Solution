module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    
    parameter [2:0] BELOW_S1=3'd0, AFT_S1=3'd1, AFT_S2=3'd2, AFT_S3=3'd3, FALL_S2=3'd4, FALL_S1=3'd5;
    reg [2:0] state, next_state;
    
    always @(*)	begin
        case(state)
            BELOW_S1 : next_state = (s==3'b001) ? AFT_S1:BELOW_S1;
            AFT_S1 : begin
                if(s==3'b011) next_state = AFT_S2;
                else if(s==3'b000) next_state = BELOW_S1;
                else next_state = AFT_S1;
            end
            AFT_S2 : begin
                if(s==3'b111) next_state = AFT_S3;
                else if(s==3'b001) next_state = FALL_S1;
                else if(s==3'b000) next_state = BELOW_S1;
                else next_state = AFT_S2;
            end
            AFT_S3 : begin
                if(s==3'b011) next_state = FALL_S2;
                else if(s==3'b001) next_state = FALL_S1;
                else if(s==3'b000) next_state = BELOW_S1;
                else next_state = AFT_S3;
            end
            FALL_S2 : begin
                if(s==3'b111) next_state = AFT_S3;
                else if(s==3'b001) next_state = FALL_S1;
                else next_state = FALL_S2;
            end
            FALL_S1 : begin
                if(s==3'b011) next_state = AFT_S2;
                else if(s==3'b000) next_state = BELOW_S1;
            	else next_state = FALL_S1;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=BELOW_S1;
        end
        else begin
            state<=next_state;
        end
    end
    
    assign dfr = (state==FALL_S1 || state==FALL_S2 || state==BELOW_S1);
    assign fr1 = (state==BELOW_S1 || state==AFT_S1 || state==AFT_S2 || state==FALL_S2 || state==FALL_S1);
    assign fr2 = (state==BELOW_S1 || state==AFT_S1 || state==FALL_S1);
    assign fr3 = (state==BELOW_S1);
    
endmodule
