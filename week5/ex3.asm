.data
    x: .space 32          # Chu?i ?ích x, ch?a có d? li?u
    y: .asciz "Duong"     # Chu?i ngu?n y, ch?a "Duong"
    newline: .asciz "\n"  # Ký t? xu?ng dòng

.text
    # N?p ??a ch? c?a chu?i ?ích x và chu?i ngu?n y vào thanh ghi
    la a0, x             # N?p ??a ch? c?a chu?i x vào a0
    la a1, y             # N?p ??a ch? c?a chu?i y vào a1

strcpy:
    add s0, zero, zero   # Kh?i t?o s0 = 0 (dùng làm ch? s? i)
L1: 
    add t1, s0, a1       # t1 = s0 + a1 = ??a ch? y[i]
    lb t2, 0(t1)         # t2 = giá tr? t?i y[i]
    add t3, s0, a0       # t3 = s0 + a0 = ??a ch? x[i]
    sb t2, 0(t3)         # x[i] = t2 = y[i]
    beq t2, zero, end_of_strcpy  # N?u y[i] == 0 (k?t thúc chu?i), thoát
    addi s0, s0, 1       # s0 = s0 + 1 <-> i = i + 1
    j L1                 # L?p l?i cho ký t? ti?p theo
end_of_strcpy:

    # In chu?i x ra màn hình ?? ki?m tra k?t qu?
    la a0, x             # N?p ??a ch? chu?i x vào a0
    li a7, 4             # D?ch v? in chu?i
    ecall                # G?i h? th?ng ?? in chu?i x

    # In ký t? xu?ng dòng
    la a0, newline       # N?p ??a ch? c?a newline
    li a7, 4             # D?ch v? in chu?i
    ecall                # G?i h? th?ng ?? in newline

    # Thoát ch??ng trình
    li a7, 10            # D?ch v? thoát ch??ng trình
    ecall
