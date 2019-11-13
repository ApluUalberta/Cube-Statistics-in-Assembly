
# Unix ID:              Aplu
# Lecture Section:      B2
# Instructor:           Karim Ali
# Lab Section:          H10 (Thursday 1700 - 1930)
# Teaching Assistant:   Ahmed Elbashir
#---------------------------------------------------------------
#---------------------------------------------------------------
# The Cubestats function takes in 4 parameters: dimension (a0), size (a1), first (a2), and edge (a3). dimension denotes the number of dimensions that the elements in the array contain (dimension can be up to k dimensions).
# first denotes the address of the first element of element of interest within the k dimensional array given. size denotes the edge size of the k-dimensional array (the mother array to be "filtered").
# edge denotes the edge size of the subarray values in the k dimensional array that we wish to access. This element is incremented through each "layer" depending on the number of dimensions held in the array
# So first increments its address differently depending on its values. Dimension also decrements recursively until it reaches 0 as its base case.
#
#
#
# Register Usage:
#
#       $sp: denotes the "size-indicator" of the stack that contains the elements to be used and altered throughout the recursive function. increments and decrements depending on what is initialized or restored
#       $fp: denotes the static stack pointer that is used to access arguments, and the loop counter
#       $a0: dimension variable. keeps track of the dimensions that the recursive call is currently in, and plays a role in executing the base case. Also plays a role in the power function and swaps with a1
#       $a1: size, denotes the edge size of the k dimensional array. Used in power calculation & also swapped with a0
#       $a2: first, is used as the address of the first element of interest in the given "layer" of the k dimensional array that is analyzed. Determines where the next recursive call starts with *first value
#       $a3: edge, is used to denote the edge size of the subarray of interest within the k dimensional array. Is crucial as a limit for the loop counter
#       $t0: stores *first and is used in branching statements to check if incrementing pos or neg average global variables
#       $t1: Replaced a lot, but commonly used to denote the ADDRESS of totalPos/totalNeg. It is also used to switch a0 and a1 as it denotes dimension - 1 in the loop
#       $t2: Replaced a lot, but commmonly used to denote the ADDRESS of countPos/countNeg. It is also used to switch a0 and a1 as it denotes size used in the power function
#       $t3: used and replaced a lot, but used mostly to denote *Totalpos or *TotalNeg which stores the updated values into the global variable. Also used to store 4*i*power(size,dimension-1)
#       $t4: Used and replaced a lot, but mostly used to denote *countPos or *CountNeg which stores the updated values into the global variable. Also used to store 4 to calculate 4*i*power(size,dimension - 1)
#       $t8: Used to store the quotient remainder in order to check if a remainder is present in the totalneg/countneg division in order to determine if an absolute floor is needed (subtracting the quotient by 1)
#       $s0: Used to store dimensions argument onto the stack, and is loaded from the stack upon restoration. Aids in the updating and holding of a0
#       $s1: Used to store the size argument onto the stack, and is loaded from the stack upon restoration. Responsible for holding a1
#       $s2: Used to store the first argument onto the stack, and is loaded from the stack upon restoration. Responsible for holding a2 and gets updated accordingly to access the next layer in the next recursive call
#       $s3: Used to store the edge argument onto the stack, and is loaded from the stack upon restoration. Responsible for holding a3
#       $s4: Used to store the Loop counter onto the stack in order to keep the increment consistent to calculate the power function correctly, and to properly terminate the recursive loop
#       $v0: stores the Negative Quotient to be printed
#       $v1: stores the Positive Quotient to be printed 
#---------------------------------------------------------------
# CMPUT 229 Student Submission License (Version 1.1)

# Copyright 2018 Allen Lu

# Unauthorized redistribution is forbidden in all circumstances. Use of this software without explicit authorization from the author or CMPUT 229 Teaching Staff is prohibited.

# This software was produced as a solution for an assignment in the course CMPUT 229 (Computer Organization and Architecture I) at the University of Alberta, Canada. This solution is confidential and remains confidential after it is submitted for grading. The course staff has the right to run plagiarism-detection tools on any code developed under this license, even beyond the duration of the course.

# Copying any part of this solution without including this copyright notice is illegal.

# If any portion of this software is included in a solution submitted for grading at an educational institution, the submitter will be subject to the sanctions for plagiarism at that institution.

# This software cannot be publicly posted under any circumstances, whether by the original student or by a third party. If this software is found in any public website or public repository, the person finding it is kindly requested to immediately report, including the URL or other repository locating information, to the following email address: cmput229@ualberta.ca.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


CubeStats:

	addiu $sp, $sp, -4					# decrement $sp by 0
	sw $fp, 0($sp)						# fp = sp
	move $fp, $sp					    # ""   ""
	
	addiu $sp, $sp, -24					# allocate 6 spaces for args, and counters
	sw $ra, -4($fp)						# ra -> *(fp + 4)
	sw $s0, -8($fp)						# s0 -> *(fp + 8)
	sw $s1, -12($fp)					# s1 -> *(fp + 12)
	sw $s2, -16($fp)					# s2 -> *(fp + 16)
	sw $s3, -20($fp)					# s3 -> *(fp + 20)
	sw $s4, -24($fp)					# s4 -> *(fp + 24)

	addi $s0, $a0, 0					# s0 <- dimension
	addi $s1, $a1, 0					# s1 <- size
	addi $s2, $a2, 0					# s2 <- first
	addi $s3, $a3, 0					# s3 <- edge

    # check for base case
    bne $a0, $0, loopinit               # if dimension == 0, execute the code below
    lw $t0, 0($a2)                      # t0 <- *first

    blez $t0, checkneg                  # if t0 >= 0, execute the code below
        
    la $t1, totalPos                    # t1 <- &totalPos
    la $t2, countPos                    # t2 <- &countPos

    lw $t3, 0($t1)                      # t3 <- *totalPos
    lw $t4, 0($t2)                      # t3 <- *countPos

    add $t3, $t3, $t0                   # *totalpos <- *totalpos + *first
    addi $t4, $t4, 1                    # *countpos <- *countpos + 1

    

    sw $t3, 0($t1)                      # t3 -> totalPos (updated value)
    sw $t4, 0($t2)                      # t4 -> countPos (updated value)
    j restorestack                      # restorer stack method

