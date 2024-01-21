# Title: MMN11q3          
# Author: Ornit Cohen gindi      ID:  043045723      Date: 1/2024
# Description: 
# Input: integer between -9999 and 9999
# Output: validation msg if needed, 
#	  16 bits of input binary representation, 
# 	  inverted binary representation 
#	  decimal value of inverted binary 

####################### Data ####################################

# settings: "initialize program counter to global main"
.data
msgInput: .asciiz "\n Please enter a 4 digit integer number between -9999 to 9999 \n"
msgWrong: .asciiz "\n Wrong input! try again \n"
msgStraight: .asciiz "\n The number you entered in binary 16 bits: \n"
msgInverted: .asciiz "\n The number you entered in binary 16 bits in inverted order: \n"
msgDecimal: .asciiz "\n The inverted number in decimal: \n"
linedown: .byte '\n'


####################### Code ####################################
.text
.globl main

wrongInput:	
	li $v0, 4        	  # define syscall to print string
	la $a0, msgWrong   	  # define what will be printed in the syscall
	syscall   	          # print msgWrong

################ q3-a: get input between -9999 and 9999 + validation

main:   #main program entry
	li $v0,  4      	 # define syscall to print string
	la $a0, msgInput   	 # define what will be printed in the syscall
	syscall   		 # print msgInput
	
	li $v0, 5      		# define syscall to read integer
	syscall   	 	# read integer
	
				# input check range
	blt $v0,-9999,wrongInput
	bgt $v0,9999,wrongInput

	#Input is ok:
	move $t0,$v0    	# backup the input number in $t0. 
	move $s0,$v0    	# backup the input number in $s0.  save for later
	li $t1, 0    		# initiate $t1. use for building the inverted number
	li $t3, 0    		# initiate $t3 counter. 
	
		
breakLine1:			 # line down
	li $v0, 11      	 # define syscall to print character
	lb $a0, linedown   	 # define what will be printed in the syscall
	syscall   		 # print line down
	
	
loopInvert: 
	andi $t2,$t0,1  	# sample lsd (rightmost digit Of t0 into t2)
	add  $t1,$t1,$t2 	# add 1 or 0 to lsd of opposite value
	addi $t3,$t3,1		# t3++
	blt $t3,16, shifts	# if not at the end of number, do the shifts
	beq $t3,16, breakLine2	# jump to do another iteration
shifts:
	srl $t0, $t0,1		# shift 1 step right
	sll $t1, $t1,1		# shift 1 step left
	blt $t3,16, loopInvert	# jump to another iteration

################ q3-b: print out the binary representation of input number

breakLine2:			 # line down
	li $v0, 11      	 # define syscall to print character
	lb $a0, linedown   	 # define what will be printed in the syscall
	syscall   		 # print line down

msgPrintStraight:
	li $v0,  4       	 # define syscall to print string
	la $a0, msgStraight    	 # define what will be printed in the syscall
	syscall   		 # print msgStraight

printBinStraight:
	li $t3, 0    		# initiate $t3 counter. 
	
	move $s1,$t1    	# backup the inverted number in $s1.  save for later
	
loopPrintStraight:
	andi $a0,$t1,1  	# get lsd (rightmost digit in t0)	
	li $v0, 1		# define syscall to print integer
	syscall			# print binary digit
	
	srl $t1,$t1,1		# shift 1 step right
	addi $t3,$t3,1		# t3++
	blt $t3,16, loopPrintStraight	# jump to another iteration

################ q3-c: print out the inverted binary representation of input number
		
msgPrintInverted:
	li $v0,  4       	 	# define syscall to print string
	la $a0, msgInverted    	 	# define what will be printed in the syscall
	syscall   		 	# print msgStraight

	move $t1,$s0    		# initiate $t1 with copy of input number	
	li $t3, 0    			# initiate $t3 counter.
loopPrintInverted:
	andi $a0,$t1,1  		# get lsd (rightmost digit in t0)	
	li $v0, 1			# define syscall to print integer
	syscall				# print binary digit
	
	srl $t1,$t1,1			# shift 1 step right
	addi $t3,$t3,1			# t3++
	blt $t3,16, loopPrintInverted	# jump to another iteration
	
################ q3-d:  print out the decimal value of the inverted input number	

msgPrintDecimal:
	li $v0,  4       	 # define syscall to print string
	la $a0, msgDecimal    	 # define what will be printed in the syscall
	syscall   		 # print msgDecimal

loadHalfWord:
	andi $t0, $s1,0x8000     	# sample the leftmost 16th bit of the inverted number (check for sign)
	bne  $t0, 0, negative  		# check if sign is 0(+) or 1(-) 
	j printInteger			# if positive
	
negative: 
	lui $s0, 0Xffff		# create a sign mask
	or $s1,$s1,$s0     	# add the sign bits to the inverted number
	
printInteger:	
	move $a0,$s1    	# load a0 with output 
	li $v0, 1		# define syscall to print integer
	syscall			# print binary digit


exit:  
	li $v0, 10   #exit program
	syscall
