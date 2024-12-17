.eqv IN_ADDRESS_HEXA_KEYBOARD       0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD      0xFFFF0014
.data
# -----------------------------------------------------------------
# MAIN Procedure
# -----------------------------------------------------------------
    message: .asciz "Key pressed: "
    keypad_map:
        .byte '0', '4', '8', 'C'  # Row 0
        .byte '1', '5', '9', 'D'  # Row 1
        .byte '2', '6', 'A', 'E'  # Row 2
        .byte '3', '7', 'B', 'F'  # Row 3

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
# Interrupt service routine
handler:
    # Saves the context
    addi    sp, sp, -32        # Adjust stack pointer to save more registers
    sw      a0, 0(sp)
    sw      a1, 4(sp)
    sw      a7, 8(sp)
    sw      t0, 12(sp)
    sw      t1, 16(sp)
    sw      t2, 20(sp)
    sw      t3, 24(sp)
    sw      t4, 28(sp)

    # Initialize t0 to 0 (row index)
    li      t0, 0

    # Re-enable the interrupt
    li      t1, IN_ADDRESS_HEXA_KEYBOARD
    li      t2, 128          # Re-enable interrupt (bit 7)
    sb      t2, 0(t1)

    # Read the key code into t2
    li      t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb      t2, 0(t1)        # t2 = scan code (signed byte)

    # If t2 is zero, no key is pressed
    beq     t2, zero, end_handler

    # Convert t2 to unsigned byte
    andi    t2, t2, 0xFF

    # Extract row bits (bits 7-4)
    srl     t3, t2, 4        # t3 = row bits
    # Extract column bits (bits 3-0)
    andi    t4, t2, 0x0F     # t4 = column bits

    # Find the row number
    li      t5, 0            # t5 = row number
find_row:
    srli    t6, t3, t5
    andi    t6, t6, 0x1
    bne     t6, zero, row_found
    addi    t5, t5, 1
    blt     t5, 4, find_row
    j       end_handler      # Invalid row, exit handler

row_found:
    mv      t7, t5           # t7 = row number

    # Find the column number
    li      t5, 0            # t5 = column number
find_col:
    srli    t6, t4, t5
    andi    t6, t6, 0x1
    bne     t6, zero, col_found
    addi    t5, t5, 1
    blt     t5, 4, find_col
    j       end_handler      # Invalid column, exit handler

col_found:
    mv      t8, t5           # t8 = column number

    # Calculate index into keypad_map
    mul     t9, t7, 4        # t9 = row * 4
    add     t9, t9, t8       # t9 = (row * 4) + column

    # Load the key value from keypad_map
    la      t6, keypad_map
    add     t6, t6, t9
    lb      a1, 0(t6)        # a1 = key value

    # Print the message
    addi    a7, zero, 4      # ecall for print string
    la      a0, message
    ecall

    # Print the key value
    addi    a7, zero, 11     # ecall for print character
    mv      a0, a1
    ecall

    # Print End of Line
    li      a7, 11
    li      a0, '\n'
    ecall

end_handler:
    # Restores the context
    lw      t4, 28(sp)
    lw      t3, 24(sp)
    lw      t2, 20(sp)
    lw      t1, 16(sp)
    lw      t0, 12(sp)
    lw      a7, 8(sp)
    lw      a1, 4(sp)
    lw      a0, 0(sp)
    addi    sp, sp, 32

    # Return from interrupt
    uret
