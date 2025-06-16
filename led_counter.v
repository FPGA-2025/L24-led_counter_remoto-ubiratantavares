module Counter #(
    parameter CLK_FREQ = 25_000_000  // frequência do clock em Hz (padrão: 25 MHz)
) (
    input  wire clk,                 // sinal de clock
    input  wire rst_n,               // reset assíncrono, ativo em nível baixo
    output wire [7:0] leds           // saída de 8 bits conectada aos LEDs
);

    // número de ciclos de clock em 1 segundo
    localparam ONE_SECOND = CLK_FREQ;

    // contador para medir 1 segundo
    reg [31:0] counter;

    // registrador que mantém o valor atual dos LEDs
    reg [7:0] leds_reg;

    // lógica sequencial: acionada na borda de subida do clock ou borda de descida do reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // quando reset está ativo: zera o contador e os LEDs
            counter   <= 32'h0;
            leds_reg <= 8'd0;
        end else begin
            if (counter >= (ONE_SECOND - 1)) begin
                // após 1 segundo: reinicia o contador e incrementa os LEDs
                counter   <= 32'h0;
                leds_reg <= leds_reg + 1;
            end else begin
                // caso contrário: continua contando ciclos de clock
                counter <= counter + 1;
            end
        end
    end

    // atribui o valor dos LEDs à saída
    assign leds = leds_reg;

endmodule
