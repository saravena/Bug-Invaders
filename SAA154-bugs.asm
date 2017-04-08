# Name:		Sabrina A Aravena  |  SAA154@pitt.edu
# Class: 	CS 447  |  Childers MW 3 - 4:15
# Recitation:	M 12 - 12:50
# Project: 	No.1  |  Space Invaders
# Due: 		March 18, 2016

#######################################################################################
	.data
ScoreMsg:		.asciiz		"The game score is "
Colon:			.asciiz		" : "
red:		 	.word		1
orange:			.word		2
green:			.word		3
off:			.word		0
curr_x:			.word		32
curr_y:			.word		63
new_x:			.word		63
phaser_x:		.word		32
phaser_y:		.word		62
bug_x:			.word		0
bug_y:			.word		0
count_phaser:		.word		0
count_bugs:		.word		0
bugs:			.space		378
phaser:			.space		126
wave:			.space		567

#######################################################################################
	.text
# main loop of game
gameLoop:
jal	keyPressed
back_keypress:
jal	get_Time
back:
j	gameLoop

#######################################################################################
# gets current time of game and acts if game ends or bugs move
get_Time:
subi	$sp, $sp, 4			# intializes stack pointer down 4
sw	$ra, 0($sp)

addi	$v0, $zero, 30
syscall					# grabs system time
add	$s1, $zero, $a0			# stores current time into $s1

subu	$t0, $s1, $s0			# (current time - overall time)

# exits game if time surpassed 2 min. (key press does not work for some reason when uncommented)
#sgtu	$t9, $t0, 120000
#beq	$t9, 1, end_GAME

# update if 100 ms passed
bge	$t0, 100, update_phaser_LIST
#bge	$t0, 600, update_bugs_LIST   ( updates bug fall similiarly to phaser functionality)
# Does not work at all. The idea is so that every 600 ms the bugs are supposed to fall and a new row of random bugs form.
# The random bug postion is functional but they do not move.
# move bugs(x,  y) to (x, y+1).
# if (Y == 63) turn LED off so it does not go in same row as bug-shooter
# add additional row of random bugs in top row

# restores stack
lw	$ra, 0($sp)
addi	$sp, $sp, 4
jr	$ra

#######################################################################################
# updates phaser
# phaser is functional until (Y < 0). Program crashes once phaser is off the board.
# attempted code in line 109
update_phaser_LIST:
addi	$v0, $zero, 30
syscall					# grabs system time
add	$s0, $zero, $a0			# stores current time into $s0

add	$s7, $zero, $zero		# initializes a register to zero

list_loop:
la	$t0, count_phaser		# load adress into count_phaser
lw	$t7, 0($t0)			# set address into temporary variable

bge	$s7, $t7, gameLoop		

la	$t3, phaser			# load phaser address into a temp. register
add	$t1, $t3, $s7			# add add both addresses together
lb	$s6, ($t1)			# load byte into $s6
addi	$t1, $t1, 1			# offset 1
lb	$s5, ($t1)			# load other byte into $s5

sw	$s6, phaser_x			# load byte into phaser_x
sw	$s5, phaser_y			# load byte into phaser_y

jal	update_Phaser

la	$t3, phaser			# load new address into temp. register
add	$t1, $t3, $s7			# add offset into address
add	$t1, $t1, 1
subi	$s5, $s5, 1
sb	$s5, ($t1)			# load $t1 into $s6
 
addi	$s7, $s7, 2			# offset 2
j	list_loop

# updates coordinates of phaser
update_Phaser:
subi	$sp, $sp, 4			# intializes stack pointer down 4
sw	$ra, 0($sp)

# should reset phaser if Y == 0 and continue fluently but "External Interruption" occurs
blt	$a1, $zero, reset_phaser	# rest phaser if y coordinate is less than 0

###################################
# if phaser(x, y) == bug(x, y)
# do lines 116-119
# bug shoot = bug shoot + 1 (updates bug shoot by one)
# jump to wave ( would be placed in another part of program


#wave:
# load current cooridantes of phaser into wave variable
# wave(x,y) = phaser(x, y)
# draw box of LED's around wave coordinate
# store into memory similiarly to storing both phaser coordinates and bug coordinates
# for (i <= 10; i++) {
#  turn off current coordinates
#  expand radius by i
#  expand each time until i reaches 10
#  if (radius(x, y) == bug(x, y) {
#	turn off bug location
#	bug hit++
#	recall wave method
#  } //end if
# } // end for 

# did not know how to implement this through MIPS though I do understand the logic

###################################
lw	$a0, phaser_x			# loads the current position of X for phaser
lw	$a1, phaser_y			# loads the current position of Y for phaser
lw	$a2, off
jal	_setLED

