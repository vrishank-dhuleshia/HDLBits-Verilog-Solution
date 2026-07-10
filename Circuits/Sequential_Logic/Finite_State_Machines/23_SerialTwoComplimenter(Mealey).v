module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
	
    //state A=2'b01 and state B=2'b10
    reg [1:0] state, next_state;
    
    always @(*) begin
        next_state[1] = ((state[0]) && (x)) || (state[1]);
        next_state[0] = (state[0]) && (~x);
        
    end
               
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state<=2'b01;
        end 
        else begin
            state<=next_state;
        end
    end
      
    assign z = (state[0] && x) | (state[1] && (~x)); 
        
endmodule
//Mealey FSM as the output depends upon the state as well as the input of the system
