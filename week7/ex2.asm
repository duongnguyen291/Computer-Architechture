# Laboratory Exercise 7, Home Assignment 2
.text
main:   
    li    a0, 29        # load first test input
    li    a1, 1        # load second test input
    li    a2, 5        # load third test input
    jal   max          # call max procedure

    li    a7, 10       # terminate program
    ecall 
end_main:   

# ----------------------------------------------------------------------
# Procedure max: Finds the largest of three integers
# param[in]  a0  integer 1
# param[in]  a1  integer 2
# param[in]  a2  integer 3
# return     s0  the largest value
# ----------------------------------------------------------------------
max:   
    add     s0, a0, zero    # copy a0 into s0 as the largest value so far
    sub     t0, a1, s0      # compute a1 - s0
    blt     t0, zero, check_a2 # if a1 < s0, skip to check_a2
    add     s0, a1, zero    # else update s0 with a1 as the largest so far

check_a2:  
    sub     t0, a2, s0      # compute a2 - s0
    bltz    t0, done        # if a2 < s0, skip to done
    add     s0, a2, zero    # else update s0 with a2 as the largest overall

done:  
    jr      ra              # return to the calling program
