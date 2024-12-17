    .data
message_no_overflow:  .asciz "No overflow detected.\n"
message_overflow:     .asciz "Overflow detected!\n"

    .text
    .globl _start

_start:
    # Gia su cong 2 so duong
    li    s0, 0x7FFFFFFF   # so lon nhat la duong s0 = 
    li    s1, 1           # gan s1 = 1

    add   t0, s0, s1       # t0 = s0 + s1
    bltz  s0, check_negative  
    bltz  s1, check_negative  
    bltz  t0, overflow      
    j     no_overflow 

check_negative:
    # Ki?m tra n?u c? s0 và s1 ??u là s? âm
    # N?u t?ng là s? d??ng, ?i?u ?ó có ngh?a là có tràn s? âm.
    bgez  s0, no_overflow     # N?u s0 là s? d??ng, không có tràn s?
    bgez  s1, no_overflow     # N?u s1 là s? d??ng, không có tràn s?
    bgez  t0, overflow        # N?u t?ng là d??ng mà các s? h?ng ??u âm, có tràn âm

no_overflow:
    la    a0, message_no_overflow  # ??a ??a ch? chu?i "No overflow detected." vào a0
    li    a7, 4                    # S? d?ng syscall 4 (print string)
    ecall                          # Th?c hi?n syscall ?? in chu?i
    j     end                      # Nh?y t?i k?t thúc ch??ng trình

overflow:
    la    a0, message_overflow  
    li    a7, 4  
    ecall      

end:
    li    a7, 10          
    ecall      
