# Title: MMN11q4          
# Author: Ornit Cohen gindi      ID:  043045723      Date: 1/2024
# Description: 
# Input: 3 unique digits between 0-9 as  target. and then multiple guesses of 3 digits
# Output: b for 1 digit guessed in place, and p for a right guess that is not in place.
#   	  game over when there the output is 'bbb'
####################### Data ####################################

# settings: "initialize program counter to global main"
.data
bool: .space 4            # 4 bytes for null termination
guess: .space 4            # 4 bytes for null termination
msgInput1: .asciiz "\n Please enter the first digit between 0-9 \n"
msgInput2: .asciiz "\n Please enter the second digit between 0-9 \n"
msgInput3: .asciiz "\n Please enter the third digit  between 0-9 \n"
msgGuess: .asciiz "\n Please enter your guess of 3 unique digits between 0-9 \n"
msgResult: .asciiz "\n The result of your guess is: \n"
msgEnd: .asciiz "\n That was fun! Bye Bye! \n"
msgPlayAgain: .asciiz "\n You did it! \n **** GAME OVER! **** \n would you like to play again? (y/n) \n"
msgWrong1: .asciiz "\n ********* Digits should be between 0-9! try again! \n\n"
msgWrong2: .asciiz "\n ********* The digits should be unique. try again! \n\n"
msgWrong3: .asciiz "\n ********* I dont understand your answer please answer again! \n"
msgWrong4: .asciiz "\n ********* Your input is out of range, please guess again! \n"
msgWrong5: .asciiz "\n ********* You guessed duplicate digits, please guess again! \n"
linedown: .byte '\n'



####################### Code ####################################
.text
.globl main



wrongChars:	
	li $v0, 4        	  # define syscall to print string
	la $a0, msgWrong1   	  # define what will be printed in the syscall
	syscall   	          # print msgWrong1	
	j main			  # start over
	
wrongEquals:	
	li $v0, 4        	  # define syscall to print string
	la $a0, msgWrong2   	  # define what will be printed in the syscall
	syscall   	          # print msgWrong2	
	j main			  # start over

######################################## MAIN #############################################
main:   

	la $a1, bool		# prepare bool array as parameter
	jal get_number		# jump (and link) to procedure get_number
	
guessStep:
	la $a0, bool		# prepare bool array as parameter
	la $a1, guess		# prepare guess array as parameter
	jal get_guess		# jump (and link) to procedure get_guess
	

breakLine2:			 # plain line down
	li $v0, 11      	 # define syscall to print character
	lb $a0, linedown   	 # define what will be printed in the syscall
	syscall   		 # print line down

checkGuess:
	bne $v1,-1,guessStep	 # go for another guess
	
################################ game Over ###############################

playAgainQ:
	li $v0, 4        	  # define syscall to print string
	la $a0, msgPlayAgain   	  # define msgPlayAgain to be printed in the syscall
	syscall                   # print question
        li $v0, 12        	  # define syscall to print string
	syscall 		  # read answer
	beq $v0,'y',main	  # possible answers
	beq $v0,'Y', main
	beq $v0,'n',exit
	beq $v0,'N', exit
	li $v0,  4      	 # define syscall to print string
	la $a0,  msgWrong3  	 # define msgWrong3 to be printed in syscall
	syscall
	li $v0, 11      	 # define syscall to print character
	lb $a0, linedown   	 # define linedown to printed in the syscall
	syscall   		 # print line down
	j playAgainQ		 # ask again		          
		          
		          
	

exit:  
	li $v0, 4        	  # define syscall to print string
	la $a0, msgEnd   	  # define msgEnd to be printed in the syscall
	syscall                   # print question
	li $v0, 10   #exit program
	syscall



################################ procedure get_number ########################
get_number: # procedure name
	
	move $t0,$a1		 # backuo pointer to byte array

readDig1: 			 # print input message
	li $v0,  4      	 # define syscall to print string
	la $a0, msgInput1   	 # define msgInput1 to be printed in the syscall (bool in a1)
	syscall   		 # print msgInput1

	li $v0,  12      	 # define syscall to print string
	syscall   		 # print msgInput
	move $t7, $v0
	blt $t7,'0',wrongChars	 # validation
	bgt $t7,'9',wrongChars	 # validation
	
readDig2:	
	li $v0,  4      	 # define syscall to print string
	la $a0, msgInput2   	 # define msgInput2 to be printed in the syscall (bool in a1)
	syscall   		 # print msgInput
	
	li $v0,  12      	 # define syscall to print string
	syscall   		 # print msgInput
	move $t8, $v0	
	blt $t8,'0',wrongChars	 # validation
	bgt $t8,'9',wrongChars	 # validation
readDig3:	
	li $v0,  4      	 # define syscall to print string
	la $a0, msgInput3   	 # define msgInput3 ?? be printed in the syscall (bool in a1)
	syscall   		 # print msgInput
	
	li $v0,  12      	 # define syscall to print string
	syscall   		 # print msgInput
	move $t9, $v0
	blt $t9,'0',wrongChars	 # validation
	bgt $t9,'9',wrongChars	 # validation
	
