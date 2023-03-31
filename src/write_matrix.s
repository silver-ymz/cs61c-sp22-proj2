.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue
	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw a2, 16(sp)
	sw a3, 20(sp)
	mv s1, a1
	mul s2, a2, a3
	slli s2, s2, 2

	li a1, 1
	jal fopen
	bltz a0, error_fopen
	mv s0, a0  # s0 is file desc

	addi a1, sp, 16
	li a2, 8
	li a3, 1
	jal fwrite
	li t0, 8
	bne a0, t0, error_fwrite

	mv a0, s0
	mv a1, s1
	mv a2, s2
	li a3, 1
	jal fwrite
	bne a0, s2, error_fwrite

	mv a0, s0
	jal fclose
	bltz a0, error_fclose

	# Epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 24
	ret

error_fopen:
	li a0 27
	j exit

error_fwrite:
	li a0 30
	j exit

error_fclose:
	li a0 28
	j exit