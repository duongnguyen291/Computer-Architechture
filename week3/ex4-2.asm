# Laboratory Exercise 3, Home Assignment 1
.text
start:
 # TODO:
	li s1, 1
	li s2, 1
	 # Cách 1:
	 # blt s2, s1, else # if j <= i then jump else
	 # Cách 2:
	li t2, 10
	 slt t0, s2, s1 # set t0 = 1 if j < i else clear t0 = 0
	 beq t0, zero, else # If t0 == 0 (i >= j), jump to else
then:
	 addi t1, t1, 1 # then part: x=x+1
	 addi t3, zero, 1 # z=1
	 j endif # skip “else” part
else:
	 addi t2, t2, -1 # begin else part: y=y-1
	 add t3, t3, t3 # z=2*z
endif: