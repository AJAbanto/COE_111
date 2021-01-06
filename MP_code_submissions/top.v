`timescale 1ns / 1ps

module top(
    input clk,
    input nrst,
    output tx
    );
    
    //baudrate and clk pulses calculation (assume 100 Mhz clk frequency)
    //clk_per_bit = 100000000/9600 (100 Mhz clk freq)
    parameter clk_per_bit = 32'd10417;
    
    //clock cycles before sending next byte
    parameter WAIT_IDLE = 32'd100000000;
    //states
    parameter ST_IDLE       = 2'b000;
    parameter ST_START_BIT  = 2'b001;
    parameter ST_DATA_BIT   = 2'b010;
    parameter ST_STOP_BIT   = 2'b011;
    
    //message to send
    parameter BYTES = 8'h59;
    //registers
    reg [1:0] c_state,n_state;
    reg [31:0] clk_cnt;
    reg [7:0] tx_data;
    reg [3:0] tx_index;
    reg tx_o;
    
    assign tx = tx_o;
    
    //state transitions
    always@(posedge clk) begin
        if(~nrst)c_state <= ST_IDLE;
        else c_state <= n_state;
    end
    
    //outputs and clk counter
    always@(posedge clk)begin
        if(~nrst)begin
            tx_o <= 1'b1;
            tx_index <= 4'b0;
            tx_data <= BYTES;
            
            clk_cnt <= 32'b0;
        end else begin
            case(c_state)
                ST_IDLE: begin
                    tx_o <= 1'b1;
                    tx_index <= tx_index;
                    
                    if(clk_cnt > WAIT_IDLE -1) clk_cnt <= 32'b0;
                    else clk_cnt <=  clk_cnt + 32'b1;
                end
                ST_START_BIT: begin
                    tx_o <= 1'b0;
                    tx_index <= tx_index;

                    if(clk_cnt  > clk_per_bit -1 ) clk_cnt <= 32'b0;
                    else clk_cnt <= clk_cnt + 32'b1;                  
                end
                ST_DATA_BIT:begin
                    tx_o <= tx_data[tx_index];
                    
                    if(clk_cnt > clk_per_bit -1)begin
                        clk_cnt <= 32'b0; 
                        if(tx_index > 4'd7 - 1) tx_index <= 4'b0;
                        else tx_index <= tx_index + 4'b1;
                    end else begin
                        clk_cnt <=  clk_cnt + 32'b1;
                        tx_index <= tx_index;
                    end
                end
                ST_STOP_BIT:begin
                    tx_o <= 1'b1;
                    
                    if(clk_cnt > clk_per_bit -1 ) clk_cnt <= 32'b0;
                    else clk_cnt <= clk_cnt + 32'b1;
                end
            endcase
        end
    end
 
    
    always@(posedge clk)begin
        if(~nrst)begin
            n_state <= ST_IDLE;
        end else begin
            case(c_state)
                ST_IDLE: begin
                    if(clk_cnt > WAIT_IDLE -1) n_state <= ST_START_BIT;
                    else n_state <= n_state;
                end
                ST_START_BIT:begin
                    if(clk_cnt > clk_per_bit - 1) n_state <= ST_DATA_BIT;
                    else n_state <= n_state;
                end
                ST_DATA_BIT:begin
                    if(clk_cnt > clk_per_bit - 1 )begin
                        if(tx_index > 4'd7 - 1) n_state <= ST_STOP_BIT;
                        else n_state <= n_state;
                    end else n_state <= n_state;
                end
                ST_STOP_BIT:begin
                    if(clk_cnt > clk_per_bit -1 )n_state <= ST_IDLE;
                    else n_state <= n_state;
                end
            endcase
        end
    end
    
    
endmodule
