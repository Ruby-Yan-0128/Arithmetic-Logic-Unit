`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2026 11:39:28 AM
// Design Name: 
// Module Name: calculator_top
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


module calculator_top(
input logic [3:0] op1, 
input logic [3:0] op2, 
input logic sign, 
input logic operation,
input logic clk, 
output logic [6:0] segBits, 
output logic [3:0] trigger
    );
    // Internal Signals 
    logic [19:0] result; 
    logic [3:0] numberBits [0:3];
    logic [6:0] displayBits [0:3];
    
    miniALU calculation(.op1(op1), .op2(op2), .operation(operation), .sign(sign), .result(result));
    displayEncoder encoder(.result(result), .numberBits(numberBits));
    
    // print each digit
    sevenSegDigit ones(.digit(numberBits[0]), .displayBits(displayBits[0]));
    sevenSegDigit tens(.digit(numberBits[1]), .displayBits(displayBits[1])); 
    sevenSegDigit hundreds(.digit(numberBits[2]), .displayBits(displayBits[2]));
    sevenSegDigit thousands(.digit(numberBits[3]), .displayBits(displayBits[3]));
    
    seg_driver DUT1 (.displayBits(displayBits), .clk(clk), .trigger(trigger), .segBits(segBits));
endmodule
