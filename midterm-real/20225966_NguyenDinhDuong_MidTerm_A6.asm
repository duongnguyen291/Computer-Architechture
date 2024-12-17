# Program to read a number and print its binary representation
.data
    prompt:     .string "Enter a positive number: "
    error_msg:  .string "Please enter a positive number!\n"
    result_msg: .string "Binary representation: "
    newline:    .string "\n"

.text
.globl main

main:
    # Print prompt
    la a0, prompt
    li a7, 4
    ecall
    
    # Read integer
    li a7, 5
    ecall
    mv s0, a0    # Save input number in s0
    
    # Check if number is positive
    blez s0, error
    
    # Print result message
    la a0, result_msg
    li a7, 4
    ecall
    
    # Initialize registers
    mv t0, s0    # Copy number to t0
    li t1, 32    # Counter for 32 bits
    li t3, 1     # For bit masking
    li t4, 31    # For shifting
    slli t3, t3, 31  # Create mask with leftmost bit set
    
print_binary:
    # Check if we've printed all bits
    beqz t1, done
    
    # Test current bit
    and t2, t0, t3
    beqz t2, print_zero
    li a0, 49    # ASCII '1'
    j do_print
print_zero:
    li a0, 48    # ASCII '0'
do_print:
    li a7, 11
    ecall
    
    # Shift bit mask right by 1
    srli t3, t3, 1
    
    # Decrement counter
    addi t1, t1, -1
    
    j print_binary

error:
    # Print error message
    la a0, error_msg
    li a7, 4
    ecall
    j exit

done:
    # Print newline
    la a0, newline
    li a7, 4
    ecall

exit:
    # Exit program
    li a7, 10
    ecall