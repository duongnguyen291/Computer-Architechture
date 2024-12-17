.data
A: .word 5,6,1,4,3,2
Aend: .word
newline: .string "\n"
space: .string " "
.text
	main:
		la a2, A # a2 = address(A[0])
		la a3, Aend
		addi a3, a3, -4 # a3 = address(A[n-1])
		mv a6, a3 # create a6 always  = last elements
		j sort # sort 
	after_sort:
		jal print_array
		li a7, 10
		ecall
	end_main:
	# --------------------------------------------------------------
	# Procedure sort (ascending selection sort using pointer)
	# register usage in sort program
	# a2 pointer to the first element in unsorted part
	# a3 pointer to the last element in unsorted part
	# t0 temporary place for value of last element
	# s0 pointer to max element in unsorted part
	# s1 value of max element in unsorted part
	# --------------------------------------------------------------
	sort:
		beq a2, a3, done # single element list is sorted
		j max # call the max procedure
	after_max:
		lw t0, 0(a3) # load last element into $t0
		sw t0, 0(s0) # copy last element to max location
		sw s1, 0(a3) # copy max value to last element
		addi a3, a3, -4 # decrement pointer to last element
		jal print_array
		j sort # repeat sort for smaller list
	done:
		j after_sort
		# ---------------------------------------------------------------------
		# Procedure max
		# function: fax the value and address of max element in the list
		# a2 pointer to first element
		# a3 pointer to last element
		# ---------------------------------------------------------------------
	max:
		addi s0, a2, 0 # init max pointer to first element
		lw s1, 0(s0) # init max value to first value
		addi t0, a2, 0 # init next pointer to first
	loop:
		beq t0, a3, ret # if next=last, return
		addi t0, t0, 4 # advance to next element
		lw t1, 0(t0) # load next element into $t1
		blt t1, s1, loop # if (next)<(max), repeat 
		addi s0, t0, 0 # next element is new max element
		addi s1, t1, 0 # next value is new max value
		j loop # change completed; now repeat
	ret:
		j after_max
	
	 print_array:
	 	mv a4,a2 # saved the address value of a2
	 	mv a5,a6 # saved the address value of a6
	 print_loop:
	        lw a0,0(a2)
	        li a7, 1           # print integer
	        ecall
	        
	        la a0, space       # load address of space string
	        li a7, 4           # print string
	        ecall
	        
	        addi a2, a2, 4     # move to next element
	        ble a2, a6, print_loop  # if not past last element, continue loop
	        
	        la a0, newline     # print newline
	        li a7, 4
	        ecall
		add a2, a4, zero # restore a2 
	   	add a6, a5, zero # restore a6
	   	li a0, 0  # restore a0

	        
	        ret                # return to caller
