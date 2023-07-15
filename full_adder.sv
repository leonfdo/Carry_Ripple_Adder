module full_adder(
    input logic a, b, cin,
    output logic sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = a & b | cin & (a ^ b);
endmodule


module n_bit_adder #(parameter n=4)(
    input logic signed[n-1:0] a, b,
    input logic cin,
    output logic signed[n-1:0] sum,
    output logic cout
);
    logic c[n:0];
    genvar i;

    assign c[0] = cin;
    assign cout = c[n];

    generate
        for (i = 0; i < n; i = i + 1) begin : add
            full_adder fa (.a(a[i]), .b(b[i]), .cin(c[i]), .sum(sum[i]), .cout(c[i+1]));
        end
    endgenerate
endmodule


module n_adder_test();
    timeunit 10ns;
    timeprecision 1ps;
    localparam n = 8;

    logic signed [n:0] a, b, sum;
    logic cin, cout;

    n_bit_adder #(.n(n)) dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        a <= 8'd10;
        b <= 8'd8;
        cin <= 0;
        #10;
		  a <= 8'd5;
        b <= 8'd6;
        cin <= 0;
        #10;
		  a <= 8'd2;
        b <= 8'd3;
        cin <= 1;
        #10;
		  
	repeat (10) begin
    #9;
    cin = $random;
    a = $random % 256 - 128;
    b = $random % 256 - 128;
    #2;

	end
    end
endmodule