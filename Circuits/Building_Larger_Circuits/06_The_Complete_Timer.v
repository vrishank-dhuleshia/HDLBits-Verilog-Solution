module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );

    parameter [3:0] CHECK_1=4'd0, CHECK_11=4'd1, CHECK_110=4'd2, CHECK_1101=4'd3, COUNTING=4'd4, DELAY=4'd5, DONE=4'd6;
    reg [3:0] state, next_state;
    reg [2:0] count4;
    reg [13:0] t_count;
    reg delay_done;
    reg [3:0] o_count;
    
    always @(*) begin
        case(state)
            CHECK_1 : next_state = data ? CHECK_11 : CHECK_1;
            CHECK_11 : next_state = data ? CHECK_110 : CHECK_1;
            CHECK_110 : next_state = data ? CHECK_110 : CHECK_1101;
            CHECK_1101 : next_state = data ? COUNTING : CHECK_1;
            COUNTING : next_state = (count4==3'd4) ? DELAY:COUNTING;
            DELAY : next_state = delay_done ? DONE:DELAY;
            DONE : next_state = ack ? CHECK_1 : DONE;
            default : next_state = CHECK_1;
        endcase
    end
    
    //flip flop logic
    always @(posedge clk) begin
        if(reset) begin
            state<=CHECK_1;
        end
        else begin
            state<=next_state;
        end
    end
    
    //assigning count to another variable
    always @(posedge clk) begin
        if(reset) begin
            o_count<=4'd0;
        end
        else if(state==DELAY && t_count==14'd0) begin
            o_count<=count[3:0];
        end
    end
    
    //counts for 4 cycles then resets to zero
    always @(posedge clk) begin
        if(reset) begin
            count4<=3'd0;
        end
        else begin
            if(next_state==COUNTING) begin
                count4<=count4+3'd1;
            end
            else begin
                count4<=3'd0;
            end
        end
    end
    
    //puts the value of data to count to calculate delay after 1101 sequence is  
    //as required by the question reduces count by 1 every 1000 cycles
    always @(posedge clk) begin
        if(reset) begin
            count<=4'd0;
        end
    	else begin
            if(state==COUNTING) begin
                count<={count[2:0],data};
            end
            if(state==DELAY) begin
        		for(int i=1; i<(count[3:0]+1); i=i+1) begin
                    if(t_count+1==((o_count[3:0]+1-i)*1000)) begin
                    	count[3:0]<=count[3:0]-3'd1;
            		end
        		end
            end
        end
    end

    //counts for (count+1)*1000 cycle
    always @(posedge clk) begin
        if(reset) begin
            t_count<=14'd0;
            delay_done<=1'b0;
        end
        else begin
            if(state==DELAY) begin
                if(t_count==((o_count[3:0]+1)*1000)-2) begin
                	delay_done<=1'b1;
            	end
            	else begin
                	t_count<=t_count+1'b1;
            	end
            end
            else if(state==DONE) begin
                delay_done<=1'b0;
                t_count<=14'd0;
            end
        end
    end
    
    assign done = (state==DONE);
    assign counting = (state==DELAY);
     
endmodule
