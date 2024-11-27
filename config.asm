.data

frame_buffer: 	.space 	0x100000	# 512 wide x 512 high pixels
x_vel:		.word	0		# x velocity start 0
y_vel:		.word	0		# y velocity start 0
x_pos:		.word	50		# x position
y_pos:		.word	27		# y position
tail:		.word	7624		# location of rail on bit map display
apple_x:	.word	32		# apple x position
apple_y:	.word	16		# apple y position
snake_up:	.word	0x0000FF00	# green pixel for when snaking moving up
snake_down:	.word	0x0100FF00	# green pixel for when snaking moving down
snake_left:	.word	0x0200FF00	# green pixel for when snaking moving left
snake_right:	.word	0x0300FF00	# green pixel for when snaking moving right
x_conversion:	.word	64		# x value for converting x_pos to bitmap display
y_conversion:	.word	4		# y value for converting (x, y) to bitmap display
