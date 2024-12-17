.text 
	# Kh?i t?o s1 và s2
	li s1, -2147483648
	li s2, -1

	# Thu?t toán xác ??nh ?i?u ki?n tràn s?
	li t0, 0 # M?c ??nh không có tràn s?
	add s3, s1, s2 # s3 = s1 + s2
	xor t1, s1, s2 # Ki?m tra xem s1 và s2 có cùng d?u hay không
	blt t1, zero, EXIT # N?u không, thoát
	blt s1, zero, NEGATIVE # Ki?m tra xem s1 và s2 có âm không?
	bge s3, s1, EXIT # s1 và s2 d??ng
	# n?u s3 >= s1 thì k?t qu? không b? tràn s?
	j OVERFLOW 
	
NEGATIVE: 
	li, t0, 2
	bge s1, s3, EXIT # s1 và s2 âm
	j AMTRAN
	# n?u s1 >= s3 thì k?t qu? không b? tràn s? 
	
OVERFLOW:
	li t0, 1 # K?t qu? b? tràn s?
AMTRAN:
	li t0, 3
EXIT:
