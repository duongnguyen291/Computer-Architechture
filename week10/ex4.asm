.data
buffer: .space 4        # Dành 4 byte b? nh? ?? l?u 4 ký t? cu?i cùng ???c nh?p vào.

.text
.globl main
main:
    # ??a ch? b? nh? vào/ra (MMIO)
    .eqv KEY_CODE       0xFFFF0004   # ??a ch? nh?n mã ASCII t? bàn phím, 1 byte
    .eqv KEY_READY      0xFFFF0000   # =1 khi có mã phím m?i s?n sàng (t? ??ng xóa sau khi ??c)
    .eqv DISPLAY_CODE   0xFFFF000C   # ??a ch? ghi mã ASCII ?? hi?n th?, 1 byte
    .eqv DISPLAY_READY  0xFFFF0008   # =1 khi màn hình s?n sàng (t? ??ng xóa sau khi ghi)

    # Kh?i t?o ??a ch? và h?ng s?
    li      a0, KEY_CODE            # L?u ??a ch? c?a KEY_CODE vào thanh ghi a0
    li      a1, KEY_READY           # L?u ??a ch? c?a KEY_READY vào thanh ghi a1
    li      s0, DISPLAY_CODE        # L?u ??a ch? c?a DISPLAY_CODE vào thanh ghi s0
    li      s1, DISPLAY_READY       # L?u ??a ch? c?a DISPLAY_READY vào thanh ghi s1
    la      s2, buffer              # L?u ??a ch? c?a buffer vào thanh ghi s2
    li      s3, 'e'                 # Mã ASCII c?a ký t? 'e'
    li      s4, 'x'                 # Mã ASCII c?a ký t? 'x'
    li      s5, 'i'                 # Mã ASCII c?a ký t? 'i'
    li      s6, 't'                 # Mã ASCII c?a ký t? 't'

loop:
    # Ch? m?t phím ???c nh?n
WaitForKey:
    lw      t1, 0(a1)               # ??c KEY_READY vào thanh ghi t1
    beq     t1, zero, WaitForKey    # N?u KEY_READY == 0 thì ti?p t?c ch?

    # ??c mã phím
ReadKey:
    lb      t0, 0(a0)               # ??c mã phím vào t0 (1 byte)
    andi    t0, t0, 0xFF            # ??m b?o t0 ch? ch?a 8 bit
    mv      s7, t0                  # L?u mã phím g?c vào thanh ghi s7

    # X? lý mã phím
    # Ki?m tra n?u là ch? cái vi?t th??ng
    li      s8, 'a'
    li      s9, 'z'
    blt     t0, s8, check_uppercase # N?u t0 < 'a', ki?m tra ch? vi?t hoa
    bgt     t0, s9, check_uppercase # N?u t0 > 'z', ki?m tra ch? vi?t hoa
    addi    t0, t0, -32             # Chuy?n sang ch? hoa (gi?m 32)
    j       after_processing

check_uppercase:
    # Ki?m tra n?u là ch? cái vi?t hoa
    li      s8, 'A'
    li      s9, 'Z'
    blt     t0, s8, check_digit     # N?u t0 < 'A', ki?m tra ch? s?
    bgt     t0, s9, check_digit     # N?u t0 > 'Z', ki?m tra ch? s?
    addi    t0, t0, 32              # Chuy?n sang ch? th??ng (t?ng 32)
    j       after_processing

check_digit:
    # Ki?m tra n?u là ch? s?
    li      s8, '0'
    li      s9, '9'
    blt     t0, s8, set_star        # N?u t0 < '0', gán ký t? '*'
    bgt     t0, s9, set_star        # N?u t0 > '9', gán ký t? '*'
    j       after_processing        # N?u là ch? s?, không thay ??i

set_star:
    li      t0, '*'                 # Gán t0 b?ng ký t? '*'

after_processing:
    # Ch? màn hình s?n sàng
WaitForDisplay:
    lw      t2, 0(s1)               # ??c DISPLAY_READY vào t2
    beq     t2, zero, WaitForDisplay # N?u DISPLAY_READY == 0 thì ch?

    # Hi?n th? ký t? ?ã x? lý
    sb      t0, 0(s0)               # Ghi ký t? vào DISPLAY_CODE

    # C?p nh?t buffer v?i mã phím g?c
    # D?ch n?i dung buffer
    lb      s8, 1(s2)
    sb      s8, 0(s2)
    lb      s8, 2(s2)
    sb      s8, 1(s2)
    lb      s8, 3(s2)
    sb      s8, 2(s2)
    sb      s7, 3(s2)               # Thêm mã phím g?c vào cu?i buffer

    # Ki?m tra n?u 4 ký t? cu?i là "exit"
    lb      s8, 0(s2)
    bne     s8, s3, loop            # So sánh v?i 'e'
    lb      s8, 1(s2)
    bne     s8, s4, loop            # So sánh v?i 'x'
    lb      s8, 2(s2)
    bne     s8, s5, loop            # So sánh v?i 'i'
    lb      s8, 3(s2)
    bne     s8, s6, loop            # So sánh v?i 't'

    # Thoát ch??ng trình n?u nh?p "exit"
    j       exit_program

    j       loop                    # L?p l?i vòng l?p

exit_program:
    li      a7, 10                  # Mã syscall ?? thoát
    ecall                           # G?i syscall ?? k?t thúc ch??ng trình
