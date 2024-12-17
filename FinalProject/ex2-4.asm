.data
    # Existing data section
    numbers:    .space  80000 
    buf_size:   .word   80000 
    count:      .word   0
    
    # Add bitmask array for negative numbers (1 bit per number)
    # For 80000 bytes of numbers (20000 integers), we need 20000 bits = 2500 bytes
    neg_mask:   .space  2500
    
    filename:   .space  256
    readbuf:    .space  1024
    prompt:     .string "Enter filename: "
    error_msg:  .string "\nError opening file\n"
    menu:       .string "\nSelect sorting algorithm:\n1. Bubble Sort\n2. Insertion Sort\n3. Selection Sort\n4. Quick Sort\n5.Quit\nChoice: "
    
    fd:         .word   0
    newline:    .string "\n"
    space:      .string " "
    start_time: .word   0
    end_time:   .word   0
    
    time_msg:   .string "\nExecution time (ms): "
    
    # New data for output file
    outfile:    .string "C:\\Users\\Admin\\OneDrive\\BÁCH KHOA\\2024-1\\Assembly Language and Computer Architecture Lab\\CA\\FinalProject\\results3.txt"
    out_fd:     .word   0
    numbuf:     .space  12
    write_err:  .string "\nError writing to output file\n"
    minus:      .string "-"
    # Add temporary buffer for merge sort
    temp_buf:   .space  80000

.text
.globl main
main:
    # Print filename prompt
    li a7, 4
    la a0, prompt
    ecall 
    # Read filename
    li a7, 8
    la a0, filename
    li a1, 256
    ecall
    # Remove newline from filename
    la t0, filename
remove_newline:
    lb t1, 0(t0)
    beqz t1, open_file
    li t2, 10
    beq t1, t2, replace_newline
    addi t0, t0, 1
    j remove_newline
replace_newline:
    sb zero, 0(t0)
    
open_file:
    li a7, 1024
    la a0, filename
    li a1, 0
    ecall
    bltz a0, file_error
    la t1, fd
    sw a0, 0(t1)
    jal read_numbers
    
menu_loop:
    # Display menu
    li a7, 4
    la a0, menu
    ecall
    
    # Read choice
    li a7, 5
    ecall
    
    # Branch based on choice
    li t0, 1
    beq a0, t0, bubble_sort
    li t0, 2
    beq a0, t0, insertion_sort
    li t0, 3
    beq a0, t0, selection_sort
    li t0, 4
    beq a0, t0, quick_sort
    li t0,5
    beq a0, t0, exit
    j exit
file_error:
    # Print error message
    li a7, 4
    la a0, error_msg
    ecall
    j exit

# ========================= READ NUMBERS WITH NEGATIVE CHECK =====================
read_numbers:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    # Reset count
    la t1, count       # Load address of count
    sw zero, 0(t1)     # Store zero at count
    
    # Initialize variables
    li t0, 0           # Current number being built
    li t1, 0           # Flag for if we're in a number
    li t6, 0           # Sign flag (0 = positive, 1 = negative)

read_loop:
    # Read one character from file
    li a7, 63          # ReadFile syscall
    lw a0, fd          # File descriptor
    la a1, readbuf     # Buffer address
    li a2, 1           # Read one character
    ecall

    # Check if end of file
    beqz a0, read_done
    
    # Load character
    lb t2, 0(a1)
    
    # Check if minus sign
    li t3, 45          # ASCII for '-'
    beq t2, t3, set_negative
    
    # Check if space or newline
    li t3, 32          # Space
    beq t2, t3, save_number
    li t3, 10          # Newline
    beq t2, t3, save_number
    
    # Convert ASCII to number and add to current number
    addi t2, t2, -48   # Convert ASCII to number
    li t3, 10
    mul t0, t0, t3     # Current * 10
    add t0, t0, t2     # Add new digit
    li t1, 1           # Set flag that we're in a number
    j read_loop
    
set_negative:
    li t6, 1           # Set negative flag
    j read_loop
    
save_number:
    beqz t1, read_loop  # If not in number, continue
    
    # Apply sign if negative
    beqz t6, save_positive
    neg t0, t0         # Negate the number if negative flag is set
    
    # Mark bitmask for negative numbers
    jal mark_negative_bit

save_positive:
    # Save number to array
    la t3, count       # Load address of count
    lw t3, 0(t3)       # Load count value
    slli t4, t3, 2     # t4 = count * 4
    la t5, numbers
    add t5, t5, t4
    sw t0, 0(t5)       # Save number
    
    # Increment count
    addi t3, t3, 1
    la t4, count       # Load address of count
    sw t3, 0(t4)       # Store new count
    
    # Reset for next number
    li t0, 0           # Reset current number
    li t1, 0           # Reset in-number flag
    li t6, 0           # Reset negative flag
    j read_loop

read_done:
    beqz t1, close_file
    beqz t6, save_positive
    neg t0, t0         # Save last number if negative
    jal mark_negative_bit
    j save_positive

close_file:
    li a7, 57          # Close file syscall
    lw a0, fd
    ecall
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    ret

# ========================= MARK NEGATIVE NUMBERS IN BITMASK =====================
mark_negative_bit:
    la t3, count       # Load count address
    lw t3, 0(t3)
    addi t3, t3, -1    # t3 = index (current count - 1)
    srai t0, t3, 3     # t0 = byte offset (index / 8)
    andi t1, t3, 7     # t1 = bit offset (index % 8)
    li t2, 1
    sll t2, t2, t1     # Shift bit to position
    la t4, neg_mask
    add t4, t4, t0     # Address of neg_mask byte
    lb t5, 0(t4)
    or t5, t5, t2      # Set bit
    sb t5, 0(t4)
    ret

exit:
    li a7, 10         # Exit syscall
    ecall
