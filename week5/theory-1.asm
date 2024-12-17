.data
    A: .word 10, 20, 30, 2, 3, 7    # Array declaration

.text
.globl main
main:
    li t0, 0          # Initialize index i = 0
    li t1, 6          # Set number of elements n = 6
    li s0, 0          # Initialize sum = 0 (register s0 will store the sum)

loop:
    beq t0, t1, end   # If i == n, exit the loop
    la t2, A          # Load the base address of the array A
    sll t3, t0, 2     # t3 = i * 4 (each word is 4 bytes)
    add t2, t2, t3    # Address of A[i]
    lw t4, 0(t2)      # Load A[i] into t4
    add s0, s0, t4    # sum = sum + A[i]
    addi t0, t0, 1    # i++
    j loop            # Jump back to loop

end:
    # The sum is now stored in s0
    # Optionally, add code here to print the sum if desired.
    # For now, we'll just return.
    li a0, 0          # Return 0
    li a7, 93         # ECALL for exit
    ecall
