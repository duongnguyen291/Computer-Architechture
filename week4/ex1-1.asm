.text 
	# Kh?i t?o s1 v� s2
	li s1, -2147483648
	li s2, -1

	# Thu?t to�n x�c ??nh ?i?u ki?n tr�n s?
	li t0, 0 # M?c ??nh kh�ng c� tr�n s?
	add s3, s1, s2 # s3 = s1 + s2
	xor t1, s1, s2 # Ki?m tra xem s1 v� s2 c� c�ng d?u hay kh�ng
	blt t1, zero, EXIT # N?u kh�ng, tho�t
	blt s1, zero, NEGATIVE # Ki?m tra xem s1 v� s2 c� �m kh�ng?
	bge s3, s1, EXIT # s1 v� s2 d??ng
	# n?u s3 >= s1 th� k?t qu? kh�ng b? tr�n s?
	j OVERFLOW 
	
NEGATIVE: 
	li, t0, 2
	bge s1, s3, EXIT # s1 v� s2 �m
	j AMTRAN
	# n?u s1 >= s3 th� k?t qu? kh�ng b? tr�n s? 
	
OVERFLOW:
	li t0, 1 # K?t qu? b? tr�n s?
AMTRAN:
	li t0, 3
EXIT:
