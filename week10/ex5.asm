# ??nh ngh?a c�c h?ng s?
# Setting: Unit: 1, Display: 256
.eqv MONITOR_SCREEN, 0x10010000  # ??a ch? b?t ??u c?a m�n h�nh bitmap
.eqv RED,            0x00FF0000  # Gi� tr? m�u ??
.eqv GREEN,          0x0000FF00  # Gi� tr? m�u xanh l�
.eqv WIDTH,          256         # Chi?u r?ng m�n h�nh (theo pixel)
.eqv UNIT_SIZE,      4           # ??n v? chi?u r?ng v� chi?u cao c?a 1 pixel

.text
.global main
main:
    # N?p c�c h?ng s? v�o thanh ghi
    li      s4, MONITOR_SCREEN   # s4 = ??a ch? m�n h�nh
    li      s5, WIDTH            # s5 = chi?u r?ng m�n h�nh
    li      s6, UNIT_SIZE        # s6 = k�ch th??c ??n v? (4 pixel)

    # ??c gi� tr? x1 t? ng??i d�ng
    li      a7, 5                # ecall ?? ??c s? nguy�n
    ecall
    mv      s0, a0               # s0 = x1

    # ??c gi� tr? y1 t? ng??i d�ng
    li      a7, 5
    ecall
    mv      s1, a0               # s1 = y1

    # ??c gi� tr? x2 t? ng??i d�ng
    li      a7, 5
    ecall
    mv      s2, a0               # s2 = x2

    # ??c gi� tr? y2 t? ng??i d�ng
    li      a7, 5
    ecall
    mv      s3, a0               # s3 = y2

    # Ki?m tra n?u x1 = x2 ho?c y1 = y2 th� tho�t
    beq     s0, s2, exit         # N?u x1 == x2, tho�t
    beq     s1, s3, exit         # N?u y1 == y2, tho�t

    # X�c ??nh minX v� maxX
    blt     s0, s2, set_minX_s0  # N?u x1 < x2, g�n minX = x1
    mv      t0, s2               # t0 = minX = x2
    mv      t1, s0               # t1 = maxX = x1
    j       set_minY             # Nh?y ??n x? l� minY

set_minX_s0:
    mv      t0, s0               # t0 = minX = x1
    mv      t1, s2               # t1 = maxX = x2

set_minY:
    # X�c ??nh minY v� maxY
    blt     s1, s3, set_minY_s1  # N?u y1 < y2, g�n minY = y1
    mv      t2, s3               # t2 = minY = y2
    mv      t3, s1               # t3 = maxY = y1
    j       start_drawing        # Nh?y ??n ph?n v? h�nh ch? nh?t

set_minY_s1:
    mv      t2, s1               # t2 = minY = y1
    mv      t3, s3               # t3 = maxY = y2

start_drawing:
    mv      s7, t2               # s7 = y hi?n t?i = minY

outer_loop:
    bgt     s7, t3, end_drawing  # N?u y > maxY, tho�t v�ng l?p ngo�i

    mv      s8, t0               # s8 = x hi?n t?i = minX

inner_loop:
    bgt     s8, t1, end_inner_loop  # N?u x > maxX, tho�t v�ng l?p trong

    # Kh?i t?o dy (h�ng pixel)
    li      s9, 0                # s9 = dy = 0

dy_loop:
    bge     s9, s6, end_dy_loop   # N?u dy >= UNIT_SIZE, tho�t v�ng l?p dy

    # Kh?i t?o dx (c?t pixel)
    li      s10, 0               # s10 = dx = 0

dx_loop:
    bge     s10, s6, end_dx_loop   # N?u dx >= UNIT_SIZE, tho�t v�ng l?p dx

    # T�nh pixel_x = x * UNIT_SIZE + dx
    mul     s11, s8, s6          # s11 = x * UNIT_SIZE
    add     s11, s11, s10        # s11 = pixel_x

    # T�nh pixel_y = y * UNIT_SIZE + dy
    mul     t4, s7, s6           # t4 = y * UNIT_SIZE
    add     t4, t4, s9           # t4 = pixel_y

    # T�nh ??a ch? b? nh?: MONITOR_SCREEN + ((pixel_y * WIDTH + pixel_x) * 4)
    mul     t5, t4, s5           # t5 = pixel_y * WIDTH
    add     t5, t5, s11          # t5 = pixel_y * WIDTH + pixel_x
    slli    t5, t5, 2            # t5 = t5 * 4 (??a ch? byte)
    add     t5, s4, t5           # t5 = ??a ch? b? nh?

    # G�n m�u m?c ??nh l� xanh l� (GREEN)
    li      t6, GREEN            # t6 = GREEN

    # Ki?m tra n?u pixel thu?c vi?n
    beq     s8, t0, set_color_red_unit
    beq     s8, t1, set_color_red_unit
    beq     s7, t2, set_color_red_unit
    beq     s7, t3, set_color_red_unit
    j       write_pixel_unit

set_color_red_unit:
    li      t6, RED              # t6 = RED

write_pixel_unit:
    sw      t6, 0(t5)            # Ghi m�u v�o pixel

    # T?ng dx (c?t pixel)
    addi    s10, s10, 1          # dx = dx + 1
    j       dx_loop

end_dx_loop:
    # T?ng dy (h�ng pixel)
    addi    s9, s9, 1            # dy = dy + 1
    j       dy_loop

end_dy_loop:
    # T?ng x (??n v?)
    addi    s8, s8, 1            # x = x + 1
    j       inner_loop

end_inner_loop:
    # T?ng y (??n v?)
    addi    s7, s7, 1            # y = y + 1
    j       outer_loop

end_drawing:
    # Tho�t ch??ng tr�nh
    li      a7, 10               # ecall ?? tho�t
    ecall

exit:
    li      a7, 10               # ecall ?? tho�t
    ecall
