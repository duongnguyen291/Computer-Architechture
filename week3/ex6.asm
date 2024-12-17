.data
array:      .word   5, -6, 6, 72, -15, -80, -9   # M?ng ch?a các s? nguyên
array_size: .word   7                          # S? l??ng ph?n t? trong m?ng
max_abs:    .word   0                          # Bi?n l?u giá tr? tuy?t ??i l?n nh?t
.text
.globl main
main:
    # Kh?i t?o con tr? m?ng
    la      a0, array                     # a0 tr? t?i ??u m?ng
    lw      t1, array_size                # t1 = s? ph?n t? trong m?ng
    li      t2, 0                          # t2 = ch? s? hi?n t?i (i = 0)
    li      t3, 0                          # t3 = giá tr? tuy?t ??i l?n nh?t (max_abs)
loop:
    bge     t2, t1, end_loop               # N?u i >= array_size thì k?t thúc vòng l?p
    lw      t4, 0(a0)                      # T?i ph?n t? hi?n t?i vào t4
    # Tính giá tr? tuy?t ??i
    blt     t4, zero, neg_case             # N?u t4 < 0, ?i t?i neg_case
    add     t5, zero, t4                    # T5 = t4 n?u t4 >= 0
    j       check_max                       # Chuy?n t?i check_max
neg_case:
    sub     t5, zero, t4                    # T5 = -t4 (tính giá tr? tuy?t ??i)
check_max:
    bgt     t5, t3, update_max             # N?u giá tr? tuy?t ??i l?n h?n max_abs thì c?p nh?t
    j       next_element                    # Chuy?n sang ph?n t? ti?p theo
update_max:
    add     t3, zero, t5                    # C?p nh?t max_abs v?i giá tr? tuy?t ??i l?n nh?t
next_element:
    addi    a0, a0, 4                       # Di chuy?n ??n ph?n t? ti?p theo (4 bytes cho int)
    addi    t2, t2, 1                       # T?ng ch? s? i
    j       loop                            # Quay l?i vòng l?p
end_loop:
    la      a1, max_abs                    # T?i ??a ch? c?a max_abs vào a1
    sw      t3, 0(a1)                      # L?u giá tr? tuy?t ??i l?n nh?t vào bi?n max_abs
    # K?t thúc ch??ng trình
    li      a7, 10                         # Mã syscall ?? k?t thúc
    ecall