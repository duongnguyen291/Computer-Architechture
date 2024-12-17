.data
    buffer:     .space 256      # Input buffer
    postfix:    .space 256      # Postfix output
    stack:      .space 256      # Operator stack
    result:     .space 256      # Result stack
    space:      .string " "     # Space character for formatting
    prompt:     .string "Enter infix expression (e.g. 9+2*6): "
    postfix_msg:.string "Postfix expression: "
    result_msg: .string "\nResult: "
    newline:    .string "\n"

.text
.globl main

main:
    # Print prompt
    la a0, prompt
    li a7, 4 
    ecall
    
    # Read infix expression
    la a0, buffer
    li a1, 256
    li a7, 8
    ecall
    
    # Initialize
    la s0, buffer      # s0 = input buffer address
    la s1, postfix     # s1 = postfix buffer address
    la s2, stack       # s2 = operator stack address
    li s3, 0          # s3 = operator stack top
    li s4, 0          # s4 = postfix index

convert_loop:
    lb t0, (s0)               # Load current char
    beqz t0, end_convert      # If null, end conversion
    li t1, '\n'
    beq t0, t1, end_convert   # If newline, end conversion
    
    # Check if digit
    li t1, '0'
    blt t0, t1, check_operator
    li t1, '9'
    bgt t0, t1, check_operator
    
    # Store digit and space
    sb t0, (s1)              # Store digit
    addi s1, s1, 1
    li t0, ' '               # Add space after digit
    sb t0, (s1)
    addi s1, s1, 1
    addi s4, s4, 2
    j next_char

check_operator:
    # Check operators
    li t1, '+'
    beq t0, t1, store_operator
    li t1, '-' 
    beq t0, t1, store_operator
    li t1, '*'
    beq t0, t1, store_operator
    li t1, '/'
    beq t0, t1, store_operator
    li t1, '('
    beq t0, t1, store_operator
    li t1, ')'
    beq t0, t1, store_operator
    j next_char

store_operator:
    # Store operator and space
    sb t0, (s1)              # Store operator
    addi s1, s1, 1
    li t0, ' '               # Add space after operator
    sb t0, (s1)
    addi s1, s1, 1
    addi s4, s4, 2
    
next_char:
    addi s0, s0, 1           # Move to next char
    j convert_loop

end_convert:
    # Add null terminator
    sb zero, (s1)
    
    # Print postfix expression
    la a0, postfix_msg
    li a7, 4
    ecall
    
    la a0, postfix
    li a7, 4
    ecall
    
    # Print result message
    la a0, result_msg
    li a7, 4
    ecall
    
    # Calculate and print result
    jal calculate_result
    
    # Print newline
    la a0, newline
    li a7, 4
    ecall
    
    # Exit program
    li a7, 10
    ecall

calculate_result:
    la t0, postfix           # Load postfix expression
    la t1, result           # Load result stack
    li t2, 0               # Result stack pointer
    li t3, 0               # Final result
    
    # Temporary result storage
    sw t3, 0(t1)
    
    # Print result
    lw a0, 0(t1)           # Load result
    li a7, 1               # Print integer
    ecall
    
    ret