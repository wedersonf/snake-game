draw_apple:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup update_snake frame pointer
	
	lw	$t0, apple_x		# t0 = x_pos of apple
	lw	$t1, apple_y		# t1 = y_pos of apple
	lw	$t2, x_conversion	# t2 = 64
	mult	$t1, $t2		# apple_y * 64
	mflo	$t3			# t3 = apple_y * 64
	add	$t3, $t3, $t0		# t3 = apple_y * 64 + apple_x
	lw	$t2, y_conversion	# t2 = 4
	mult	$t3, $t2		# (y_pos * 64 + apple_x) * 4
	mflo	$t0			# t0 = (apple_y * 64 + apple_x) * 4
	
	la 	$t1, frame_buffer	# load frame buffer address
	add	$t0, $t1, $t0		# t0 = (apple_y * 64 + apple_x) * 4 + frame address
	li	$t4, RED
	sw	$t4, 0($t0)		# store direction plus color on the bitmap display
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code	
	


new_apple_location:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup update_snake frame pointer

redo_random:		
	addi	$v0, $zero, 42	# random int 
	addi	$a1, $zero, 63	# upper bound
	syscall
	add	$t1, $zero, $a0	# random apple_x
	
	addi	$v0, $zero, 42	# random int 
	addi	$a1, $zero, 63	# upper bound
	syscall
	add	$t2, $zero, $a0	# random apple_y
	
	lw	$t3, x_conversion	# t3 = 64
	mult	$t2, $t3		# random apple_y * 64
	mflo	$t4			# t4 = random apple_y * 64
	add	$t4, $t4, $t1		# t4 = random apple_y * 64 + random apple_x
	lw	$t3, y_conversion	# t3 = 4
	mult	$t3, $t4		# (random apple_y * 64 + random apple_x) * 4
	mflo	$t4			# t1 = (random apple_y * 64 + random apple_x) * 4
	
	la 	$t0, frame_buffer	# load frame buffer address
	add	$t0, $t4, $t0		# t0 = (apple_y * 64 + apple_x) * 4 + frame address
	lw	$t5, 0($t0)		# t5 = value of pixel at t0
	
	li	$t6, SILVER		# load light gray color
	beq	$t5, $t6, good_apple	# if loction is a good sqaure branch to good_apple
	j redo_random

good_apple:
	sw	$t1, apple_x
	sw	$t2, apple_y	

	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code
