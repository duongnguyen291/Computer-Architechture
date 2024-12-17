.data
    prompt_size: .string "Enter the size of array: "
    prompt_elem: .string "Enter element "
    colon:      .string ": "
    pos_msg:    .string "\nSum of positive elements: "
    neg_msg:    .string "\nSum of negative elements: "
    newline:    .string "\n"
    error_msg:   .string "The size of array must be positive"
    array:      .word 100    # Space for up to 100 integers

.text
.globl main

main:
    # Print prompt for array size
    la a0, prompt_size
    li a7, 4
    ecall
    
    # Read array size
    li a7, 5
    ecall
    ble a0,zero, end
    mv s0, a0        # s0 = array size
    
    # Initialize array index and address
    la s1, array     # s1 = array base address
    li t0, 0         # t0 = current index
    li s2, 0         # s2 = sum of positive numbers
    li s3, 0         # s3 = sum of negative numbers
    
input_loop:
    # Check if we've read all elements
    beq t0, s0, calc_done
    
    # Print "Enter element i: "
    la a0, prompt_elem
    li a7, 4
    ecall
    
    mv a0, t0
    li a7, 1
    ecall
    
    la a0, colon
    li a7, 4
    ecall
    
    # Read element
    li a7, 5
    ecall
    
    # Store element in array
    slli t1, t0, 2       # t1 = t0 * 4 (offset)
    add t1, t1, s1       # t1 = base + offset
    sw a0, 0(t1)         # store element
    
    # Increment index
    addi t0, t0, 1
    j input_loop

calc_done: 
    # Reset index for summing
    li t0, 0         # t0 = current index
    
sum_loop:
    # Check if we've processed all elements
    beq t0, s0, print_results
    
    # Load current element
    slli t1, t0, 2       # t1 = t0 * 4
    add t1, t1, s1       # t1 = base + offset
    lw t2, 0(t1)         # t2 = current element
    
    # Check if positive or negative
    bgez t2, is_positive # if t2 >= 0, branch to is_positive
    
    # Add Negative number
    add s3, s3, t2
    j next_elem
    
is_positive:
    beqz t2, next_elem   # if t2 = 0, skip
    add s2, s2, t2
    
next_elem:
    addi t0, t0, 1
    j sum_loop

print_results:
    # Print sum of positive elements
    la a0, pos_msg
    li a7, 4
    ecall
    
    mv a0, s2
    li a7, 1
    ecall
    
    # Print sum of negative elements
    la a0, neg_msg
    li a7, 4
    ecall
    
    mv a0, s3
    li a7, 1
    ecall
    
    # Print newline
    la a0, newline
    li a7, 4
    ecall
    
    # Exit program
    li a7, 10
    ecall
end:
    la a0, error_msg
    li a7, 4
    ecall
