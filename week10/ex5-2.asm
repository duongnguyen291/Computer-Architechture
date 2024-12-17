# RISC-V Assembly Code - Assignment 5
# Draw a rectangle with a red border and green background on a bitmap display
# where each unit (pixel) has a width and height of 4 pixels.
# Setting: Unit: 1, Display: 256
.eqv MONITOR_SCREEN, 0x10010000  # Start address of the bitmap display
.eqv RED,            0x00FF0000  # Red color value
.eqv GREEN,          0x0000FF00  # Green color value
.eqv WIDTH,          256         # Width of the bitmap display in pixels
.eqv UNIT_SIZE,      4           # Unit width and height in pixels

.text
.global main
main:
    # Load constants into registers
    li      s4, MONITOR_SCREEN   # s4 = MONITOR_SCREEN
    li      s5, WIDTH            # s5 = WIDTH
    li      s6, UNIT_SIZE        # s6 = UNIT_SIZE

    # Read x1
    li      a7, 5                # ecall code for read integer
    ecall
    mv      s0, a0               # s0 = x1

    # Read y1
    li      a7, 5
    ecall
    mv      s1, a0               # s1 = y1

    # Read x2
    li      a7, 5
    ecall
    mv      s2, a0               # s2 = x2

    # Read y2
    li      a7, 5
    ecall
    mv      s3, a0               # s3 = y2

    # Ensure x1 ? x2 and y1 ? y2
    beq     s0, s2, exit         # if x1 == x2, exit
    beq     s1, s3, exit         # if y1 == y2, exit

    # Determine minX and maxX
    blt     s0, s2, set_minX_s0
    mv      t0, s2               # t0 = minX = s2
    mv      t1, s0               # t1 = maxX = s0
    j       set_minY

set_minX_s0:
    mv      t0, s0               # t0 = minX = s0
    mv      t1, s2               # t1 = maxX = s2

set_minY:
    # Determine minY and maxY
    blt     s1, s3, set_minY_s1
    mv      t2, s3               # t2 = minY = s3
    mv      t3, s1               # t3 = maxY = s1
    j       start_drawing

set_minY_s1:
    mv      t2, s1               # t2 = minY = s1
    mv      t3, s3               # t3 = maxY = s3

start_drawing:
    mv      s7, t2               # s7 = y (unit) = minY

outer_loop:
    bgt     s7, t3, end_drawing  # if y > maxY, exit loop

    mv      s8, t0               # s8 = x (unit) = minX

inner_loop:
    bgt     s8, t1, end_inner_loop  # if x > maxX, exit inner loop

    # Initialize dy
    li      s9, 0                # s9 = dy = 0

dy_loop:
    bge     s9, s6, end_dy_loop   # if dy >= UNIT_SIZE, exit dy_loop

    # Initialize dx
    li      s10, 0               # s10 = dx = 0

dx_loop:
    bge     s10, s6, end_dx_loop   # if dx >= UNIT_SIZE, exit dx_loop

    # Compute pixel_x = x * UNIT_SIZE + dx
    mul     s11, s8, s6          # s11 = x * UNIT_SIZE
    add     s11, s11, s10        # s11 = pixel_x

    # Compute pixel_y = y * UNIT_SIZE + dy
    mul     t4, s7, s6           # t4 = y * UNIT_SIZE
    add     t4, t4, s9           # t4 = pixel_y

    # Compute address = MONITOR_SCREEN + ((pixel_y * WIDTH + pixel_x) * 4)
    mul     t5, t4, s5           # t5 = pixel_y * WIDTH
    add     t5, t5, s11          # t5 = pixel_y * WIDTH + pixel_x
    slli    t5, t5, 2            # t5 = t5 * 4 (byte offset)
    add     t5, s4, t5           # t5 = address

    # Initialize color to GREEN
    li      t6, GREEN            # t6 = GREEN

    # Check if the unit is on the border
    beq     s8, t0, set_color_red_unit
    beq     s8, t1, set_color_red_unit
    beq     s7, t2, set_color_red_unit
    beq     s7, t3, set_color_red_unit
    j       write_pixel_unit

set_color_red_unit:
    li      t6, RED              # t6 = RED

write_pixel_unit:
    sw      t6, 0(t5)            # Write color to pixel

    # Increment dx
    addi    s10, s10, 1          # dx = dx + 1
    j       dx_loop

end_dx_loop:
    # Increment dy
    addi    s9, s9, 1            # dy = dy + 1
    j       dy_loop

end_dy_loop:
    # Increment x (unit)
    addi    s8, s8, 1            # x = x + 1
    j       inner_loop

end_inner_loop:
    # Increment y (unit)
    addi    s7, s7, 1            # y = y + 1
    j       outer_loop

end_drawing:
    # Exit the program
    li      a7, 10               # ecall code for exit
    ecall

exit:
    li      a7, 10               # ecall code for exit
    ecall
