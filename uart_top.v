module uart_top(
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    input wire rx,
    output wire tx,
    output wire [7:0] rx_data,
    output wire tx_busy,
    output wire rx_done
);
    wire baud_tick;
    wire [15:0] divisor = 16'd650; // Example divisor for 9600 baud at 100 MHz

    baud_rate_generator brg (
        .clk(clk),
        .reset(reset),
        .divisor(divisor),
        .baud_tick(baud_tick)
    );

    uart_transmitter transmitter (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_receiver receiver (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
endmodule
