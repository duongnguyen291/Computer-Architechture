.text
main:
    li t0, 100               # Load immediate: t0 = 100 (equivalent to $s0 in MIPS)
    slti t1, t0, -100        # Set t1 to 1 if t0 < -100, otherwise 0 (equivalent to $at in MIPS)
    beq t1, x0, else         # Branch to 'else' if t1 == 0
    li t2, 1                 # t2 = 1 (executed if branch not taken, equivalent to $t2 in MIPS)
    li t3, 20                # t3 = 20 (executed if branch not taken, equivalent to $t3 in MIPS)
    j endif                  # Jump to 'endif'

else:
    li t2, -1                # t2 = -1 (executed if branch taken)
    li t3, -20               # t3 = -20 (executed if branch taken)

endif:
    nop                      # No operation (placeholder for future instructions)
