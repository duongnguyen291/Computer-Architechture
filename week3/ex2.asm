.data
 A: .word 2, 2, 2, 2
.text
	 # TODO: Initialize s2, s3, s4 registers
	 li s1, 0 # i = 0
	 la s2, A # ??a ch? c?a m?ng
	 li s3, 4 # S? ph?n t? c?a m?ng
	 li s4, 1 # S? b??c nh?y
	 li s5, 0 # sum = 0
loop:
	 slt t2, s1, s3 # check loop condition i < n
	 beq t2, zero, endloop # if i >= n then end loop
	 add t1, s1, s1 # t1 = 2 * s1
	 add t1, t1, t1 # t1 = 4 * s1 => t1 = 4*i
	 add t1, t1, s2 # t1 store the address of A[i]
	 lw t0, 0(t1) # load value of A[i] in t0
	 add s5, s5, t0 # sum = sum + A[i]
	 add s1, s1, s4 # i = i + step
	 j loop # go to loop
endloop: