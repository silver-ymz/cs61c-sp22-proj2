.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue

	addi t0, x0, 1
	bge a1, t0, start
	li a0, 36
	j exit
start:
	addi t0, x0, 0
	addi t1, a0, 0
	addi t2, x0, 1
	slli t2, t2, 31
	addi t3, x0, 0
loop_start:
	lw t4, 0(t1)
	blt t4, t2, loop_continue
	add t2, x0, t4
	add t3, x0, t0
loop_continue:
	addi t0, t0, 1
	addi t1, t1, 4
	bne t0, a1, loop_start

loop_end:
	# Epilogue

	add a0, x0, t3
	ret
