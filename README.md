# Mini 4-Bit Arithmetic Logic Unit

A SystemVerilog mini ALU for an FPGA that performs addition, subtraction, left shift, or logical right shift on two 4-bit inputs. The calculated result is split into decimal digits and displayed on a four-digit seven-segment display.

Inspired by UCLA IEEE DAV Lab 1: <https://projects.ieeebruins.com/>.

## Features

- Two 4-bit operands (`op1` and `op2`)
- 20-bit result output
- Addition and subtraction
- Left shift and right shift
- Decimal conversion and seven-segment encoding
- Multiplexed four-digit display
- Vivado constraints for the Basys 3 FPGA board
- Standalone testbenches for the ALU and display pipeline

## Operation Selection

The `operation` and `sign` inputs select the function:

| `operation` | `sign` | Operation | Expression |
|---|---|---|---|
| `0` | `0` | Addition | `op1 + op2` |
| `0` | `1` | Subtraction | `op1 - op2` |
| `1` | `0` | Left shift | `op1 << op2` |
| `1` | `1` | Right shift | `op1 >>> op2` |

Because the operands are 4 bits wide, shift counts and operand values range from `0` to `15`. The shift implementation uses SystemVerilog arithmetic right shift; with an unsigned 4-bit `op1`, this is equivalent to a logical right shift.

## Repository Structure

```text
calculator_top.sv  Top-level module connecting the ALU and display modules
miniALU.sv         ALU implementation
miniALU_tb.sv      Testbench for all four ALU operations
displayEncoder.sv  Splits a result into four decimal digits
display_tb.sv      Testbench for decimal and seven-segment conversion
sevenSegDigit.sv   Maps one digit to seven-segment cathode patterns
seg_driver.sv      Time-multiplexes the four seven-segment digits
PinMap.xdc         Basys 3 pin assignments and clock constraint
```

## Hardware Requirements

- AMD/Xilinx Vivado
- A Basys 3 FPGA board, or a compatible board with modified constraints
- USB cable for board programming
- A four-digit seven-segment display connected according to `PinMap.xdc`

The supplied constraints use 3.3 V LVCMOS signals and a 100 MHz system clock connected to `W5`.

## Setup in Vivado

1. Clone the repository:

   ```bash
   git clone https://github.com/Ruby-Yan-0128/Arithmetic-Logic-Unit.git
   cd Arithmetic-Logic-Unit
   ```

2. Create a Vivado project and select a Basys 3-compatible FPGA part.

3. Add these sources:

   - `calculator_top.sv`
   - `miniALU.sv`
   - `displayEncoder.sv`
   - `sevenSegDigit.sv`
   - `seg_driver.sv`

4. Add `PinMap.xdc` as the constraints file.

5. Set `calculator_top` as the top-level module.

6. Run synthesis and implementation, generate the bitstream, and program the FPGA.

> The two testbench files should not be included in a synthesis top-level design. They are for simulation only.

## Usage

Set the operand switches or other board inputs to the desired 4-bit values:

- `op1[3:0]`: first 4-bit operand
- `op2[3:0]`: second operand or shift count
- `operation`: select arithmetic (`0`) or shift (`1`)
- `sign`: select addition/left shift (`0`) or subtraction/right shift (`1`)

For example:

| Inputs | Result |
|---|---:|
| `op1 = 7`, `op2 = 5`, addition | `12` |
| `op1 = 7`, `op2 = 5`, subtraction | `2` |
| `op1 = 7`, `op2 = 1`, left shift | `14` |
| `op1 = 7`, `op2 = 1`, right shift | `3` |

The `result` is converted into ones, tens, hundreds, and thousands digits, then time-multiplexed across the display.

## Running the Testbenches

In Vivado, add the required testbench and implementation modules to a simulation project.

### ALU testbench

Add `miniALU.sv` and `miniALU_tb.sv`, set `miniALU_tb` as the simulation top, and run behavioral simulation. The testbench exercises:

1. `7 + 5`
2. `7 - 5`
3. `7 << 5`
4. `7 >>> 5`

The terminal monitor prints the inputs and result at each step.

### Display testbench

Add `displayEncoder.sv`, `sevenSegDigit.sv`, and `display_tb.sv`, set `display_tb` as the simulation top, and run behavioral simulation. It converts `2345` and `6789` and monitors the resulting segment patterns.

## Pin Mapping

The supplied `PinMap.xdc` maps the design to the following Basys 3 signals:

- Clock: `W5`
- `operation`: `R3`
- `sign`: `T2`
- `op1`: `R2, T1, U1, W2`
- `op2`: `T3, V2, W13, W14`
- Seven-segment segments: `U7, V5, U5, V8, U8, W6, W7`
- Digit triggers: `U2, U4, V4, W4`

## Notes

- Subtraction is performed as unsigned 4-bit arithmetic. With `4'd7 - 4'd5`, for example, the module produces `2`; if the first operand is smaller, the 4-bit result wraps modulo 16.
- `displayEncoder` supports values up to 9999 in the displayed digits; the 20-bit result can still be larger, so only the ones through thousands positions are shown.
- Shift results are stored in a 20-bit `result`, so left shifts can represent values wider than 4 bits.
