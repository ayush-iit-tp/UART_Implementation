module uart_tb;
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire [7:0] rx_data;
    wire tx_busy;
    wire rx_done;

    uart_top uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .rx(tx),
        .tx_busy(tx_busy),
        .rx_done(rx_done)
    );

    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'd0;

        #20 reset = 0;

        #100 tx_data = 8'hA5;
        tx_start = 1;
        #10 tx_start = 0;

        #200000; // Wait for transmission and reception
        $finish;
    end
endmodule
