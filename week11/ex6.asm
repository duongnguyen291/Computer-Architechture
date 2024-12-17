.data
overflow_msg: .asciz "Overflow occurred during addition!\n"
.text
main:
    # Set up software interrupt handling
    # Load the interrupt service routine address to the UTVEC register
    la t0, overflow_handler
    csrrs zero, utvec, t0

    # Enable software interrupt
    li t1, 0x2   # USIE bit (bit 1 in uie register)
    csrrs zero, uie, t1

    # Enable global interrupts
    csrrsi zero, ustatus, 1

    # Two numbers to add (choose values that will cause overflow)
    li a0, 0x7FFFFFFF   # Maximum positive 32-bit signed integer
    li a1, 1            # Adding 1 will cause overflow

    # Perform addition with overflow check
    add t0, a0, a1      # This will cause overflow
    bltz t0, trigger_interrupt  # Branch if result is negative (overflow occurred)

    j end_program
    
end_program:
    # If no interrupt triggered, exit program
    li a7, 10
    ecall
    
trigger_interrupt:
    # Trigger software interrupt by setting USIP bit in uip register
    li t1, 0x2   # USIP bit (bit 1 in uip register)
    csrrs zero, uip, t1



# Interrupt Service Routine for overflow
overflow_handler:
    # Save context
    addi sp, sp, -8
    sw a0, 0(sp)
    sw a7, 4(sp)

    # Print overflow message
    li a7, 4
    la a0, overflow_msg
    ecall

    # Restore context
    lw a7, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 8

    # Clear the software interrupt bit
    li t1, 0x2
    csrrc zero, uip, t1

    # Terminate the program
    li a7, 10
    ecall
