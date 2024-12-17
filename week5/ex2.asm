.data
    message1: .asciz "The sum of "  # Chu?i ??u tiên
    message2: .asciz " and "        # Chu?i n?i gi?a
    message3: .asciz " is "         # Chu?i k?t thúc

.text
    # Kh?i t?o giá tr? cho các thanh ghi $s0 và $s1
    li s0, 5           # N?p giá tr? 5 vào thanh ghi s0
    li s1, 10          # N?p giá tr? 10 vào thanh ghi s1

    # Tính t?ng
    add t0, s0, s1     # t0 = s0 + s1, l?u k?t qu? t?ng vào t0

    # In ra chu?i "The sum of "
    la a0, message1    # Load ??a ch? c?a chu?i message1 vào a0
    li a7, 4           # Service number 4 là print string
    ecall              # G?i h? th?ng ?? in chu?i message1

    # In giá tr? c?a s0
    mv a0, s0          # Move giá tr? c?a s0 vào a0
    li a7, 1           # Service number 1 là print integer
    ecall              # G?i h? th?ng ?? in giá tr? s0

    # In ra chu?i " and "
    la a0, message2    # Load ??a ch? c?a chu?i message2 vào a0
    li a7, 4           # Service number 4 là print string
    ecall              # G?i h? th?ng ?? in chu?i message2

    # In giá tr? c?a s1
    mv a0, s1          # Move giá tr? c?a s1 vào a0
    li a7, 1           # Service number 1 là print integer
    ecall              # G?i h? th?ng ?? in giá tr? s1

    # In ra chu?i " is "
    la a0, message3    # Load ??a ch? c?a chu?i message3 vào a0
    li a7, 4           # Service number 4 là print string
    ecall              # G?i h? th?ng ?? in chu?i message3

    # In k?t qu? t?ng
    mv a0, t0          # Move giá tr? t?ng t? t0 vào a0
    li a7, 1           # Service number 1 là print integer
    ecall              # G?i h? th?ng ?? in k?t qu? t?ng

    # Thoát ch??ng trình
    li a7, 10          # Service number 10 là thoát ch??ng trình
    ecall
