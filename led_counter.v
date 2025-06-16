module Counter #(
    parameter CLK_FREQ = 25_000_000 
) (
    input  wire clk,
    input  wire rst_n,
	output wire [7:0] leds
);

	localparam ONE_SECOND = CLK_FREQ; // número de ciclos de clock em 1 segundo

	reg [31:0] counter;

	reg [7:0] leds_reg;

	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			counter <= 32'h0;
			leds_reg <= 8'd0;	
		end else begin
			if (counter >= (ONE_SECOND - 1)) begin
				counter <= 32'h0;
				leds_reg <= leds_reg + 1;
			end else begin
				counter <= counter + 1;
			end
		end
	end

	assign leds = leds_reg;

endmodule
