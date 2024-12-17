# Data section
.data
infix:          .space 256
postfix:        .space 256
postfix_:       .space 256 
stack:          .space 256
msg_read_infix: .string "Please enter an infix expression: "
msg_print_infix: .string "Infix expression: "
msg_print_postfix: .string "Postfix expression: "
msg_print_result: .string "Result of the expression: "
msg_enter:      .string "\n"
msg_error1:     .string "You enter a number that greater than 99. Please try again!"
msg_error2:     .string "You enter a number that less than 0. Please try again!"
msg_error3:     .string "ERROR: You enter a divisor that equal 0."
msg_error4:     .string "ERROR: You enter a bracket that has wrong position."

.text
.globl main

main:
    # Call input_infix function
    j input_infix

#---------------------------------------------------------------------
# Input infix expression and display it
#---------------------------------------------------------------------
input_infix:
    # Print prompt message
    la a0, msg_read_infix
    li a7, 4           # Print string syscall
    ecall
    
    # Read input string
    la a0, infix       # Buffer address
    li a1, 256         # Maximum length
    li a7, 8           # Read string syscall
    ecall
    
    # Print "Infix expression: "
    la a0, msg_print_infix
    li a7, 4
    ecall
    
    # Print input expression
    la a0, infix
    li a7, 4
    ecall
    
    # Branch to convert postfix
    j convert_postfix

#---------------------------------------------------------------------
# Convert infix to postfix
#---------------------------------------------------------------------
convert_postfix:
    # Initialize registers
    li s0, 0          # index j of infix
    li s1, 0          # index i of postfix
    li s2, -1         # index k of stack
    li a3, 0          # lparcount = 0
    li s3, 0          # element to push to postfix
    
    # Load first character
    la t0, infix
    lb t0, 0(t0)
    li t1, '-'
    beq t0, t1, lt0_error

loop_infix:
    # Load current character
    la t1, infix
    add t1, t1, s0
    lb t0, 0(t1)
    
    # Check for end of string
    beqz t0, end_loop_infix
    li t1, '\n'
    beq t0, t1, end_loop_infix
    
    # Check for space
    li t1, ' '
    beq t0, t1, remove_space1
    
    # Check for operators
    li t1, '+'
    beq t0, t1, consider_plus_minus
    li t1, '-'
    beq t0, t1, consider_plus_minus
    li t1, '*'
    beq t0, t1, consider_mul_div
    li t1, '%'
    beq t0, t1, consider_mul_div
    li t1, '/'
    beq t0, t1, consider_mul_div
    li t1, '('
    beq t0, t1, consider_lpar
    li t1, ')'
    beq t0, t1, consider_rpar1
    
    # If here, character is operand - store in postfix
    la t1, postfix
    add t1, t1, s1
    sb t0, 0(t1)
    addi s1, s1, 1

    # Continue main loop
    j loop_continue

# Remove space handler
remove_space1:
    addi s0, s0, 1
    j loop_infix

# Continue loop handler
loop_continue:
    addi s0, s0, 1
    la t1, infix
    add t1, t1, s0
    lb t2, 0(t1)
    
    # Check if character is digit
    li t3, '0'
    bge t2, t3, check_digit
    j not_digit
    
check_digit:
    li t3, '9'
    ble t2, t3, continue
    
not_digit:
    li s3, ' '
    la t1, postfix
    add t1, t1, s1
    sb s3, 0(t1)
    addi s1, s1, 1
    j loop_infix

continue:
    addi t3, s0, 1
    la t1, infix
    add t1, t1, t3
    lb t4, 0(t1)
    
    # Check for numbers > 99
    li t1, '0'
    bge t4, t1, check_gt99
    j store_number

check_gt99:
    li t1, '9'
    ble t4, t1, gt99_error
    
store_number:
    la t1, postfix
    add t1, t1, s1
    sb t2, 0(t1)
    addi s1, s1, 1
    
    li s3, ' '
    la t1, postfix
    add t1, t1, s1
    sb s3, 0(t1)
    addi s1, s1, 1
    addi s0, s0, 1
    j loop_infix

# Various error handlers
gt99_error:
    la a0, msg_error1
    li a7, 4
    ecall
    j input_infix

lt0_error:
    la a0, msg_error2
    li a7, 4
    ecall
    j input_infix

# Operator handlers
consider_plus_minus:
    li t1, -1
    beq s2, t1, push_op
    
    la t1, stack
    add t1, t1, s2
    lb t5, 0(t1)    # Changed from t9 to t5
    
    li t1, '('
    beq t5, t1, push_op  # Changed from t9 to t5
    
    la t1, stack
    add t1, t1, s2
    lb t1, 0(t1)
    
    la t2, postfix
    add t2, t2, s1
    sb t1, 0(t2)
    
    addi s2, s2, -1
    addi s1, s1, 1
    
    li s3, ' '
    la t1, postfix
    add t1, t1, s1
    sb s3, 0(t1)
    addi s1, s1, 1
    
    j consider_plus_minus
# Add this implementation after the consider_plus_minus section:

