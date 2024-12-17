.text
start:
	li s1,1
	li s2,1
	li s3,2
	li s4,2
	li t2,10
    # Assume m is in s3 and n is in s4
    add t0, s1, s2     # t0 = i + j
    add t1, s3, s4     # t1 = m + n
    slt t0, t1, t0     # Set t0 = 1 if (m + n) < (i + j), else 0
    beq t0, zero, else # If t0 == 0 (i + j <= m + n), jump to else
then:
    addi t1, t1, 1     # Then part: x = x + 1
    addi t3, zero, 1   # z = 1
    j endif             # Skip else part
else:
    addi t2, t2, -1    # Else part: y = y - 1
    add t3, t3, t3     # z = 2 * z
endif:
