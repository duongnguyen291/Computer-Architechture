# Program to find the largest uppercase character in a string with exception handling
.data
    buffer:     .space 100     # Buffer to store input string
    prompt:     .string "Enter a string: "
    result:     .string "Largest uppercase character: "
    newline:    .string "\n"
    no_upper:   .string "Error: No uppercase characters found in the string!\n"
    empty_str:  .string "Error: Empty string or whitespace only!\n"
    same_chars: .string "Note: Multiple characters found with ASCII value "
    error_io:   .string "Error: Input/Output error occurred!\n"
    count_msg:  .string "Number of occurrences: "

# Text Section
.text
.globl main

main:
    # Print prompt
    li a7, 4              
    la a0, prompt         
    ecall

    # Read string
    li a7, 8              
    la a0, buffer         
    li a1, 100            
    ecall

    # Check for I/O errors (simplified - checking if first byte is 0)
    lb t0, (a0)
    beqz t0, io_error

    # Initialize variables
    la t0, buffer         # t0 points to current character
    li t1, 0             # t1 holds the largest uppercase char
    li t2, 1             # t2 is whitespace flag (1 = only whitespace seen so far)
    li t3, 0             # t3 counts occurrences of largest char
    
process_loop:
    lb t4, (t0)          # load current character
    beqz t4, end_loop    # if null terminator, end loop
    
    # Check if character is not whitespace
    li t5, 32            # Space character
    bne t4, t5, not_whitespace
    j check_next
    
not_whitespace:
    li t2, 0             # Clear whitespace flag

check_next:    
    # Check if character is uppercase (ASCII 65-90)
    li t5, 65            # 'A'
    blt t4, t5, next_char
    li t5, 90            # 'Z'
    bgt t4, t5, next_char
    
    # Compare with current largest
    blt t4, t1, next_char    # if current < largest, skip
    bne t4, t1, update_largest
    # If equal, increment counter
    addi t3, t3, 1
    j next_char

update_largest:
    # If new largest found, reset counter and update
    li t3, 1
    mv t1, t4

next_char:
    addi t0, t0, 1       # move to next character
    j process_loop

end_loop:
    # Check if string was empty or only whitespace
    bnez t2, empty_string
    
    # Check if we found any uppercase characters
    beqz t1, no_uppercase
    
    # Print result message
    li a7, 4
    la a0, result
    ecall
    
    # Print the character
    li a7, 11
    mv a0, t1
    ecall
    
    # Print newline
    li a7, 4
    la a0, newline
    ecall

    # If multiple occurrences, print count
    li t4, 1
    ble t3, t4, exit
    
    # Print multiple occurrence message
    la a0, same_chars
    li a7, 4
    ecall

    # Print ASCII value
    mv a0, t1
    li a7, 1
    ecall
    
    # Print newline
    la a0, newline
    li a7, 4
    ecall
    
    # Print count message
    la a0, count_msg
    li a7, 4
    ecall
    
    # Print count
    mv a0, t3
    li a7, 1
    ecall
    
    # Print newline
    la a0, newline
    li a7, 4
    ecall
    
    j exit

no_uppercase:
    # Print no uppercase found message
    li a7, 4
    la a0, no_upper
    ecall
    j exit

empty_string:
    # Print empty string message
    li a7, 4
    la a0, empty_str
    ecall
    j exit

io_error:
    # Print I/O error message
    li a7, 4
    la a0, error_io
    ecall
    j exit

exit:
    # Exit program
    li a7, 10
    ecall