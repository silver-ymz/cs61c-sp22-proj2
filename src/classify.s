.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	li t0, 5
	bne a0, t0, error_arg
	
	addi sp, sp, -52
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	mv s0, a1  # s0 is argv
	mv s1, a2  # s1 is silent mode

	# Read pretrained m0
	lw a0, 4(s0)
	addi a1, sp, 28  # sp+28 is rows of m0
	addi a2, sp, 32  # sp+32 is cols of m0
	jal read_matrix
	mv s2, a0  # s2 is m0

	# Read pretrained m1
	lw a0, 8(s0)
	addi a1, sp, 36  # sp+36 is rows of m1
	addi a2, sp, 40  # sp+40 is cols of m1
	jal read_matrix
	mv s3, a0  # s3 is m1

	# Read input matrix
	lw a0, 12(s0)
	addi a1, sp, 44  # sp+44 is rows of input
	addi a2, sp, 48  # sp+48 is cols of input
	jal read_matrix
	mv s4, a0  # s4 is input

	# Compute h = matmul(m0, input)
	lw s5, 28(sp)
	lw a0, 48(sp)
	mul s5, s5, a0  # s5 is length of h
	slli a0, s5, 2
	jal malloc
	beqz a0, error_malloc
	mv s5, a0  # s5 is h

	mv a0, s2
	lw a1, 28(sp)
	lw a2, 32(sp)
	mv a3, s4
	lw a4, 44(sp)
	lw a5, 48(sp)
	mv a6, s5
	jal matmul

	# Compute h = relu(h)
	mv a0, s5
	lw t0, 28(sp)
	lw a1, 48(sp)
	mul a1, a1, t0
	jal relu

	# Compute o = matmul(m1, h)
	lw s2, 36(sp)
	lw a0, 48(sp)
	mul s2, s2, a0  # s2 is length of o
	slli a0, s2, 2
	jal malloc
	beqz a0, error_malloc
	mv s2, a0  # s2 is o

	mv a0, s3
	lw a1, 36(sp)
	lw a2, 40(sp)
	mv a3, s5
	lw a4, 28(sp)
	lw a5, 48(sp)
	mv a6, s2
	jal matmul

	# Write output matrix o
	lw a0, 16(s0)
	mv a1, s2
	lw a2, 36(sp)
	lw a3, 48(sp)
	jal write_matrix

	# Compute and return argmax(o)
	mv a0, s2
	lw a1, 36(sp)
	lw t0, 48(sp)
	mul a1, a1, t0
	jal argmax

	# If enabled, print argmax(o) and newline
	li t0, 1
	beq s1, t0, end
	jal print_int
	li a0, '\n'
	jal print_char

end:
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	addi sp, sp, 52
	ret

error_malloc:
	li a0, 26
	j exit

error_arg:
	li a0, 31
	j exit