.eqv IN_ADDRESS_HEXA_KEYBOARD       0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD      0xFFFF0014
.data
    message: .asciz "Key scan code: "
# -----------------------------------------------------------------
# MAIN Procedure
# -----------------------------------------------------------------

.text
main:
    # Load the interrupt service routine address to the UTVEC register
    la      t0, handler
    csrrw   zero, utvec, t0

    # Set the UEIE (User External Interrupt Enable) bit in UIE register
    li      t1, 0x100
    csrrs   zero, uie, t1       # uie - ueie bit (bit 8)
    # Set the UIE (User Interrupt Enable) bit in USTATUS register
    csrrsi  zero, ustatus, 0x1  # ustatus - enable uie (bit 0)

    # Enable the interrupt of keypad of Digital Lab Sim
    li      t1, IN_ADDRESS_HEXA_KEYBOARD
    li      t3, 128  # 0x80 in decimal; bit 7 = 1 to enable interrupt
    sb      t3, 0(t1)

    # ---------------------------------------------------------
    # Loop to print a sequence numbers
    # ---------------------------------------------------------
    xor     s0, s0, s0      # count = s0 = 0
loop:
    addi    s0, s0, 1       # count = count + 1
prn_seq:
    addi    a7, zero, 1
    add     a0, s0, zero    # Print auto sequence number
    ecall
    addi    a7, zero, 11
    li      a0, '\n'        # Print EOL
    ecall
sleep:
    addi    a7, zero, 32
    li      a0, 300         # Sleep 300 ms
    ecall
    j       loop
end_main:

# -----------------------------------------------------------------
# Interrupt service routine
# -----------------------------------------------------------------
handler:
    # Saves the context
    addi    sp, sp, -24        # Adjust stack pointer to save more registers
    sw      a0, 0(sp)
    sw      a1, 4(sp)
    sw      a7, 8(sp)
    sw      t0, 12(sp)
    sw      t1, 16(sp)
    sw      t2, 20(sp)

    # Initialize t0 to 0 (row index)
    li      t0, 0

check_rows:
    # Re-enable the interrupt and select row t0
    li      t1, IN_ADDRESS_HEXA_KEYBOARD
    li      t2, 128          # 0x80 in decimal; re-enable interrupt (bit 7)
    or      t2, t2, t0       # Combine with row index to select row
    sb      t2, 0(t1)        # Write to control register

    # Read the key code into t2
    li      t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb      t2, 0(t1)        # Read the key code into t2

    # Check if key code is non-zero
    beq     t2, zero, next_row

    # Print the message
    addi    a7, zero, 4
    la      a0, message
    ecall

    # Move the key code from t2 to a0 before printing
    add     a0, t2, zero

    # Print the key code
    li      a7, 34           # ecall to print integer in hex
    ecall

    # Print End of Line
    li      a7, 11
    li      a0, '\n'
    ecall

    # Break the loop since key is found
    j       end_handler

next_row:
    addi    t0, t0, 1        # Increment row index
    li      t1, 16           # Number of rows (0 to 15 for 4 bits)
    blt     t0, t1, check_rows

end_handler:
    # Restores the context
    lw      t2, 20(sp)
    lw      t1, 16(sp)
    lw      t0, 12(sp)
    lw      a7, 8(sp)
    lw      a1, 4(sp)
    lw      a0, 0(sp)
    addi    sp, sp, 24

    # Return from interrupt
    uret
