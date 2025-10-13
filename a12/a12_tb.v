// 9896862 Lucas Nascimento Belo

module tb_hex_to_7seg;
    reg [3:0] hex_in;
    reg [6:0] esperado;
    wire [6:0] segments;
    
    hex_to_7seg dut(.hex(hex_in), .segments(segments));
    
    initial begin
        $display("Teste do decoder");

        hex_in = 4'b0000;
        esperado = 7'b1111110;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0001;
        esperado = 7'b0110000;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0010;
        esperado = 7'b1101101;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0011;
        esperado = 7'b1111001;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0100;
        esperado = 7'b0110011;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0101;
        esperado = 7'b1011011;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0110;
        esperado = 7'b1011111;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b0111;
        esperado = 7'b1110000;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1000;
        esperado = 7'b1111111;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1001;
        esperado = 7'b1111011;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1010;
        esperado = 7'b1110111;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1011;
        esperado = 7'b0011111;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1100;
        esperado = 7'b1001110;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1101;
        esperado = 7'b0111101;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1110;
        esperado = 7'b1001111;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");

        hex_in = 4'b1111;
        esperado = 7'b1000111;
		#10;
        $display("esperado=%b | obtido=%b | %s", esperado, segments, (segments == esperado) ? "OK" : "ERRO");
        
        $display("Fim dos testes");
        $finish;
    end
endmodule