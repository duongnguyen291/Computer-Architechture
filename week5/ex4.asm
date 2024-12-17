.data 
string: .space 50 # Dành không gian cho chu?i nh?p vào
message1: .asciz "Nhap xau: " # Thông báo yêu c?u nh?p chu?i
message2: .asciz "Do dai xau la: " # Thông báo ?? dài chu?i
newline: .byte 10 # Giá tr? c?a ký t? newline (ASCII 10)
.text 
main: 
get_string: 
 # Hi?n th? h?p tho?i ?? ng??i dùng nh?p chu?i
 la a0, message1 # N?p ??a ch? c?a thông báo yêu c?u nh?p chu?i
 la a1, string # N?p ??a ch? c?a chu?i vào buffer
 li a2, 50 # Gi?i h?n s? ký t? nh?p là 50
 li a7, 54 # Mã ECALL ?? hi?n th? h?p tho?i nh?p chu?i
 ecall # G?i ECALL hi?n th? h?p tho?i
 # Lo?i b? ký t? newline n?u có
 la a0, string # N?p ??a ch? c?a chu?i vào a0
 li t0, 0 # ??t bi?n ??m i = 0
remove_newline: 
 add t1, a0, t0 # Tính ??a ch? c?a string[i]
 lb t2, 0(t1) # L?y giá tr? string[i]
 beq t2, zero, end_remove_nl # N?u g?p ký t? null, k?t thúc vòng l?p
 li t3, 10 # Giá tr? ASCII c?a ký t? newline là 10
 beq t2, t3, set_null # N?u ký t? là newline, thay th? b?ng null
 addi t0, t0, 1 # T?ng bi?n ??m i
 j remove_newline # L?p l?i vòng l?p
set_null: 
 sb zero, 0(t1) # Thay newline b?ng ký t? null
end_remove_nl:
get_length: 
 li t0, 0 # ??t bi?n ??m i = 0
check_char: 
 add t1, a0, t0 # Tính ??a ch? c?a string[i]
 lb t2, 0(t1) # L?y giá tr? string[i] (t2 = string[i])
 beq t2, zero, end_of_str # N?u g?p ký t? null, k?t thúc vòng l?p
 addi t0, t0, 1 # T?ng bi?n ??m i
 j check_char # L?p l?i vòng l?p
end_of_str: 
end_of_get_length: 
print_length: 
 # Hi?n th? ?? dài chu?i ra màn hình b?ng h?p tho?i thông báo
 la a0, message2 # N?p ??a ch? c?a thông báo "Do dai xau la: "
 mv a1, t0 # Chuy?n giá tr? ?? dài chu?i vào thanh ghi a1
 li a7, 56 # Mã ECALL ?? hi?n th? h?p tho?i thông báo ?? dài
 ecall # G?i ECALL hi?n th? h?p tho?i
 # Thoát ch??ng trình
 li a7, 10 # Mã ECALL ?? thoát ch??ng trình
 ecall