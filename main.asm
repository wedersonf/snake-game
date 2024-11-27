# Authors: Matheus Souza, Wederson Fagundes
# Email: mdsouza@inf.ufsm.br, wmfagundes@inf.ufsm.br
# Description: Game of Snake

###############################################################
### 			BITMAP SETTINGS			    ###	
###							    ###
###	Unit Width in pixels: 8 			    ###
###	Unit Heigh in Pixels: 8				    ###
###	Display Width in Pixels: 512			    ###
###	Display Height in Pixels: 512  			    ###
###	Base address for display 0x10010000 (static data)   ###
###							    ###	
###############################################################

.text
init:
    la $t0, main
    jalr    $t0
    la $t0, finit
    jr $t0

finit:
    move    $a0, $v0
    li $v0, 17
    syscall

.include "config.asm"
.include "display_bitmap.asm"
.include "apple.asm"
.include "snake.asm"

main:
	li $a0, SILVER
	jal set_background_color
	jal screen_init2
	
l1:
	li $a0, NAVY
	jal set_foreground_color
	
	# draw left wall
	li $a0, 0
	li $a1, 0
	li $a2, 63
	li $a3, 0
	jal draw_line
	
	# draw top wall
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 63
	jal draw_line
	
	# draw right wall
	li $a0, 63
	li $a1, 63
	li $a2, 0
	li $a3, 63
	jal draw_line
	
	# draw bottom wall
	li $a0, 63
	li $a1, 63
	li $a2, 63
	li $a3, 0
	jal draw_line
	
	### draw initial snake
	la	$t0, frame_buffer	# load frame buffer address
	lw	$s2, tail		# s2 = tail of snake
	lw	$s3, snake_up		# s3 = direction of snake
	
	add	$t1, $s2, $t0		# t1 = tail start on bit map display
	sw	$s3, 0($t1)		# draw pixel where snake is
	addi	$t1, $t1, -256		# set t1 to pixel above
	#sw	$s3, 0($t1)		# draw pixel where snake currently is
	
	### draw initial apple
	jal	new_apple_location
	jal 	draw_apple
	
game_update_loop:

	lw	$t3, 0xffff0004		# get keypress from keyboard input
	
	### Sleep for 33 ms so frame rate is about 30 fps
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 33	# 33 ms
	syscall
	
	beq	$t3, 100, move_right	# if key press = 'd' branch to moveright
	beq	$t3, 97, move_left	# else if key press = 'a' branch to move_left
	beq	$t3, 119, move_up	# if key press = 'w' branch to move_up
	beq	$t3, 115, move_down	# else if key press = 's' branch to move_down
	beq	$t3, 0, move_up		# start game moving up
	
move_up:
	lw	$s3, snake_up	# s3 = direction of snake
	add 	$a0, $s3, $zero	# a0 = direction of snake
	jal	update_snake
	
	# move the snake
	jal 	update_snake_head_position
	
	j	exit_moving
	
move_down:
	lw	$s3, snake_down	# s3 = direction of snake
	add	$a0, $s3, $zero	# a0 = direction of snake
	jal	update_snake
	
	# move the snake
	jal 	update_snake_head_position
	
	j	exit_moving
	
move_left:
	lw	$s3, snake_left	# s3 = direction of snake
	add	$a0, $s3, $zero	# a0 = direction of snake
	jal	update_snake
	
	# move the snake
	jal 	update_snake_head_position
	
	j	exit_moving
	
move_right:
	lw	$s3, snake_right	# s3 = direction of snake
	add	$a0, $s3, $zero	# a0 = direction of snake
	jal	update_snake
	
	# move the snake
	jal 	update_snake_head_position

	j	exit_moving

exit_moving:
	j 	game_update_loop		# loop back to beginning
