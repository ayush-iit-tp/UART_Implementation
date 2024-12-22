module uart_receiver(
    input wire clk,
    input wire reset,
    input wire baud_tick,
    input wire rx,           // Serial input
    output reg [7:0] rx_data, // Parallel output
    output reg rx_done        // Reception complete
);
    reg [3:0] bit_counter;
    reg [7:0] shift_reg;

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b10,
        STOP = 2'b11
    } state_t;

    state_t state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rx_data <= 8'd0;
            rx_done <= 1'b0;
            bit_counter <= 4'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 1'b0;
                    if (~rx) // Detect start bit
                        state <= START;
                end

                START: begin
                    if (baud_tick) begin
                        if (rx == 1'b0) // Validate start bit
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        shift_reg <= {rx, shift_reg[7:1]};
                        bit_counter <= bit_counter + 1;
                        if (bit_counter == 4'd7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        if (rx == 1'b1) begin // Validate stop bit
                            rx_data <= shift_reg;
                            rx_done <= 1'b1;
                        end
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
