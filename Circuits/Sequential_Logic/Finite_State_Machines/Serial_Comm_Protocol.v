module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    
    parameter [3:0] SB=4'b0,
    B1=4'b0001, B2=4'b0010,
    B3=4'b0011, B4=4'b0100,
    B5=4'b0101, B6=4'b0110,
    B7=4'b0111, B8=4'b1000,
    Dock_stage=4'b1001;
    
    reg [3:0] state, next_state, prev_state, prev2_state;
    
    always @(*) begin
        case (state)
            SB : next_state = (~in) ? B1 : SB;
            B1 : next_state = B2;
            B2 : next_state = B3;
            B3 : next_state = B4;
            B4 : next_state = B5;
            B5 : next_state = B6;
            B6 : next_state = B7;
            B7 : next_state = B8;
            B8 : next_state = Dock_stage;
            Dock_stage : next_state = (in) ? SB : Dock_stage;
            default : next_state = SB;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=SB;
        end
        else begin
            state<=next_state;
            prev_state<=state;
            prev2_state<=prev_state;
        end
    end    

    assign done = (state==SB && prev_state==Dock_stage && prev2_state==B8);
endmodule
