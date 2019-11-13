#
# CMPUT 229: Cube Statistics Laboratory
# Author: Jose Nelson Amaral
# Date: December 2009
#
# Main program to read base array into memory,
# read a several cube specifications
# and print statistics for each cube.
#
	.data
arena:
	.space 32768
Pedge:
	.asciiz "edge = "
PnegAvg:
	.asciiz ", Negative Average = "
PposAvg:	
	.asciiz ", Positive Average = "
Pnewline:
	.asciiz "\n"

# These data items will be used by the CubeStats method.
	.globl countNeg
	.globl countPos
	.globl totalNeg
	.globl totalPos
totalNeg:	.word 0
totalPos:	.word 0
countNeg:	.word 0
countPos:	.word 0

######################################################################
# Register usage:                                                    #
# $s0: dimension                                                     #
# $s1: size                                                          #
# $s2: edge                                                          #
# $s3: first                                                         #
######################################################################
	
	.text
	.globl power
power:
	li $v0, 1
ploop:	
	beqz $a1, pdone
	mul $v0, $v0, $a0
	subu $a1, $a1, 1
	j ploop
pdone:
	jr $ra
	
	.globl main
main:
	subu     $sp, $sp, 4            # Adjust the stack to save $fp
	sw	 $fp, 0($sp)            # Save $fp
	move     $fp, $sp	        # $fp <-- $fp
	subu     $sp, $sp, 4	        # Adjust stack to save $ra
	sw	 $ra, -4($fp)	        # Save the return address ($ra)

	# Get the dimension
	li	 $v0, 5
	syscall
	move     $s0, $v0               # $s0 <-- dimension

	# Get the size
	li	 $v0, 5
	syscall
	move     $s1, $v0               # $s1 <-- size

	# Calculate numelems
	move     $a0, $s1	        # $a0 <-- size
	move     $a1, $s0	        # $a1 <-- dimension
	jal	 power		        # numelems <-- power(size,dimension)

	# Read array
	sll	 $v0,$v0,2	        # $v0 <-- 4*numelems
	la	 $t5, arena	        # cursor <-- start of arena 
	add	 $t6, $t5, $v0	        # $t6 <-- end of array
ReadArray:
	li	 $v0, 5
	syscall			        # $v0 <-- element
	sw	 $v0, 0($t5)	    # *cursor <-- element
	addi $t5, $t5, 4	        # *cursor++
	blt	 $t5, $t6, ReadArray # if(cursor<end of array) 

forever:
	# Read a Cube
	la	 $s3, arena	        # first <-- start of arena
	add	 $t2, $0, $0	        # d <-- 0
	
ReadCube:
	# Get the corner, calculating its absolute location along the way
	li	 $v0, 5
	syscall			        # $v0 <-- cubed
	move     $t4, $v0		# $t4 <-- cubed
	blt	 $t4, $0, ExitMain	# if(cubed<0) ExitMain
	move     $a0, $s1		# $a0 <-- size
	sub      $a1, $s0, $t2		# $a1 <-- dimension - d
	addi     $a1, $a1, -1       # $a1 <-- dimension - d - 1
	jal	 power			# $v0 <-- power(size,d)
	mul	 $t3, $t4, $v0	        # $t3 <-- cubed*power(size,dimension - d - 1)
	sll      $t3, $t3, 2            # $t3 <-- 4*$t3 (offset)
	add	 $s3, $s3, $t3	        # first = first + cubed*power(size,dimension - d - 1)
	add	 $t2, $t2, 1	        # d <-- d + 1
	blt	 $t2, $s0, ReadCube     # if(d<dimension) ReadCube

	# Get the edge length
	li	 $v0, 5
	syscall				# $v0 <-- edge
	move     $s2, $v0		# $s2 <-- edge

	# Initialize totals and counts to be used by CubeStats
	sw	$0, countNeg
	sw	$0, countPos
	sw	$0, totalNeg	
	sw	$0, totalPos
	# Set up the arguments and call CubeStats
	move     $a0, $s0		# $a0 <-- dimension
	move     $a1, $s1		# $a1 <-- size
	move     $a2, $s3		# $a2 <-- first
	move     $a3, $s2		# $a3 <-- edge
	
	jal	 CubeStats
	# Get the averages into $t0, $t1
	move     $t0, $v0
	move     $t1, $v1

	# Print the value of the edge
	li       $v0, 4
	la       $a0, Pedge
	syscall
	move     $a0, $s2
	li       $v0, 1
	syscall

	# Print the value of the positive average
	li       $v0, 4
	la       $a0, PposAvg
	syscall
	move     $a0, $t1
	li       $v0, 1
	syscall

	# Print the value of the negative average
	li      $v0, 4
	la      $a0, PnegAvg
	syscall
	move    $a0, $t0
	li      $v0, 1
	syscall
	li		$v0, 4
	la		$a0, Pnewline
	syscall
	j       forever
	
ExitMain:	
	# Usual stuff at the end of the main
	lw      $ra, -4($fp)
	addu    $sp, $sp, 4
	lw      $fp, 0($sp)
	addu    $sp, $sp, 4
	jr      $ra

