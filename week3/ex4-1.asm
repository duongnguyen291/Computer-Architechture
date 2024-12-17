.text
start:
    # Initialize i to s1
    li s1, 1
    # Initialize j to s2
    li s2, 2
    li t2, 2
    li t3, 2
    slt t0, s1, s2     # Set t0 = 1 if i < j, else 0
    bne t0, zero, else # If t0 != 0 (i < j), jump to else
then:
    addi t2, t2, -1    # Else part: y = y - 1
    add t3, t3, t3     # z = 2 * z
    j endif             # Skip else part
else:
    addi t1, t1, 1     # Then part: x = x + 1
    addi t3, zero, 1   # z = 1
endif:
