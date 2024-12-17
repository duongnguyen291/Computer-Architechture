.text
start:
    li s1,1	# Initialize i to s1
    li s2,1# Initialize j to s2
    li t2,10
    add t0, s1, s2     # t0 = i + j
    slt t0, t0, zero   # Set t0 = 1 if (i + j) < 0, else 0
    beq t0, zero, else # If t0 == 0 (i + j > 0), jump to else
then:
    addi t1, t1, 1     # Then part: x = x + 1
    addi t3, zero, 1   # z = 1
    j endif             # Skip else part
else:
    addi t2, t2, -1    # Else part: y = y - 1
    add t3, t3, t3     # z = 2 * z
endif:
