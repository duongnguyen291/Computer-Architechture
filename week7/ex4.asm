.data
message: .asciz  "Ket qua tinh giai thua la: "  # Chu?i thông báo k?t qu?

.text
main:
    jal    WARP               # G?i th? t?c WARP ?? kh?i t?o và tính giai th?a

print:
    add    a1, s0, zero       # Chuy?n k?t qu? giai th?a vào a1 ?? in ra
    li     a7, 56             # S? d?ch v? h? th?ng ?? in chu?i
    la     a0, message        # ??a ??a ch? chu?i thông báo vào a0
    ecall                     # G?i h? th?ng ?? in thông báo
    
quit:
    li     a7, 10             # S? d?ch v? h? th?ng ?? k?t thúc ch??ng trình
    ecall                     # G?i h? th?ng ?? k?t thúc
end_main:

# ----------------------------------------------------------------------
# Procedure WARP: gán giá tr? n và g?i th? t?c FACT
# ----------------------------------------------------------------------
WARP:
    addi   sp, sp, -4         # ?i?u ch?nh con tr? ng?n x?p (stack pointer) 
    sw     ra, 0(sp)          # L?u ??a ch? tr? v? (return address) lên ng?n x?p

    li     a0, 3              # Gán giá tr? n = 3 vào thanh ghi a0
    jal    FACT               # G?i th? t?c FACT ?? tính giai th?a

    lw     ra, 0(sp)          # Ph?c h?i ??a ch? tr? v? t? ng?n x?p
    addi   sp, sp, 4          # Khôi ph?c con tr? ng?n x?p
    jr     ra                 # Quay tr? l?i ch??ng trình chính
wrap_end:

# ----------------------------------------------------------------------
# Procedure FACT: tính giai th?a c?a n
# param[in]  a0  integer n (s? nguyên n) 
# return     s0  k?t qu? n! (giai th?a c?a n)
# ----------------------------------------------------------------------
FACT:
    addi    sp, sp, -8        # C?p phát không gian trên ng?n x?p ?? l?u ra và a0
    sw      ra, 4(sp)         # L?u thanh ghi ra lên ng?n x?p
    sw      a0, 0(sp)         # L?u giá tr? n (a0) lên ng?n x?p

    li      t0, 2             # Gán t0 = 2
    bge     a0, t0, recursive # N?u n >= 2, g?i ?? quy
    li      s0, 1             # N?u n < 2, tr? v? k?t qu? là 1 (0! = 1 và 1! = 1)
    j       done              # K?t thúc th? t?c FACT

recursive:
    addi    a0, a0, -1         # Gi?m n ?i 1 (n = n - 1)
    jal     FACT              # G?i ?? quy ?? tính (n-1)!
    lw      s1, 0(sp)         # Ph?c h?i giá tr? n t? ng?n x?p
    mul     s0, s0, s1        # Tính n! = n * (n-1)!

done:
    lw      ra, 4(sp)         # Ph?c h?i thanh ghi ra t? ng?n x?p
    lw      a0, 0(sp)         # Ph?c h?i thanh ghi a0 t? ng?n x?p
    addi    sp, sp, 8         # Khôi ph?c con tr? ng?n x?p
    jr      ra                # Quay l?i ??a ch? g?i ban ??u
fact_end:
