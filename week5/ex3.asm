.data
    x: .space 32          # Chu?i ?�ch x, ch?a c� d? li?u
    y: .asciz "Duong"     # Chu?i ngu?n y, ch?a "Duong"
    newline: .asciz "\n"  # K� t? xu?ng d�ng

.text
    # N?p ??a ch? c?a chu?i ?�ch x v� chu?i ngu?n y v�o thanh ghi
    la a0, x             # N?p ??a ch? c?a chu?i x v�o a0
    la a1, y             # N?p ??a ch? c?a chu?i y v�o a1

strcpy:
    add s0, zero, zero   # Kh?i t?o s0 = 0 (d�ng l�m ch? s? i)
L1: 
    add t1, s0, a1       # t1 = s0 + a1 = ??a ch? y[i]
    lb t2, 0(t1)         # t2 = gi� tr? t?i y[i]
    add t3, s0, a0       # t3 = s0 + a0 = ??a ch? x[i]
    sb t2, 0(t3)         # x[i] = t2 = y[i]
    beq t2, zero, end_of_strcpy  # N?u y[i] == 0 (k?t th�c chu?i), tho�t
    addi s0, s0, 1       # s0 = s0 + 1 <-> i = i + 1
    j L1                 # L?p l?i cho k� t? ti?p theo
end_of_strcpy:

    # In chu?i x ra m�n h�nh ?? ki?m tra k?t qu?
    la a0, x             # N?p ??a ch? chu?i x v�o a0
    li a7, 4             # D?ch v? in chu?i
    ecall                # G?i h? th?ng ?? in chu?i x

    # In k� t? xu?ng d�ng
    la a0, newline       # N?p ??a ch? c?a newline
    li a7, 4             # D?ch v? in chu?i
    ecall                # G?i h? th?ng ?? in newline

    # Tho�t ch??ng tr�nh
    li a7, 10            # D?ch v? tho�t ch??ng tr�nh
    ecall
