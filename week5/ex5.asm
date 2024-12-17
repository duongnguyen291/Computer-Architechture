.data
	string: .space 21                # C?p phát 21 byte cho chu?i (bao g?m 20 ký t? và 1 ký t? null)
	msg: .asciz "Nhap ky tu: "       # Thông báo yêu c?u nh?p ký t?
	msg2: .asciz "\nChuoi nguoc lai la: " # Thông báo v? chu?i ng??c
.text
get_str:
	la a0, msg                      # ??a thông báo "Nhap ky tu: " vào thanh ghi a0 ?? in ra
	li a7, 4                        # Mã h? th?ng ?? in chu?i (syscall 4)
	ecall                           # Th?c hi?n l?nh syscall ?? in ra thông báo

	li t0, 0                        # t0 là ch? s? hi?n t?i c?a chu?i (?? ??m s? ký t?)
	la t1, string                   # t1 tr? ??n v? trí b?t ??u c?a chu?i (string)

get_input:
	li a7, 12                       # Mã h? th?ng ?? ??c ký t? (syscall 12)
	ecall                           # Th?c hi?n l?nh syscall ?? ??c ký t? t? ng??i dùng
	sb a0, 0(t1)                    # L?u ký t? v?a nh?p vào v? trí hi?n t?i c?a chu?i (t1)
	
	li t2, 10                       # t2 gi? giá tr? '\n' (mã ASCII 10)
	beq a0, t2, end_input            # N?u ký t? nh?p vào là '\n' (Enter), thì k?t thúc nh?p

	addi t0, t0, 1                  # T?ng ch? s? chu?i (s? ký t? ?ã nh?p)
	addi t1, t1, 1                  # Di chuy?n con tr? chu?i (t1) ??n v? trí ti?p theo
	
	li t2, 20                       # t2 gi? giá tr? 20 (s? ký t? t?i ?a có th? nh?p)
	bge t0, t2, end_input           # N?u s? ký t? nh?p vào >= 20, thì d?ng nh?p

	j get_input                     # Quay l?i vòng l?p nh?p ký t? ti?p theo

end_input:
	sb zero, 0(t1)                  # Thêm ký t? null '\0' vào cu?i chu?i ?? k?t thúc chu?i
	la t1, string                   # t1 tr? l?i v? trí ??u tiên c?a chu?i (string)
	add t2, t1, t0                  # t2 tr? ??n v? trí cu?i cùng c?a chu?i (d?a trên s? ký t? t0)
	addi t2, t2, -1                 # t2 tr? ??n ký t? cu?i cùng th?c s? c?a chu?i (không ph?i null)
	addi t3, t0, -1                 # t3 là ch? s? dùng ?? duy?t ng??c chu?i

	la a0, msg2                     # ??a thông báo "Chuoi nguoc lai la: " vào a0
	li a7, 4                        # Mã h? th?ng ?? in chu?i (syscall 4)
	ecall                           # Th?c hi?n l?nh syscall ?? in ra thông báo

print_rev:
	blt t3, zero, end_prog           # N?u ch? s? t3 < 0 (?ã duy?t h?t chu?i), thì k?t thúc ch??ng trình
	lb a0, 0(t2)                    # ??c ký t? t?i v? trí t2 (ký t? hi?n t?i c?a chu?i ng??c)
	li a7, 11                       # Mã h? th?ng ?? in ký t? (syscall 11)
	ecall                           # Th?c hi?n l?nh syscall ?? in ký t? ra màn hình
	addi t2, t2, -1                 # Di chuy?n t2 v? phía tr??c (ký t? tr??c trong chu?i)
	addi t3, t3, -1                 # Gi?m ch? s? t3 (vì ?ang duy?t ng??c chu?i)
	j print_rev                     # Quay l?i vòng l?p ?? in ký t? ti?p theo

end_prog:	
	li a7, 10                       # Mã h? th?ng ?? thoát ch??ng trình (syscall 10)
	ecall                           # Th?c hi?n l?nh syscall ?? thoát ch??ng trình
