.data
A: .word 2, 1, 6, 4, 5, 3  # New array
Aend: .word                 # End array
newline: .string "\n"       # String for new line
space: .string " "          # String for space
.text
.globl main
main:
    la      a2, A           # Load address of the beginning of array A into a2
    la      a3, Aend        # Load address of the end of array A into a3
    mv a6, a3               # Copy the end address of A into a6
    addi a6, a6, -1         # Decrement a6 to point to the last element of A
    li      s0, 0           # Initialize s0 to 0, used as the element count
    li      s1, -1          # Initialize s1 to -1, used as the loop index i

DemPhanTu:                   # Count elements in the array
    beq     a3, a2, Size     # If a3 == a2, reached the end of the array, jump to Size
    addi    a3, a3, -4       # Decrement a3 by 4 bytes (each element is 4 bytes)
    addi    s0, s0, 1        # Increment the element count (count)
    j       DemPhanTu        # Repeat the loop

Size:                       # Calculate the size of the array
    addi    t0, s0, -1       # t0 = number of elements in array - 1

loop1:                     # Outer loop for sorting
    addi    s1, s1, 1        # Increment i
    li      s2, 0            # Initialize s2 to 0, used as the inner loop index j
    beq     s1, t0, Exit     # If i == size - 1, jump to Exit

loop2:                     # Inner loop for comparison
    sub     t2, t0, s1       # t2 = (size - 1) - i
    beq     s2, t2, loop1    # If j == (size - 1) - i, return to loop1

if_swap:                   # Check if a swap is needed
    slli    t3, s2, 2        # t3 = j * 4 (calculate offset for address A[j])
    add     s3, a2, t3       # s3 = address of A[j]
    lw      t4, 0(s3)        # Load value of A[j] into t4
    addi    s3, s3, 4        # s3 = address of A[j+1]
    lw      t5, 0(s3)        # Load value of A[j+1] into t5
    blt     t5, t4, swap     # If A[j+1] < A[j], jump to swap
    addi    s2, s2, 1        # Increment j
    j       loop2            # Repeat loop2

swap:                      # Swap A[j] and A[j+1]
    sw      t4, 0(s3)        # A[j+1] = A[j]
    addi    s3, s3, -4       # s3 = address of A[j] (calculate back to A[j])
    sw      t5, 0(s3)        # A[j] = A[j+1]
    addi    s2, s2, 1        # Increment j
    jal print_array          # Call print_array to display the current state of the array
    j       loop2            # Repeat loop2

print_array:               # Print the array
    mv a4, a2               # Save the address value of a2 (start of the array)
    mv a5, a6               # Save the address value of a6 (end of the array)
print_loop:
        lw a0, 0(a2)        # Load the current element into a0
        li a7, 1            # Syscall code for printing an integer
        ecall               # Make the syscall
        
        la a0, space        # Load address of space string
        li a7, 4            # Syscall code for printing a string
        ecall               # Make the syscall
        
        addi a2, a2, 4      # Move to the next element
        ble a2, a6, print_loop  # If not past the last element, continue loop
        
        la a0, newline      # Load address of newline string
        li a7, 4            # Syscall code for printing a string
        ecall               # Make the syscall
        
    add a2, a4, zero        # Restore a2 to its original value
    add a6, a5, zero        # Restore a6 to its original value
    li a0, 0                # Restore a0

    ret                      # Return to the caller

Exit:                      # Exit point of the program
    li      a7, 10          # Load syscall code to exit the program
    ecall                   # Make the syscall
