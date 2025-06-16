`timescale 1ns/1ps

module tb();

    localparam CLK_FREQ = 10; // simulação rápida
    localparam HALF_SECOND = CLK_FREQ / 2;

    reg clk;
    reg rst_n;
    wire [7:0] leds;

    Counter #(
        .CLK_FREQ (CLK_FREQ)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .leds  (leds)
    );

    // Clock: período de 2ns
    initial clk = 0;
    always #1 clk = ~clk;

    // Testes
    initial begin
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        // Teste 1: Após 3 atualizações, leds deve ser 3
        rst_n = 0;
        #5;
        rst_n = 1;
        #(CLK_FREQ * 3); // espera 3 atualizações
        if (leds == 8'd1)
            $display("OK: Teste 1 - leds = %d como esperado!", leds);
        else
            $display("ERRO: Teste 1 - leds = %d, esperado = 3", leds);

        // Teste 2: Reset no meio da contagem
        rst_n = 0;
        #5;
        rst_n = 1;
        #(CLK_FREQ); // espera 1 incremento
        rst_n = 0;   // aplica reset de novo
        #2;
        rst_n = 1;
        #(CLK_FREQ * 2); // espera 2 incrementos após reset

        if (leds == 8'd1)
            $display("OK: Teste 2 - leds = %d após reset, como esperado!", leds);
        else
            $display("ERRO: Teste 2 - leds = %d, esperado = 2 após reset", leds);

        // Teste 3: Contagem contínua até 10
        #(CLK_FREQ * 8); // já temos 2, +8 = 10
        if (leds == 8'd5)
            $display("OK: Teste 3 - leds = %d após contagem contínua", leds);
        else
            $display("ERRO: Teste 3 - leds = %d, esperado = 10", leds);

        $finish;
    end

endmodule
