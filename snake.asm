update_snake:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup update_snake frame pointer
	
	### DRAW HEAD
	lw	$t0, x_pos		# t0 = x_pos of snake
	lw	$t1, y_pos		# t1 = y_pos of snake
	lw	$t2, x_conversion	# t2 = 64
	mult	$t1, $t2		# y_pos * 64
	mflo	$t3			# t3 = y_pos * 64
	add	$t3, $t3, $t0		# t3 = y_pos * 64 + x_pos
	lw	$t2, y_conversion	# t2 = 4
	mult	$t3, $t2		# (y_pos * 64 + x_pos) * 4
	mflo	$t0			# t0 = (y_pos * 64 + x_pos) * 4
	
	la 	$t1, frame_buffer	# load frame buffer address
	add	$t0, $t1, $t0		# t0 = (y_pos * 64 + x_pos) * 4 + frame address
	lw	$t4, 0($t0)		# save original val of pixel in t4
	sw	$a0, 0($t0)		# store direction plus color on the bitmap display
	
	
	### Set Velocity
	lw	$t2, snake_up			# load word snake up = 0x0000ff00
	beq	$a0, $t2, set_velocity_up		# if head direction and color == snake up branch to set_velocity_up
	
	lw	$t2, snake_down			# load word snake up = 0x0100ff00
	beq	$a0, $t2, set_velocity_down	# if head direction and color == snake down branch to set_velocity_up
	
	lw	$t2, snake_left			# load word snake up = 0x0200ff00
	beq	$a0, $t2, set_velocity_left	# if head direction and color == snake left branch to set_velocity_up
	
	lw	$t2, snake_right			# load word snake up = 0x0300ff00
	beq	$a0, $t2, set_velocity_right	# if head direction and color == snake right branch to set_velocity_up
	
set_velocity_up:
	addi	$t5, $zero, 0		# set x velocity to zero
	addi	$t6, $zero, -1	 	# set y velocity to -1
	sw	$t5, x_vel		# update x_vel in memory
	sw	$t6, y_vel		# update y_vel in memory
	j exit_velocity_set
	
set_velocity_down:
	addi	$t5, $zero, 0		# set x velocity to zero
	addi	$t6, $zero, 1 		# set y velocity to 1
	sw	$t5, x_vel		# update x_vel in memory
	sw	$t6, y_vel		# update y_vel in memory
	j exit_velocity_set
	
set_velocity_left:
	addi	$t5, $zero, -1		# set x velocity to -1
	addi	$t6, $zero, 0 		# set y velocity to zero
	sw	$t5, x_vel		# update x_vel in memory
	sw	$t6, y_vel		# update y_vel in memory
	j exit_velocity_set
	
set_velocity_right:
	addi	$t5, $zero, 1	# set x velocity to 1
	addi	$t6, $zero, 0 		# set y velocity to zero
	sw	$t5, x_vel		# update x_vel in memory
	sw	$t6, y_vel		# update y_vel in memory
	j exit_velocity_set
	
exit_velocity_set:
	
	### Head location checks
	li 	$t2, RED		# load red color
	bne	$t2, $t4, head_not_apple	# if head location is not the apple branch away
	
	jal 	new_apple_location
	jal	draw_apple
	j	exit_update_snake
	
head_not_apple:

	li	$t2, SILVER			# load light gray color
	beq	$t2, $t4, valid_head_square	# if head location is background branch away
	
	addi 	$v0, $zero, 10	# exit the program
	syscall
	
valid_head_square:

	### Remove Tail
	lw	$t0, tail		# t0 = tail
	la 	$t1, frame_buffer	# load frame buffer address
	add	$t2, $t0, $t1		# t2 = tail location on the bitmap display
	li 	$t3, SILVER		# load light gray color
	lw	$t4, 0($t2)		# t4 = tail direction and color
	sw	$t3, 0($t2)		# replace tail with background color
	
	### update new Tail
	lw	$t5, snake_up			# load word snake up = 0x0000ff00
	beq	$t5, $t4, set_next_tail_up		# if tail direction and color == snake up branch to set_next_tail_up
	
	lw	$t5, snake_down			# load word snake up = 0x0100ff00
	beq	$t5, $t4, set_next_tail_down	# if tail direction and color == snake down branch to set_next_tail_down
	
	lw	$t5, snake_left			# load word snake up = 0x0200ff00
	beq	$t5, $t4, set_next_tail_left	# if tail direction and color == snake left branch to set_next_tail_left
	
	lw	$t5, snake_right			# load word snake up = 0x0300ff00
	beq	$t5, $t4, set_next_tail_right	# if tail direction and color == snake right branch to set_next_tail_right
	
set_next_tail_up:
	addi	$t0, $t0, -256		# tail = tail - 256
	sw	$t0, tail		# store  tail in memory
	j exit_update_snake
	
set_next_tail_down:
	addi	$t0, $t0, 256		# tail = tail + 256
	sw	$t0, tail		# store  tail in memory
	j exit_update_snake
	
set_next_tail_left:
	addi	$t0, $t0, -4		# tail = tail - 4
	sw	$t0, tail		# store  tail in memory
	j exit_update_snake
	
set_next_tail_right:
	addi	$t0, $t0, 4		# tail = tail + 4
	sw	$t0, tail		# store  tail in memory
	j exit_update_snake
	
exit_update_snake:
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code
	
update_snake_head_position:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup update_snake frame pointer	
	
	lw	$t3, x_vel	# load x_vel from memory
	lw	$t4, y_vel	# load y_vel from memory
	lw	$t5, x_pos	# load x_pos from memory
	lw	$t6, y_pos	# load y_pos from memory
	add	$t5, $t5, $t3	# update x pos
	add	$t6, $t6, $t4	# update y pos
	sw	$t5, x_pos	# store updated xpos back to memory
	sw	$t6, y_pos	# store updated ypos back to memory
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code
