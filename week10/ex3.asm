# RISC-V Assembly Code - Assignment 3
# V? b�n c? vua tr�n Bitmap Display
# L?u � setting bitmap s? l�:
# Unit width, height in pixels: 2
# Display width, height in pixels: 256

.data
# ??nh ngh?a c�c m�u s?c
WHITE:      .word   0x00FFFFFF  # M�u tr?ng
BLACK:      .word   0x00000000  # M�u ?en

.text
.global main
main:
    # C?u h�nh c�c tham s? c?a Bitmap Display
    # Gi? s? Display Width v� Height l� 128 ??n v? (unit)
    # B?n c� th? ?i?u ch?nh t�y theo c?u h�nh c?a b?n

    # ??a ch? c? s? c?a m�n h�nh
    li      t0, 0x10010000       # MONITOR_SCREEN

    # T?i m�u tr?ng v� ?en v�o thanh ghi
    la      t1, WHITE            # ??a ch? c?a m�u tr?ng
    lw      t2, 0(t1)            # t2 = m�u tr?ng

    la      t1, BLACK            # ??a ch? c?a m�u ?en
    lw      t3, 0(t1)            # t3 = m�u ?en

    # Thi?t l?p c�c tham s? b�n c?
    li      t4, 8                # S? � tr�n m?i h�ng v� c?t (8x8)
    li      t5, 16               # K�ch th??c m?i � (16 ??n v?)

    # B?t ??u v�ng l?p ?? v? b�n c?
    li      s0, 0                # y = 0 (h�ng ??u ti�n)

draw_row:
    bge     s0, t4, end_program  # N?u y >= 8, k?t th�c
    li      s1, 0                # x = 0 (c?t ??u ti�n)

draw_column:
    bge     s1, t4, next_row     # N?u x >= 8, chuy?n sang h�ng ti?p theo

    # T�nh to�n m�u cho � hi?n t?i
    add     t6, s0, s1           # t6 = x + y
    andi    t6, t6, 1            # t6 = (x + y) % 2
    beq     t6, zero, use_white  # N?u t6 == 0, d�ng m�u tr?ng

    # D�ng m�u ?en
    mv      s5, t3               # s5 = m�u ?en
    j       draw_square

use_white:
    # D�ng m�u tr?ng
    mv      s5, t2               # s5 = m�u tr?ng

draw_square:
    # V? � vu�ng k�ch th??c t5 x t5
    # T�nh to�n ??a ch? b?t ??u c?a �
    li      s6, 128              # s6 = Display Width (s? ??n v? tr�n m?i h�ng)
    mul     s7, s0, t5           # s7 = y * k�ch th??c �
    mul     s7, s7, s6           # s7 = s7 * Display Width (t�nh s? d�ng b? qua)
    mul     s8, s1, t5           # s8 = x * k�ch th??c � (t�nh s? c?t b? qua)
    add     s7, s7, s8           # s7 = t?ng offset ??n v?

    # V�ng l?p qua c�c d�ng c?a � vu�ng
    li      s3, 0                # s3 = i = 0

draw_square_row:
    bge     s3, t5, increment_column  # N?u i >= k�ch th??c �, t?ng c?t
    # C?p nh?t offset cho d�ng hi?n t?i
    mul     s9, s3, s6           # s9 = i * Display Width
    add     s10, s7, s9          # s10 = offset d�ng hi?n t?i

    # V�ng l?p qua c�c c?t c?a � vu�ng
    li      s4, 0                # s4 = j = 0

draw_square_column:
    bge     s4, t5, next_square_row  # N?u j >= k�ch th??c �, chuy?n sang d�ng ti?p theo

    # T�nh ??a ch? pixel
    add     s11, s10, s4         # s11 = offset ??n v? hi?n t?i
    slli    s11, s11, 2          # s11 = s11 * 4 (m?i ??n v? 4 byte)
    add     s11, t0, s11         # s11 = ??a ch? pixel hi?n t?i

    # Ghi m�u v�o pixel
    sw      s5, 0(s11)           # [??a ch? pixel] = m�u

    # Ti?p t?c ??n pixel ti?p theo
    addi    s4, s4, 1            # s4 += 1
    j       draw_square_column

next_square_row:
    addi    s3, s3, 1            # s3 += 1
    j       draw_square_row

increment_column:
    addi    s1, s1, 1            # x += 1
    j       draw_column

next_row:
    addi    s0, s0, 1            # y += 1
    j       draw_row

end_program:
    # K?t th�c ch??ng tr�nh
    li      a7, 10               # ecall code cho tho�t
    ecall
