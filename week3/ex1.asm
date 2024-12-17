# Laboratory Exercise 3, Home Assignment 1
.text
start:
 # TODO:
 # Initialize i to s1
 # Initialize j to s2
 # Cách 1:
 # blt s2, s1, else # if j < i then jump else
 # Cách 2:
 slt t0, s2, s1 # set t0 = 1 if j < i else clear t0 = 0
 bne t0, zero, else # t0 != 0 means t0 = 1, jump else
then:
 addi t1, t1, 1 # then part: x=x+1
 addi t3, zero, 1 # z=1
 j endif # skip “else” part
else:
 addi t2, t2, -1 # begin else part: y=y-1
 add t3, t3, t3 # z=2*z
endif: