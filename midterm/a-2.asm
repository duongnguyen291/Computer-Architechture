    .data
prompt: .asciz "Enter a positive integer N: "
comma: .asciz ", "
newline: .asciz "\n"

    .text
    .globl _start
_start:
    # Print prompt message
    la a0, prompt
    li a7, 4
    ecall

    # Read integer N from the user
    li a7, 5
    ecall
    mv t0, a0            # t0 stores N

    # Initialize Fibonacci variables
    li t1, 0             # t1 = 0 (first Fibonacci number)
    li t2, 1             # t2 = 1 (second Fibonacci number)

print_fibonacci:
    # Check if the current Fibonacci number is greater than or equal to N
    bge t1, t0, end_program

    # Print the current Fibonacci number (t1)
    mv a0, t1
    li a7, 1              # syscall for print integer
    ecall

    # Print comma and space
    la a0, comma
    li a7, 4              # syscall for print string
    ecall

    # Calculate the next Fibonacci number
    add t3, t1, t2       # t3 = t1 + t2
    mv t1, t2            # t1 = t2 (move to next Fibonacci number)
    mv t2, t3            # t2 = t3 (move to next Fibonacci number)

    # Repeat the loop
    j print_fibonacci

end_program:
    # Print newline
    la a0, newline
    li a7, 4              # syscall for print string
    ecall

    # Exit program
    li a7, 10             # syscall for exit
    ecall
