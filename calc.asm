.MODEL SMALL  
.STACK 100H   
 

.DATA       
    buffer DB 6  ; Buffer for user input (max 5 digits + null terminator)
    op DW ?      
    op2 DW ?
    VALEUR DW ?
    con DW ?     
    operation DW ?
    dividend DW ?
    divisor DW ?  
    result DW ?
    remainder DW ?
    
    binary_input DB 17, 0, 17 DUP('$')  ; Max 16 chars + CR
    hex_input DB 5, 0, 5 DUP('$')       ; Max 4 chars + CR
    binary_output DB 17 DUP('$')        ; 16 bits + null
    hex_output DB 5 DUP('$')            ; 4 digits + null
    conversion_type DB 0                ; 1=bin2hex, 2=hex2bin
    prompt_bin_to_hex DB 0DH, 0AH, "        Enter a binary number (up to 16 bits): $"
    ligne DB 0DH,0AH, "--------------------------------------------------------------------------------$"
    opmode DB 0DH, 0AH, "                     |  SELECT CONVERSION TYPE: |", 0DH, 0AH
                DB "                     |1:  DECIMAL               |", 0DH, 0AH
                DB "                     |2:  HEXADECIMAL           |", 0DH, 0AH
                DB "                     |3:  BINARY                |", 0DH, 0AH
                DB "                     |ENTER YOUR CHOICE:        |$"
    option DB 0DH,0AH, "                ENTER C FOR CALCULATION OR B FOR BASE CONVERSION$"
    msg DB 0DH, 0AH, "PRESS Q TO QUIT OR ANY OTHER KEY TO CONTINUE$" 
    errmsg DB 0DH,0AH, 'Error: Division by zero $' ; Error message
    prompt DB 0DH, 0AH, "ENTER AN OPERATION < +, /, *, -, &, |, x, n, o> : $"
    
    andmsg DB  "AND SELECTED! $"
    ormsg DB  "OR SELECTED! $"
    xormsg DB "XOR SELECTED! $"
    nandmsg DB  "NAND SELECTED! $"
    normsg DB  "NOR SELECTED! $"
    
    divmsg DB 'DIVISION SELECTED! $'   ; Message for division  
    inv DB  "INVALID SELECTION! $"   
    prompt1 DB "ENTER OPERAND 1 : $"
    prompt2 DB "ENTER OPERAND 2 : $"  
    prompt3 DB "RESULT - DECIMAL = $"  
    addmsg DB "ADDITION SELECTED! $"  
    submsg DB "SUBTRACTION SELECTED! $"     
    mulmsg DB "MULTIPLICATION SELECTED! $"
    divzero DB 0DH,0AH, "ERROR: DIVISION BY ZERO! $" ; Division by zero error
    invalidnum DB 0DH,0AH, "ERROR: INVALID NUMBER! $" ; Invalid number error
    baseprompt DB 0DH, 0AH, "                     |  SELECT CONVERSION TYPE: |", 0DH, 0AH
                DB "                     |1: DECIMAL TO HEXADECIMAL |", 0DH, 0AH
                DB "                     |2: HEXADECIMAL TO DECIMAL |", 0DH, 0AH
                DB "                     |3: DECIMAL TO BINARY      |", 0DH, 0AH
                DB "                     |4: BINARY TO DECIMAL      |", 0DH, 0AH
                DB "                     |5: BINARY TO HEXADECIMAL  |", 0DH, 0AH
                DB "                     |6: HEXADECIMAL TO BINARY  |", 0DH, 0AH
                DB "                     |ENTER YOUR CHOICE:        |$"
    binmsg DB "BINARY SELECTED! $"
    decmsg DB  "DECIMAL SELECTED! $"
    hexmsg DB "HEXADECIMAL SELECTED! $"
    negmsg DB  "NEGATIVE NUMBER DETECTED! $"
    invalidbase DB  "ERROR: INVALID BASE SELECTION! $"     
    msg1 db 0Dh, 0Ah , 'INIT FLAGS', 0Dh, 0Ah, '$'  ; Message to print
    flags_str db 13,10,'Displaying The Flags:  CF   PF   AF   ZF   SF   OF',13,10,'$'
    
    flag_values db 32 dup(?)
    num DW 13       ; Number to convert (change this as needed)
    binary DB 16 DUP(' '), '$'  ; Store binary result (16-bit max)
    newline DB 0DH, 0AH, '$'    ; Newline for formatting
    hex_msg db 10,13,'Enter a hexadecimal number (1 to 4 digits): $'
    dec_msg db 10,13,'Enter a decimal number (0 to 65535): $'
    result_msg db 10,13,'The result is: $'
    invalid_msg db 10,13,'Invalid input!$'
    again_msg db 10,13,'Do you want to do it again (Y/N)? $'
    buffer2 db 6 dup('$')  ; Buffer for result
    hex db 5, ?, 5 dup('$')  ; Buffer for hexadecimal input
    dec_num dw 0  ; Variable to store decimal number
    
    prompt_bin_to_dec db 0DH, 0AH, 'enter binary number (16 bits max): $'
    decimal_result dw 0 
    
    hex_result_msg DB "HEXADECIMAL: $"
    bin_result_msg DB "BINARY: $"
    
    operand1_msg DB  'Operand 1 - DECIMAL: $'
    operand2_msg DB  'Operand 2 - DECIMAL: $'
    VALUE2 dw 0   ; Buffer to store the decimal string (7 digits + terminator)
    
    
.CODE
MAIN PROC
START:
    
    MOV AX, @data
    MOV DS, AX  
    
   
    
    mov dx, offset msg1
    mov ah, 09h
    int 21h

    ; Push flags
    pushf
    pop ax  ; AX now contains the flag register

    ; Check each flag and store '1' or '0' in flag_values
    mov cx, 9  ; Number of flags to check
    lea si, flag_values  ; Pointer to flag storage
    

    CALL check_flags

 

     MOV DX, OFFSET ligne 
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET option 
    MOV AH, 09H
    INT 21H  
    MOV DX, OFFSET ligne 
    MOV AH, 09H
    INT 21H
    
    ; Read operation
    MOV AH, 01H  
    INT 21H      
    MOV buffer, AL 
    
    CMP buffer ,'C'
    JE JUMP_CALC    
    
    CMP buffer ,'c'
    JE JUMP_CALC
    
    CMP buffer ,'B'
    JE JUMP_BASE
    
    CMP buffer , 'b'
    JE JUMP_BASE  
    CALL CLEAR_SCREEN  ; Clear the screen
    JMP JUMP_INV
    
JUMP_CALC: 
    JMP  CALCUL
JUMP_BASE: 
    JMP  BASE 
    
 
JUMP_INV:
    CALL CLEAR_SCREEN  ; Clear the screen
    MOV DX, OFFSET inv
    MOV AH, 09H
    INT 21H
    JMP START

CALCUL:

    ; Prompt for operation
    MOV DX, OFFSET prompt
    MOV AH, 09H
    INT 21H  

    ; Read operation
    MOV AH, 01H  
    INT 21H      
    MOV buffer, AL  

    ; Check if the operation is valid
    CMP buffer, '+'  
    JE JUMP_ADDITION
    CMP buffer, '*'  
    JE JUMP_MULTIPLICATION
    CMP buffer, '-'  
    JE SUBTRACTION
    CMP buffer, '/'  ; Check for division operator
    JE JUMP_DIVISION 

    CMP buffer, '&'
    JE JUMP_AND
    CMP buffer, '|'
    JE JUMP_OR
    CMP buffer, 'x'
    JE JUMP_XOR
    CMP buffer, 'n'
    JE JUMP_NAND
    CMP buffer, 'o'
    JE JUMP_NOR
    
JUMP_ADDITION:
    JMP ADDITION
JUMP_MULTIPLICATION:
    JMP MULTIPLICATION 
JUMP_DIVISION:
    JMP DIVISION

JUMP_AND:
    JMP AND_OP
JUMP_OR:
    JMP OR_OP
JUMP_XOR:
    JMP XOR_OP
JUMP_NAND:
    JMP NAND_OP
JUMP_NOR:
    JMP NOR_OP

    ; If invalid, print error message and restart
    MOV si, OFFSET inv
    mov bl, 0Ch             ; Light red (0Ch) for errors
call PrintColorText
    JMP START 
    
SUBTRACTION:
    ; Print "SUBTRACTION SELECTED!" in yellow
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET submsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
    
    ; Ask for operation mode (decimal/hex/binary)
    MOV DX, OFFSET opmode
    MOV AH, 09H
    INT 21H
    MOV AH, 01H  
    INT 21H      
    MOV buffer, AL  

    ; Prompt for operand 1
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET prompt1
    MOV AH, 09H   
    INT 21H  

    ; Read operand 1 (decimal/hex/binary)
    CMP buffer, '1'
    je deci
    CMP buffer, '3'
    JE bin
    CMP buffer, '2'
    JE hex1

bin:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP1

hex1:
    CALL hex_to_dec2
    jmp OP1
    
deci:
    CALL ReadNumber

OP1:   
    mov AX, VALEUR 
    MOV op, AX
    MOV si, OFFSET operand1_msg
    CALL DisplayOperand 

    ; Prompt for operand 2
    MOV DX, OFFSET prompt2
    MOV AH, 09H   
    INT 21H    

    ; Read operand 2 (same mode as operand 1)
    CMP buffer, '1'
    je deci2
    CMP buffer, '3'
    JE bin2
    CMP buffer, '2'
    JE hex2

bin2:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP

hex2:
    CALL hex_to_dec2
    jmp OP

deci2:
    CALL ReadNumber
   
OP: 
    mov AX, VALEUR
    MOV op2, AX
    
    MOV si, OFFSET operand2_msg
    CALL DisplayOperand
    
    ; Perform subtraction
    MOV AX, op  
    SUB AX, op2  
    MOV operation, AX  

    ; Print "RESULT=" in light green
    MOV si, OFFSET prompt3
    mov bl, 0Ah             ; Light green
    call PrintColorText
    
    ; Print decimal result
    MOV AX, operation 
    MOV con, AX
    CALL PrintNumber3
    
    ; Print newline
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    
    ; Print hex result in light green
    MOV si, OFFSET hex_result_msg
    mov bl, 0Ah
    call PrintColorText
    MOV AX, operation
    CALL PrintHex
    
    ; Display flags
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    pushf
    pop ax
    CALL check_flags

    ; Ask the user to continue or exit
    MOV DX, OFFSET msg 
    MOV AH, 09H
    INT 21H  

    MOV AH, 01H  ; Wait for key press
    INT 21H      
    CMP AL, 'Q'  ; Check if user wants to exit
    JE JUMP_SKIP3
    CMP AL, 'q'  ; Check if user wants to exit
    JE JUMP_SKIP3
    JMP START    ; Repeat the program
    ;------------------------------------------
      
JUMP_SKIP3:
    JMP EXIT_PROGRAM

    ; Print the result
    MOV AX, operation
    CALL PrintNumber 

ADDITION:
    ; Print "ADDITION SELECTED!"
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET addmsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
        
    MOV DX, OFFSET opmode
    MOV AH, 09H
    INT 21H
    MOV AH, 01H  
    INT 21H      
    MOV buffer, AL  
    
    ; Prompt for operand 1
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET prompt1
    MOV AH, 09H   
    INT 21H  

    ; Read operand 1 based on selected type
    CMP buffer, '1'
    JE deci4
    CMP buffer, '3'
    JE bin4
    CMP buffer, '2'
    JE hex4

bin4:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP4

hex4:
    CALL hex_to_dec2
    JMP OP4
    
deci4:
    CALL ReadNumber

OP4:   
    mov AX, VALEUR 
    MOV op, AX
    
    MOV si, OFFSET operand1_msg
    CALL DisplayOperand
    
    ; Prompt for operand 2
    MOV DX, OFFSET prompt2
    MOV AH, 09H   
    INT 21H    

    ; Read operand 2 based on selected type
    CMP buffer, '1'
    JE deci3
    CMP buffer, '3'
    JE bin3
    CMP buffer, '2'
    JE hex3

bin3:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP3

hex3:
    CALL hex_to_dec2
    JMP OP3

deci3:
    CALL ReadNumber
   
OP3: 
    mov AX, VALEUR
    MOV op2, AX   
    MOV si, OFFSET operand2_msg
    CALL DisplayOperand
    
   MOV AX, op  
    ADD AX, op2  
    MOV operation, AX  

    ; Print "RESULT="
    MOV si, OFFSET prompt3
    mov bl, 0Ah
    call PrintColorText
    
    ; Print the result
    MOV AX, operation 
    MOV con, AX
    CALL PrintNumber2
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    MOV AX, operation 
    MOV con, AX
    CALL dectobin
     MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    
    ; Print hex result
    MOV si, OFFSET hex_result_msg
    mov bl, 0Ah
    call PrintColorText
    MOV AX, operation
    CALL PrintHex
    
    ; Display flags (only once)
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    pushf
    pop ax
    CALL check_flags
    ; Ask the user to continue or exit
    MOV DX, OFFSET msg 
    MOV AH, 09H
    INT 21H
        
    MOV AH, 01H  ; Wait for key press
    INT 21H      
    CMP AL, 'Q'  ; Check if user wants to exit
    JE JUMP_SKIP
    CMP AL, 'q'  ; Check if user wants to exit
    JE JUMP_SKIP
    JMP START    ; Repeat the program
      
JUMP_SKIP:
    JMP EXIT_PROGRAM
DIVISION:
    ; Print "DIVISION SELECTED!"
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET divmsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText

    MOV DX, OFFSET opmode
    MOV AH, 09H
    INT 21H
    MOV AH, 01H  
    INT 21H      
    MOV buffer, AL  
    ; Prompt for operand 1
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET prompt1
    MOV AH, 09H   
    INT 21H  
          
    CMP buffer , '1'
    JE deci6
    CMP buffer , '3'
    JE bin6
    CMP buffer , '2'
    JE hex6
bin6:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
   
    JMP OP6
hex6:
    CALL hex_to_dec2
    
    jmp OP6
   
deci6:
    CALL ReadNumber
OP6: 
    mov AX,VALEUR
    MOV dividend, AX 
   
    MOV si, OFFSET operand1_msg
    CALL DisplayOperand 
     
    MOV op, AX
    ; Prompt for operand 2
    MOV DX, OFFSET prompt2
    MOV AH, 09H   
    INT 21H
    
    ; Read operand 2
    CMP buffer , '1'
    JE deci5
    CMP buffer , '3'
    JE bin5
    CMP buffer , '2'
    JE hex5
bin5:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP5
hex5:
    CALL hex_to_dec2
    
    jmp OP5
deci5:
   CALL ReadNumber
   
