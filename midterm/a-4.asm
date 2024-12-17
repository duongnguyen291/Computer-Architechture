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

    # Initialize loop variable i = 2 (perfect numbers start from 2)
    li t1, 2             # t1 is the current number to check if it's perfect

check_perfect:
    # Check if i >= N
    bge t1, t0, end_program  # If i >= N, end program

    # Initialize sum of divisors (excluding itself)
    li t2, 1              # t2 is the divisor starting from 1
    li t3, 0              # t3 will store the sum of divisors of t1

divisor_check:
    # Check if t2 >= t1 (only consider divisors less than t1)
    bge t2, t1, verify_perfect

    # Check if t1 % t2 == 0 (t2 is a divisor of t1)
    rem t4, t1, t2
    beq t4, zero, add_divisor  # If t1 % t2 == 0, add t2 to the sum

    # Increment divisor t2
    addi t2, t2, 1
    j divisor_check

add_divisor:
    # Add t2 to the sum of divisors
    add t3, t3, t2
    # Increment divisor t2
    addi t2, t2, 1
    j divisor_check

verify_perfect:
    # Check if sum of divisors (t3) is equal to t1
    bne t3, t1, skip_print  # If t3 != t1, then t1 is not a perfect number

    # Print the current perfect number (t1)
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
    j check_perfect

end_program:
    # Print newline
    la a0, newline
    li a7, 4              # syscall for print string
    ecall

    # Exit program
    li a7, 10             # syscall for exit
    ecall
