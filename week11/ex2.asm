.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012

.data
    message: .asciz "Someone's pressed a button.\n"

# --------------------------------------------------
# MAIN Procedure 
# --------------------------------------------------
.text
main:
    # N?p ??a ch? c?a interrupt handler vào thanh ghi utvec
    la t0, handler
    csrrs zero, utvec, t0      # utvec = ??a ch? handler

    # B?t bit UEIE (User External Interrupt Enable) trong thanh ghi UIE
    li t1, 0x100               # bit 8 = 1
    csrrs zero, uie, t1        # set bit 8 c?a uie

    # B?t bit UIE (User Interrupt Enable) trong thanh ghi USTATUS 
    csrrsi zero, ustatus, 0x1  # b?t bit 0 c?a ustatus

    # B?t interrupt cho keypad trong Digital Lab Sim
    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t3, 0x80                # bit 7 = 1 ?? enable interrupt
    sb t3, 0(t1)

    # Vòng l?p vô h?n ?? demo hi?u ?ng c?a interrupt
loop:
    nop                        # không th?c hi?n gì
    # Delay 10ms
    li a7, 32                  # syscall sleep
    li a0, 10                  # 10ms
    ecall
    nop
    j loop
end_main:

# --------------------------------------------------
# Interrupt Service Routine (ISR)
# --------------------------------------------------
handler:
    # L?u context
    addi sp, sp, -8            # dành 2 word trên stack
    sw a0, 0(sp)               # l?u a0
    sw a7, 4(sp)               # l?u a7

    # X? lý interrupt
    # In thông báo trong Run I/O
    li a7, 4                   # syscall in chu?i
    la a0, message          
    ecall

    # Khôi ph?c context
    lw a7, 4(sp)               # l?y l?i a7
    lw a0, 0(sp)               # l?y l?i a0  
    addi sp, sp, 8             # gi?i phóng stack

    # Tr? v? ch??ng trình chính
    uret                       # tr? v? t? interrupt
