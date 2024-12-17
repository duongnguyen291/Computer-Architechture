.data
A: .word 1, -5, 3, 7, -2, 8, -6  # Kh?i t?o m?ng A v?i các ph?n t? s? nguyên

.text
main:
la a0, A        # T?i ??a ch? c? s? c?a m?ng A vào thanh ghi a0
li a1, 8        # Gán giá tr? 8 vào a1 (s? ph?n t? trong m?ng, nh?ng th?c t? m?ng ch? có 7 ph?n t?. ?? ti?n s? d?ng blt)
j mspfx         # Nh?y ??n th? t?c mspfx ?? tính t?ng ti?n t? l?n nh?t
continue:
exit:
li a7, 10       # Gán giá tr? 10 vào a7 (mã cho system call k?t thúc ch??ng trình)
ecall           # G?i system call ?? k?t thúc ch??ng trình
end_of_main:

# -----------------------------------------------------------------
# Th? t?c mspfx
# @brief Tìm t?ng ti?n t? l?n nh?t trong danh sách các s? nguyên
# @param[in] a0 ??a ch? c? s? c?a danh sách (A) c?n x? lý
# @param[in] a1 S? ph?n t? trong danh sách (A)
# @param[out] s0 ?? dài c?a m?ng con (sub-array) trong A mà t?ng l?n nh?t ??t ???c
# @param[out] s1 T?ng l?n nh?t c?a m?t m?ng con xác ??nh
# -----------------------------------------------------------------

mspfx:
li s0, 0            # Kh?i t?o ?? dài c?a ti?n t? l?n nh?t trong s0 là 0
li s1, 0x80000000   # Kh?i t?o t?ng ti?n t? l?n nh?t trong s1 là s? nguyên nh? nh?t (giá tr? nh? nh?t ki?u int)
li t0, 0            # Kh?i t?o ch? s? i cho vòng l?p trong t0 là 0
li t1, 0            # Kh?i t?o t?ng ch?y (running sum) trong t1 là 0
loop: 
add t2, t0, t0      # ??a 2*i vào t2 (tính 2*i)
add t2, t2, t2      # ??a 4*i vào t2 (tính 4*i)
add t3, t2, a0      # ??a ??a ch? c?a A[i] vào t3 (tính 4*i + A)
lw t4, 0(t3)        # T?i giá tr? A[i] t? b? nh? vào t4
add t1, t1, t4      # C?ng giá tr? A[i] vào t?ng ch?y (running sum) trong t1
blt s1, t1, mdfy    # N?u t?ng ch?y (t1) l?n h?n t?ng l?n nh?t hi?n t?i (s1), nh?y ??n mdfy ?? c?p nh?t k?t qu?
j next              # Nh?y ??n b??c ti?p theo n?u không c?n c?p nh?t

mdfy:
addi s0, t0, 1      # C?p nh?t ?? dài m?i c?a ti?n t? l?n nh?t (i + 1)
addi s1, t1, 0      # C?p nh?t t?ng ti?n t? l?n nh?t là t?ng ch?y hi?n t?i
next:
addi t0, t0, 1      # T?ng ch? s? i lên 1
blt t0, a1, loop    # N?u i < n (s? ph?n t? trong m?ng), l?p l?i
done:
j continue          # K?t thúc th? t?c, nh?y v? continue
mspfx_end:
