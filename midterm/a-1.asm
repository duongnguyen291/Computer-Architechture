.data
prompt: .asciz "Nhap so nguyen duong N: "
newline: .asciz ",\n"
.text
.globl _start
_start:
    # Print prompt message
    li a7, 4
    la a0, prompt
    ecall

    # Read integer N from the user
    li a7, 5
    ecall
    mv t0, a0            # t0 stores N

    # Initialize counter i = 1
    li t1, 1              # t1 is i (current number)

loop:
    # Check if i < N
    bge t1, t0, end_loop  # If i >= N, exit the loop

    # Check if i % 3 == 0 or i % 5 == 0
    li t2, 3              # t2 is divisor 3
    rem t3, t1, t2        # t3 = i % 3
    beq t3, zero, print   # If i % 3 == 0, go to print

    li t2, 5              # t2 is divisor 5
    rem t3, t1, t2        # t3 = i % 5
    beq t3, zero, print   # If i % 5 == 0, go to print

    # Increment i and continue loop
    addi t1, t1, 1
    j loop

print:
    # Print the current number i
    mv a0, t1
    li a7, 1              # syscall for print integer
    ecall

    # Print comma and newline
    la a0, newline
    li a7, 4              # syscall for print string
    ecall

    # Increment i and continue loop
    addi t1, t1, 1
    j loop

end_loop:
    # Exit program
    li a7, 10             # syscall for exit
    ecall
