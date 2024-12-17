# RISC-V Assembly Code - Assignment 3
# V? bàn c? vua trên Bitmap Display
# L?u ý setting bitmap s? là:
# Unit width, height in pixels: 2
# Display width, height in pixels: 256

.data
# ??nh ngh?a các màu s?c
WHITE:      .word   0x00FFFFFF  # Màu tr?ng
BLACK:      .word   0x00000000  # Màu ?en

.text
.global main
main:
    # C?u hình các tham s? c?a Bitmap Display
    # Gi? s? Display Width và Height là 128 ??n v? (unit)
    # B?n có th? ?i?u ch?nh tùy theo c?u hình c?a b?n

    # ??a ch? c? s? c?a màn hình
    li      t0, 0x10010000       # MONITOR_SCREEN

    # T?i màu tr?ng và ?en vào thanh ghi
    la      t1, WHITE            # ??a ch? c?a màu tr?ng
    lw      t2, 0(t1)            # t2 = màu tr?ng

    la      t1, BLACK            # ??a ch? c?a màu ?en
    lw      t3, 0(t1)            # t3 = màu ?en

    # Thi?t l?p các tham s? bàn c?
    li      t4, 8                # S? ô trên m?i hàng và c?t (8x8)
    li      t5, 16               # Kích th??c m?i ô (16 ??n v?)

    # B?t ??u vòng l?p ?? v? bàn c?
    li      s0, 0                # y = 0 (hàng ??u tiên)

draw_row:
    bge     s0, t4, end_program  # N?u y >= 8, k?t thúc
    li      s1, 0                # x = 0 (c?t ??u tiên)

draw_column:
    bge     s1, t4, next_row     # N?u x >= 8, chuy?n sang hàng ti?p theo

    # Tính toán màu cho ô hi?n t?i
    add     t6, s0, s1           # t6 = x + y
    andi    t6, t6, 1            # t6 = (x + y) % 2
    beq     t6, zero, use_white  # N?u t6 == 0, dùng màu tr?ng

    # Dùng màu ?en
    mv      s5, t3               # s5 = màu ?en
    j       draw_square

use_white:
    # Dùng màu tr?ng
    mv      s5, t2               # s5 = màu tr?ng

draw_square:
    # V? ô vuông kích th??c t5 x t5
    # Tính toán ??a ch? b?t ??u c?a ô
    li      s6, 128              # s6 = Display Width (s? ??n v? trên m?i hàng)
    mul     s7, s0, t5           # s7 = y * kích th??c ô
    mul     s7, s7, s6           # s7 = s7 * Display Width (tính s? dòng b? qua)
    mul     s8, s1, t5           # s8 = x * kích th??c ô (tính s? c?t b? qua)
    add     s7, s7, s8           # s7 = t?ng offset ??n v?

    # Vòng l?p qua các dòng c?a ô vuông
    li      s3, 0                # s3 = i = 0

draw_square_row:
    bge     s3, t5, increment_column  # N?u i >= kích th??c ô, t?ng c?t
    # C?p nh?t offset cho dòng hi?n t?i
    mul     s9, s3, s6           # s9 = i * Display Width
    add     s10, s7, s9          # s10 = offset dòng hi?n t?i

    # Vòng l?p qua các c?t c?a ô vuông
    li      s4, 0                # s4 = j = 0

draw_square_column:
    bge     s4, t5, next_square_row  # N?u j >= kích th??c ô, chuy?n sang dòng ti?p theo

    # Tính ??a ch? pixel
    add     s11, s10, s4         # s11 = offset ??n v? hi?n t?i
    slli    s11, s11, 2          # s11 = s11 * 4 (m?i ??n v? 4 byte)
    add     s11, t0, s11         # s11 = ??a ch? pixel hi?n t?i

    # Ghi màu vào pixel
    sw      s5, 0(s11)           # [??a ch? pixel] = màu

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
    # K?t thúc ch??ng trình
    li      a7, 10               # ecall code cho thoát
    ecall
