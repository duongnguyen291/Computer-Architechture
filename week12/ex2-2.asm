#  Duy?t qua ma tr?n 16 x 16 theo th? t? c?t.
#  Pete Sanderson
#  31 th�ng 3, 2007
#
#  ?? d? d�ng quan s�t th? t? theo c?t, h�y ch?y c�ng c? Visualization 
#  ?? theo d�i tham chi?u b? nh? v?i c�c c�i ??t m?c ??nh tr�n ch??ng tr�nh n�y.
#  B?n c� th? ch?y c�ng c? M� ph?ng B? nh? ??m (Data Cache Simulator) 
#  c�ng l�c ho?c ri�ng bi?t tr�n ch??ng tr�nh n�y ?? quan s�t hi?u su?t b? nh? ??m. 
#  So s�nh k?t qu? v?i thu?t to�n duy?t qua theo th? t? h�ng.
#
#  M� t??ng ???ng C/C++/Java v?i ch??ng tr�nh MIPS n�y l�:
#     int size = 16;
#     int[size][size] data;
#     int value = 0;
#     for (int col = 0; col < size; col++) {
#        for (int row = 0; row < size; row++) }
#           data[row][col] = value;
#           value++;
#        }
#     }
#
#  L?u �: Ch??ng tr�nh n�y ???c c?u h�nh s?n cho ma tr?n 16 x 16. N?u b?n mu?n thay ??i k�ch th??c, 
#        c?n thay ??i ba d�ng sau:
#        1. K�ch th??c b? nh? l?u tr? m?ng t?i "data:" c?n thay ??i t? 
#           256 (t?c l� 16 * 16) th�nh #c?t * #h�ng.
#        2. L?nh "li" ?? kh?i t?o $t0 c?n thay ??i th�nh s? h�ng m?i.
#        3. L?nh "li" ?? kh?i t?o $t1 c?n thay ??i th�nh s? c?t m?i.
#
         .data
data:    .word     0 : 256       # b? nh? l?u tr? ma tr?n 16x16 c?a c�c t?
         .text
         li       t0, 16        # $t0 = s? l??ng h�ng
         li       t1, 16        # $t1 = s? l??ng c?t
         la			a0, data      # l?y ??a ch? c?a m?ng data
         mv     s0, zero        # $s0 = b? ??m h�ng
         mv     s1, zero        # $s1 = b? ??m c?t
         mv     t2, zero        # $t2 = gi� tr? s? ???c l?u v�o m?ng
#  M?i l?n l?p trong v�ng l?p s? l?u gi� tr? t?ng d?n v�o ph?n t? ti?p theo trong ma tr?n.
#  ?? l?ch b? nh? ???c t�nh ? m?i l?n l?p. offset = 4 * (row*#cols+col)
#  L?u �: kh�ng c? g?ng t?i ?u hi?u su?t th?i gian ch?y!
loop:    mul     s2, s0, t1       # $s2 = row * #cols  (d�y l?nh g?m hai b??c)
         add      s2, s2, s1      # $s2 += b? ??m c?t
         slli     s2, s2, 2       # $s2 *= 4 (d?ch tr�i 2 bit) ?? t�nh ?? l?ch byte
         add      s2, a0, s2      # c?ng th�m ??a ch? c? s? m?ng
         sw       t2, 0(s2)       # l?u gi� tr? v�o ph?n t? c?a ma tr?n
         addi     t2, t2, 1       # t?ng gi� tr? c?n l?u
#  ?i?u khi?n v�ng l?p: N?u b? ??m h�ng v??t qu� cu?i c?t, reset b? ??m h�ng v� t?ng b? ??m c?t.
#  N?u v??t qu� c?t cu?i c�ng, k?t th�c ch??ng tr�nh.
         addi     s0, s0, 1       # t?ng b? ??m h�ng
         bne      s0, t0, loop    # ch?a ??n cu?i c?t n�n quay l?i v�ng l?p
         mv       s0, zero        # reset b? ??m h�ng
         addi     s1, s1, 1       # t?ng b? ??m c?t
         bne      s1, t1, loop    # quay l?i v�ng l?p n?u ch?a ??n cu?i ma tr?n (ch?a qua c?t cu?i c�ng)
#  Ch??ng tr�nh ?� duy?t xong ma tr?n.
         li       a7, 10          # d?ch v? h? th?ng 10 l� tho�t ch??ng tr�nh
         ecall                   # k?t th�c ch??ng tr�nh.
