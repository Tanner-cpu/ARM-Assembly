@ Filename: boswell_lab5.s
@ Author:   Tanner Boswell
@ Email:    tcb0021@uah.edu
@ Class:    CS309-01 2021
@ Purpose:  A program that represents a functional gas pump with 3 types (Regular, 
@	    Mid-Grade, and Premium) and a limited inventory. Allows the user to 
@	    dispense a certain amount of gas at a time following certain conditionals.
@	    Used as an assignment to target memory management when given complex 
@ 	    instructions.  
@
@ History: 
@    Date:		Purpose of change
@    8-Apr-2021		Initialized the data, created prompts for the users, and 
@			developed input functionality. 
@    9-Apr-2021		Completed arithmetic functions to represent usage of gas pump.
@    10-Apr-2021	Debugged, implemented required conditionals, and added documentation.
@		
@ Use these commands to assemble, link, run and debug this program:
@    as -o boswell_lab5.o boswell_lab5.s
@    gcc -o boswell_lab5 boswell_lab5.o
@    ./boswell_lab5 
@    gdb --args ./boswell_lab5 
@
@ ***********************************************************************
@ SECRET CODE USED TO PRINT CURRENT INVENTORY: 'x'
@ ***********************************************************************
@
@ ***********************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. 
@ ***********************************************************************
@
@ If you get an error and it does not call out a line 
@ number, check the current default directory.

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

@*******************
inventory:
@*******************

@ This section initializes the specific registers that will be used during the program
@ for the inventory level and amount dispensed for each mode of the gas pump. r8 is 
@ used to implement functional options during our program. (More details about r8 later) 

        ldr r8, = gradeoption 		  @ Puts address of the integer (0) in r8.
        ldr r8, [r8] 			  @ Reads the contents of gradeoption and stores it in r8. 

	ldr r9, = regularInventoryLevel   @ Puts the address of the initial Regular inventory (500) in r9. 
   	ldr r9, [r9]			  @ Reads the contents of regularInventoryLevel and stores it in r9.

 	ldr r10, = midgradeInventoryLevel @ Puts the address of the initial Mid-Grade inventory (500) in r10.
   	ldr r10, [r10]    		  @ Reads the contents of midgradeInventoryLevel and stores it in r10.   

	ldr r11, = premiumInventoryLevel  @ Puts the address of the initial Premium inventory (500) in r11.
   	ldr r11, [r11]			  @ Reads the contents of premiumInventoryLevel and stores it in r11. 
         
        ldr r7, = regularAmountDispensed  @ Puts the address of the initial amount of Regular dispensed in r7.
        ldr r7, [r7]			  @ Reads the contents of regularAmountDispensed and stores it in r7.

 	ldr r6, = midgradeAmountDispensed @ Puts the address of the initial amount of Mid-Grade dispensed in r6.
	ldr r6, [r6]	      		  @ Reads the contents of midgradeAmountDispensed and stores it in r6.

	ldr r5, = premiumAmountDispensed  @ Puts the address of the initial amount of Premium dispensed in r5.
	ldr r5, [r5]			  @ Reads the contents of premiumAmountDispensed and stores it in r5.

@*******************
welcome_prompt:
@*******************

@ This section prints a welcome prompt that introduces the program and displays the initial 
@ inventory levels and amount dispensed for each mode in the gas pump. 

	ldr r0, = strWelcomePrompt	  @ Puts the address of the string that welcomes the user in r0
	bl printf			  @ and prints it. 

	mov r1, r9			  @ Moves the inventory data that was previously stored and copies
	mov r2, r10			  @ it into registers 1, 2, and 3.
	mov r3, r11

	ldr r0, = strInventoryPrompt      @ Puts the address of the string that displays the initial inventory 
	bl printf 			  @ placed in registers 1, 2, and 3 and prints it. 

	mov r1, r7			  @ Moves the amount dispensed data that was previously stored and copies
	mov r2, r6			  @ it into registers 1, 2, and 3.
	mov r3, r5

	ldr r0, = strAmountDispensed 	  @ Puts the address of the string that displays the initial amount 
	bl printf			  @ dispensed placed in registers 1, 2, and 3 and prints it. 

