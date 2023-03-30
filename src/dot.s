.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

	# Prologue

	addi t0, x0, 1
	bge a2, t0, start0
	li a0, 36
	j exit
start0:
	bge a3, t0, start1
	li a0, 37
	j exit
start1:
	bge a4, t0, start2
	li a0, 37
	j exit
start2:
	addi t0, x0, 0  # t0 is idx
	addi t1, a0, 0  # t1 is adr of arr0 elm
	addi t2, a1, 0  # t2 is adr of arr1 elm
	addi t3, x0, 0  # t3 is ans
	slli a5, a3, 2  # a5 is 4 * a3
	slli a6, a4, 2  # a6 is 4 * a4
loop_start:
	lw t4, 0(t1)
	lw t5, 0(t2)
	mul t6, t4, t5
	add t3, t3, t6
	addi t0, t0, 1
	add t1, t1, a5
	add t2, t2, a6
	bne t0, a2, loop_start

	# Epilogue

	add a0, x0, t3
	ret
