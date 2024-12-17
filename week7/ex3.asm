.text
main:
    li      s0, 69         # Gán giá tr? 10 cho thanh ghi s0
    li      s1, 96         # Gán giá tr? 20 cho thanh ghi s1
    jal     swap           # G?i th? t?c swap ?? hoán ??i giá tr? s0 và s1
    # K?t thúc ch??ng trình
    li      a7, 10         # G?i d?ch v? h? th?ng ?? k?t thúc
    ecall
# ----------------------------------------------------------------------
# Procedure swap: hoán ??i giá tr? c?a hai thanh ghi s0 và s1
# ----------------------------------------------------------------------
swap:
    addi    sp, sp, -8     # ?i?u ch?nh con tr? ng?n x?p (gi?m 8 byte)
    sw      s0, 4(sp)      # L?u giá tr? s0 vào ng?n x?p
    sw      s1, 0(sp)      # L?u giá tr? s1 vào ng?n x?p
    nop                    # L?nh r?ng
    # Ph?c h?i giá tr? t? ng?n x?p
    lw      s0, 0(sp)      # L?y giá tr? s1 t? ng?n x?p và gán cho s0
    lw      s1, 4(sp)      # L?y giá tr? s0 t? ng?n x?p và gán cho s1
    addi    sp, sp, 8      # Khôi ph?c con tr? ng?n x?p (t?ng 8 byte)

    jr      ra             # Quay l?i ch??ng trình chính