@*******************
get_input:
@*******************  
 
@ This section checks to see if there is enough fuel for each mode to continue, prompts the user to select
@ a desired type of gasoline, scans the input to check for invalid inputs, and compares the input with characters 
@ to make decisions by using register 8. Additionally, it checks for input of the secret code and prints 
@ confirmation of the user's chosen gasoline type.    

@ ***********************************************************************
@ In this section, the value of r8 changes depending on the input from
@ the user. If #1 is assigned to r8, the Regular option is chosen. If #2 
@ is assigned to r8, the Mid-Grade option is chosen. If #3 is assigned to 
@ r8, the Premium option is chosen. If #4 is assigned to r8, a calculation 
@ error has occured. Lastly, if #5 is assigned to r8, the secret option is
@ chosen. With lack of space and memory, the changing values of register 8 
@ are used to make decisions throughout the code.
@ ***********************************************************************

check_finalfuel: 

   @ This subsection checks to see if the inventory levels are less than 10. 
   @ If they are all less than 10, branch to the myexit and end the program. 
   @ Else, do not do anything. 

   cmp r9, #10 				  @ Compare regular inventory levels and the literal, 10. 
   cmplt r10, #10			  @ If regular inventory levels are less than 10, check if mid-grade
   cmplt r11, #10 			  @ inventory levels are less than 10. If mid-grade inventory levels 
   blt myexit                             @ are less than 10, check if premium inventory levels are less than 10.
					  @ If premium inventory levels are less than 10, branch to myexit. 


   ldr r0, = strInputGrade   		  @ Puts the address of the string that prompts the user to select
   bl printf				  @ a type of gasoline into register 0 and prints it.

   ldr r0, = charInputGrade 		  @ Setup to read in one character.
   ldr r1, = charInput      		  @ load r1 with the address of where the
                            		  @ input value will be stored. 
   bl  scanf                		  @ scan the keyboard.
   cmp r0, #READERROR       		  @ Check for a read error.
   beq readerrorchar              	  @ If there was a read error, it branches to readerror. 
   ldr r1, = charInput        		  @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             		  @ Read the contents of intInput and store in r1 so that
                            		  @ it can be read. 


   cmp r1, #'r'				  @ Compares the input in r1 to the character, 'r'. 
   moveq r8, #1				  @ If they are equal, copy #1 into r8, which represents the 
					  @ Regular option. 
   cmp r1, #'R'				  @ Compares the input in r1 to the character, 'R'. 			
   moveq r8, #1				  @ If they are equal, copy #1 into r8, which represents the
					  @ Regular option.
   cmp r1, #'m'				  @ Compares the input in r1 to the character, 'm'.
   moveq r8, #2				  @ If they are equal, copy #2 into r8, which represents the
			 		  @ Mid-Grade option.
   cmp r1, #'M'				  @ Compares the input in r1 to the character, 'M'.
   moveq r8, #2				  @ If they are equal, copy #2 into r8, which represents the
					  @ Mid-Grade option.
   cmp r1, #'p'				  @ Compares the input in r1 to the character, 'p'.
   moveq r8, #3				  @ If they are equal, copy #3 into r8, which represents the
					  @ Premium option.
   cmp r1, #'P'				  @ Compares the input in r1 to the character, 'P'.
   moveq r8, #3				  @ If they are equal, copy #3 into r8, which represents the
   					  @ Premium option.
   cmp r1, #'x' 			  @ Compares the input in r1 to the character, 'x'.
   moveq r8, #5				  @ If they are equal, copy #5 into r8, which represents the
					  @ Secret option that prints the current inventory and amount 
					  @ dispensed. 
   cmp r8, #0				  @ If r8 is equal to 0, which means it has not been changed,
   beq readerrorchar			  @ branch to readerrorchar for error detection.

check_secretcode:			  @ This subsection checks to see if r8 has the value of #5,
   cmp r8, #5				  @ which represents the secret option. 
   beq print_inventorycopy		  @ If so, branch over to print_inventorycopy	
   

grade_confirmation:			  @ This subsection checks which option was chosen and prints 		  
   ldr r0, = regularconfirmation	  @ the corresponding confirmation message. Puts the address of
   cmp r8, #1 				  @ the Regular confirmation in r0 and checks to see if option 1 was
   bleq printf				  @ chosen.If so, print out Regular confirmation message. 
   
   ldr r0, = midgradeconfirmation	  @ Puts the address of the Mid-Grade confirmation in r0 and 
   cmp r8, #2				  @ checks to see if option 2 was chosen. 
   bleq printf				  @ If so, print out Mid-Grade confirmation message. 

   ldr r0, = premiumconfirmation	  @ Puts the address of the Premium confirmation in r0 and 
   cmp r8, #3				  @ checks to see if option 3 was chosen.
   bleq printf				  @ If so, print out Premium confirmation message. 

@*******************
get_dollarinput:
@*******************
   
@ This section checks current inventory levels of all 3 types, prompts the user to enter a dollar amount to dispense 
@ between 1 and 50, calls arithemtic functions depending on the chosen option, prints a confirmation message, prints 
@ a low fuel message if necessary, and resets the input buffer to prepare another input. 

check_currentfuel: 

@ This subsection checks the current inventory levels of each type of gasoline to see 
@ if another transaction is possible. 

   cmp r9, #10 				   @ Compares regular inventory levels with the literal, 10. 		
   cmplt r8, #1				   @ If current regular inventory levels are less than 10, check
   beq notenoughfuel			   @ if option 1 was selected through r8. If r8 equals 1, branch 
					   @ to notenoughfuel.
   cmp r10, #10 			   @ Compares Mid-Grade inventory levels with the literal, 10. 
   cmplt r8, #2				   @ If current Mid-Grade inventory levels are less than 10, check
   beq notenoughfuel			   @ if option 2 was selected through r8. If r8 equals 2, branch
					   @ to notenoughfuel.
   cmp r11, #10 			   @ Compares Premium inventory levels with the literal, 10. 
   cmplt r8, #3				   @ If current Premium inventory levels are less than 10, check
   beq notenoughfuel			   @ if option 3 was selected through r8. If r8 equals 3, branch
   					   @ to notenoughfuel.
   

   ldr r0, = strDollarAmount	           @ Puts the address of the string that prompts the user to enter a dollar 
   bl printf 				   @ amount to dispense in r0 and prints it. 

   ldr r0, = numInputAmount 		   @ Setup to read in one number.
   ldr r1, = intInput        	           @ load r1 with the address of where the
                            		   @ input value will be stored. 
   bl  scanf                		   @ scan the keyboard.
   cmp r0, #READERROR       		   @ Check for a read error.
   beq readerrorint            		   @ If there was a read error, it branches to readerror. 
   ldr r1, = intInput       		   @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             		   @ Read the contents of intInput and store in r1 so that
                            		   @ it can be printed. 

   cmp r1, #1	            		   @ Compares the given input with the literal, 1.
   blt readerrorint            		   @ If the given input is less than 1, it calls for an error.
   cmp r1, #50		    		   @ Compares the given input with the literal 50.
   bgt readerrorint			   @ If the given input is greater than 50, it calls for an error.

call_functions: 

   cmp r8, #1				   @ Checks to see if option 1 was chosen by comparing r8 to the
   bleq calculate_regular		   @ literal, 1. If the values equal, it calls the calculate_regular function.
   cmp r8, #2				   @ Checks to see if option 2 was chosen by comparing r8 to the
   bleq calculate_midgrade 		   @ literal, 2. If the values equal, it calls the calculate_midgrade function.
   cmp r8, #3				   @ Checks to see if option 3 was chosen by comparing r8 to the
   bleq calculate_premium	   	   @ literal, 3. If the values equal, it calls the calculate_premium function.

   ldr r0, = confirmation		   @ After calling the function, puts the address of the string that gives 
   cmp r1, #0 				   @ gives confirmation of the most recent transaction in r0. It, then, compares 
   blne printf 				   @ r1 and the literal, 0. (the value of r1 changes to 0 later on if an error has
					   @ has occurred.) If r1 does not equal 0, then print confirmation. 
   ldr r0, = lowfuel			   @ Puts the address of the string that notfies of insufficient fuel in r0. 
   cmp r8, #4				   @ Checks to see if option 4 has been assigned to r8 by comparing it to the 
   bleq printf				   @ literal, 4. If the values are equal, print low fuel message to the screen. 
   b reset			 	   @ branch to reset to clear the input buffer. 

reset:

@ this subsection clears the input buffer for another input by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   mov r8, #0 				   @ Resets the previously chosen option by moving the value of 0 into r8.
   ldr r0, = strInputPattern 
   ldr r1, = strInputError   		   @ Put address into r1 for read.
   bl scanf 				   @ scan the keyboard. 
   
   b get_input				   @ Branches to get_input to restart process. 
   
notenoughfuel: 

   ldr r0, = lowgrade			   @ Puts the address of the string that notfies the user that there is 
   bl printf 				   @ not enough fuel to choose this type of gasoline in r8 and prints it. 
   b reset				   @ Branches to reset to prepare for another input. 

@*******************
calculate_regular:
@*******************

@ This function calculates the transaction for dispensing 
@ regular grade gasoline. 

   ldr r4, = regular			   @ Puts the address of the integer that represents the amount of gasoline
   ldr r4, [r4]				   @ in tenths of gallons for every dollar dispensed in r4 and stores it in r4.
   mul r3, r1, r4			   @ Multiples the input dollar amount with the previous value and stores it in r3.
   sub r2, r9, r3			   @ Subtracts the result from the Regular inventory, and stores it in r2. 
   cmp r2, #0				   @ Compare the final result with 0.
   blt insufficientfuel1		   @ If the result is less than 0, branch to insufficientfuel1. 
   add r7, r7, r1			   @ Else, add dollar input to amount dispensed for Regular gasoline. 
   mov r9, r2				   @ Copy the result from earlier into r9, which represents the current inventory.
   mov r1, r3				   @ Copy the amount dispensed into r1 to print for confirmation. 
   b complete1				   @ Branch to complete1 for branch link back to main function. 

insufficientfuel1:			   @ If the result of the transaction is lower than 0, then prevent the transaction
   mov r1, #0				   @ from happening. Copy the literal, 0, into r1 to prevent confirmation message. 
   mov r8, #4				   @ Copy the literal, 4, into r8, which represents an error and triggers the low fuel  
					   @ message. 
complete1:					
   mov r15, r14  			   @ Branch link back to the main program. 

@*******************
calculate_midgrade:
@*******************

@ This function calculates the transaction for dispensing 
@ Mid-Grade grade gasoline. 

   ldr r4, = midgrade			   @ Puts the address of the integer that represents the amount of gasoline
   ldr r4, [r4]				   @ in tenths of gallons for every dollar dispensed in r4 and stores it in r4. 
   mul r3, r1, r4			   @ Multiples the input dollar amount with the previous value and stores it in r3.
   sub r2, r10, r3			   @ Subtracts the result from the Mid-Grade inventory, and stores it in r2. 
   cmp r2, #0				   @ Compare the final result with 0.
   blt insufficientfuel2 		   @ If the result is less than 0, branch to insufficientfuel2. 
   add r6, r6, r1			   @ Else, add dollar input to amount dispensed for Mid-Grade gasoline.
   mov r10, r2				   @ Copy the result from earlier into r9, which represents the current inventory.
   mov r1, r3				   @ Copy the amount dispensed into r1 to print for confirmation. 
   b complete2				   @ Branch to complete2 for branch link back to main function. 

insufficientfuel2:			   @ If the result of the transaction is lower than 0, then prevent the transaction
   mov r1, #0				   @ from happening. Copy the literal, 0, into r1 to prevent confirmation message.
   mov r8, #4				   @ Copy the literal, 4, into r8, which represents an error and triggers the low fuel  
					   @ message. 
complete2:
   mov r15, r14				   @ Branch link back to the main program. 
   
@*******************
calculate_premium:
@*******************

@ This function calculates the transaction for dispensing 
@ Premium grade gasoline.

  ldr r4, = premium 			   @ Puts the address of the integer that represents the amount of gasoline
  ldr r4, [r4] 				   @ in tenths of gallons for every dollar dispensed in r4 and stores it in r4.
  mul r3, r1, r4 			   @ Multiples the input dollar amount with the previous value and stores it in r3.
  sub r2, r11, r3			   @ Subtracts the result from the Premium inventory, and stores it in r2. 
  cmp r2, #0 				   @ Compare the final result with 0.
  blt insufficientfuel3			   @ If the result is less than 0, branch to insufficientfuel3.
  add r5, r5, r1			   @ Else, add dollar input to amount dispensed for Premium gasoline.
  mov r11, r2				   @ Copy the result from earlier into r9, which represents the current inventory.
  mov r1, r3				   @ Copy the amount dispensed into r1 to print for confirmation. 
  b complete3				   @ Branch to complete3 for branch link back to main function. 

insufficientfuel3:			   @ If the result of the transaction is lower than 0, then prevent the transaction
   mov r1, #0				   @ from happening. Copy the literal, 0, into r1 to prevent confirmation message.
   mov r8, #4				   @ Copy the literal, 4, into r8, which represents an error and triggers the low fuel 
					   @ message.
complete3:
  mov r15, r14 				   @ Branch link back to the main program.

@*******************
print_inventorycopy:
@*******************

@ When the secret code 'x' is entered when selecting grade, this section displays the current  
@ inventory levels and amount dispensed for each mode in the gas pump. 

	mov r1, r9			   @ Moves the current Regular, Mid-Grade, and Premium inventory 
	mov r2, r10			   @ data and copies it into registers 1, 2, and 3.	
	mov r3, r11

	ldr r0, = strInventoryPrompt	   @ Puts the address of the string that displays the current inventory 
	bl printf 			   @ placed in registers 1, 2, and 3 and prints it. 

	mov r1, r7			   @ Moves the current amount dispensed data 
	mov r2, r6			   @ and copies it into registers 1, 2, and 3.
	mov r3, r5

	ldr r0, = strAmountDispensed	   @ Puts the address of the string that displays the current amount    
	bl printf			   @ dispensed placed in registers 1, 2, and 3 and prints it.
    
        b reset				   @ Branch to reset to prepare for another input. 

@***********
readerrorint:
@***********

@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, = errorMessage    		   @ Puts address into r0 and prints an error message to  
   bl printf	            	           @ notify the user.

   ldr r0, = strInputPattern 
   ldr r1, = strInputError   		   @ Put address into r1 for read.
   bl scanf                 	           @ scan the keyboard.
 
@The input buffer should now be clear so get another input.

   b get_dollarinput			   @ Branch to get_dollarinput to prompt the user to enter another amount. 

@***********
readerrorchar:
@***********

@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, = errorMessage    		   @ Puts address into r0 and prints an error message to  
   bl printf	            	           @ notify the user.

   ldr r0, = strInputPattern 
   ldr r1, = strInputError   		   @ Put address into r1 for read.
   bl scanf                 	           @ scan the keyboard.
 
@The input buffer should now be clear so get another input.

   b get_input				   @ Branch to get_input to prompt the user to enter another type of gasoline. 

@*******************
myexit:
@*******************

@ This section prints off final values after each pump's inventory falls 
@ below 10, forces the exit, and returns control back to OS.

   mov r1, r9				   @ Moves the final Regular, Mid-Grade, and Premium inventory 
   mov r2, r10				   @ data and copies it into registers 1, 2, and 3.
   mov r3, r11

   ldr r0, = strInventoryPromptFinal	   @ Puts the address of the string that displays the final inventory 
   bl printf 				   @ placed in registers 1, 2, and 3 and prints it. 

   mov r1, r7				   @ Moves the final amount dispensed data 
   mov r2, r6				   @ and copies it into registers 1, 2, and 3.
   mov r3, r5

   ldr r0, = strAmountDispensed		   @ Puts the address of the string that displays the final amount 
   bl printf				   @ dispensed placed in registers 1, 2, and 3 and prints it.

@ End of my code. Force the exit and return control to OS

   ldr r0, =endOfProgram 		   @ Puts the address of the string that notfies the end of the program
   bl printf				   @ in r0 and prints it. 
   mov r7, #0x01 			   @ SVC call to exit
   svc 0         			   @ Make the system call. 

.data 

@ Declare the strings and data needed 

.balign 4
errorMessage: .asciz "Error: Invalid Input\n" @ Used to notify the user an error has occurred. 

.balign 4
confirmation: .asciz "%d tenths of gallons have been dispensed\n\n" @ Used to give the user confirmation of the transaction.

.balign 4
regularconfirmation: .asciz "You selected Regular\n" @ Used to give the user confirmation of selected grade (Regular).

.balign 4
midgradeconfirmation: .asciz "You selected Mid-Grade\n" @ Used to give the user confirmation of selected grade (Mid-Grade).

.balign 4
premiumconfirmation: .asciz "You selected Premium\n"  @ Used to give the user confirmation of selected grade (Premium).

.balign 4
lowfuel: .asciz "Error: Insufficent fuel. Please select a lower amount.\n" @ Used to notify the user of insufficient fuel.

.balign 4
endOfProgram: .asciz "Pump is currently unavailable: End of program.\n" @ Forces a word boundry to notfiy the end of program.

.balign 4
lowgrade: .asciz "Error: Not enough fuel in stock. Please select another option.\n" @ Used to notfiy the user to select a different type. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 
 
.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input.

.balign 4
strWelcomePrompt: .asciz "\nWelcome to gasoline pump\n" @ Forces a word boundary to welcome the user.

.balign 4
strInventoryPrompt: .asciz "\nCurrent inventory of gasoline (in tenths of gallons) is:\nRegular %d\nMid-Grade %d\nPremium %d\n"
@ Used to display the current inventory levels of gasoline.

.balign 4
strInventoryPromptFinal: .asciz "\nFinal inventory of gasoline (in tenths of gallons) is:\nRegular %d\nMid-Grade %d\nPremium %d\n"
@ Used to display the final inventory levels of gasoline. 

.balign 4
strAmountDispensed: .asciz "\nDollar amount dispensed by grade:\nRegular $%d\nMid-Grade $%d\nPremium $%d\n\n"
@ Used to display the dollar amount dispensed for each type of gasoline. 

.balign 4
strInputGrade: .asciz "Select Grade of gas to dispense (R,M,or P)\n" @ Used to prompt the user to select a grade.

.balign 4
strDollarAmount: .asciz "Enter Dollar amount to dispense (At least 1 and no more than 50)\n"
@ Used to prompt the user to select a dollar amount for the transaction. 

.balign 4
printtotal: .asciz "%d\n" @ Integer format for read

.balign 4
charInputGrade: .asciz "%s"  @ String format for read.

.balign 4
numInputAmount: .asciz "%d"  @ Integer format for read. 

.balign 4
charInput: .word 0 @ Location used to store the user input. 

.balign 4
gradeoption: .word 0 @ Integer used to represent the grade options through the program.

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
regularInventoryLevel: .word 500 @ Initial starting inventory for Regular. 

.balign 4
midgradeInventoryLevel: .word 500 @ Initial starting inventory for Mid-Grade.

.balign 4
premiumInventoryLevel: .word 500 @ Initial starting inventory for Premium. 

.balign 4
regularAmountDispensed: .word 0 @ Initial amount dispensed for Regular.

.balign 4
midgradeAmountDispensed: .word 0 @ Initial amount dispensed for Mid-Grade.

.balign 4
premiumAmountDispensed: .word 0 @ Initial amount dispensed for Premium. 

.balign 4
regular: .word 4 @ Integer used to calculate dispensing for Regular fuel. 

.balign 4
midgrade: .word 3 @ Integer used to calculate dispensing for Mid-Grade fuel. 

.balign 4
premium: .word 2 @ Integer used to calculate dispensing for Premium fuel. 

@ Let the assembler know these are the C library functions.
.global printf
@     r0 - Contains the starting address of the string to be printed.
@     r1 - If the string contains an output parameter (%d, %c, etc.) register
@          r1 must contain the value to be printed. 

.global scanf
@      r0 - Contains the address of the input format string used to read the user
@           input value. 
@      r1 - Must contain the address where the input value is going to be stored.

