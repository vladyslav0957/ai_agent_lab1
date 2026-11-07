`timescale 1ns / 1ps

module spi_master #(
    // Дільник частоти: для 50 МГц системного клоку CLK_DIV=4 дає sclk ~ 6.25 МГц
    // (півперіод sclk = CLK_DIV тактам системного clk)
    parameter CLK_DIV = 4
)(
    input  wire       clk,       // Базовий тактовий сигнал (50 МГц)
    input  wire       rst,       // Синхронне скидання (активна '1')
    input  wire       start,     // Імпульс запуску транзакції
    input  wire [7:0] tx_data,   // Дані для відправки
    output reg  [7:0] rx_data,   // Прийняті дані
    output reg        ready,     // '1' коли модуль вільний і готовий до нової передачі
    
    // Зовнішні лінії протоколу SPI
    output reg        sclk,      // Тактовий сигнал SPI
    output reg        mosi,      // Вихід даних майстра
    input  wire       miso,      // Вхід даних від слейва
    output reg        cs_n       // Вибір слейва (Chip Select, активний '0')
);

    // Стани кінцевого автомата (FSM)
    localparam IDLE     = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_tx;
    reg [7:0] shift_rx;
    reg [2:0] bit_cnt;
    reg [7:0] clk_cnt;
    reg       sclk_reg;

    always @(posedge clk) begin
        if (rst) begin
            state    <= IDLE;
            ready    <= 1'b1;
            cs_n     <= 1'b1;
            sclk     <= 1'b0;
            mosi     <= 1'b0;
            rx_data  <= 8'd0;
            shift_tx <= 8'd0;
            shift_rx <= 8'd0;
            bit_cnt  <= 3'd0;
            clk_cnt  <= 8'd0;
            sclk_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    ready    <= 1'b1;
                    cs_n     <= 1'b1;
                    sclk     <= 1'b0;
                    sclk_reg <= 1'b0;
                    clk_cnt  <= 8'd0;
                    bit_cnt  <= 3'd7; // Передаємо старшим бітом уперед (MSB first)

                    if (start) begin
                        ready    <= 1'b0;
                        cs_n     <= 1'b0;          // Опускаємо Chip Select
                        shift_tx <= tx_data;
                        mosi     <= tx_data[7];    // Виставляємо перший (старший) біт
                        state    <= TRANSFER;
                    end
                end

                TRANSFER: begin
                    if (clk_cnt == CLK_DIV - 1) begin
                        clk_cnt  <= 8'd0;
                        sclk_reg <= ~sclk_reg;
                        sclk     <= ~sclk_reg;

                        if (~sclk_reg == 1'b1) begin
                            // Наростаючий фронт sclk: зчитуємо біт з лінії miso
                            shift_rx <= {shift_rx[6:0], miso};
                        end else begin
                            // Спадний фронт sclk: оновлюємо біт на лінії mosi
                            if (bit_cnt == 0) begin
                                state <= DONE;
                            end else begin
                                bit_cnt  <= bit_cnt - 1'b1;
                                shift_tx <= {shift_tx[6:0], 1'b0};
                                mosi     <= shift_tx[6];
                            end
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1'b1;
                    end
                end

                DONE: begin
                    // Завершальний такт: піднімаємо CS, виставляємо прийнятий байт
                    cs_n    <= 1'b1;
                    sclk    <= 1'b0;
                    mosi    <= 1'b0;
                    rx_data <= shift_rx;
                    ready   <= 1'b1;
                    state   <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule