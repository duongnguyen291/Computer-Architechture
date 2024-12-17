.data
A: .word -1, -1, -1, -1, 1  # M?ng v?i 5 ph?n t?
.text
    # Kh?i t?o các thanh ghi
    la s2, A            # ??a ch? c? s? c?a m?ng A
    li s3, 4          # n = s? ph?n t? c?a m?ng A (5 ph?n t?)
    li s1, 0            # i = 0
    li s5, 3            # sum = 0
    li s4, 1            # step = 1
loop:
	 beq s5, zero, endloop
	 bne  s5, zero,  process
process:
	 add t1, s1, s1 # t1 = 2 * s1
	 add t1, t1, t1 # t1 = 4 * s1 => t1 = 4*i
	 add t1, t1, s2 # t1 store the address of A[i]
	 lw  t0, 0(t1) # load value of A[i] in t0
	 add s5, s5, t0 # sum = sum + A[i]
	 add s1, s1, s4 # i = i + step
	 j loop # go to loop
endloop: