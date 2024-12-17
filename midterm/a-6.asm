.data
    prompt:     .string "Nhap so nguyen duong N (he co so 10): "
    result:     .string "So N o he co so 8 la: "
    newline:    .string "\n"
    buffer:     .space 32    # Buffer ?? l?u các ch? s? h? c? s? 8

.text
.globl main

main:
    # In prompt
    la a0, prompt
    li a7, 4
    ecall
    
    # ??c s? nguyên N
    li a7, 5
    ecall
    mv s0, a0      # L?u N vào s0
    
    # Kh?i t?o các bi?n
    la s1, buffer  # ??a ch? buffer ?? l?u k?t qu?
    li t0, 8       # Divisor = 8
    li t1, 0       # Counter cho s? ch? s?
    mv t2, s0      # Copy c?a N ?? làm vi?c
    
convert_loop:
    # Ki?m tra n?u s? = 0
    beqz t2, print_result
    
    # Chia cho 8 và l?y d?
    rem t3, t2, t0     # t3 = N % 8
    div t2, t2, t0     # N = N / 8
    
    # Chuy?n s? d? thành ký t? ASCII và l?u vào buffer
    addi t3, t3, 48    # Chuy?n thành ký t? ASCII
    sb t3, (s1)        # L?u vào buffer
    addi s1, s1, 1     # T?ng con tr? buffer
    addi t1, t1, 1     # T?ng counter
    
    j convert_loop

print_result:
    # In thông báo k?t qu?
    la a0, result
    li a7, 4
    ecall
    
    # Chu?n b? in các ch? s?
    la s1, buffer      # Reset con tr? buffer v? ??u
    add s1, s1, t1     # Di chuy?n ??n cu?i chu?i s?
    addi s1, s1, -1    # Lùi l?i 1 v? trí
    
print_loop:
    # Ki?m tra n?u ?ã in h?t
    beqz t1, print_newline
    
    # L?y và in t?ng ký t?
    lb a0, (s1)
    li a7, 11
    ecall
    
    # C?p nh?t các bi?n
    addi s1, s1, -1    # Lùi con tr?
    addi t1, t1, -1    # Gi?m counter
    
    j print_loop

print_newline:
    # In xu?ng dòng
    la a0, newline
    li a7, 4
    ecall
    
exit:
    # Thoát ch??ng trình
    li a7, 10
    ecall