checkneg:
    bgez $t0, negzerocase               # if the code is less than 0, execute the code below

    la $t1, totalNeg                    # t1 <- &totalNeg
    la $t2, countNeg                    # t2 <- &countNeg

    lw $t3, 0($t1)                      # t3 <- *totalNeg
    lw $t4, 0($t2)                      # t4 <- *countNeg

    add $t3, $t3, $t0                   # *totalNeg <- *totalNeg + *first
    addi $t4, $t4, 1                    # *countNeg <- *countNeg + 1

    sw $t3, 0($t1)                      # t3 -> *totalNeg
    sw $t4, 0($t2)                      # t4 -> *countNeg
    j restorestack                      # restorer method
negzerocase:
    # ignore
    j restorestack                      # restorer method


restorestack:
	lw $ra, -4($fp)						# ra <- *(fp + 4)
	lw $s0, -8($fp)						# s0 <- *(fp + 8)
	lw $s1, -12($fp)					# s1 <- *(fp + 12)
	lw $s2, -16($fp)					# s2 <- *(fp + 16)
	lw $s3, -20($fp)					# s3 <- *(fp + 20)
	lw $s4, -24($fp)					# s4 <- *(fp + 24)
    
    lw $fp, 24($sp)                     # $fp = $sp - 4 (move the frame pointer right below the stack pointer to keep track of the previous function)
    addi $sp, $sp, 28                   # $sp = $sp + 28 (move the stack pointer up 28 points to start a new block of the stack memory)


    jr $ra                              # return to caller method


loopinit:
    addi $s4, $zero, 0          # i = 0

loop:
    #switch dimension and size around, also decrement dimension by 1 
    beq  $s4, $a3, finalcalculation     # if i == edge, exit the loop
    addi $t1, $a0, -1                   # t1 <- dimension - 1
    addi $t2, $a1, 0                    # t2 <- size

    addi $a1, $t1, 0                    # a1 <- dimension - 1
    addi $a0, $t2, 0                    # a0 <- size

    jal power                           # call the power function with the reversed a0 and a1 arguments

    # multiply the power by i, then multiply by 4
    mul $t3, $s4, $v0                   # t3 <-  i * power(size, dimension-1)
    li $t4, 4                           # t4 <- 4
    mul $t3, $t3, $t4                   # t3 <- 4*i*power(size,dimension-1)

    #change first to first + new_first 
    add $a2, $a2, $t3                   # a2 <- first + 4*i*power(size,dimension)

    #switch the variables back to their original arguments
    addi $a0, $t1, 0                    # a0 = dimension - 1
    addi $a1, $t2, 0                    # a1 = size

    jal CubeStats                       # after reswapping, call Cubestats again..

    addi $a0, $s0, 0                    # dimension <- s0
    addi $a1, $s1, 0                    # size <- s1 (stays the same)
    addi $a2, $s2, 0                    # first <- s2

    addi $s4, $s4, 1                    # i = i + 1
    j loop                              # recheck

finalcalculation:

    #initialize the v registers

    addi $v0, $zero, 0                  # v0 <- 0
    addi $v1, $zero, 0                  # v1 <- 0

    la $t1, totalPos                    # t1 <- &totalPos
    la $t2, countPos                    # t2 <- &countPos

    lw $t3, 0($t1)                      # t3 <- *totalPos
    lw $t4, 0($t2)                      # t4 <- *countPos

    beq $t4, $zero, ncalc               # if *countpos != 0, execute positive division
    div $t3, $t4                        # *totalPos / *countPos
    mflo $v1                            # v1 <- Posquotient
ncalc:
    la $t1, totalNeg                    # t1 <- &totalNeg
    la $t2, countNeg                    # t2 <- &countNeg

    lw $t3, 0($t1)                      # t3 <- *totalNeg
    lw $t4, 0($t2)                      # t4 <- *countNeg

    beq $t4, $0, restorestack           # if t4 == 0, v0 = 0 and restore stack
    div $t3, $t4                        # *totalNeg / *countPos
    mflo $v0                            # quotient = *totalNeg/ *countPos
    mfhi $t8                            # t8 <- remainder
    beq $t8, $0, restorestack           # if remainder == 0, return v0
    addi $v0, $v0, -1                   # if there is a remainder, take the absolute floor
    j restorestack                      # restore the stack

    


#     bne $t3, $zero, notpos
#     la $t1, totalPos
#     la $t2, countPos
    
#     lw $t3, 0($t1)
#     lw $t4, 0($t2)

#     beq $t3, $0, restorestack
#     div $t3, $t4
#     mflo $v1
#     j restorestack

# notpos:
#     div $t3, $t4
#     mflo $v0
#     mfhi $t5

#     beq $t5, $0, jump
#     addi $v0, $v0, -1
# jump

    
