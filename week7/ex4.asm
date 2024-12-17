.data
message: .asciz  "Ket qua tinh giai thua la: "  # Chu?i th�ng b�o k?t qu?

.text
main:
    jal    WARP               # G?i th? t?c WARP ?? kh?i t?o v� t�nh giai th?a

print:
    add    a1, s0, zero       # Chuy?n k?t qu? giai th?a v�o a1 ?? in ra
    li     a7, 56             # S? d?ch v? h? th?ng ?? in chu?i
    la     a0, message        # ??a ??a ch? chu?i th�ng b�o v�o a0
    ecall                     # G?i h? th?ng ?? in th�ng b�o
    
quit:
    li     a7, 10             # S? d?ch v? h? th?ng ?? k?t th�c ch??ng tr�nh
    ecall                     # G?i h? th?ng ?? k?t th�c
end_main:

# ----------------------------------------------------------------------
# Procedure WARP: g�n gi� tr? n v� g?i th? t?c FACT
# ----------------------------------------------------------------------
WARP:
    addi   sp, sp, -4         # ?i?u ch?nh con tr? ng?n x?p (stack pointer) 
    sw     ra, 0(sp)          # L?u ??a ch? tr? v? (return address) l�n ng?n x?p

    li     a0, 3              # G�n gi� tr? n = 3 v�o thanh ghi a0
    jal    FACT               # G?i th? t?c FACT ?? t�nh giai th?a

    lw     ra, 0(sp)          # Ph?c h?i ??a ch? tr? v? t? ng?n x?p
    addi   sp, sp, 4          # Kh�i ph?c con tr? ng?n x?p
    jr     ra                 # Quay tr? l?i ch??ng tr�nh ch�nh
wrap_end:

# ----------------------------------------------------------------------
# Procedure FACT: t�nh giai th?a c?a n
# param[in]  a0  integer n (s? nguy�n n) 
# return     s0  k?t qu? n! (giai th?a c?a n)
# ----------------------------------------------------------------------
FACT:
    addi    sp, sp, -8        # C?p ph�t kh�ng gian tr�n ng?n x?p ?? l?u ra v� a0
    sw      ra, 4(sp)         # L?u thanh ghi ra l�n ng?n x?p
    sw      a0, 0(sp)         # L?u gi� tr? n (a0) l�n ng?n x?p

    li      t0, 2             # G�n t0 = 2
    bge     a0, t0, recursive # N?u n >= 2, g?i ?? quy
    li      s0, 1             # N?u n < 2, tr? v? k?t qu? l� 1 (0! = 1 v� 1! = 1)
    j       done              # K?t th�c th? t?c FACT

recursive:
    addi    a0, a0, -1         # Gi?m n ?i 1 (n = n - 1)
    jal     FACT              # G?i ?? quy ?? t�nh (n-1)!
    lw      s1, 0(sp)         # Ph?c h?i gi� tr? n t? ng?n x?p
    mul     s0, s0, s1        # T�nh n! = n * (n-1)!

done:
    lw      ra, 4(sp)         # Ph?c h?i thanh ghi ra t? ng?n x?p
    lw      a0, 0(sp)         # Ph?c h?i thanh ghi a0 t? ng?n x?p
    addi    sp, sp, 8         # Kh�i ph?c con tr? ng?n x?p
    jr      ra                # Quay l?i ??a ch? g?i ban ??u
fact_end:
