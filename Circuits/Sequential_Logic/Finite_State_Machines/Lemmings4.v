module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    parameter LEFT  = 3'b000, 
              RIGHT  = 3'b001, 
              GND_L  = 3'b010, 
              GND_R  = 3'b011, 
              DIG_L  = 3'b100, 
              DIG_R  = 3'b101,
              NULL   = 3'b110;
    
    reg [2:0] state, next_state;
    reg [7:0] count;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Counter — tracks ~ground directly, not FSM state
    always @(posedge clk or posedge areset) begin
        if (areset)
            count <= 0;
        else
            count <= (~ground) ? count + 1 : 0;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (~ground) next_state = GND_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left) next_state = RIGHT;
                else next_state = LEFT;
            end
            RIGHT: begin
                if (ground) next_state = GND_R;
                else if (dig) next_state = DIG_R;
                else if (bump_right) next_state = LEFT;
                else next_state = RIGHT;
            end
            DIG_L: begin
                if (~ground) next_state = GND_L;
                else next_state = DIG_L;
            end
            DIG_R: begin
                if (~ground) next_state = GND_R;
                else         next_state = DIG_R;
            end
            GND_L: begin
                if (~ground) next_state = GND_L;
                else if (count > 20) next_state = NULL;
                else next_state = LEFT;
            end
            GND_R: begin
                if (~ground) next_state = GND_R;
                else if (count > 20) next_state = NULL;
                else next_state = RIGHT;
            end
            NULL: begin
                next_state = NULL;
            end
            default: next_state = LEFT;
        endcase
    end

    // Output logic
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == GND_L || state == GND_R);
    assign digging = (state == DIG_L || state == DIG_R);
        
endmodule
