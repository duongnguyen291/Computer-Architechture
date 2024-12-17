.data
buffer: .space 4        # D�nh 4 byte b? nh? ?? l?u 4 k� t? cu?i c�ng ???c nh?p v�o.

.text
.globl main
main:
    # ??a ch? b? nh? v�o/ra (MMIO)
    .eqv KEY_CODE       0xFFFF0004   # ??a ch? nh?n m� ASCII t? b�n ph�m, 1 byte
    .eqv KEY_READY      0xFFFF0000   # =1 khi c� m� ph�m m?i s?n s�ng (t? ??ng x�a sau khi ??c)
    .eqv DISPLAY_CODE   0xFFFF000C   # ??a ch? ghi m� ASCII ?? hi?n th?, 1 byte
    .eqv DISPLAY_READY  0xFFFF0008   # =1 khi m�n h�nh s?n s�ng (t? ??ng x�a sau khi ghi)

    # Kh?i t?o ??a ch? v� h?ng s?
    li      a0, KEY_CODE            # L?u ??a ch? c?a KEY_CODE v�o thanh ghi a0
    li      a1, KEY_READY           # L?u ??a ch? c?a KEY_READY v�o thanh ghi a1
    li      s0, DISPLAY_CODE        # L?u ??a ch? c?a DISPLAY_CODE v�o thanh ghi s0
    li      s1, DISPLAY_READY       # L?u ??a ch? c?a DISPLAY_READY v�o thanh ghi s1
    la      s2, buffer              # L?u ??a ch? c?a buffer v�o thanh ghi s2
    li      s3, 'e'                 # M� ASCII c?a k� t? 'e'
    li      s4, 'x'                 # M� ASCII c?a k� t? 'x'
    li      s5, 'i'                 # M� ASCII c?a k� t? 'i'
    li      s6, 't'                 # M� ASCII c?a k� t? 't'

loop:
    # Ch? m?t ph�m ???c nh?n
WaitForKey:
    lw      t1, 0(a1)               # ??c KEY_READY v�o thanh ghi t1
    beq     t1, zero, WaitForKey    # N?u KEY_READY == 0 th� ti?p t?c ch?

    # ??c m� ph�m
ReadKey:
    lb      t0, 0(a0)               # ??c m� ph�m v�o t0 (1 byte)
    andi    t0, t0, 0xFF            # ??m b?o t0 ch? ch?a 8 bit
    mv      s7, t0                  # L?u m� ph�m g?c v�o thanh ghi s7

    # X? l� m� ph�m
    # Ki?m tra n?u l� ch? c�i vi?t th??ng
    li      s8, 'a'
    li      s9, 'z'
    blt     t0, s8, check_uppercase # N?u t0 < 'a', ki?m tra ch? vi?t hoa
    bgt     t0, s9, check_uppercase # N?u t0 > 'z', ki?m tra ch? vi?t hoa
    addi    t0, t0, -32             # Chuy?n sang ch? hoa (gi?m 32)
    j       after_processing

check_uppercase:
    # Ki?m tra n?u l� ch? c�i vi?t hoa
    li      s8, 'A'
    li      s9, 'Z'
    blt     t0, s8, check_digit     # N?u t0 < 'A', ki?m tra ch? s?
    bgt     t0, s9, check_digit     # N?u t0 > 'Z', ki?m tra ch? s?
    addi    t0, t0, 32              # Chuy?n sang ch? th??ng (t?ng 32)
    j       after_processing

check_digit:
    # Ki?m tra n?u l� ch? s?
    li      s8, '0'
    li      s9, '9'
    blt     t0, s8, set_star        # N?u t0 < '0', g�n k� t? '*'
    bgt     t0, s9, set_star        # N?u t0 > '9', g�n k� t? '*'
    j       after_processing        # N?u l� ch? s?, kh�ng thay ??i

set_star:
    li      t0, '*'                 # G�n t0 b?ng k� t? '*'

after_processing:
    # Ch? m�n h�nh s?n s�ng
WaitForDisplay:
    lw      t2, 0(s1)               # ??c DISPLAY_READY v�o t2
    beq     t2, zero, WaitForDisplay # N?u DISPLAY_READY == 0 th� ch?

    # Hi?n th? k� t? ?� x? l�
    sb      t0, 0(s0)               # Ghi k� t? v�o DISPLAY_CODE

    # C?p nh?t buffer v?i m� ph�m g?c
    # D?ch n?i dung buffer
    lb      s8, 1(s2)
    sb      s8, 0(s2)
    lb      s8, 2(s2)
    sb      s8, 1(s2)
    lb      s8, 3(s2)
    sb      s8, 2(s2)
    sb      s7, 3(s2)               # Th�m m� ph�m g?c v�o cu?i buffer

    # Ki?m tra n?u 4 k� t? cu?i l� "exit"
    lb      s8, 0(s2)
    bne     s8, s3, loop            # So s�nh v?i 'e'
    lb      s8, 1(s2)
    bne     s8, s4, loop            # So s�nh v?i 'x'
    lb      s8, 2(s2)
    bne     s8, s5, loop            # So s�nh v?i 'i'
    lb      s8, 3(s2)
    bne     s8, s6, loop            # So s�nh v?i 't'

    # Tho�t ch??ng tr�nh n?u nh?p "exit"
    j       exit_program

    j       loop                    # L?p l?i v�ng l?p

exit_program:
    li      a7, 10                  # M� syscall ?? tho�t
    ecall                           # G?i syscall ?? k?t th�c ch??ng tr�nh
