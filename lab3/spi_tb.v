`timescale 1ns / 1ps

module spi_tb;

    // Період 20 нс відповідає тактовій частоті 50 МГц (1 / 50 МГц = 20 нс)
    localparam CLK_PERIOD = 20;

    // Сигнали керування та шини даних
    reg        clk;
    reg        rst;
    reg        start;
    reg  [7:0] tx_data;
    wire [7:0] rx_data;
    wire       ready;

    // Фізичні лінії SPI
    wire       sclk;
    wire       mosi;
    wire       miso;
    wire       cs_n;

    // Режим Loopback: з'єднуємо лінію виходу майстра MOSI з його входом MISO
    assign miso = mosi;

    // Підключення екземпляра тестованого модуля (Unit Under Test — UUT)
    spi_master #(
        .CLK_DIV(4)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .ready(ready),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs_n(cs_n)
    );

    // Генератор тактового сигналу (меандр: 10 нс у '0', 10 нс в '1')
    always begin
        #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Головний процес тестування
    initial begin
        // Запис часових діаграм у файл wave.vcd для перегляду осцилограм
        $dumpfile("wave.vcd");
        $dumpvars(0, spi_tb);

        // Початкові стани сигналів
        clk     = 1'b0;
        rst     = 1'b1;
        start   = 1'b0;
        tx_data = 8'h00;

        // Витримуємо скидання 5 тактів (100 нс)
        #(CLK_PERIOD * 5);
        rst = 1'b0;
        #(CLK_PERIOD * 5);
        
        // ТЕСТ 1: Передача байта 0xA5 (10100101)
        tx_data = 8'hA5;
        start   = 1'b1;
        #(CLK_PERIOD);
        start   = 1'b0;

        // Чекаємо початку та успішного завершення транзакції
        wait(!ready);
        wait(ready);
        #(CLK_PERIOD * 2);

        if (rx_data === 8'hA5) begin
            $display("[OK] Байт 0xA5 успішно передано і прийнято без помилок!");
        end else begin
            $display("[ПОМИЛКА] Очікувалось 0xA5, але отримано: 0x%02X", rx_data);
        end

        #(CLK_PERIOD * 10);

        // ТЕСТ 2: Передача байта 0x3C (00111100)
        tx_data = 8'h3C;
        start   = 1'b1;
        #(CLK_PERIOD);
        start   = 1'b0;

        wait(!ready);
        wait(ready);
        #(CLK_PERIOD * 2);

        if (rx_data === 8'h3C) begin
            $display("[OK] Байт 0x3C успішно передано і прийнято без помилок!");
        end else begin
            $display("[ПОМИЛКА] Очікувалось 0x3C, але отримано: 0x%02X", rx_data);
        end

        #(CLK_PERIOD * 20);
        $display("Усі тести завершено успішно!");
        $finish;
    end

endmodule