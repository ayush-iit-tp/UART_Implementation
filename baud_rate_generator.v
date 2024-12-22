module baud_rate_generator(
    input wire clk,        // System clock
    input wire reset,      // Synchronous reset
    input wire [15:0] divisor, // Divisor for baud rate generation
    output reg baud_tick   // Output baud rate tick
);
    reg [15:0] counter;

    always @(posedge clk or posedge reset) 
begin
        if (reset) 
        begin
            counter <= 16'd0;
            baud_tick <= 1'b0;
        end else if (counter == divisor - 1) 
          begin
            counter <= 16'd0;
            baud_tick <= 1'b1;
        end else 
             begin
            counter <= counter + 1;
            baud_tick <= 1'b0;
        end
    end
endmodule