OP5: 
    mov AX,VALEUR
    MOV divisor, AX
    
    MOV si, OFFSET operand2_msg
    CALL DisplayOperand 
    
    ;Perform division
    MOV AX, dividend  
    XOR DX, DX
    DIV divisor
    MOV result, AX       ; Store quotient
    MOV remainder, DX    ; Store remainder 

    ; Print "RESULT="
    MOV si, OFFSET prompt3
    mov bl, 0Ah
    call PrintColorText

    ; Print the result
     ; Print the result
    MOV AX, result
     
    MOV con, AX
    CALL PrintNumber2
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    MOV AX, con 
    MOV operation, AX
    CALL dectobin
     MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    
    ; Print hex result
    MOV si, OFFSET hex_result_msg
    mov bl, 0Ah
    call PrintColorText
    MOV AX, con
    CALL PrintHex

    mov dx, offset msg1
    mov ah, 09h
    int 21h

    ; Push flags
    pushf
    pop ax  ; AX now contains the flag register

    ; Check each flag and store '1' or '0' in flag_values
    mov cx, 9  ; Number of flags to check
    lea si, flag_values  ; Pointer to flag storage
   
    CALL check_flags

    ; Ask the user to continue or exit
    MOV DX, OFFSET msg
    MOV AH, 09H
    INT 21H     

    MOV AH, 01H  ; Wait for key press
    INT 21H      
    
    ; Ask the user to continue or exit
      

    MOV AH, 01H  ; Wait for key press
    INT 21H      
    CMP AL, 'Q'  ; Check if user wants to exit
    JE JUMP_SKIP1
    CMP AL, 'q'  ; Check if user wants to exit
    JE JUMP_SKIP1
    JMP START    ; Repeat the program
      
JUMP_SKIP1:
    JMP EXIT_PROGRAM
    
MULTIPLICATION:
    ; Print "MULTIPLICATION SELECTED!"
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET mulmsg
   mov bl, 0Eh             ; Yellow color
    call PrintColorText
       
    MOV DX, OFFSET opmode
    MOV AH, 09H
    INT 21H
    MOV AH, 01H  
    INT 21H      
    MOV buffer, AL  
    ; Prompt for operand 1
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET prompt1
    MOV AH, 09H   
    INT 21H  

    ; Read operand 1
    CMP buffer , '1'
    je deci7
    CMP buffer , '3'
    JE bin7
    CMP buffer , '2'
    JE hex7
bin7:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP7
hex7:
    CALL hex_to_dec2
    
    jmp OP7
   
deci7:
    CALL ReadNumber
OP7:   
    mov AX,VALEUR 
    MOV op, AX
    MOV si, OFFSET operand1_msg
    CALL DisplayOperand
    ; Prompt for operand 2
    MOV DX, OFFSET prompt2
    MOV AH, 09H   
    INT 21H    

    ; Read operand 2
     
    CMP buffer , '1'
    je deci8
    CMP buffer , '3'
    JE bin8
    CMP buffer , '2'
    JE hex8
bin8:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JMP OP8
hex8:
    CALL hex_to_dec2
    
    jmp OP8
deci8:
   CALL ReadNumber
   
OP8: 
   
    mov AX,VALEUR
    mov op2,AX
    MOV si, OFFSET operand2_msg
    CALL DisplayOperand
    MOV AX, op
    MUL op2  
    MOV operation, AX  

    ; Print "RESULT="
    MOV si, OFFSET prompt3
    mov bl, 0Ah
    call PrintColorText
    
    ; Print the result
    MOV AX, operation 
    MOV con, AX
    CALL PrintNumber2
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    MOV AX, operation 
    MOV con, AX
    CALL dectobin
     MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H 
    
    ; Print hex result
    MOV si, OFFSET hex_result_msg
    mov bl, 0Ah
    call PrintColorText
    MOV AX, operation
    CALL PrintHex
    
    ; Display flags (only once)
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    pushf
    pop ax
    CALL check_flags
    
    ; Ask the user to continue or exit
    MOV DX, OFFSET msg
    MOV AH, 09H
    INT 21H     

    MOV AH, 01H  ; Wait for key press
    INT 21H  
        
    CMP AL, 'Q'  ; Check if user wants to exit
    JE JUMP_SKIP2
    CMP AL, 'q'  ; Check if user wants to exit
    JE JUMP_SKIP2
    JMP START    ; Repeat the program
      
JUMP_SKIP2:
    JMP EXIT_PROGRAM

DivisionByZeroError:
    ; Print error message
    MOV si, OFFSET errmsg
 mov bl, 0Ch             ; Light red (0Ch) for errors
call PrintColorText

    ; Exit program
    MOV AH, 4CH
    INT 21H 
        JMP EXIT_PROMPT
AND_OP:
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
    mov si, OFFSET andmsg   
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
     
    call ReadOperands
    mov ax, op
    and ax, op2
    mov operation, ax

    call DisplayResultAndFlags
    jmp AskContinue

OR_OP:
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET ormsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
      
    CALL ReadOperands

    MOV AX, op  
    OR AX, op2  
    MOV operation, AX  

    CALL DisplayResultAndFlags
    JMP AskContinue
XOR_OP:
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET xormsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
        
    CALL ReadOperands

    MOV AX, op  
    XOR AX, op2  
    MOV operation, AX  

    CALL DisplayResultAndFlags
    JMP AskContinue
NAND_OP:
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET nandmsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
        
    CALL ReadOperands

    MOV AX, op  
    AND AX, op2  
    NOT AX  
    MOV operation, AX  

    CALL DisplayResultAndFlags
    JMP AskContinue
NOR_OP:
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
    MOV si, OFFSET normsg
   mov bl, 0Eh             ; Yellow color
    call PrintColorText
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
        
    CALL ReadOperands

    MOV AX, op  
    OR AX, op2  
    NOT AX  
    MOV operation, AX  

    CALL DisplayResultAndFlags
    JMP AskContinue
    
BASE:
    ; Prompt for base selection
    MOV DX, OFFSET baseprompt
    MOV AH, 09H
    INT 21H

    ; Read base selection
    MOV AH, 01H
    INT 21H
    MOV buffer, AL

    ; Check base selection
    CMP buffer, '1'
    JE DEC_HEX
    CMP buffer, '2'
    JE HEX_DEC
    CMP buffer, '3'
    JE DEC_BIN
    CMP buffer, '4'
    JE BIN_TO_DEC
    CMP buffer, '5'
    JE BIN_TO_HEX
    CMP buffer, '6'
    JE HEXADECIMAL_SELECTED_jump
    JMP INV
DEC_HEX:
    JMP dec_to_hex
HEX_DEC:
    JMP hex_to_dec
DEC_BIN:
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET dec_msg
    MOV AH, 09H
    INT 21H
    ;mov bl, 0Eh             ; Yellow color
    ;call PrintColorText
      
    CALL ReadNumber
    MOV AX , VALEUR
    mov bl, 0Eh 
    MOV si, OFFSET bin_result_msg
    mov bl, 0Ah  
    call PrintColorText
    
    CALL dectobin2
    
    JMP EXIT_PROMPT
HEXADECIMAL_SELECTED_jump:
    JMP HEXADECIMAL_SELECTED

BIN_TO_HEX:
    MOV [conversion_type], 1    ; Set conversion type
    ; Prompt for binary input
    MOV AH, 09H
    LEA DX, prompt_bin_to_hex
    INT 21H

    ; Read binary input
    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    ; Validate and convert binary to hex
    MOV si, OFFSET hex_result_msg
    mov bl, 0Ah  
    call PrintColorText
    CALL BINARY_TO_HEX
    JC INVALID_INPUT_JUMP
    JMP DISPLAY_RESULT
