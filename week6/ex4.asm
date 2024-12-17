.data
array: .word 3,5,1,4,2  # Array to be sorted
arrayEnd: .word          # End of the array
newline: .string "\n"    # String for new line
space: .string " "       # String for space
.text
.globl main

main:
    la a2, array         # Load address of the beginning of the array into a2
    la a6, arrayEnd      # Load address of the end of the array into a6
    addi a3, a3, 5       # Set the number of elements (n) to 5
    addi a6, a6, -4      # Adjust a6 to point to the last element of the array
    jal ra, insertion_sort # Call insertion_sort function
    
    # End the program
    li a7, 10            # Load syscall code for program exit
    ecall                 # Make the syscall

insertion_sort:
    li t0, 1             # i = 1 (starting from the second element)
outer_loop:
    bge t0, a3, done     # If i >= n, exit the loop
    slli t1, t0, 2       # t1 = i * 4 (offset for the i-th element)
    add t1, a2, t1       # Get the address of a[i]
    lw t2, 0(t1)         # key = a[i]
    addi t3, t0, -1      # j = i - 1
    
inner_loop:
    bltz t3, insert      # If j < 0, insert key
    slli t4, t3, 2       # t4 = j * 4 (offset for the j-th element)
    add t4, a2, t4       # Get the address of a[j]
    lw t5, 0(t4)         # Load value of a[j]
    ble t5, t2, insert    # If a[j] <= key, insert key
    
    sw t5, 4(t4)         # a[j+1] = a[j] (shift element to the right)
    addi t3, t3, -1      # j-- (decrement j)
    j inner_loop         # Repeat inner loop
    
insert:
    slli t4, t3, 2       # Calculate offset for j
    add t4, a2, t4       # Get address of a[j]
    sw t2, 4(t4)         # a[j+1] = key (insert the key at the correct position)
    jal print_array       # Call print_array to display the current state of the array
    addi t0, t0, 1       # i++ (increment i)
    j outer_loop         # Repeat outer loop

print_array:               # Print the array
    mv a4, a2             # Save the address value of a2 (start of the array)
    mv a5, a6             # Save the address value of a6 (end of the array)
print_loop:
        lw a0, 0(a2)      # Load the current element into a0
        li a7, 1          # Syscall code for printing an integer
        ecall             # Make the syscall
        
        la a0, space      # Load address of space string
        li a7, 4          # Syscall code for printing a string
        ecall             # Make the syscall
        
        addi a2, a2, 4    # Move to the next element
        ble a2, a6, print_loop  # If not past the last element, continue loop
        
        la a0, newline    # Load address of newline string
        li a7, 4          # Syscall code for printing a string
        ecall             # Make the syscall
        
    mv a2, a4             # Restore a2 to its original value
    mv a6, a5             # Restore a6 to its original value
    li a0, 0              # Restore a0

    ret                    # Return to the caller

done:
    li      a7, 10        # Load syscall code to exit the program
    ecall                 # Make the syscall
