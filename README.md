# Assembley-Calculator
Assembly Calculator & Base Converter
Overview
This project is an 8086 assembly language program that provides two main functionalities:

A calculator supporting arithmetic and logical operations

A base conversion tool for decimal, hexadecimal, and binary numbers

The program features a menu-driven interface with color output and flag status display.

Features
Calculator Operations
Arithmetic Operations:

Addition (+)

Subtraction (-)

Multiplication (*)

Division (/)

Logical Operations:

AND (&)

OR (|)

XOR (x)

NAND (n)

NOR (o)

Base Conversion
Decimal ↔ Hexadecimal

Decimal ↔ Binary

Binary ↔ Hexadecimal

Additional Features
Flag status display (CF, PF, AF, ZF, SF, OF)

Color-coded output

Input validation

Clear screen functionality

Interactive menu system

Requirements
DOSBox or similar x86 emulator

MASM or compatible assembler

Usage
Assemble the program with MASM:

masm calculator.asm;
link calculator;
Run the executable in DOSBox:

calculator.exe
Main Menu Options
C: Enter calculator mode

B: Enter base conversion mode

Technical Details
Uses DOS interrupts for I/O operations

Implements conversion algorithms for different bases

Displays processor flags after operations

Includes error handling for invalid inputs



License
This project is open source under the MIT License.

Contributing
Contributions are welcome! Please fork the repository and submit pull requests.

Author
Benallal Amine
