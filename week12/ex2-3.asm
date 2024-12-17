# T�nh 12 s? Fibonacci ??u ti�n v� l?u v�o m?ng, sau ?� in ra m�n h�nh
      .data  
fibs: .word   0 : 16        # "m?ng" ch?a 12 gi� tr? Fibonacci
size: .word  16             # k�ch th??c c?a m?ng 
      .text
      la   t0, fibs        # t?i ??a ch? c?a m?ng fibs
      la   t5, size        # t?i ??a ch? c?a bi?n size
      lw   t5, 0(t5)      # t?i k�ch th??c c?a m?ng
      li   t2, 1           # 1 l� s? Fibonacci ??u ti�n v� th? hai
      sw   t2, 0(t0)      # F[0] = 1
      sw   t2, 4(t0)      # F[1] = F[0] = 1
      addi t1, t5, -2     # B? ??m v�ng l?p, s? l?p (size-2) l?n
loop: lw   t3, 0(t0)      # L?y gi� tr? t? m?ng F[n]
      lw   t4, 4(t0)      # L?y gi� tr? t? m?ng F[n+1]
      add  t2, t3, t4    # $t2 = F[n] + F[n+1]
      sw   t2, 8(t0)      # L?u F[n+2] = F[n] + F[n+1] v�o m?ng
      addi t0, t0, 4      # t?ng ??a ch? m?ng Fibonacci
      addi t1, t1, -1     # gi?m b? ??m v�ng l?p
      bgtz t1, loop        # ti?p t?c n?u ch?a k?t th�c
      la   a0, fibs        # tham s? ??u ti�n cho h�m in (m?ng)
      add  a1, zero, t5  # tham s? th? hai cho h�m in (k�ch th??c)
      jal  print            # g?i h�m in ra m�n h�nh
      li   a7, 10          # g?i h? th?ng ?? tho�t
      ecall               # tho�t ch??ng tr�nh
		
#########  h�m in c�c s? tr�n c�ng m?t d�ng.

      .data
space:.asciz  " "          # k� t? kho?ng tr?ng ?? t�ch gi?a c�c s?
head: .asciz  "C�c s? Fibonacci l�:\n"
      .text
print:add  t0, zero, a0  # ??a ch? b?t ??u c?a m?ng
      add  t1, zero, a1  # kh?i t?o b? ??m v�ng l?p b?ng k�ch th??c m?ng
      la   a0, head        # t?i ??a ch? c?a d�ng ti�u ??
      li   a7, 4           # d?ch v? in chu?i
      ecall               # in ti�u ??
out:  lw   a0, 0(t0)      # t?i s? Fibonacci t? m?ng ?? in
      li   a7, 1           # d?ch v? in s? nguy�n
      ecall               # in s? Fibonacci
      la   a0, space       # t?i ??a ch? c?a k� t? kho?ng tr?ng
      li   a7, 4           # d?ch v? in chu?i
      ecall               # in k� t? kho?ng tr?ng
      addi t0, t0, 4      # t?ng ??a ch? m?ng
      addi t1, t1, -1     # gi?m b? ??m v�ng l?p
      bgtz t1, out         # ti?p t?c v�ng l?p n?u ch?a h?t
      jr   ra              # quay l?i
