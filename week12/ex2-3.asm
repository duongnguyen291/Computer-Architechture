# Tính 12 s? Fibonacci ??u tiên và l?u vào m?ng, sau ?ó in ra màn hình
      .data  
fibs: .word   0 : 16        # "m?ng" ch?a 12 giá tr? Fibonacci
size: .word  16             # kích th??c c?a m?ng 
      .text
      la   t0, fibs        # t?i ??a ch? c?a m?ng fibs
      la   t5, size        # t?i ??a ch? c?a bi?n size
      lw   t5, 0(t5)      # t?i kích th??c c?a m?ng
      li   t2, 1           # 1 là s? Fibonacci ??u tiên và th? hai
      sw   t2, 0(t0)      # F[0] = 1
      sw   t2, 4(t0)      # F[1] = F[0] = 1
      addi t1, t5, -2     # B? ??m vòng l?p, s? l?p (size-2) l?n
loop: lw   t3, 0(t0)      # L?y giá tr? t? m?ng F[n]
      lw   t4, 4(t0)      # L?y giá tr? t? m?ng F[n+1]
      add  t2, t3, t4    # $t2 = F[n] + F[n+1]
      sw   t2, 8(t0)      # L?u F[n+2] = F[n] + F[n+1] vào m?ng
      addi t0, t0, 4      # t?ng ??a ch? m?ng Fibonacci
      addi t1, t1, -1     # gi?m b? ??m vòng l?p
      bgtz t1, loop        # ti?p t?c n?u ch?a k?t thúc
      la   a0, fibs        # tham s? ??u tiên cho hàm in (m?ng)
      add  a1, zero, t5  # tham s? th? hai cho hàm in (kích th??c)
      jal  print            # g?i hàm in ra màn hình
      li   a7, 10          # g?i h? th?ng ?? thoát
      ecall               # thoát ch??ng trình
		
#########  hàm in các s? trên cùng m?t dòng.

      .data
space:.asciz  " "          # ký t? kho?ng tr?ng ?? tách gi?a các s?
head: .asciz  "Các s? Fibonacci là:\n"
      .text
print:add  t0, zero, a0  # ??a ch? b?t ??u c?a m?ng
      add  t1, zero, a1  # kh?i t?o b? ??m vòng l?p b?ng kích th??c m?ng
      la   a0, head        # t?i ??a ch? c?a dòng tiêu ??
      li   a7, 4           # d?ch v? in chu?i
      ecall               # in tiêu ??
out:  lw   a0, 0(t0)      # t?i s? Fibonacci t? m?ng ?? in
      li   a7, 1           # d?ch v? in s? nguyên
      ecall               # in s? Fibonacci
      la   a0, space       # t?i ??a ch? c?a ký t? kho?ng tr?ng
      li   a7, 4           # d?ch v? in chu?i
      ecall               # in ký t? kho?ng tr?ng
      addi t0, t0, 4      # t?ng ??a ch? m?ng
      addi t1, t1, -1     # gi?m b? ??m vòng l?p
      bgtz t1, out         # ti?p t?c vòng l?p n?u ch?a h?t
      jr   ra              # quay l?i
