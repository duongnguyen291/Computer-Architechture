.data
	string: .space 21                # C?p ph�t 21 byte cho chu?i (bao g?m 20 k� t? v� 1 k� t? null)
	msg: .asciz "Nhap ky tu: "       # Th�ng b�o y�u c?u nh?p k� t?
	msg2: .asciz "\nChuoi nguoc lai la: " # Th�ng b�o v? chu?i ng??c
.text
get_str:
	la a0, msg                      # ??a th�ng b�o "Nhap ky tu: " v�o thanh ghi a0 ?? in ra
	li a7, 4                        # M� h? th?ng ?? in chu?i (syscall 4)
	ecall                           # Th?c hi?n l?nh syscall ?? in ra th�ng b�o

	li t0, 0                        # t0 l� ch? s? hi?n t?i c?a chu?i (?? ??m s? k� t?)
	la t1, string                   # t1 tr? ??n v? tr� b?t ??u c?a chu?i (string)

get_input:
	li a7, 12                       # M� h? th?ng ?? ??c k� t? (syscall 12)
	ecall                           # Th?c hi?n l?nh syscall ?? ??c k� t? t? ng??i d�ng
	sb a0, 0(t1)                    # L?u k� t? v?a nh?p v�o v? tr� hi?n t?i c?a chu?i (t1)
	
	li t2, 10                       # t2 gi? gi� tr? '\n' (m� ASCII 10)
	beq a0, t2, end_input            # N?u k� t? nh?p v�o l� '\n' (Enter), th� k?t th�c nh?p

	addi t0, t0, 1                  # T?ng ch? s? chu?i (s? k� t? ?� nh?p)
	addi t1, t1, 1                  # Di chuy?n con tr? chu?i (t1) ??n v? tr� ti?p theo
	
	li t2, 20                       # t2 gi? gi� tr? 20 (s? k� t? t?i ?a c� th? nh?p)
	bge t0, t2, end_input           # N?u s? k� t? nh?p v�o >= 20, th� d?ng nh?p

	j get_input                     # Quay l?i v�ng l?p nh?p k� t? ti?p theo

end_input:
	sb zero, 0(t1)                  # Th�m k� t? null '\0' v�o cu?i chu?i ?? k?t th�c chu?i
	la t1, string                   # t1 tr? l?i v? tr� ??u ti�n c?a chu?i (string)
	add t2, t1, t0                  # t2 tr? ??n v? tr� cu?i c�ng c?a chu?i (d?a tr�n s? k� t? t0)
	addi t2, t2, -1                 # t2 tr? ??n k� t? cu?i c�ng th?c s? c?a chu?i (kh�ng ph?i null)
	addi t3, t0, -1                 # t3 l� ch? s? d�ng ?? duy?t ng??c chu?i

	la a0, msg2                     # ??a th�ng b�o "Chuoi nguoc lai la: " v�o a0
	li a7, 4                        # M� h? th?ng ?? in chu?i (syscall 4)
	ecall                           # Th?c hi?n l?nh syscall ?? in ra th�ng b�o

print_rev:
	blt t3, zero, end_prog           # N?u ch? s? t3 < 0 (?� duy?t h?t chu?i), th� k?t th�c ch??ng tr�nh
	lb a0, 0(t2)                    # ??c k� t? t?i v? tr� t2 (k� t? hi?n t?i c?a chu?i ng??c)
	li a7, 11                       # M� h? th?ng ?? in k� t? (syscall 11)
	ecall                           # Th?c hi?n l?nh syscall ?? in k� t? ra m�n h�nh
	addi t2, t2, -1                 # Di chuy?n t2 v? ph�a tr??c (k� t? tr??c trong chu?i)
	addi t3, t3, -1                 # Gi?m ch? s? t3 (v� ?ang duy?t ng??c chu?i)
	j print_rev                     # Quay l?i v�ng l?p ?? in k� t? ti?p theo

end_prog:	
	li a7, 10                       # M� h? th?ng ?? tho�t ch??ng tr�nh (syscall 10)
	ecall                           # Th?c hi?n l?nh syscall ?? tho�t ch??ng tr�nh