subi	$a1, $a1, 1			# decrement y variable by 1
sw	$a1, phaser_y			# store new variable into phaser_y
lw	$a0, phaser_x			# loads new position of X for phaser
lw	$a1, phaser_y			# loads new position of Y for phaser
lw	$a2, red
jal	_setLED
j	end_update

# resets phaser coordinates to (0,0)
reset_phaser:
sw	$zero, phaser_x			# set X to 0
sw	$zero, phaser_y			# set Y to 0

# restores stack
end_update:
lw	$ra, 0($sp)
addi	$sp, $sp, 4
jr	$ra

#######################################################################################
# Checks which key was pressed and implements accordingly
keyPressed:
li	$t0, 0xFFFF0000			# if the LSB at this address is 0, no key was pressed. If it is 1, a key was pressed
lw	$t1, ($t0)			# loads the word at 0xFFFF0000	
andi	$t1, $t1, 1			# isolates the LSB
beq	$t1, $zero, back_keypress	# if the value is 0, no key was pressed, and returns to the main Game Loop
	
# A key was pressed
li	$t0, 0xFFFF0004			# holds the value of they key that was pressed
lw	$t1, ($t0)			# loads the value of the key that was pressed
	 
beq 	$t1, 0xE2, left_pressed		# if 'a' is found the bug-buster moves left
beq	$t1, 0xE3, right_pressed	# if 'd' is found the bug-buster moves right
beq	$t1, 0xE0, up_pressed		# if 'w' is found the player wants to shoot phaser
beq	$t1, 0xE1, down_pressed		# if 's' is found the game ends
beq	$t1, 0x42, b_pressed		# if 'b' is found the game starts

end_keyPress:
jr	$ra

#######################################################################################
# Moves the bug-buster left from (X,Y) to (X-1,Y)
left_pressed:
lw	$t2, curr_x			# loads current X position of the bug-buster
beq	$t2, 0, wrap_LEFT		# if X = 0, the bug-buster is at the left most position and needs to wrap to other side
subi	$t2, $t2, 1			# subtract 1 from the current X position
j	update_Left			# change the curr_x, X ,to the value of new_x, X-1

# Reassigns bug-buster to other side of board
wrap_LEFT:
li	$t2, 63				# wrap the bug-buster around
# Updates current X position
update_Left:	
sw	$t2, new_x			# updates curr_x to new_x
jal	ChangeLED			# turns the LED at curr_x off and the LED at new_x on

j	back

#######################################################################################
# Moves the bug-buster right from (X,Y) to (X+1,Y)
right_pressed:
lw	$t2, curr_x			# loads the current X position of the bug-buster
beq	$t2, 63, wrap_RIGHT		# if X = 63, the bug-buster is at the right most position and needs to wrap to other side
addi	$t2, $t2, 1			# add 1 to the current X position
j	update_Right			# change the curr_x, X ,to the value of new_x, X+1

# Reassigns bug-buster to the other side of board
wrap_RIGHT:
li	$t2, 0				# wrap the bug-buster around
# Updates current X position
update_Right:	
sw	$t2, new_x			# updates curr_x to new_x
jal	ChangeLED			# turns the LED at curr_x off and the LED at new_x on

j	back
	
#######################################################################################
up_pressed:
addi	$s4, $s4, 1			# add to to phaser shoot count

lw	$a0, curr_x			# loads the current position of the bug-buster
sw	$a0, phaser_x			# stores current x value of bug-buster into phaser
lw	$a0, phaser_x			# loads updated x coordinate for phaser
addi	$t5, $zero, 62
sw	$t5, phaser_y
lw	$a1, phaser_y			# loads the current position of Y for phaser (DEFAULT 62)
lw	$a2, red

jal 	_setLED

la	$t0, phaser			# loads address of phaser
lw	$t1, count_phaser		# loads word into count_phaser buffer
add	$t0, $t1, $t0			

sb	$a0, ($t0)			# stores value of $t1 into $a0
addi	$t0, $t0, 1			# add 1 offset
sb	$a1, ($t0)			# stores updated value of $t1 into $a1

addi	$t1, $t1, 2 			# add offset by 2
sw	$t1, count_phaser

j 	back_keypress

#######################################################################################
down_pressed:
j	end_GAME			# ends game if down arrow is pressed

#######################################################################################
b_pressed:
# starts bug-buster at initial position(32, 63)
lw	$a0, curr_x			# loads the current position of X(DEFAULT 32)	
lw	$a1, curr_y			# loads the current position of Y(DEFAULT 63)
lw	$a2, orange
jal 	_setLED

# initializes phaser shoot count to 0
add	$s4, $zero, $zero
# initializes bug shoot count to 0
add	$s2, $zero, $zero

# grabs overall system time
addi	$v0, $zero, 30
syscall					# grabs system time
add	$s0, $zero, $a0			# stores time into $s0

#######################################################################################
displayBugs:
add	$s3, $zero, $zero		# intilize count to 0

