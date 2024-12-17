.data
    prompt:     .string "Nhap so nguyen duong N (he co so 10): "
    result:     .string "So N o he co so 8 la: "
    newline:    .string "\n"
    buffer:     .space 32    # Buffer ?? l?u c�c ch? s? h? c? s? 8

.text
.globl main

main:
    # In prompt
    la a0, prompt
    li a7, 4
    ecall
    
    # ??c s? nguy�n N
    li a7, 5
    ecall
    mv s0, a0      # L?u N v�o s0
    
    # Kh?i t?o c�c bi?n
    la s1, buffer  # ??a ch? buffer ?? l?u k?t qu?
    li t0, 8       # Divisor = 8
    li t1, 0       # Counter cho s? ch? s?
    mv t2, s0      # Copy c?a N ?? l�m vi?c
    
convert_loop:
    # Ki?m tra n?u s? = 0
    beqz t2, print_result
    
    # Chia cho 8 v� l?y d?
    rem t3, t2, t0     # t3 = N % 8
    div t2, t2, t0     # N = N / 8
    
    # Chuy?n s? d? th�nh k� t? ASCII v� l?u v�o buffer
    addi t3, t3, 48    # Chuy?n th�nh k� t? ASCII
    sb t3, (s1)        # L?u v�o buffer
    addi s1, s1, 1     # T?ng con tr? buffer
    addi t1, t1, 1     # T?ng counter
    
    j convert_loop

print_result:
    # In th�ng b�o k?t qu?
    la a0, result
    li a7, 4
    ecall
    
    # Chu?n b? in c�c ch? s?
    la s1, buffer      # Reset con tr? buffer v? ??u
    add s1, s1, t1     # Di chuy?n ??n cu?i chu?i s?
    addi s1, s1, -1    # L�i l?i 1 v? tr�
    
print_loop:
    # Ki?m tra n?u ?� in h?t
    beqz t1, print_newline
    
    # L?y v� in t?ng k� t?
    lb a0, (s1)
    li a7, 11
    ecall
    
    # C?p nh?t c�c bi?n
    addi s1, s1, -1    # L�i con tr?
    addi t1, t1, -1    # Gi?m counter
    
    j print_loop

print_newline:
    # In xu?ng d�ng
    la a0, newline
    li a7, 4
    ecall
    
exit:
    # Tho�t ch??ng tr�nh
    li a7, 10
    ecall