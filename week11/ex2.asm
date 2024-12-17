.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012

.data
    message: .asciz "Someone's pressed a button.\n"

# --------------------------------------------------
# MAIN Procedure 
# --------------------------------------------------
.text
main:
    # N?p ??a ch? c?a interrupt handler v�o thanh ghi utvec
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

    # V�ng l?p v� h?n ?? demo hi?u ?ng c?a interrupt
loop:
    nop                        # kh�ng th?c hi?n g�
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
    addi sp, sp, -8            # d�nh 2 word tr�n stack
    sw a0, 0(sp)               # l?u a0
    sw a7, 4(sp)               # l?u a7

    # X? l� interrupt
    # In th�ng b�o trong Run I/O
    li a7, 4                   # syscall in chu?i
    la a0, message          
    ecall

    # Kh�i ph?c context
    lw a7, 4(sp)               # l?y l?i a7
    lw a0, 0(sp)               # l?y l?i a0  
    addi sp, sp, 8             # gi?i ph�ng stack

    # Tr? v? ch??ng tr�nh ch�nh
    uret                       # tr? v? t? interrupt
