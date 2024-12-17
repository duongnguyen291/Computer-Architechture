.text
main:
    li      s0, 69         # G�n gi� tr? 10 cho thanh ghi s0
    li      s1, 96         # G�n gi� tr? 20 cho thanh ghi s1
    jal     swap           # G?i th? t?c swap ?? ho�n ??i gi� tr? s0 v� s1
    # K?t th�c ch??ng tr�nh
    li      a7, 10         # G?i d?ch v? h? th?ng ?? k?t th�c
    ecall
# ----------------------------------------------------------------------
# Procedure swap: ho�n ??i gi� tr? c?a hai thanh ghi s0 v� s1
# ----------------------------------------------------------------------
swap:
    addi    sp, sp, -8     # ?i?u ch?nh con tr? ng?n x?p (gi?m 8 byte)
    sw      s0, 4(sp)      # L?u gi� tr? s0 v�o ng?n x?p
    sw      s1, 0(sp)      # L?u gi� tr? s1 v�o ng?n x?p
    nop                    # L?nh r?ng
    # Ph?c h?i gi� tr? t? ng?n x?p
    lw      s0, 0(sp)      # L?y gi� tr? s1 t? ng?n x?p v� g�n cho s0
    lw      s1, 4(sp)      # L?y gi� tr? s0 t? ng?n x?p v� g�n cho s1
    addi    sp, sp, 8      # Kh�i ph?c con tr? ng?n x?p (t?ng 8 byte)

    jr      ra             # Quay l?i ch??ng tr�nh ch�nh
