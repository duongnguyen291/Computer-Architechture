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

    # Initialize loop variable i = 2
    li t1, 2             # t1 is the current number to check if it's prime

check_prime:
    # Check if i >= N
    bge t1, t0, end_program  # If i >= N, end program

    # Assume i is prime
    li t2, 2              # t2 is the divisor, start from 2
    li t3, 1              # t3 is the flag to indicate if i is prime (1 means prime)

divisor_check:
    # Check if t2 * t2 > t1 (only need to check up to sqrt(i))
    mul t4, t2, t2
    bgt t4, t1, print_prime  # If t2 * t2 > t1, i is prime

    # Check if t1 % t2 == 0
    rem t4, t1, t2
    beq t4, zero, not_prime  # If t1 % t2 == 0, i is not prime

    # Increment divisor t2
    addi t2, t2, 1
    j divisor_check

not_prime:
    li t3, 0              # Set flag to 0 indicating i is not prime

print_prime:
    # If t3 is 1, print the prime number
    beq t3, zero, skip_print

    # Print the current prime number (t1)
    mv a0, t1
    li a7, 1              # syscall for print integer
    ecall

    # Print comma and space
    la a0, comma
    li a7, 4              # syscall for print string
    ecall

skip_print:
    # Increment i and repeat the process
    addi t1, t1, 1
    j check_prime

end_program:
    # Print newline
    la a0, newline
    li a7, 4              # syscall for print string
    ecall

    # Exit program
    li a7, 10             # syscall for exit
    ecall
