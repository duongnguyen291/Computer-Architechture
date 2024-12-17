# Laboratory Exercise 7, Home Assignment 1
.text
main: 
    li  a0, -69         # load input parameter  
    jal abs             # jump and link to abs procedure 

    li  a7, 10          # terminate
    ecall  
end_main: 

# --------------------------------------------------------------------
# Procedure abs: Calculates the absolute value of a number
# param[in]    a0    the integer for which absolute value is needed 
# return       s0    absolute value
# --------------------------------------------------------------------
abs:     
    sub s0, zero, a0    # put -a0 in s0 if a0 < 0     
    blt a0, zero, done  # if a0 < 0 then done 
    add s0, a0, zero    # else put a0 in s0
done:    
    jr ra              # return to the calling program
