.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014

.text
main:
    li t1, IN_ADDRESS_HEXA_KEYBOARD    # ??a ch? nh?p row index
    li t2, OUT_ADDRESS_HEXA_KEYBOARD   # ??a ch? ??c scan code
    li s0, 0x1                         # row index ban ??u (0x1)

polling:
    # G?i row index ?? quét
    sb s0, 0(t1)                       # g?i row index t?i IN_ADDRESS

    # ??c scan code
    lb a0, 0(t2)                       # ??c scan code t? OUT_ADDRESS

    # In scan code n?u có phím ???c nh?n (khác 0)
    beqz a0, check_next_row            # n?u không có phím nh?n, chuy?n row ti?p
    li a7, 34                          # in s? nguyên ? d?ng hex
    ecall

    # In xu?ng dòng
    li a7, 11                          # in ký t?
    li a0, 10                          # ký t? xu?ng dòng '\n'
    ecall

check_next_row:
    # T?m d?ng
    li a7, 32                          # ng? (sleep)
    li a0, 100                         # 100ms
    ecall

    # Chuy?n sang row ti?p theo
    slli s0, s0, 1                     # d?ch trái 1 bit ?? l?y row ti?p (0x1 -> 0x2 -> 0x4 -> 0x8)
    li t3, 0x10                        # gi?i h?n row (sau 0x8)
    bne s0, t3, polling                # n?u ch?a quét h?t các row thì ti?p t?c polling

    # Reset l?i row ??u tiên
    li s0, 0x1
    j polling                          # quay l?i polling
