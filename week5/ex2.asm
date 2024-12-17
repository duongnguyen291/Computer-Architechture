.data
    message1: .asciz "The sum of "  # Chu?i ??u ti�n
    message2: .asciz " and "        # Chu?i n?i gi?a
    message3: .asciz " is "         # Chu?i k?t th�c

.text
    # Kh?i t?o gi� tr? cho c�c thanh ghi $s0 v� $s1
    li s0, 5           # N?p gi� tr? 5 v�o thanh ghi s0
    li s1, 10          # N?p gi� tr? 10 v�o thanh ghi s1

    # T�nh t?ng
    add t0, s0, s1     # t0 = s0 + s1, l?u k?t qu? t?ng v�o t0

    # In ra chu?i "The sum of "
    la a0, message1    # Load ??a ch? c?a chu?i message1 v�o a0
    li a7, 4           # Service number 4 l� print string
    ecall              # G?i h? th?ng ?? in chu?i message1

    # In gi� tr? c?a s0
    mv a0, s0          # Move gi� tr? c?a s0 v�o a0
    li a7, 1           # Service number 1 l� print integer
    ecall              # G?i h? th?ng ?? in gi� tr? s0

    # In ra chu?i " and "
    la a0, message2    # Load ??a ch? c?a chu?i message2 v�o a0
    li a7, 4           # Service number 4 l� print string
    ecall              # G?i h? th?ng ?? in chu?i message2

    # In gi� tr? c?a s1
    mv a0, s1          # Move gi� tr? c?a s1 v�o a0
    li a7, 1           # Service number 1 l� print integer
    ecall              # G?i h? th?ng ?? in gi� tr? s1

    # In ra chu?i " is "
    la a0, message3    # Load ??a ch? c?a chu?i message3 v�o a0
    li a7, 4           # Service number 4 l� print string
    ecall              # G?i h? th?ng ?? in chu?i message3

    # In k?t qu? t?ng
    mv a0, t0          # Move gi� tr? t?ng t? t0 v�o a0
    li a7, 1           # Service number 1 l� print integer
    ecall              # G?i h? th?ng ?? in k?t qu? t?ng

    # Tho�t ch??ng tr�nh
    li a7, 10          # Service number 10 l� tho�t ch??ng tr�nh
    ecall
