.data
    msg1: .string "Largest: "
    msg2: .string ", "
    msg3: .string "\nSmallest: "
    newline: .string "\n"

.text
main:
    # C?p phát b? nh? stack cho 8 s? + 4 k?t qu? (max, maxpos, min, minpos)
    addi sp, sp, -48
    
    # L?u các giá tr? test vào stack
    li t0, 5
    sw t0, 0(sp)   # a0
    li t0, -2
    sw t0, 4(sp)   # a1
    li t0, 7
    sw t0, 8(sp)   # a2
    li t0, 9
    sw t0, 12(sp)  # a3
    li t0, 1
    sw t0, 16(sp)  # a4
    li t0, 12
    sw t0, 20(sp)  # a5
    li t0, -3
    sw t0, 24(sp)  # a6
    li t0, -6
    sw t0, 28(sp)  # a7
    
    # G?i hàm tìm max/min
    jal ra, find_max_min

    # In "Largest: "
    la a0, msg1
    li a7, 4
    ecall
    
    # In giá tr? max
    lw a0, 32(sp)
    li a7, 1
    ecall
    
    # In ", "
    la a0, msg2
    li a7, 4
    ecall
    
    # In v? trí max
    lw a0, 36(sp)
    li a7, 1
    ecall
    
    # In "\nSmallest: "
    la a0, msg3
    li a7, 4
    ecall
    
    # In giá tr? min
    lw a0, 40(sp)
    li a7, 1
    ecall
    
    # In ", "
    la a0, msg2
    li a7, 4
    ecall
    
    # In v? trí min
    lw a0, 44(sp)
    li a7, 1
    ecall
    
    # In newline
    la a0, newline
    li a7, 4
    ecall
    
    # Gi?i phóng stack và k?t thúc
    addi sp, sp, 48
    li a7, 10
    ecall

find_max_min:
    # Kh?i t?o giá tr? max, min là ph?n t? ??u tiên
    lw t0, 0(sp)   # t0 = max value
    mv t1, t0      # t1 = min value
    li t2, 0       # t2 = max position
    li t3, 0       # t3 = min position
    li t4, 1       # t4 = counter (b?t ??u t? 1 vì ?ã l?y ph?n t? 0)
    li t5, 8       # t5 = size of array
    
loop:
    beq t4, t5, end_loop    # N?u ?ã duy?t h?t thì thoát
    
    # Load giá tr? hi?n t?i
    slli t6, t4, 2          # t6 = t4 * 4 (offset)
    add t6, sp, t6          # t6 = ??a ch? ph?n t? hi?n t?i
    lw s1, 0(t6)            # s1 = giá tr? hi?n t?i
    
    # So sánh v?i max
    bge t0, s1, check_min   # N?u max >= current thì ki?m tra min
    mv t0, s1               # Update max value
    mv t2, t4               # Update max position
    
check_min:
    ble t1, s1, continue    # N?u min <= current thì continue
    mv t1, s1               # Update min value
    mv t3, t4               # Update min position
    
continue:
    addi t4, t4, 1         # T?ng counter
    j loop
    
end_loop:
    # L?u k?t qu? vào stack
    sw t0, 32(sp)          # max value
    sw t2, 36(sp)          # max position
    sw t1, 40(sp)          # min value
    sw t3, 44(sp)          # min position
    
    ret