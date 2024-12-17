.data
    prompt:     .string "Nhap so N: "
    lucky:      .string "Day la so may man!\n"
    not_lucky:  .string "Day khong phai la so may man!\n"
    buffer:     .space 12    # Buffer ?? l?u s? nh?p v�o
    newline:    .string "\n"

.text
.globl main

main:
    # In prompt
    la a0, prompt
    li a7, 4
    ecall
    
    # ??c s? nguy�n
    li a7, 5       # syscall ?? ??c s? nguy�n
    ecall
    mv s0, a0      # L?u s? v�o s0
    
    # T�nh s? ch? s?
    mv t0, s0      # Copy s? v�o t0
    li t1, 0       # ??m s? ch? s?
count_digits:
    beqz t0, prep_check
    li t2, 10
    div t0, t0, t2
    addi t1, t1, 1
    j count_digits

prep_check:
    # Ki?m tra s? ch? s? ch?n/l?
    li t2, 2
    div t3, t1, t2     # t3 = s? ch? s?/2
    
    # Reset c�c bi?n
    mv t0, s0          # Copy l?i s? ban ??u
    li t4, 0          # Sum b�n tr�i
    li t5, 0          # Sum b�n ph?i
    li t6, 0          # Counter
    
    # T?o 10^n ?? l?y t?ng ch? s?
    li s1, 1          # s1 = 10^n
    li s2, 10
power_loop:
    beq t6, t1, start_check
    mul s1, s1, s2
    addi t6, t6, 1
    j power_loop

start_check:
    li t6, 0          # Reset counter
    
get_digits:
    beq t6, t1, compare_sums
    div s3, s1, s2    # s3 = 10^(n-1)
    div t2, t0, s3    # L?y ch? s? ??u
    rem t0, t0, s3    # C?p nh?t s? c�n l?i
    
    # Ki?m tra n?a tr�i/ph?i
    bge t6, t3, add_right
add_left:
    add t4, t4, t2    # C?ng v�o t?ng b�n tr�i
    j continue
add_right:
    add t5, t5, t2    # C?ng v�o t?ng b�n ph?i
continue:
    mv s1, s3         # C?p nh?t 10^n
    addi t6, t6, 1
    j get_digits

compare_sums:
    # So s�nh t?ng 2 b�n
    beq t4, t5, is_lucky
    
not_lucky_label:
    # In k?t qu? kh�ng may m?n
    la a0, not_lucky
    li a7, 4
    ecall
    j exit

is_lucky:
    # In k?t qu? may m?n
    la a0, lucky
    li a7, 4
    ecall

exit:
    # Tho�t ch??ng tr�nh
    li a7, 10
    ecall