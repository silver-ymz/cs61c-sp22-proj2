.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

	# Prologue
	addi sp, sp, -24
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw ra, 12(sp)
	mv s1, a1  # s1 is caller a1, rows
	mv s2, a2  # s2 is caller a2, cols

	li a1, 0
	jal fopen
	bltz a0, error_fopen
	mv s0, a0  # s0 is file desc

	addi a1, sp, 16
	li a2, 8
	jal fread
	li t0, 8
	bne a0, t0, error_fread

	lw t0, 16(sp)
	lw t1, 20(sp)
	sw t0, 0(s1)
	sw t1, 0(s2)
	mul s1, t0, t1  # s1 is length of matrix
	slli s1, s1, 2
	mv a0, s1
	jal malloc
	beqz a0, error_malloc
	mv s2, a0  # s2 is addr of return matrix

	mv a0, s0
	mv a1, s2
	mv a2, s1
	jal fread
	mv t0, s1
	bne a0, t0, error_fread

	mv a0, s0
	jal fclose
	bltz a0, error_fclose

	# Epilogue
	mv a0, s2
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 24
	ret

error_malloc:
    li a0 26
    j exit

error_fopen:
	li a0 27
	j exit

error_fread:
	li a0 29
	j exit

error_fclose:
	li a0 28
	j exit