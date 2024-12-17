.data 
string: .space 50 # D�nh kh�ng gian cho chu?i nh?p v�o
message1: .asciz "Nhap xau: " # Th�ng b�o y�u c?u nh?p chu?i
message2: .asciz "Do dai xau la: " # Th�ng b�o ?? d�i chu?i
newline: .byte 10 # Gi� tr? c?a k� t? newline (ASCII 10)
.text 
main: 
get_string: 
 # Hi?n th? h?p tho?i ?? ng??i d�ng nh?p chu?i
 la a0, message1 # N?p ??a ch? c?a th�ng b�o y�u c?u nh?p chu?i
 la a1, string # N?p ??a ch? c?a chu?i v�o buffer
 li a2, 50 # Gi?i h?n s? k� t? nh?p l� 50
 li a7, 54 # M� ECALL ?? hi?n th? h?p tho?i nh?p chu?i
 ecall # G?i ECALL hi?n th? h?p tho?i
 # Lo?i b? k� t? newline n?u c�
 la a0, string # N?p ??a ch? c?a chu?i v�o a0
 li t0, 0 # ??t bi?n ??m i = 0
remove_newline: 
 add t1, a0, t0 # T�nh ??a ch? c?a string[i]
 lb t2, 0(t1) # L?y gi� tr? string[i]
 beq t2, zero, end_remove_nl # N?u g?p k� t? null, k?t th�c v�ng l?p
 li t3, 10 # Gi� tr? ASCII c?a k� t? newline l� 10
 beq t2, t3, set_null # N?u k� t? l� newline, thay th? b?ng null
 addi t0, t0, 1 # T?ng bi?n ??m i
 j remove_newline # L?p l?i v�ng l?p
set_null: 
 sb zero, 0(t1) # Thay newline b?ng k� t? null
end_remove_nl:
get_length: 
 li t0, 0 # ??t bi?n ??m i = 0
check_char: 
 add t1, a0, t0 # T�nh ??a ch? c?a string[i]
 lb t2, 0(t1) # L?y gi� tr? string[i] (t2 = string[i])
 beq t2, zero, end_of_str # N?u g?p k� t? null, k?t th�c v�ng l?p
 addi t0, t0, 1 # T?ng bi?n ??m i
 j check_char # L?p l?i v�ng l?p
end_of_str: 
end_of_get_length: 
print_length: 
 # Hi?n th? ?? d�i chu?i ra m�n h�nh b?ng h?p tho?i th�ng b�o
 la a0, message2 # N?p ??a ch? c?a th�ng b�o "Do dai xau la: "
 mv a1, t0 # Chuy?n gi� tr? ?? d�i chu?i v�o thanh ghi a1
 li a7, 56 # M� ECALL ?? hi?n th? h?p tho?i th�ng b�o ?? d�i
 ecall # G?i ECALL hi?n th? h?p tho?i
 # Tho�t ch??ng tr�nh
 li a7, 10 # M� ECALL ?? tho�t ch??ng tr�nh
 ecall