consider_mul_div:
    li t1, -1
    beq s2, t1, push_op
    
    la t1, stack
    add t1, t1, s2
    lb t5, 0(t1)
    
    li t1, '('
    beq t5, t1, push_op
    
    li t1, '+'
    beq t5, t1, push_op
    
    li t1, '-'
    beq t5, t1, push_op
    
    la t1, stack
    add t1, t1, s2
    lb t1, 0(t1)
    
    la t2, postfix
    add t2, t2, s1
    sb t1, 0(t2)
    
    addi s2, s2, -1
    addi s1, s1, 1
    
    li s3, ' '
    la t1, postfix
    add t1, t1, s1
    sb s3, 0(t1)
    addi s1, s1, 1
    
    j consider_mul_div

push_op:
    addi s2, s2, 1
    la t1, stack
    add t1, t1, s2
    sb t0, 0(t1)
    addi s0, s0, 1
    j loop_infix

consider_lpar:
    addi a3, a3, 1
    addi s2, s2, 1
    la t1, stack
    add t1, t1, s2
    sb t0, 0(t1)
    addi s0, s0, 1
    j loop_infix

consider_rpar1:
    beqz a3, invalid_parentheses
    addi a3, a3, -1
    j consider_rpar2

consider_rpar2:
    la t1, stack
    add t1, t1, s2
    lb t1, 0(t1)
    
    li t2, '('
    beq t1, t2, remove_lpar
    
    la t2, postfix
    add t2, t2, s1
    sb t1, 0(t2)
    
    addi s2, s2, -1
    addi s1, s1, 1
    
    li s3, ' '
    la t1, postfix
    add t1, t1, s1
    sb s3, 0(t1)
    addi s1, s1, 1
    
    j consider_rpar2

remove_lpar:
    addi s2, s2, -1
    addi s0, s0, 1
    j loop_infix

invalid_parentheses:
    la a0, msg_error4
    li a7, 4
    ecall
    j input_infix

remove_parentheses:
    # Print postfix expression
    la a0, msg_print_postfix
    li a7, 4
    ecall
    
    la a0, postfix
    li a7, 4
    ecall
    
    la a0, msg_enter
    li a7, 4
    ecall
    
    j calculate_postfix
# Similar conversions for other operators...
# [Additional operator handling code would go here]

end_loop_infix:
    li t1, -1
    beq s2, t1, remove_parentheses
    
    la t1, stack
    add t1, t1, s2
    lb t0, 0(t1)
    
    la t1, postfix
    add t1, t1, s1
    sb t0, 0(t1)
    
    addi s2, s2, -1
    addi s1, s1, 1
    
    li s3, ' '
    la t1, postfix
    add t1, t1, s1
    sb s3, 0(t1)
    addi s1, s1, 1
    
    j end_loop_infix

calculate_postfix:
    li s1, 0           # index for postfix string
    li s4, 0           # temporary storage for building numbers
loop_postfix:
    la t1, postfix
    add t1, t1, s1
    lb t0, 0(t1)
    
    beqz t0, print_result
    
    li t1, ' '
    beq t0, t1, process_number
    
    # Check if character is digit
    li t1, '0'
    bge t0, t1, check_number
    j check_operator
    
check_number:
    li t1, '9'
    ble t0, t1, build_number
    j check_operator
build_number:
    # Convert character to number and add to s4
    addi t0, t0, -48          # Convert ASCII to number
    li t1, 10
    mul s4, s4, t1            # Multiply current value by 10
    add s4, s4, t0            # Add new digit
    addi s1, s1, 1
    j loop_postfix
handle_number:
    # Convert character to number and push to stack
    addi t0, t0, -48
    sw t0, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 1
    j loop_postfix
process_number:
    # Only push number if we have built one
    beqz s4, remove_space
    sw s4, 0(sp)              # Push number to stack
    addi sp, sp, 4
    li s4, 0                  # Reset number builder
    j remove_space
remove_space:
    addi s1, s1, 1
    j loop_postfix
check_operator:
    # Pop two numbers and perform operation
    lw t4, -8(sp)             # First number
    lw t5, -4(sp)             # Second number
    addi sp, sp, -8
    
    li t1, '+'
    beq t0, t1, add_func
    li t1, '-'
    beq t0, t1, sub_func
    li t1, '*'
    beq t0, t1, mul_func
    li t1, '/'
    beq t0, t1, div_func
    li t1, '%'
    beq t0, t1, mod_func
    
    addi s1, s1, 1
    j loop_postfix

add_func:
    add t4, t4, t5
    sw t4, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 1
    j loop_postfix

sub_func:
    sub t4, t4, t5
    sw t4, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 1
    j loop_postfix

mul_func:
    mul t4, t4, t5
    sw t4, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 1
    j loop_postfix

div_func:
    beqz t5, invalid_divisor
    div t4, t4, t5
    sw t4, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 1
    j loop_postfix

mod_func:
    beqz t5, invalid_divisor
    rem t4, t4, t5
    sw t4, 0(sp)
    addi sp, sp, 4
    addi s1, s1, 1
    j loop_postfix

invalid_divisor:
    la a0, msg_error3
    li a7, 4
    ecall
    li a7, 10
    ecall

print_result:
    la a0, msg_print_result
    li a7, 4
    ecall
    
    lw a0, -4(sp)
    li a7, 1
    ecall
    
    la a0, msg_enter
    li a7, 4
    ecall
    
    li a7, 10
    ecall