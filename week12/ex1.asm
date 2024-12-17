#  Duy?t m?ng 16 x 16 theo th? t? hàng (row-major order). Duong dep trai 
#  Pete Sanderson
#  31 tháng 3 n?m 2007
#  ?? d? dàng quan sát th? t? theo hàng, ch?y công c? Hi?n th? Tham chi?u B? nh?
#  v?i các cài ??t m?c ??nh trên ch??ng trình này.
#  B?n có th?, cùng lúc ho?c riêng bi?t, ch?y B? mô ph?ng B? nh? Cache 
#  trên ch??ng trình này ?? quan sát hi?u su?t b? nh? ??m. So sánh k?t qu?
#  v?i thu?t toán duy?t theo th? t? c?t (column-major order).
#  Mã ch??ng trình MIPS t??ng ???ng v?i C/C++/Java nh? sau:
#     int size = 16;
#     int[size][size] data;
#     int value = 0;
#     for (int row = 0; row < size; row++) {
#        for (int col = 0; col < size; col++) }
#           data[row][col] = value;
#           value++;
#        }
#     }
#  L?u ý: Ch??ng trình ???c cài ??t s?n cho ma tr?n 16 x 16. N?u b?n mu?n thay ??i kích th??c,
#        c?n thay ??i ba câu l?nh sau:
#        1. Khai báo kích th??c b? nh? m?ng t?i "data:" c?n thay ??i t?
#           256 (t??ng ???ng 16 * 16) thành #c?t * #hàng.
#        2. L?nh "li" ?? kh?i t?o giá tr? cho $t0 c?n thay ??i thành s? hàng m?i.
#        3. L?nh "li" ?? kh?i t?o giá tr? cho $t1 c?n thay ??i thành s? c?t m?i.

         .data
data:    .word     0 : 256       # b? nh? l?u tr? cho ma tr?n 16x16 c?a các t?
         .text
         li       t0, 16        # $t0 = s? l??ng hàng
         li       t1, 16        # $t1 = s? l??ng c?t
         la			a0, data      # l?y ??a ch? c?a m?ng data
         mv     s0, zero        # $s0 = b? ??m hàng
         mv     s1, zero        # $s1 = b? ??m c?t
         mv     t2, zero        # $t2 = giá tr? s? ???c l?u vào m?ng

#  M?i vòng l?p s? l?u giá tr? t?ng d?n c?a $t2 vào ph?n t? ti?p theo c?a ma tr?n.
#  ?? l?ch (offset) ???c tính toán t?i m?i vòng l?p. offset = 4 * (hàng * #c?t + c?t)
#  L?u ý: không có t?i ?u hóa hi?u su?t th?i gian trong ch??ng trình này!

loop:    mul      s2, s0, t1       # $s2 = hàng * #c?t  (dãy l?nh g?m hai b??c)
         add      s2, s2, s1      # $s2 += b? ??m c?t
         slli     s2, s2, 2       # $s2 *= 4 (d?ch trái 2 bit) ?? tính ?? l?ch byte
         add      s2, a0, s2      # c?ng thêm ??a ch? c? s? m?ng
         sw       t2, 0(s2)       # l?u giá tr? vào ph?n t? c?a ma tr?n
         addi     t2, t2, 1       # t?ng giá tr? c?n l?u

#  ?i?u khi?n vòng l?p: N?u t?ng quá c?t cu?i, reset b? ??m c?t và t?ng b? ??m hàng
#                N?u t?ng quá hàng cu?i, k?t thúc ch??ng trình.
         addi     s1, s1, 1       # t?ng b? ??m c?t
         bne      s1, t1, loop    # ch?a ??n cu?i hàng, quay l?i vòng l?p
         mv       s1, zero        # reset b? ??m c?t
         addi     s0, s0, 1       # t?ng b? ??m hàng
         bne      s0, t0, loop    # ch?a ??n cu?i ma tr?n, quay l?i vòng l?p

#  Chúng ta ?ã hoàn thành vi?c duy?t qua ma tr?n.
         li       a7, 10          # d?ch v? h? th?ng 10 là thoát ch??ng trình
         ecall                   # thoát kh?i ch??ng trình