# display bugs at random in top row
loop_random:
addi	$v0, $zero, 42			# pick random row between in range [0-63]
addi	$a0, $zero, 0			# LOWER BOUND	
addi	$a1, $zero, 63			# UPPER BOUND
syscall

# displays bugs
sw	$a0, bug_x 			# stores random X coordinate into bug_x
lw	$a0, bug_x			# load current X of bug
lw	$a1, bug_y			# load current Y of bug (DEFAULT 0)
lw	$a2, green
jal	_setLED

# bugs should've then been placed into memory and proceed to move down every 600 ms
# code for that does not work
#la	$t0, bugs			# loads address of bug
#lw	$t1, count_bugs			# loads word into count_bug buffer
#add	$t0, $t1, $t0			

#sb	$a0, ($t0)			# stores value of $t1 into $a0
#addi	$t0, $t0, 1			# add 1 offset
#sb	$a1, ($t0)			# stores updated value of $t1 into $a1

#addi	$t1, $t1, 2 			# add offset by 2
#sw	$t1, count_bugs

addi	$s3, $s3, 1			# add 1 to count 

ble	$s3, 3, loop_random		# loop to display each bug at a time

j	back_keypress

#######################################################################################
# displays score and ends game
end_GAME:
addi	$v0, $zero, 4
la	$a0, ScoreMsg			# displays score message
syscall

# will display 0 because register never gets updated (code written in pseudocode)
addi	$v0, $zero, 1
la	$a0, ($s2)			# displays number of times bugs were hit
syscall

addi	$v0, $zero, 4
la	$a0, Colon			# displays colon message
syscall

addi	$v0, $zero, 1
la	$a0, ($s4)			# displays number of times phaser has been shot
syscall

addi	$v0, $zero, 10			# end game 
syscall

#######################################################################################
_setLED:
# void _setLED(int x, int y, int color)
#   sets the LED at (x,y) to color
#   color: 0=off, 1=red, 2=orange, 3=green
#
# x, y and color are assumed to be legal values (0-63,0-63,0-3)
# $a0 is x, $a1 is y, $a2 is color 
# trashes:   $t0-$t3
# returns:   none
#
# byte offset into display = y * 16 bytes + (x / 4)

#clear trash registers
addi	$t0, $zero, 0
addi	$t1, $zero, 0
addi	$t2, $zero, 0
addi	$t3, $zero, 0

sll	$t0,$a1,4			# y * 16 bytes
srl	$t1,$a0,2      			# x / 4
add	$t0,$t0,$t1    			# byte offset into display
li	$t2,0xffff0008			# base address of LED display
add	$t0,$t2,$t0    			# address of byte with the LED
# now, compute led position in the byte and the mask for it
andi	$t1,$a0,0x3  			# remainder is led position in byte
neg	$t1,$t1        			# negate position for subtraction
addi	$t1,$t1,3      			# bit positions in reverse order
sll	$t1,$t1,1      			# led is 2 bits
# compute two masks: one to clear field, one to set new color
li	$t2,3		
sllv	$t2,$t2,$t1
not	$t2,$t2        			# bit mask for clearing current color
sllv	$t1,$a2,$t1    			# bit mask for setting color
# get current LED value, set the new field, store it back to LED
lbu	$t3,0($t0)     			# read current LED value	
and	$t3,$t3,$t2    			# clear the field for the color
or	$t3,$t3,$t1    			# set color field
sb	$t3,0($t0)    			# update display
jr	$ra

#######################################################################################
# Reads the left or right key and updates curr pointer
ChangeLED:
subi	$sp, $sp, 8			# intializes stack pointer down 8
sw	$ra, 0($sp)
sw	$t1, 4($sp)
# turns off LED at current position
lw	$a0, curr_x			# loads current x position of the bug-buster
lw	$a1, curr_y			# loads current y position of the bug-buster(DEFAULT 63)
lw	$a2, off			# sets the current position to "off"
jal	update_Change
# turn on LED at new postion
lw	$a0, new_x			# loads new x position of the bug-buster
lw	$a1, curr_y			# loads new y position of the bug-buster(DEFAULT 63)
lw	$a2, orange			# sets the new X and Y coordinates to orange
jal	update_Change
# updates the curr_x position to the new_x position
lw	$t1, new_x
sw	$t1, curr_x
# restore  stack
lw	$ra, 0($sp)
lw	$t1, 4($sp)
addi	$sp, $sp, 8
jr	$ra

# pushes stack pointer down and stores when LED changes
update_Change:
subi	$sp, $sp, 12
sw	$ra, 0($sp)
sw	$t0, 4($sp)
sw	$t1, 8($sp)

jal	_setLED

lw	$ra, 0($sp)
lw	$t0, 4($sp)
lw	$t1, 8($sp)
addi	$sp, $sp, 12
jr	$ra
