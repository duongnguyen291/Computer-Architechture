.data
A: .word 1, -5, 3, 7, -2, 8, -6  # Kh?i t?o m?ng A v?i c�c ph?n t? s? nguy�n

.text
main:
la a0, A        # T?i ??a ch? c? s? c?a m?ng A v�o thanh ghi a0
li a1, 8        # G�n gi� tr? 8 v�o a1 (s? ph?n t? trong m?ng, nh?ng th?c t? m?ng ch? c� 7 ph?n t?. ?? ti?n s? d?ng blt)
j mspfx         # Nh?y ??n th? t?c mspfx ?? t�nh t?ng ti?n t? l?n nh?t
continue:
exit:
li a7, 10       # G�n gi� tr? 10 v�o a7 (m� cho system call k?t th�c ch??ng tr�nh)
ecall           # G?i system call ?? k?t th�c ch??ng tr�nh
end_of_main:

# -----------------------------------------------------------------
# Th? t?c mspfx
# @brief T�m t?ng ti?n t? l?n nh?t trong danh s�ch c�c s? nguy�n
# @param[in] a0 ??a ch? c? s? c?a danh s�ch (A) c?n x? l�
# @param[in] a1 S? ph?n t? trong danh s�ch (A)
# @param[out] s0 ?? d�i c?a m?ng con (sub-array) trong A m� t?ng l?n nh?t ??t ???c
# @param[out] s1 T?ng l?n nh?t c?a m?t m?ng con x�c ??nh
# -----------------------------------------------------------------

mspfx:
li s0, 0            # Kh?i t?o ?? d�i c?a ti?n t? l?n nh?t trong s0 l� 0
li s1, 0x80000000   # Kh?i t?o t?ng ti?n t? l?n nh?t trong s1 l� s? nguy�n nh? nh?t (gi� tr? nh? nh?t ki?u int)
li t0, 0            # Kh?i t?o ch? s? i cho v�ng l?p trong t0 l� 0
li t1, 0            # Kh?i t?o t?ng ch?y (running sum) trong t1 l� 0
loop: 
add t2, t0, t0      # ??a 2*i v�o t2 (t�nh 2*i)
add t2, t2, t2      # ??a 4*i v�o t2 (t�nh 4*i)
add t3, t2, a0      # ??a ??a ch? c?a A[i] v�o t3 (t�nh 4*i + A)
lw t4, 0(t3)        # T?i gi� tr? A[i] t? b? nh? v�o t4
add t1, t1, t4      # C?ng gi� tr? A[i] v�o t?ng ch?y (running sum) trong t1
blt s1, t1, mdfy    # N?u t?ng ch?y (t1) l?n h?n t?ng l?n nh?t hi?n t?i (s1), nh?y ??n mdfy ?? c?p nh?t k?t qu?
j next              # Nh?y ??n b??c ti?p theo n?u kh�ng c?n c?p nh?t

mdfy:
addi s0, t0, 1      # C?p nh?t ?? d�i m?i c?a ti?n t? l?n nh?t (i + 1)
addi s1, t1, 0      # C?p nh?t t?ng ti?n t? l?n nh?t l� t?ng ch?y hi?n t?i
next:
addi t0, t0, 1      # T?ng ch? s? i l�n 1
blt t0, a1, loop    # N?u i < n (s? ph?n t? trong m?ng), l?p l?i
done:
j continue          # K?t th�c th? t?c, nh?y v? continue
mspfx_end:
