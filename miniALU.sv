`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2026 10:54:36 AM
// Design Name: 
// Module Name: miniALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module miniALU(
    input [3:0] op1, 
    input [3:0] op2, 
    input operation, 
    input sign, 
    output logic [19:0] result

    );
    always_comb begin
        if (operation && ~sign) begin  // left shift
            result = op1 << op2;
        end else if (operation && sign) begin // right shift 
            result = op1 >>> op2; 
        end else if (~operation && ~sign) begin    // addition
            result = op1 + op2;     
        end else if (~operation && sign) begin     // subtraction
            result = op1 - op2;
        end 
     end 
endmodule
