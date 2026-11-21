`timescale 1ns / 1ns

module displayEncoder(
    input [19:0] result, 
    output logic [3:0] numberBits[0:3]

    );
    always_comb begin
        // kth element of array numberBits[k] = (result / 10^k) % 10
        numberBits[0] = (result / 1) % 10; // ones 
        numberBits[1] = (result / 10) % 10; // tens 
        numberBits[2] = (result / 100) % 10; // hundreds
        numberBits[3] = (result / 1000) % 10; // thousands
    end 
endmodule
