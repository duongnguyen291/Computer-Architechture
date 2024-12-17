# RISC-V Assembly Code - Assignment 1
# Hi?n th? studentID "66" trên LED 7 ?o?n

.data
DIGIT_TO_7SEG:
    .byte 0x3F    # 0: 00111111
    .byte 0x06    # 1: 00000110
    .byte 0x5B    # 2: 01011011
    .byte 0x4F    # 3: 01001111
    .byte 0x66    # 4: 01100110
    .byte 0x6D    # 5: 01101101
    .byte 0x7D    # 6: 01111101
    .byte 0x07    # 7: 00000111
    .byte 0x7F    # 8: 01111111
    .byte 0x6F    # 9: 01101111

.text
.global main
main:    
    # ??c m?t ký t? t? ng??i dùng
    li      a7, 12               # ecall code cho ??c ký t?
    ecall
    # Mã ASCII c?a ký t? n?m trong a0

    # L?y 2 ch? s? cu?i c?a mã ASCII
    li      t3, 100              # t3 = 100
    rem     t0, a0, t3           # t0 = a0 % 100 (l?y 2 ch? s? cu?i)

    # Tách ch? s? hàng ch?c và hàng ??n v?
    li      t3, 10               # t3 = 10
    div     t1, t0, t3           # t1 = t0 / 10 (ch? s? hàng ch?c)
    rem     t2, t0, t3           # t2 = t0 % 10 (ch? s? hàng ??n v?)

    # L?y mã 7 ?o?n cho ch? s? hàng ch?c
    la      t3, DIGIT_TO_7SEG    # t3 = ??a ch? b?ng mã 7 ?o?n
    add     t4, t3, t1           # t4 = ??a ch? mã 7 ?o?n cho ch? s? hàng ch?c
    lbu     a0, 0(t4)            # a0 = mã 7 ?o?n cho ch? s? hàng ch?c
    jal     SHOW_7SEG_LEFT       # Hi?n th? trên LED bên trái

    # L?y mã 7 ?o?n cho ch? s? hàng ??n v?
    la      t3, DIGIT_TO_7SEG    # t3 = ??a ch? b?ng mã 7 ?o?n
    add     t4, t3, t2           # t4 = ??a ch? mã 7 ?o?n cho ch? s? hàng ??n v?
    lbu     a0, 0(t4)            # a0 = mã 7 ?o?n cho ch? s? hàng ??n v?
    jal     SHOW_7SEG_RIGHT      # Hi?n th? trên LED bên ph?i

    # K?t thúc ch??ng trình
    li      a7, 10               # ecall code cho thoát
    ecall

# ---------------------------------------------------------------
# Hàm SHOW_7SEG_LEFT: Hi?n th? trên LED 7 ?o?n bên trái
# param[in] a0 - giá tr? c?n hi?n th?
# ---------------------------------------------------------------
SHOW_7SEG_LEFT:
    lui     t0, 1048560          # t0 = 1048560 << 12
    addi    t0, t0, 17           # t0 = t0 + 17 (??a ch? SEVENSEG_LEFT)
    sb      a0, 0(t0)            # Ghi giá tr? vào ??a ch? LED bên trái
    jr      ra                   # Quay l?i hàm g?i

# ---------------------------------------------------------------
# Hàm SHOW_7SEG_RIGHT: Hi?n th? trên LED 7 ?o?n bên ph?i
# param[in] a0 - giá tr? c?n hi?n th?
# ---------------------------------------------------------------
SHOW_7SEG_RIGHT:
    lui     t0, 1048560          # t0 = 1048560 << 12
    addi    t0, t0, 16           # t0 = t0 + 16 (??a ch? SEVENSEG_RIGHT)
    sb      a0, 0(t0)            # Ghi giá tr? vào ??a ch? LED bên ph?i
    jr      ra                   # Quay l?i hàm g?i
