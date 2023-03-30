.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue

	addi t0, x0, 1
	bge a1, t0, start
	li a0, 36
	j exit
start:
	addi t0, x0, 0
	addi t1, a0, 0
loop_start:
	lw t2, 0(t1)
	bge t2, x0, ge_zero
	addi t2, x0, 0
ge_zero:
	sw t2, 0(t1)
	addi t0, t0, 1
	addi t1, t1, 4
	bne t0, a1, loop_start

	ret










loop_continue:



loop_end:


	# Epilogue


	ret