INV:   
    ; Invalid base selection
    MOV DX, OFFSET invalidbase
    MOV AH, 09H
    INT 21H
    JMP BASE
INVALID_INPUT_JUMP:
    JMP INVALID_INPUT
BIN_TO_DEC:
    MOV [conversion_type], 4    
    MOV AH, 09H
    LEA DX, prompt_bin_to_dec
    INT 21H

    MOV AH, 0AH
    LEA DX, binary_input
    INT 21H

    CALL BINARY_TO_DEC
    JC INVALID_INPUT      
    
    MOV si, OFFSET prompt3
    mov bl, 0Ah             ; Light green (0Ah) for success
    call PrintColorText
    MOV DX, OFFSET newline 
    MOV AH, 09H
    INT 21H
    mov bl, 07h
    MOV AX, [decimal_result]
    CALL PrintNumber2
    JMP EXIT_PROMPT
DECIMAL_SELECTED:
    ; Print "DECIMAL SELECTED!"
    MOV si, OFFSET decmsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
      
    JMP PRINT_RESULT_DECIMAL  
    
BINARY_SELECTED:
    ; Print "DECIMAL SELECTED!"
    MOV si, OFFSET binmsg
    mov bl, 0Eh             ; Yellow color
    call PrintColorText
      
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    CALL ReadNumber
    CALL FAR PTR dectobin
    JMP START
 
HEXADECIMAL_SELECTED:
    ; Print "HEXADECIMAL SELECTED!"
    
    JMP PRINT_RESULT_HEXADECIMAL2

PRINT_RESULT_DECIMAL:
    ; Print "RESULT="
    MOV si, OFFSET prompt3
   mov bl, 0Ah             ; Light green (0Ah) for success
call PrintColorText

PRINT_POSITIVE_DECIMAL:
    ; Print the result in decimal
    MOV AX, operation
    CALL PrintNumber
    JMP EXIT_PROMPT

PRINT_POSITIVE_BINARY:
    ; Print the result in binary
    MOV AX, operation
    CALL PrintBinary
    JMP EXIT_PROMPT

PRINT_RESULT_HEXADECIMAL:
    CALL hex_to_dec
    
    JMP EXIT_PROMPT
PRINT_RESULT_HEXADECIMAL2:
    CALL hex2bin
    
    JMP EXIT_PROMPT
 
PRINT_POSITIVE_HEXADECIMAL:
    ; Print the result in hexadecimal
    MOV AX, operation
    ;CALL PrintHexadecimal
    JMP EXIT_PROMPT
    
INVALID_INPUT:
    ; Display invalid message
    MOV AH, 09H
    LEA DX, invalid_msg
    INT 21H
EXIT_PROMPT:
   
    CMP AH , 'Q'
    JE EXIT_PROGRAM
    CMP AH , 'q'
    JE EXIT_PROGRAM
    JMP START  ; Check if user wants to exit
    
EXIT_PROGRAM:
    ; Exit program
    MOV AH, 4CH
    INT 21H  

AskContinue:
    MOV DX, OFFSET msg 
    MOV AH, 09H
    INT 21H  
    MOV AH, 01H
    INT 21H      
    CMP AL, 'Q'
    JE EXIT_PROGRAM
    CMP AL, 'q'
    JE EXIT_PROGRAM
    JMP START

    MAIN ENDP;====================================================================================== main end

;------------------------------------------------------------
; ReadNumber: Reads a multi-digit number from the user  
;------------------------------------------------------------

ReadNumber PROC
    XOR BX, BX   ; BX = 0 (stores the final number)

ReadLoop:
    MOV AH, 01H  ; Read a character
    INT 21H
    CMP AL, 0DH  ; Check if Enter (Carriage Return)
    JE DoneReading

    SUB AL, '0'  ; Convert ASCII to number
    MOV AH, 0    ; Clear high byte
    PUSH AX      ; Store digit temporarily

    MOV AX, BX   ; Load accumulated number
    MOV CX, 10   ; Prepare for multiplication
    MUL CX       ; AX = AX * 10
    POP DX       ; Retrieve last digit
    ADD AX, DX   ; Add digit to number
    MOV BX, AX   ; Store updated number in BX

    JMP ReadLoop  ; Repeat until Enter is pressed

DoneReading:
    MOV AX, BX
    MOV VALEUR , AX   ; Store final number in AX
    RET

ReadNumber ENDP

;------------------------------------------------------------
; Procedure to convert a decimal number to binary and print it
;------------------------------------------------------------ 

dectobin5 PROC
    MOV si, OFFSET bin_result_msg
    mov bl, 0AH             ; Light green (0Ah) for success
    call PrintColorText 
    MOV AX, operation
    mov bl, 0AH 

    ; Point to the last position in the binary array
    LEA SI, binary + 15

    ; Set up the loop counter for 16 bits
    MOV CX, 16

convert_loop89:
    ; Clear DX before division
    MOV DX, 0

    ; Shift right (equivalent to division by 2)
    SHR AX, 1

    ; If Carry Flag = 0, store '0'
    JNC store_zero89

    ; Store '1' if Carry Flag is set
    MOV BYTE PTR [SI], '1'
    JMP next_bit8

store_zero89:
    ; Store '0'
    MOV BYTE PTR [SI], '0'

next_bit89:
    ; Move left in the array
    DEC SI

    ; Repeat for 16 bits
    LOOP convert_loop89

    ; Print the binary result
    MOV si, OFFSET binary
    
    mov bl, 0AH             ; Light green (0Ah) for success
    call PrintColorText
    ; Print a newline
    
    ; Return to the caller
    RET
dectobin5 ENDP

dectobin3 PROC
    MOV si, OFFSET bin_result_msg
    mov bl, 70h             ; Light green (0Ah) for success
    call PrintColorText 
    MOV AX, operation
    mov bl, 0Eh 

    ; Point to the last position in the binary array
    LEA SI, binary + 15

    ; Set up the loop counter for 16 bits
    MOV CX, 16

convert_loop8:
    ; Clear DX before division
    MOV DX, 0

    ; Shift right (equivalent to division by 2)
    SHR AX, 1

    ; If Carry Flag = 0, store '0'
    JNC store_zero8

    ; Store '1' if Carry Flag is set
    MOV BYTE PTR [SI], '1'
    JMP next_bit8

store_zero8:
    ; Store '0'
    MOV BYTE PTR [SI], '0'

next_bit8:
    ; Move left in the array
    DEC SI

    ; Repeat for 16 bits
    LOOP convert_loop8

    ; Print the binary result
    MOV si, OFFSET binary
   
    mov bl, 0Eh             ; Light green (0Ah) for success
    call PrintColorText
    ; Print a newline
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    ; Return to the caller
    RET
dectobin3 ENDP
    
dectobin PROC
    MOV si, OFFSET bin_result_msg
    mov bl, 0Ah             ; Light green (0Ah) for success
    call PrintColorText 
    MOV AX, operation
   
    ; Point to the last position in the binary array
    LEA SI, binary + 15

    ; Set up the loop counter for 16 bits
    MOV CX, 16

convert_loop:
    ; Clear DX before division
    MOV DX, 0

    ; Shift right (equivalent to division by 2)
    SHR AX, 1

    ; If Carry Flag = 0, store '0'
    JNC store_zero7

    ; Store '1' if Carry Flag is set
    MOV BYTE PTR [SI], '1'
    JMP next_bit

store_zero7:
    ; Store '0'
    MOV BYTE PTR [SI], '0'

next_bit:
    ; Move left in the array
    DEC SI

    ; Repeat for 16 bits
    LOOP convert_loop

    ; Print the binary result
    MOV si, OFFSET binary
    
    mov bl, 0Ah             ; Light green (0Ah) for success
    call PrintColorText
    ; Print a newline
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    ; Return to the caller
    RET
dectobin ENDP

dectobin2 PROC
    
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    ; Load the number into AX
    MOV AX, VALEUR
    ; Point to the last position in the binary array
    LEA SI, binary + 15
    ; Set up the loop counter for 16 bits
    MOV CX, 16

convert_loop2:
    
    MOV DX, 0
    ; Shift right (equivalent to division by 2)
    SHR AX, 1
    ; If Carry Flag = 0, store '0'
    JNC store_zero27

    ; Store '1' if Carry Flag is set
    MOV BYTE PTR [SI], '1'
    JMP next_bit2

store_zero27:
    ; Store '0'
    MOV BYTE PTR [SI], '0'

next_bit2:
    
    DEC SI

    LOOP convert_loop2

    MOV DX, OFFSET binary
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    RET
dectobin2 ENDP

hex2bin PROC
    
    CALL hex_to_dec2
    ;CALL PrintNumber2
    MOV AX , VALEUR
    PUSH AX
    PUSH BX
    ; Display result message
    mov si,  OFFSET hex_result_msg
    mov bl,0Ah
    CALL PrintColorText
    mov ah, 9
    
    mov dx,  OFFSET newline
    int 21h
    POP BX
    POP AX
    CALL dectobin2
    MOV AX ,VALEUR
 
    RET
hex2bin ENDP
;------------------------------------------------------------
; PrintNumber: Converts integer (AX) to ASCII and prints it
;------------------------------------------------------------  
PrintNumber20E PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; --- Store original number ---
    MOV SI, AX
    
    ; --- Set YELLOW color ---
    PUSH AX
    PUSH BX
    MOV AH, 09h
    MOV BH, 0
    MOV BL, 0Eh     ; Light green
    MOV CX, 5
    MOV AL, ' '     ; Dummy write to set color
    INT 10h
    POP BX
    POP AX
    ; --- Convert digits (store on stack) ---
    XOR CX, CX      ; Digit counter = 0
    MOV BX, 10      ; Divisor

ConvertLoop:
    XOR DX, DX
    DIV BX          ; AX = quotient, DX = remainder
    ADD DL, '0'     ; Convert to ASCII
    PUSH DX         ; Store digit
    INC CX          ; Digit count++
    TEST AX, AX
    JNZ ConvertLoop
    
    ; --- Print digits ---
PrintLoop:
    POP DX          ; Get digit
    MOV AH, 02h     ; DOS print char
    INT 21h
    LOOP PrintLoop
    
    ; --- Reset color ---
    MOV AH, 09h
    MOV BL, 07h     ; Light gray
    INT 10h
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
    PrintNumber20E ENDP

PrintNumber2 PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; --- Store original number ---
    MOV SI, AX
    
    ; --- Set green color ---
    PUSH AX
    PUSH BX
    MOV AH, 09h
    MOV BH, 0
    MOV BL, 0Ah     ; Light green
    MOV CX, 5
    MOV AL, ' '     ; Dummy write to set color
    INT 10h
    POP BX
    POP AX
    
    ; --- Convert digits (store on stack) ---
    XOR CX, CX      ; Digit counter = 0
    MOV BX, 10      ; Divisor
    
ConvertLoop9:
    XOR DX, DX
    DIV BX          ; AX = quotient, DX = remainder
    ADD DL, '0'     ; Convert to ASCII
    PUSH DX         ; Store digit
    INC CX          ; Digit count++
    TEST AX, AX
    JNZ ConvertLoop9
    
    ; --- Print digits ---
PrintLoop9:
    POP DX          ; Get digit
    MOV AH, 02h     ; DOS print char
    INT 21h
    LOOP PrintLoop9
    
    ; --- Reset color ---
    MOV AH, 09h
    MOV BL, 07h     ; Light gray
    INT 10h
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumber2 ENDP

PrintNumber PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; Store the number
    MOV BX, AX
    
    ; Set color (light green)
    MOV AH, 09h
    MOV BH, 0
    MOV BL, 0Ah
    MOV CX, 5
    INT 10h
    
    ; Handle negative numbers
    TEST BX, 8000H
    JZ POSITIVE_NUMBER
    ; Print negative sign
    MOV DL, '-'
    MOV AH, 02H
    INT 21H
    NEG BX
    
POSITIVE_NUMBER:
    ; Convert digits and push to stack
    XOR CX, CX      ; Digit counter
    MOV AX, BX
    MOV BX, 10      ; Divisor

CONVERT_LOOP:
    XOR DX, DX
    DIV BX          ; AX = quotient, DX = remainder
    ADD DL, '0'     ; Convert to ASCII
    PUSH DX         ; Store digit
    INC CX          ; Digit count++
    TEST AX, AX
    JNZ CONVERT_LOOP

    ; Print digits from stack
PRINT_LOOP:
    POP DX          ; Get digit
    MOV AH, 02H     ; Print character
    INT 21H
    LOOP PRINT_LOOP
    
    ; Print newline
    MOV AH, 09H
    MOV DX, OFFSET newline
    INT 21H
    
    ; Reset color to default
    MOV AH, 09h
    MOV BL, 07h
    INT 10h
    
    ; Print binary representation
    MOV AX, con
    CALL dectobin
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumber ENDP

DISPLAY_RESULT:
    ; Display result message
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    MOV AH, 09H
    LEA DX, hex_output
    INT 21H
    ;MOV AH, 4CH
    ;INT 21H
    ;CMP AX ,'Q'
    ;JE EXIT_PROJUMP
    ;JMP START
    ;EXIT_PROJUMP:
    JMP EXIT_PROMPT
;------------------------------------------------------------
; PrintBinary: Converts integer (AX) to binary and prints it
;------------------------------------------------------------
PrintBinary PROC
    MOV CX, 16       ; 16-bit binary representation
    MOV BX, AX       ; Copy AX (number) into BX for processing
    MOV SI, 0        ; Flag to track leading zeros

    ; Check if number is zero
    CMP BX, 0
    JNE PRINT_BITS
    MOV DL, '0'      ; Print '0' explicitly if BX is zero
    MOV AH, 02H
    INT 21H
    RET

PRINT_BITS:
    MOV DX, 0        ; Clear DX

BIT_LOOP:
    SHL BX, 1        ; Shift left (MSB to CF)
    JNC SKIP_PRINT   ; If CF is 0 and we haven't started, skip printing

    MOV SI, 1        ; Mark that we started printing
SKIP_PRINT:
    TEST SI, SI      ; If printing started, print the bit
    JZ CONTINUE_LOOP

    MOV DL, '0'      ; Default is 0
    JC SET_ONE       ; If CF is set, change to '1'
    JMP PRINT_CHAR

SET_ONE:
    MOV DL, '1'

PRINT_CHAR:
    MOV AH, 02H
    INT 21H

CONTINUE_LOOP:
    LOOP BIT_LOOP    ; Process next bit

    RET
PrintBinary ENDP

hex_to_dec2 PROC
    call clear_buffer

    ; Display message to enter hexadecimal number
    mov ah, 9
    lea dx, hex_msg
    int 21h

    ; Capture hexadecimal number as string
    mov ah, 0ah
    lea dx, hex
    int 21h

    ; Debug: Print the captured hexadecimal string
    mov ah, 9
    lea dx, hex+2
    int 21h

    ; Convert hexadecimal string to number
    lea si, hex+2        ; Point to the start of the hexadecimal string
    mov bh, [si-1]       ; Load the length of the string
    call hex2number      ; Convert to decimal
    mov VALEUR, ax       ; Store the result in VALEUR

    ; Debug: Print the decimal value stored in VALEUR
    ;mov dx, offset prompt3
    ;mov ah, 09h
    ;int 21h
    mov ax, VALEUR
    

    ; Exit the procedure
    ret
    hex_to_dec2 ENDP
;------------------------------------------------------------
; PrintHexadecimal: Converts integer (AX) to hexadecimal and prints it
;------------------------------------------------------------
hex_to_dec PROC
    call clear_buffer

    ; Display message to enter hexadecimal number
    mov ah, 9
    lea dx, hex_msg
    int 21h

    ; Capture hexadecimal number as string
    mov ah, 0ah
    lea dx, hex
    int 21h

    ; Convert hexadecimal string to number
    lea si, hex+2
    mov bh, [si-1]
    call hex2number
    mov dec_num, ax

    ; Convert number to decimal string to display
    lea si, buffer
    call number2string
    MOV ax , WORD PTR buffer2
    MOV VALEUR , AX
    ; Display result message
    ; Print "RESULT="
    MOV si, OFFSET prompt3
    mov bl, 0Ah             ; Light green (0Ah) for success
    call PrintColorText
    mov ah, 9
    MOV dx, OFFSET newline
    int 21h

    ; Display number as string
    mov ah, 9
    lea dx, buffer2
    int 21h

    JMP EXIT_PROMPT
hex_to_dec ENDP
;===============================================================================
hex_to_decop PROC
    call clear_buffer

    ; Display message to enter hexadecimal number
    mov ah, 9
    lea dx, hex_msg
    int 21h

    ; Capture hexadecimal number as string
    mov ah, 0ah
    lea dx, hex
    int 21h

    ; Convert hexadecimal string to number
    lea si, hex+2
    mov bh, [si-1]
    call hex2number
    mov dec_num, ax

    ; Convert number to decimal string to display
    lea si, buffer
    call number2string
    MOV ax , WORD PTR buffer2
    MOV VALEUR , AX
   
    ret
    hex_to_decop ENDP

dec_to_hex:
    call clear_buffer
    ; Display message to enter decimal number
    mov ah, 9
    lea dx, dec_msg
    int 21h

    ; Capture decimal number
    
     mov cx, 10
     mov bx, 0

input_loop:
    mov ah, 1
    int 21h
    cmp al, 13
    je input_end
    sub al, 48
    mov ah, 0
    push ax
    mov ax, bx
    mul cx
    mov bx, ax
    pop ax
    add bx, ax
    jmp input_loop

input_end:
    mov ax, bx
    mov cx, 16
    mov bx, 0

conversion_loop:
    div cx
    push dx
    mov dx, 0
    inc bl
    cmp ax, 0
    jne conversion_loop
    PUSH AX
    PUSH BX
    ; Display result message
    mov si,  OFFSET hex_result_msg
    mov bl,0Ah
    CALL PrintColorText
    mov ah, 9
    
    mov dx,  OFFSET newline
    int 21h
    POP BX
    POP AX
    mov ah, 9
    
    
    

output_loop:
    pop ax
    cmp al, 9
    jg output_hex
    add al, 48
    mov ah, 2
    mov dl, al
    int 21h
    inc bh
    cmp bh, bl
    jne output_loop
    JMP EXIT_PROMPT
    

output_hex:
    add al, 55
    mov ah, 2
    mov dl, al
    int 21h
    inc bh
    cmp bh, bl
    jne output_loop
    JMP EXIT_PROMPT


invalid_input:
    ; Display invalid input message
    mov ah, 9
    lea dx, invalid_msg
    int 21h
    
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;----------------------------------------------------------
; HEX_VALEUR_TO_DEC: Converts hex value in VALEUR to decimal string
; Input: 
;   VALEUR = Hexadecimal value to convert (0-FFFFh)
; Output:
;   buffer2 = Contains decimal string representation
;   Displays result on screen
;----------------------------------------------------------
;----------------------------------------------------------
; HEX_VALEUR_TO_DEC: Converts hex value in VALEUR to decimal string
; Input: 
;   VALEUR = Hexadecimal value to convert (0-FFFFh)
; Output:
;   buffer2 = Contains decimal string representation
;   Displays result on screen
;----------------------------------------------------------


;++++++++++++++++++++++++++++++++++++++++++++++

check_flags proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    ; Initialize flag string storage
    mov si, offset flag_values
    mov cx, 6                   ; We'll check 6 flags
    
    ; === CF (bit 0) ===
    mov byte ptr [si], 'C'
    mov byte ptr [si+1], 'F'
    mov byte ptr [si+2], ':'
    mov byte ptr [si+3], ' '    ; Add space after colon
    pushf                       ; Get flags into AX
    pop ax
    test ax, 0000000000000001b  ; CF is bit 0
    jz cf_zero
    mov byte ptr [si+4], '1'
    jmp next_cf
cf_zero:
    mov byte ptr [si+4], '0'
next_cf:
    mov byte ptr [si+5], ' '    ; Add space after value
    add si, 6                   ; Move to next flag position

    ; === PF (bit 2) ===
    mov byte ptr [si], 'P'
    mov byte ptr [si+1], 'F'
    mov byte ptr [si+2], ':'
    mov byte ptr [si+3], ' '    ; Add space after colon
    pushf
    pop ax
    test ax, 0000000000000100b  ; PF is bit 2
    jz pf_zero
    mov byte ptr [si+4], '1'
    jmp next_pf
pf_zero:
    mov byte ptr [si+4], '0'
next_pf:
    mov byte ptr [si+5], ' '    ; Add space after value
    add si, 6

    ; === AF (bit 4) ===
    mov byte ptr [si], 'A'
    mov byte ptr [si+1], 'F'
    mov byte ptr [si+2], ':'
    mov byte ptr [si+3], ' '    ; Add space after colon
    pushf
    pop ax
    test ax, 0000000000010000b  ; AF is bit 4
    jz af_zero
    mov byte ptr [si+4], '1'
    jmp next_af
af_zero:
    mov byte ptr [si+4], '0'
next_af:
    mov byte ptr [si+5], ' '    ; Add space after value
    add si, 6

    ; === ZF (bit 6) ===
    mov byte ptr [si], 'Z'
    mov byte ptr [si+1], 'F'
    mov byte ptr [si+2], ':'
    mov byte ptr [si+3], ' '    ; Add space after colon
    pushf
    pop ax
    test ax, 0000000001000000b  ; ZF is bit 6
    jz zf_zero
    mov byte ptr [si+4], '1'
    jmp next_zf
zf_zero:
    mov byte ptr [si+4], '0'
next_zf:
    mov byte ptr [si+5], ' '    ; Add space after value
    add si, 6

    ; === SF (bit 7) ===
    mov byte ptr [si], 'S'
    mov byte ptr [si+1], 'F'
    mov byte ptr [si+2], ':'
    mov byte ptr [si+3], ' '    ; Add space after colon
    pushf
    pop ax
    test ax, 0000000010000000b  ; SF is bit 7
    jz sf_zero
    mov byte ptr [si+4], '1'
    jmp next_sf
sf_zero:
    mov byte ptr [si+4], '0'
next_sf:
    mov byte ptr [si+5], ' '    ; Add space after value
    add si, 6

    ; === OF (bit 11) ===
    mov byte ptr [si], 'O'
    mov byte ptr [si+1], 'F'
    mov byte ptr [si+2], ':'
    mov byte ptr [si+3], ' '    ; Add space after colon
    pushf
    pop ax
    test ax, 0000000100000000b  ; OF is bit 11
    jz of_zero
    mov byte ptr [si+4], '1'
    jmp next_of
of_zero:
    mov byte ptr [si+4], '0'
next_of:
    mov byte ptr [si+5], ' '    ; Add space after value

    ; Null terminate the string
    mov byte ptr [si+6], '$'

    ; Print "Flags: " header normally
    mov dx, offset flags_str
    mov ah, 09h
    int 21h

    ; Print flag values in red
    mov si, offset flag_values
print_red_flags:
    mov al, [si]
    cmp al, '$'
    je done_printing
    
    ; Set red color attribute
    mov ah, 09h
    mov bh, 0        ; Page number
    mov bl, 04h      ; Red on black (04h)
    mov cx, 1        ; Print 1 character
    int 10h
    
    ; Move cursor forward
    mov ah, 03h      ; Get cursor position
    int 10h
    inc dl           ; Move right
    mov ah, 02h      ; Set cursor position
    int 10h
    
    inc si
    jmp print_red_flags

done_printing:
    ; Print newline
    mov dx, offset newline
    mov ah, 09h
    int 21h

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
check_flags endp

clear_buffer proc
    lea si, buffer2
    mov al, '$'
    mov cx, 5
clearing:
    mov [si], al
    inc si
    loop clearing
    ret
clear_buffer endp

hex2number proc
    mov ax, 0
Ciclo:
    shl al, 1
    rcl ah, 1
    shl al, 1
    rcl ah, 1
    shl al, 1
    rcl ah, 1
    shl al, 1
    rcl ah, 1
    mov bl, [si]
    call validate
    cmp bl, 'A'
    jae letterAF
    sub bl, 48
    jmp continue
letterAF:
    sub bl, 55
continue:
    or al, bl
    inc si
    dec bh
    jnz Ciclo
    ret
hex2number endp

validate proc
    cmp bl, '0'
    jb error
    cmp bl, 'F'
    ja error
    cmp bl, '9'
    jbe ok
    cmp bl, 'A'
    jae ok
error:
    pop ax
    pop ax
    mov ah, 9
    lea dx, invalid_msg
    int 21h
    
ok:
    ret
validate endp

number2string proc
    mov bx, 10
    mov cx, 0
cycle1:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne cycle1
    lea si, buffer2
cycle2:
    pop dx
    add dl, 48
    mov [si], dl
    inc si
    loop cycle2
    ret
number2string endp 

BINARY_TO_HEX PROC
    LEA SI, binary_input + 2  ; Point to input string
    XOR BX, BX                ; Clear BX for result
    XOR CX, CX                ; Counter for bits

BINARY_LOOP:
    MOV AL, [SI]
    CMP AL, 0DH               ; Check end of input
    JE BINARY_DONE
    CMP AL, '0'               ; Validate binary digit
    JB INVALID_BIN
    CMP AL, '1'
    JA INVALID_BIN

    SHL BX, 1                 ; Shift BX left
    SUB AL, '0'               ; Convert to 0/1
    ADD BL, AL                ; Add to BX
    INC SI
    INC CX
    CMP CX, 16                ; Max 16 bits
    JB BINARY_LOOP

BINARY_DONE:
    CMP CX, 0                 ; Check empty input
    JE INVALID_BIN
    ; Convert BX to hex string
    LEA DI, hex_output
    MOV CX, 4
HEX_CONVERT_LOOP:
    PUSH CX
    MOV CL, 4
    ROL BX, CL                ; Rotate next nibble into view
    MOV AL, BL
    AND AL, 0FH               ; Isolate nibble
    CMP AL, 9
    JBE HEX_DIGIT
    ADD AL, 7                 ; Adjust for A-F
HEX_DIGIT:
    ADD AL, '0'               ; Convert to ASCII
    MOV [DI], AL
    INC DI
    POP CX
    LOOP HEX_CONVERT_LOOP
    CLC                       ; Clear carry (success)
    RET

INVALID_BIN:
    STC                       ; Set carry (error)
    RET
BINARY_TO_HEX ENDP

BINARY_TO_DEC PROC
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DX

    MOV CL, [binary_input + 1]
    MOV CH, 0
    JCXZ INVALID_BIN_DEC

    LEA SI, [binary_input + 2]
    XOR BX, BX

BIN_CONV_LOOP:
    MOV AL, [SI]
    CMP AL, '0'
    JB INVALID_BIN_DEC
    CMP AL, '1'
    JA INVALID_BIN_DEC

    SHL BX, 1
    SUB AL, '0'
    ADD BL, AL

    INC SI
    LOOP BIN_CONV_LOOP

    MOV [decimal_result], BX
    MOV VALEUR , BX
    CLC
    JMP END_BIN_CONV

INVALID_BIN_DEC:
    STC
END_BIN_CONV:
    POP DX
    POP SI
    POP CX
    POP BX
    
    RET
BINARY_TO_DEC ENDP
;++++++++++++++++++++++++++++++++++++++++++
ReadOperands PROC
    MOV DX, OFFSET prompt1
    MOV AH, 09H   
    INT 21H  
    CALL ReadNumber
    MOV op, AX  

    MOV DX, OFFSET prompt2
    MOV AH, 09H   
    INT 21H    
    CALL ReadNumber
    MOV op2, AX  
    RET
ReadOperands ENDP

DisplayResultAndFlags PROC
    MOV si, OFFSET prompt3
    mov bl, 0Ah             ; Light green (0Ah) for success
    call PrintColorText

    MOV AX, operation
    CALL PrintNumber2 
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    
    MOV si, OFFSET hex_result_msg
    mov bl, 0Ah             ; Light green (0Ah) for success
    call PrintColorText
    
    MOV AX, operation
    CALL PrintHex
    
    mov dx, offset msg1
    mov ah, 09h
    int 21h

    
    pushf
    pop ax

    mov cx, 9
    lea si, flag_values
    
    CALL check_flags
    RET
DisplayResultAndFlags ENDP

PrintHex PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; --- Store value ---
    MOV BX, AX       ; BX = value to print (e.g., 10 = 0x000A)

    

    ; --- Print 4 hex digits (MSB first) ---
    MOV CX, 4     ; 4 digits to print
    ; Light green on black
    PUSH AX
    PUSH BX
    MOV AH, 09h   ; BIOS function for colored output
    MOV BH, 0     ; Page 0
    MOV BL, 0Ah   
    INT 10H
    POP BX
    POP AX

HexLoop:
    ; --- Rotate BX to get next nibble ---
    MOV AL, BH  
    MOV CL , 4; Work on upper byte first
    SHR AL, CL       ; Get top nibble of BH
    CALL PrintNibble ; Print it

    MOV AL, BH       ; Get lower nibble of BH
    AND AL, 0Fh
    CALL PrintNibble

    MOV AL, BL       ; Get top nibble of BL
    SHR AL, CL
    CALL PrintNibble

    MOV AL, BL       ; Get lower nibble of BL
    AND AL, 0Fh
    CALL PrintNibble

    ; --- Exit loop (since we manually printed 4 nibbles) ---
    JMP Done

PrintNibble:
    ; --- Convert AL (nibble) to ASCII and print ---
    ADD AL, '0'
    CMP AL, '9'
    JBE PrintDigit
    ADD AL, 7        ; Adjust for 'A'-'F'
