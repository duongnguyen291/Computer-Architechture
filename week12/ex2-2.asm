#  Duy?t qua ma tr?n 16 x 16 theo th? t? c?t.
#  Pete Sanderson
#  31 tháng 3, 2007
#
#  ?? d? dàng quan sát th? t? theo c?t, hãy ch?y công c? Visualization 
#  ?? theo dõi tham chi?u b? nh? v?i các cài ??t m?c ??nh trên ch??ng trình này.
#  B?n có th? ch?y công c? Mô ph?ng B? nh? ??m (Data Cache Simulator) 
#  cùng lúc ho?c riêng bi?t trên ch??ng trình này ?? quan sát hi?u su?t b? nh? ??m. 
#  So sánh k?t qu? v?i thu?t toán duy?t qua theo th? t? hàng.
#
#  Mã t??ng ???ng C/C++/Java v?i ch??ng trình MIPS này là:
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
#  L?u ý: Ch??ng trình này ???c c?u hình s?n cho ma tr?n 16 x 16. N?u b?n mu?n thay ??i kích th??c, 
#        c?n thay ??i ba dòng sau:
#        1. Kích th??c b? nh? l?u tr? m?ng t?i "data:" c?n thay ??i t? 
#           256 (t?c là 16 * 16) thành #c?t * #hàng.
#        2. L?nh "li" ?? kh?i t?o $t0 c?n thay ??i thành s? hàng m?i.
#        3. L?nh "li" ?? kh?i t?o $t1 c?n thay ??i thành s? c?t m?i.
#
         .data
data:    .word     0 : 256       # b? nh? l?u tr? ma tr?n 16x16 c?a các t?
         .text
         li       t0, 16        # $t0 = s? l??ng hàng
         li       t1, 16        # $t1 = s? l??ng c?t
         la			a0, data      # l?y ??a ch? c?a m?ng data
         mv     s0, zero        # $s0 = b? ??m hàng
         mv     s1, zero        # $s1 = b? ??m c?t
         mv     t2, zero        # $t2 = giá tr? s? ???c l?u vào m?ng
#  M?i l?n l?p trong vòng l?p s? l?u giá tr? t?ng d?n vào ph?n t? ti?p theo trong ma tr?n.
#  ?? l?ch b? nh? ???c tính ? m?i l?n l?p. offset = 4 * (row*#cols+col)
#  L?u ý: không c? g?ng t?i ?u hi?u su?t th?i gian ch?y!
loop:    mul     s2, s0, t1       # $s2 = row * #cols  (dãy l?nh g?m hai b??c)
         add      s2, s2, s1      # $s2 += b? ??m c?t
         slli     s2, s2, 2       # $s2 *= 4 (d?ch trái 2 bit) ?? tính ?? l?ch byte
         add      s2, a0, s2      # c?ng thêm ??a ch? c? s? m?ng
         sw       t2, 0(s2)       # l?u giá tr? vào ph?n t? c?a ma tr?n
         addi     t2, t2, 1       # t?ng giá tr? c?n l?u
#  ?i?u khi?n vòng l?p: N?u b? ??m hàng v??t quá cu?i c?t, reset b? ??m hàng và t?ng b? ??m c?t.
#  N?u v??t quá c?t cu?i cùng, k?t thúc ch??ng trình.
         addi     s0, s0, 1       # t?ng b? ??m hàng
         bne      s0, t0, loop    # ch?a ??n cu?i c?t nên quay l?i vòng l?p
         mv       s0, zero        # reset b? ??m hàng
         addi     s1, s1, 1       # t?ng b? ??m c?t
         bne      s1, t1, loop    # quay l?i vòng l?p n?u ch?a ??n cu?i ma tr?n (ch?a qua c?t cu?i cùng)
#  Ch??ng trình ?ã duy?t xong ma tr?n.
         li       a7, 10          # d?ch v? h? th?ng 10 là thoát ch??ng trình
         ecall                   # k?t thúc ch??ng trình.