CubeStats:

	# initializing the stack
	# allocate stack memory
	# assign the return address to 4 + sp
	# next is the 

	addiu $sp, $sp, -4					# decrement $sp by 0
	lw $fp, 0($sp)						# fp = sp
	add $fp, $sp, $zero
	
	addiu $sp, $sp, -24					# allocate 6 spaces for args, and counters
	sw $ra, -4($fp)						# ra -> *(fp + 4)
	sw $s0, -8($fp)						# s0 -> *(fp + 8)
	sw $s1, -12($fp)					# s1 -> *(fp + 12)
	sw $s2, -16($fp)					# s2 -> *(fp + 16)
	sw $s3, -20($fp)					# s3 -> *(fp + 20)
	sw $s4, -24($fp)					# s4 -> *(fp + 24)

	add $s0, $a0, $0					# s0 <- dimension
	add $s1, $a1, $0					# s1 <- size
	add $s2, $a2, $0					# s2 <- first
	add $s3, $a3, $0					# s3 <- edge

	#sw $ra, 20($sp)
	#sw $fp, 16($sp)

	#move $fp, $sp

	#sw $a0, 12($sp)					# stack[fp + 56] <- dimension
	#sw $a1, 8($sp)						# stack[fp + 60] <- size
	#sw $a2, 4($sp)						# stack[fp + 64] <- first
	#sw $a3, 0($sp)						# stack[fp + 68] <- edge


	move $t0, $s0					# t0 <- dimension


	bne $t0, $zero, recurse				# if  dimension == 0, execute bottom code

	lw $t2, 0($s2)						# t2 <- *first
	
	blez $t2, addneg					# if *first > 0, execute the bottom code\

	la $t3, totalPos					# t3 <- &totalPos
	la $t4, countPos					# t4 <- &countPos

	lw $t5, 0($t3)						# t5 <- *totalPos
	lw $t6, 0($t4)						# t6 <- *countPos

	#TODO: store word for totalpos and countpos into the proper stack location
	
	add $t5, $t5, $t2					# totalpos <- totalpos + *first
	addi $t6, $t6, 1					# countpos <- countpos + 1

	sw $t5, 0($t3)						# t5 -> *totalPos						 
	sw $t6, 0($t4)						# t6 -> *countPos
	j notneg
addneg: 

	bgez $t2, notneg					# if *first < 0, execute the code below

	la $t3, totalNeg					# t3 <- &totalNeg
	la $t4, countNeg					# t4 <- &countNeg

	lw $t5, 0($t3)						# t5 <- *totalNeg
	lw $t5, 0($t4)						# t6 <- *countNeg

	add $t5, $t5, $t2					# *countNeg <- *countNeg + *first
	addi $t6, $t6, 1					# *countNeg <- *countNeg + 1

	sw $t5, 0($t3)						# store back into the global totalNeg
	sw $t6, 0($t4)						# store back into the globat countNeg

notneg:
	la $t3, countPos					# t3 <- &countPos
	lw $t4, 0($t3)						# t4 <- *countPos

	beq $t4, $zero, eq0					# if countPos != 0, execute the code below
	la $t5, totalPos						# t5 <- &totalPos
	lw $t6, 0($t5)							# t6 <- *totalPos
		
	div $t6, $t4							# *totalpos / *countpos
	mflo $v1							# Final positive average
	j checkneg
eq0:
	addi $v1, $zero, 0					# if countpos == 0, then the average is 0

checkneg:

	la $t3, countNeg					# t3 <- &countNeg
	lw $t4, 0($t3)						# t4 <- *countNeg

	beq $t4, $zero, neg0				# if countNeg != 0, execute the code below
	la $t5, totalNeg					# t5 <- &totalneg
	lw $t6, 0($t5)						# t6 <- *totalneg

	div $t6, $t4						# *totalneg / *countNeg
	mflo $v0							# final quotient
	mfhi $t8
	
	bne $t8, $zero, regdiv 				# find out how to handle this part
	addi $v0, $v0, -1					# return the proper ceiling
regdiv:
	j notneg0

neg0:
	addi $v0, $zero, 0					# if countNeg == 0, then the average is 0

notneg0:

	lw $ra, -4($fp)						# ra <- *(fp + 4)
	lw $s0, -8($fp)						# s0 <- *(fp + 8)
	lw $s1, -12($fp)					# s1 <- *(fp + 12)
	lw $s2, -16($fp)					# s2 <- *(fp + 16)
	lw $s3, -20($fp)					# s3 <- *(fp + 20)
	lw $s4, -24($fp)					# s4 <- *(fp + 24)

	jr $ra								#return to recursive caller

recurse:
	addi $s4, $zero, 0					# for (i = 0; i < edge; i++)
loop:

	beq $s3, $s4, endloop
	# store the arguments onto the stack



	add $t1, $a0, $0					# t1 <- dimension
	addi $t1, $t1, -1					# dimension <- dimension - 1
	add $t2, $a1, $0					# t2 <- size
	add $a1, $t1, $0					# swap a1 and a0
	add $a0, $t2, $0					# swap a1 and a0

	addiu $sp, $sp, -4					# decrement stack pointer by 4
	lw $fp, 0($sp)						
	add $fp, $sp, $zero					#fp = sp

	addiu $sp, $sp, -12					#allocate 3 spaces
	sw $ra, -4($fp)						# ra -> *(fp + 4)
	sw $a0, -8($fp)						# size -> *(fp + 8)
	sw $a1, -12($fp)					# dimension -> *(fp + 12)

	jal power							# power(size,dimension)
	#swap variables back

	lw $ra, -4($fp)						#restore ra
	lw $a0, -12($fp)					# a0 <- dimension
	lw $a1, -8($fp)						# a0 <- size
	addiu $sp, $sp, 12					# reset stack pointer position
	
	mul $t1, $s4, $v0					# t1 <- i*power_result
	li $t2, 4							# t2 <- 4
	mul $t1, $t1, $t2					# t1 <- 4*power
	add $a2, $a2, $t1					# first <- first + dimension



	jal CubeStats


	
	addiu $sp, $sp, 24					
	

	addi $s4, $s4, 1
	j loop
endloop:


	