PrintDigit:
    MOV DL, AL
    MOV AH, 02h      ; Print character
    INT 21h
    RET

Done:
    MOV AH, 09h
    MOV AL, ' '      ; Invisible space (resets color)
    MOV BL, 07h      ; Light gray on black
    MOV CX, 1
    INT 10h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintHex ENDP
PrintHex0E PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; --- Store value ---
    MOV BX, AX       ; BX = value to print (e.g., 10 = 0x000A)

    

    ; --- Print 4 hex digits (MSB first) ---
    MOV CX, 4     ; 4 digits to print
    ; Light green on black
    PUSH AX
    PUSH BX
    MOV AH, 09h   ; BIOS function for colored output
    MOV BH, 0     ; Page 0
    MOV BL, 0Eh   
    INT 10H
    POP BX
    POP AX

HexLoop3:
    ; --- Rotate BX to get next nibble ---
    MOV AL, BH  
    MOV CL , 4; Work on upper byte first
    SHR AL, CL       ; Get top nibble of BH
    CALL PrintNibble3 ; Print it

    MOV AL, BH       ; Get lower nibble of BH
    AND AL, 0Fh
    CALL PrintNibble3

    MOV AL, BL       ; Get top nibble of BL
    SHR AL, CL
    CALL PrintNibble3

    MOV AL, BL       ; Get lower nibble of BL
    AND AL, 0Fh
    CALL PrintNibble3

    ; --- Exit loop (since we manually printed 4 nibbles) ---
    JMP Done3

PrintNibble3:
    ; --- Convert AL (nibble) to ASCII and print ---
    ADD AL, '0'
    CMP AL, '9'
    JBE PrintDigit3
    ADD AL, 7        ; Adjust for 'A'-'F'
PrintDigit3:
    MOV DL, AL
    MOV AH, 02h      ; Print character
    INT 21h
    RET

Done3:
    MOV AH, 09h
    MOV AL, ' '      ; Invisible space (resets color)
    MOV BL, 07h      ; Light gray on black
    MOV CX, 1
    INT 10h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
    PrintHex0E ENDP

CLEAR_SCREEN PROC
    PUSH AX 
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Clear screen
    MOV AX, 0600H    ; AH=06 (scroll), AL=00 (full screen)
    MOV BH, 07H      ; Normal attribute
    MOV CX, 0000H    ; Upper left corner
    MOV DX, 184FH    ; Lower right corner
    INT 10H
    
    ; Reset cursor position
    MOV AH, 02H
    MOV BH, 00H
    MOV DX, 0000H
    INT 10H
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CLEAR_SCREEN ENDP
    
display_flags_red proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, offset flag_values
    mov cx, 36                ; 6 flags * 6 chars (e.g. "CF: 1 ")

print_loop:
    mov al, [si]
    cmp al, '$'
    je end_print

    mov ah, 0Eh               ; Teletype output (scrolls and moves cursor)
    mov bh, 0                 ; Page number
    mov bl, 04h               ; Red text color (for CGA/EGA/VGA text mode)
    int 10h

    inc si
    loop print_loop

end_print:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_flags_red endp

DisplayOperand PROC
    ; Input: AX = operand value, DX = offset of operand message (e.g., operand1_msg)
    PUSH AX
    PUSH BX
    PUSH DX
    
    ; Print operand header (e.g., "Operand 1 - DECIMAL: ")
    
    mov bl, 70h             ; Light green (0Ah) for success
    call PrintColorText
    
    ; Restore registers
    POP DX  ; Remove DX (message) from stack
    POP BX  ; Restore BX
    POP AX  ; Restore AX (operand value)
    
    ; Print decimal value
    PUSH AX
    CALL PrintNumber20E
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    
    ; Print hex label and value
    MOV si, OFFSET hex_result_msg
    mov bl, 70h             ; Light green (0Ah) for success
    call PrintColorText
    POP AX
    PUSH AX
    CALL PrintHex0E
    MOV AH, 09H
    MOV DX, OFFSET newline
    INT 21H
    
    ; Print binary label and value
    
    POP AX
    MOV operation, AX
    CALL dectobin3
    
    ; Newline
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    
    RET
DisplayOperand ENDP

; Enhanced PrintColorText that automatically restores default color when done
PrintColorText PROC
    ; Input: DS:SI points to string, BL = color
    push ax
    push bx
    push cx
    push dx      ; Also preserve DX
    push si
    push di
    
    ; Save original color attribute
    mov ah, 08h            ; BIOS read character and attribute
    mov bh, 0              ; Page number
    int 10h                ; BH now contains original attribute
    push bx                ; Save original attribute

    mov cx, 1              ; Number of times to write character
    mov bh, 0              ; Page number
    
    ; Get current cursor position
    mov ah, 03h            ; BIOS get cursor position
    int 10h                ; DH = row, DL = column

print_loop_:
    mov al, [si]           ; Get character
    cmp al, '$'            ; Check string terminator
    je print_done_

    ; Write colored character
    mov ah, 09h            ; BIOS write character and attribute
    int 10h

    ; Move cursor forward
    inc dl                 ; Increment column
    mov ah, 02h            ; BIOS set cursor position
    int 10h

    inc si                 ; Next character
    jmp print_loop_

print_done_:
    ; Restore original color attribute
    pop bx                 ; BH now contains original attribute
    mov bl, 07h            ; Default color (light gray on black)
    
    ; Write a space with default attribute to restore color
    mov ah, 09h            ; BIOS write character and attribute
    mov al, ' '            ; Space character
    int 10h                ; This restores the default attribute
    
    ; Move cursor back one position
    dec dl
    mov ah, 02h            ; BIOS set cursor position
    int 10h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintColorText ENDP
; New procedure to restore default text attributes
RestoreDefaultColor PROC
    push ax
    push bx
    push cx
    
    mov ah, 09h            ; BIOS write character and attribute
    mov bh, 0              ; Page number
    mov bl, 07h            ; Light gray on black (default)
    mov cx, 1              ; Just one character
    mov al, ' '            ; Space character (won't be visible)
    int 10h
    
    pop cx
    pop bx
    pop ax
    ret
RestoreDefaultColor ENDP
PrintNumber3 PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AX, operation
    MOV CX, 0        ; CX = digit counter
    MOV BX, 10       ; Divisor for conversion

    ; Set green color (0Ah) for all output
        ; Light green color
    
    ; Check if the number is negative
    TEST AX, 8000H
    JZ POSITIVE_NUMBER6
    ; Negative number
    PUSH AX
    MOV DL, '-'
    MOV AH, 02H
    INT 21H         ; Print '-' sign (green from previous BL setting)
    POP AX
    NEG AX

POSITIVE_NUMBER6:
    ; Convert number to ASCII
CONVERT_LOOP26:
    XOR DX, DX      ; Clear DX
    DIV BX          ; AX = AX / 10, DX = remainder (last digit)
    ADD DL, '0'     ; Convert remainder to ASCII
    PUSH DX         ; Store digit on stack
    INC CX          ; Increase counter
    TEST AX, AX     ; Check if AX == 0
    JNZ CONVERT_LOOP26

PRINT_LOOP6:
    POP DX   
    MOV BL, 0Ah     ; Retrieve digit
    MOV AH, 02H     ; DOS print function
    INT 21H         ; Print digit (green from BL setting)
    LOOP PRINT_LOOP6
    
    ; Print newline in green
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    ; Print binary in green
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    XOR AX, AX
    MOV AX, con
    CALL dectobin5    ; Make sure dectobin also uses green
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumber3 ENDP




    END START
