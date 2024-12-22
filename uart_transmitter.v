module uart_transmitter(
    input wire clk,
    input wire reset,
    input wire baud_tick,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,          // Serial output
    output reg tx_busy      // Transmitter busy flag
);
    reg [3:0] bit_counter;
    reg [9:0] shift_reg;

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
            tx <= 1'b1;
            tx_busy <= 1'b0;
            shift_reg <= 10'd0;
            bit_counter <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        tx_busy <= 1'b1;
                        shift_reg <= {1'b1, tx_data, 1'b0}; // Stop, data, start bits
                        bit_counter <= 4'd0;
                        state <= START;
                    end
                end

                START: begin
                    if (baud_tick) begin
                        tx <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        state <= DATA;
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        tx <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_counter <= bit_counter + 1;
                        if (bit_counter == 4'd7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        tx <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
