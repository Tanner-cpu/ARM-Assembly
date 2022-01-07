@ Filename: boswell_lab4.s
@ Author:   Tanner Boswell
@ Email:    tcb0021@uah.edu
@ Class:    CS309-01 2021
@ Purpose:  Present to the user a chart of factorials up to any given 
@ 	    number between 1 and 12. Use as an assignment to cover basics 
@	    for ARM Assembly. 
@
@ History: 
@    Date:		Purpose of change
@    31-Mar-2021	Fully completed the development of this code by using 
@			the fundamentals of scanf, printf, comparisons, basic 
@			arithemtic, and loop controls. 
@		
@ Use these commands to assemble, link, run and debug this program:
@    as -o boswell_lab4.o boswell_lab4.s
@    gcc -o boswell_lab4 boswell_lab4.o
@    ./boswell_lab4 
@    gdb --args ./boswell_lab4 
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
prompt:
@*******************

@ Explain the purpose of the program to the user and its capabilities.
 
   ldr r0, =strInputPrompt @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt.

@*******************
get_input:
@*******************

@ r0 is set up with the address of input pattern.
@ scanf puts the input value at the address stored in r1. The address for our 
@ declared variable is in the data section - intInput. After the call to scanf 
@ the input is at the address pointed to by r1 which 
@ in this case will be intInput. 

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
			    
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error, it branches to readerror. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   cmp r1, #1	            @ Compares the given input with the literal 1.
   blt readerror            @ If the given input is less than 1, it calls for an error.
   cmp r1, #12		    @ Compares the given input with the literal 12.
   bgt readerror	    @ If the given input is greater than 12, its calls for an error.


@*******************
followup_prompt:
@*******************

@ Give the user more information.

   ldr r0, =confirmationPrompt @ Assigns a confirmation prompt to r0, and prints it. 
   bl printf
   
   ldr r0, = followingPrompt @ Assigns a following prompt with more information to r0, 
   bl printf  		     @ and prints it. 
  

@********************
get_calculation:
@********************

@ Calculate the factorials and print them to the screen for the user. The the upcoming loop 
@ calculuates the starting point's factorial and increments until it is greater than the given 
@ input from the user. It prints as it calculates, and exits the loop once the calculation is 
@ complete.  

   ldr r4, =startingPoint    @ Since printf and scanf changes the values of r0-r3 and r12,
   ldr r4, [r4] 	     @ The following registers are used to keep data needed for the 
 			     @ calculation of the factorials after each iteration of the 
   ldr r5, =result	     @ upcoming loop (r4, r5, r6).
   ldr r5, [r5]		     @ StartingPoint is used to keep track of which factorial iteration
			     @ the program is on in comparison to the given input. 
   ldr r6, =calculation      @ result is used to capture each individual factorial result up to 
   ldr r6, [r6] 	     @ up to the desired number. 
			     @ calculation is used for calculating the next factorial with the 
			     @ with the result of the previous factorial. 
			     
   loop:
	ldr r1, =intInput    @ Have to reload r1 because it gets wiped out. 
   	ldr r1, [r1] 	     @ Read the contents of intInput and store in r1 so it can be compared
   	cmp r1, r4	     @ Compare the input given to the starting point (1).
        bge then             @ If the given input is greater than or equal to the starting point,
        else: b myexit 	     @ branch into the then statement; else, branch to myexit. 
	
   then:
        mul r5, r6, r4       @ Multiply the starting point with the result of the last factorial.
			     @ In the first case, it is set to 1. 
        mov r2, r5	     @ Move the result of that calculation to r2 to print. 
	mov r6, r5	     @ Move the result of that calcualtion to r6 for next calculation.
        mov r1, r4	     @ Move the place holder r4 to r1 to print. 

   	ldr r0, =strOutputNum @ Put the address of strOutputNum in the r0 to print the number 
   	bl  printf	      @ and factorial to the screen. 

   	add r4, r4, #1       @ Increment the place holder/counter r4. 
       
   	b loop  	     @ Branch back to the beginning of the loop. 

   b   myexit                @ Leave the code. 

@***********
readerror:
@***********

@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =errorMessage    @ Puts address into r0 and prints an error message to  
   bl printf	            @ notify the user.

   ldr r0, =strInputPattern 
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
 
@The input buffer should now be clear so get another input.

   b myexit

@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS
   
   ldr r0, =endOfProgram 
   bl printf
   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call. 

.data 

@ Declare the strings and data needed 

.balign 4 @ Used to prompt the user of the purpose of this program. 
strInputPrompt: .asciz "This program will print the factorial of the integers\nfrom 1 to a number you enter. Please enter an integer\nnumber from 1 to 12.\n"

.balign 4
errorMessage: .asciz "Error: Invalid Input\n" @ Used to notify the user an error has occurred. 

.balign 4
endOfProgram: .asciz "End of program.\n" @ Forces a word boundry to notfiy the end of program.

.balign 4 @ Used to prompt the user of the following calculations.
followingPrompt: .asciz "Following is the number and the product of the integers\nfrom 1 to n.\nNumber		n!\n"

.balign 4
confirmationPrompt: .asciz "You entered %d \n" @ Used to print confirmation prompt.

.balign 4
numInputPattern: .asciz "%d"  @ Integer format for read. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input.

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
strOutputNum: .asciz "%d 		%d\n" @ Used to print the calculations of each factorial/ 

.balign 4 
startingPoint: .word 1 @ Location used to store place holder of current factorial. 

.balign 4
calculation: .word 1 @ Location used to store data that will be used for calculating factorials.

.balign 4
result: .word 1 @ Location used to store the results of each factorial/ 

@ Let the assembler know these are the C library functions. 

.global printf
@     r0 - Contains the starting address of the string to be printed.
@     r1 - If the string contains an output parameter (%d, %c, etc.) register
@          r1 must contain the value to be printed. 
 
.global scanf
@      r0 - Contains the address of the input format string used to read the user
@           input value. 
@      r1 - Must contain the address where the input value is going to be stored.

