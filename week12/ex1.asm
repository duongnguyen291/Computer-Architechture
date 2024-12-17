#  Duy?t m?ng 16 x 16 theo th? t? h�ng (row-major order). Duong dep trai 
#  Pete Sanderson
#  31 th�ng 3 n?m 2007
#  ?? d? d�ng quan s�t th? t? theo h�ng, ch?y c�ng c? Hi?n th? Tham chi?u B? nh?
#  v?i c�c c�i ??t m?c ??nh tr�n ch??ng tr�nh n�y.
#  B?n c� th?, c�ng l�c ho?c ri�ng bi?t, ch?y B? m� ph?ng B? nh? Cache 
#  tr�n ch??ng tr�nh n�y ?? quan s�t hi?u su?t b? nh? ??m. So s�nh k?t qu?
#  v?i thu?t to�n duy?t theo th? t? c?t (column-major order).
#  M� ch??ng tr�nh MIPS t??ng ???ng v?i C/C++/Java nh? sau:
#     int size = 16;
#     int[size][size] data;
#     int value = 0;
#     for (int row = 0; row < size; row++) {
#        for (int col = 0; col < size; col++) }
#           data[row][col] = value;
#           value++;
#        }
#     }
#  L?u �: Ch??ng tr�nh ???c c�i ??t s?n cho ma tr?n 16 x 16. N?u b?n mu?n thay ??i k�ch th??c,
#        c?n thay ??i ba c�u l?nh sau:
#        1. Khai b�o k�ch th??c b? nh? m?ng t?i "data:" c?n thay ??i t?
#           256 (t??ng ???ng 16 * 16) th�nh #c?t * #h�ng.
#        2. L?nh "li" ?? kh?i t?o gi� tr? cho $t0 c?n thay ??i th�nh s? h�ng m?i.
#        3. L?nh "li" ?? kh?i t?o gi� tr? cho $t1 c?n thay ??i th�nh s? c?t m?i.

         .data
data:    .word     0 : 256       # b? nh? l?u tr? cho ma tr?n 16x16 c?a c�c t?
         .text
         li       t0, 16        # $t0 = s? l??ng h�ng
         li       t1, 16        # $t1 = s? l??ng c?t
         la			a0, data      # l?y ??a ch? c?a m?ng data
         mv     s0, zero        # $s0 = b? ??m h�ng
         mv     s1, zero        # $s1 = b? ??m c?t
         mv     t2, zero        # $t2 = gi� tr? s? ???c l?u v�o m?ng

#  M?i v�ng l?p s? l?u gi� tr? t?ng d?n c?a $t2 v�o ph?n t? ti?p theo c?a ma tr?n.
#  ?? l?ch (offset) ???c t�nh to�n t?i m?i v�ng l?p. offset = 4 * (h�ng * #c?t + c?t)
#  L?u �: kh�ng c� t?i ?u h�a hi?u su?t th?i gian trong ch??ng tr�nh n�y!

loop:    mul      s2, s0, t1       # $s2 = h�ng * #c?t  (d�y l?nh g?m hai b??c)
         add      s2, s2, s1      # $s2 += b? ??m c?t
         slli     s2, s2, 2       # $s2 *= 4 (d?ch tr�i 2 bit) ?? t�nh ?? l?ch byte
         add      s2, a0, s2      # c?ng th�m ??a ch? c? s? m?ng
         sw       t2, 0(s2)       # l?u gi� tr? v�o ph?n t? c?a ma tr?n
         addi     t2, t2, 1       # t?ng gi� tr? c?n l?u

#  ?i?u khi?n v�ng l?p: N?u t?ng qu� c?t cu?i, reset b? ??m c?t v� t?ng b? ??m h�ng
#                N?u t?ng qu� h�ng cu?i, k?t th�c ch??ng tr�nh.
         addi     s1, s1, 1       # t?ng b? ??m c?t
         bne      s1, t1, loop    # ch?a ??n cu?i h�ng, quay l?i v�ng l?p
         mv       s1, zero        # reset b? ??m c?t
         addi     s0, s0, 1       # t?ng b? ??m h�ng
         bne      s0, t0, loop    # ch?a ??n cu?i ma tr?n, quay l?i v�ng l?p

#  Ch�ng ta ?� ho�n th�nh vi?c duy?t qua ma tr?n.
         li       a7, 10          # d?ch v? h? th?ng 10 l� tho�t ch??ng tr�nh
         ecall                   # tho�t kh?i ch??ng tr�nh