checkUnique:	
	beq $t7, $t8, wrongEquals	#check duplicate digits
	beq $t7, $t9, wrongEquals	#check duplicate digits	 	
	beq $t8, $t9, wrongEquals	#check duplicate digits
	
saveDigit:			#save
	sb $t7, 0($t0)
	sb $t8, 1($t0)
	sb $t9, 2($t0)		
	
jr $ra

################################################################################
################################ procedure get_guess ###########################

get_guess: 			# procedure name

	move $t2,$a0		 # backup bool
	move $t0,$a1		 # backup guess
	
guessNumbers:			 # print input message
	li $v0,  4      	 # define syscall to print string
	la $a0, msgGuess   	 # define msgGuess to be printed in the syscall
	syscall   		 # print msgInput	
	
	
readString:
	li $v0,8		 # for syscall 8 that reads string
	move $a0,$t0		 # refer a0 to  guess
	li $a1,4		 # amount of chars to read including null
	syscall			 # read guess from user
	

	move $t0, $a0		 # so the string goes into guess string

	
	lb $t4, ($t0)		# load digits of current guess
	lb $t5, 1($t0)
	lb $t6, 2($t0)
	
	
validateGuessRange:		#validation of range between '0'-'9'
	blt $t4,'0',printWrongRange
	bgt $t4,'9',printWrongRange
	blt $t5,'0',printWrongRange
	bgt $t5,'9',printWrongRange
	blt $t6,'0',printWrongRange
	bgt $t6,'9',printWrongRange

checkUniqueGuess:			#validation of uniqueness
	beq $t4, $t5, printWrongEquals	# msg if two numbers are equal
	beq $t4, $t6, printWrongEquals	# msg if two numbers are equal	 	
	beq $t5, $t6, printWrongEquals	# msg if two numbers are equal

callCompare:  			#else, prepare calling compare
	move $a0,$t2		 #  bool parameter
	move $a1,$t0		 #  guess parameter
	addi $sp, $sp, -4	 # make room for  ra in stack
	sw $ra,0($sp)		 # push ra to stack
	jal compare		 # call compare procedure	
		
					
returnToMain:
	lw $ra, 0($sp)		 # restore ra from stack
	addi $sp, $sp, -4	 # restore stack pointer								
	jr $ra			 # return to main


printWrongRange:
	li $v0,  4      	 # define syscall to print string
	la $a0, msgWrong4   	 # define msgWrong4 to be printed in the syscall
	syscall   		 # print msgInput		
	j guessNumbers	
	
printWrongEquals:
	li $v0,  4      	 # define syscall to print string
	la $a0, msgWrong5   	 # define msgWrong5 to be printed in the syscall
	syscall   		 # print msgInput		
	j guessNumbers		
	
################################################################################
################################ procedure compare #############################

compare: 
	move $t2,$a0		 # backup bool
	move $t3,$a1		 # backup guess

	lb $t4, 0($t2)		 # arrange registers with set of original digits	
	lb $t5, 1($t2)
	lb $t6, 2($t2)

	lb $t7, 0($t3)		 # arrange registers with set of guessed digits
	lb $t8, 1($t3)
	lb $t9, 2($t3)
	
resultMsg:
	li $v0, 4        	  # define syscall to print string
	la $a0, msgResult   	  # define msgResult to be printed in the syscall
	syscall   	          # print msgResult	
	
results:	
	li $a0,'b'		#prepare 'b' for bool output
	li $v0, 11		# define service of pront charachter
	li $v1, 2		# prepare counter (that should end at -1 in case of bbb)
checkBool1:
	bne $t4, $t7,checkBool2
	addi $v1, $v1, -1	# counts 1 bool
	syscall
checkBool2:
	bne $t5, $t8,checkBool3
	addi $v1, $v1, -1	# counts 2 bools
	syscall
checkBool3:	
	bne $t6, $t9,checkBoolCount
	addi $v1, $v1, -1	# counts 3 bools
	syscall
	
checkBoolCount:			# check counter, if it is -1 then it is 'bbb' and game is over
	bne $v1, -1 , checkPgia1
	j endCompare
	
		
checkPgia1:
	li $a0,'p'		#prepare 'p' for pgia output
	beq $t4, $t8,printP1	#check if there is  a right guess not in place
	bne $t4, $t9,checkPgia2 #check if there is  a right guess not in place
printP1:
	syscall			# print'p' for pgia
checkPgia2:
	beq $t5, $t7,printP2	#check if there is  a right guess not in place
	bne $t5, $t9,checkPgia3 #check if there is  a right guess not in place

printP2:
	syscall			# print'p' for pgia
checkPgia3:	
	beq $t6, $t7,printP3	#check if there is  a right guess not in place
	bne $t6, $t8,endCompare #check if there is  a right guess not in place
printP3:
	syscall			# print'p' for pgia
			
				
					
endCompare:
	jr $ra			# end process
