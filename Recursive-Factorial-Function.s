@Filename:Boswell5.s
@Author:  Tanner Boswell
@Email:   tcb0021@uah.edu
@Class:   CS413-02 
@Term: 	  Fall 2021
@Date:    11-7-2021
@Purpose: 
@	  
@	This program calculates the Factorial numbers for a user's integer input by using recursion. 
@	It acts as practice for students in CS 413-02 when it comes to using the stack to pass and return 
@	parameters to a recursive function in ARM. 
@
@Use these commands to assemble, link, run and debug this program:
@	as -o Boswell5.o Boswell5.s
@	gcc -o Boswell5 Boswell5.o
@	./Boswell5
@	gdb --args ./Boswell5
@
@************************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a 
@ label declared in the .data section
@************************************************************************
@
@ If you get an error and it does not call out a line 
@ number, check the current default directory.

.equ READERROR, 0 @Used to check for scnaf read error.

.global main @Have to use main because of C library uses.

main:

@*****************
welcome_prompt:
@*****************

@ This section prints a welcome menu as well as a prompt for the user to enter any positve integer. It, then, 
@ checks for errors or invalid inputs. If there wasn't any errors with the given input, it pushes r6, the register
@ acting as (n), r7, the register acting as the counter, and r8, the register acting as the total, onto the stack. 
@ It calls the factorial subroutine and then branchees back to restart. 

	ldr r0, = welcomePrompt		@ Puts the address of the string that welcomes the user in r0 
	bl printf			@ and prints it. 

user_input: 

	ldr r0, = inputPrompt 		@ Puts the address of the string that prompts the user for an input
	bl printf 			@ in r0 and prints it. 
	
	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = input 		@ Load r1 with the address of where the input value will be stored.

	bl scanf 			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error. 
	beq read_error			@ If there was a read error, it branches to read_error.
	ldr r1, = input			@ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]			@ Read the contents of input and store in r1 so that it can be compared.

	cmp r1, #0
	blt read_error

	mov r6, r1			@ Move the value of r1 into r6.
	mov r7, r1			@ Move the value of r1 into r7.
	mov r8, #1			@ Move the value of the literal, 1, into r8.
	

	ldr r1, = stack			@ Puts the address of the stack in r1. 
	mov fp, #123			@ Gives frame pointer a dummy value as a point of reference.
	push {r6}			@ Push r6 on the stack. (n)
	push {r7}			@ Push r7 on the stack. (counter)
	push {r8}			@ Push r8 on the stack. (total)
				
	bl factorial_subroutine		@ Branch Link factorial_subroutine. 

	b restart			@ Branch to restart.

@**************
restart:
@**************

@ This section reads in the input from the user and directs if the program continues or does not. 

	mov r8, #0		@ r8 is used as a boolean statement to depict user input. 

	ldr r0, = restartMessage@ Put the address of the restart message in r0 
	bl printf		@ and prints it. 

	ldr r0, = restartInput	@ Setup to read in one string.
	ldr r1, = input 	@ Load r1 with the address of where the input value will be stored.
	
	bl scanf		@ Scan the keyboard. 
	cmp r0, #READERROR	@ Check for a read error. 
	beq read_continue_error @ If there was a read error, it branches to read_continue_error. 
	ldr r1, = input		@ Have to reload r1 becasue it gets wiped out. 
	ldr r1, [r1] 		@ Read the contents of input and store it in r1. 

	cmp r1, #'y'		@ Compare the input with the character y.
	moveq r8, #1		@ If the input equals y, move 1 into r8. 

	cmp r1, #'Y'		@ Compare the input with the character Y.
	moveq r8, #1		@ If the input equals Y, move 1 into r8. 

	cmp r1, #'n' 		@ Compare the input with the character n.
	moveq r8, #2 		@ If the input equals n, move 2 into r8. 

	cmp r1, #'N'		@ Compare the input with the character N.
	moveq r8, #2		@ If the input equals N, move 2 into r8. 

	cmp r8, #0		@ Compare the input with the integer 0.
	beq read_continue_error	@ If the input equals 0, then branch to read_continue_error

	cmp r8, #1		@ If r8 equals 1, branch back to reset. 
	beq reset

	cmp r8, #2		@ If r8 equals 2, branch to exit. 
	beq exit 

exit:		 
	mov r7, #0x01		@ End of my code. Force the exit and return control to OS
	svc 0 			@ Make the system call

@********************
factorial_subroutine:
@********************

@ This section is the recursive subroutine that calculates the factorial of any given input. It sets up a 
@ temporary stack, loads in appropriate values such as the total, counter, and n value, and calculates the 
@ appropriate equation. It uses umull to multiply and checks to see if any overflow occured. If overflow 
@ occurs, it branches to notify the user and stops the function.If overflow does not occur, it decrements the 
@ counter, and stores the counter, the new total, and the n value back into the stack. If the counter is equal 
@ to 1, then it branches to print off the results. If the counter does not equal to 1, then it calls the function
@ again for another iteration. 


	mov r9, #0		@ register used for branching with overflow. 
	STMFD sp!, {fp, lr}	@ Push frame-pointer ansd link-register. 
	mov fp, sp		@ Frame pointer at the bottom of the frame.
	sub sp, sp, #12		@ Create the stack frame (one word).

	ldr r2, [fp, #8] 	@ Load the total into r2.
	ldr r1, [fp, #12] 	@ Load the counter into r1.
	ldr r3, [fp, #16] 	@ Load the n value into r3.


	umull r4, r5, r2, r1 	@ Multiply r1 (counter) and r2 (total) and store it in r4.

	cmp r5, #0		@ Compare r5 with 0. 
	movne r9, #1		@ If r5 does not equal 0, move 1 into r9.
	blne overflow 		@ If r5 does not equal 0, branch to overflow.
	
	cmp r9, #1		@ Compare r9 with 1.
	beq complete_function	@ If r9 equals 1, then branch to complete the function. 

	sub r1, r1, #1 		@ Decrement counter.
	str r1, [fp, #-8] 	@ Store the new counter onto the stack. 
	str r4, [fp, #-12] 	@ Store the total onto the stack. 
	str r3, [fp, #-4] 	@ Store the n value onto the stack. 

	ldr r1, [fp, #-8] 	@ Load the counter back into r1.
	cmp r1, #1		@ If r1 is not equal to 1, 
	bne skip_print		@ branch to skip the printing section because more iterations are needeed.
	
	ldr r2, [fp, #-12]	@ Load the total into r2.
	ldr r1, [fp, #-4] 	@ Load the n value into r1.
	push {r2}		@ Push r2 on the stack. 
	push {r1}		@ Push r1 on the stack. 
	bl _printf		@ Branch Link to _printf.
	pop {r2}		@ Pop r2 off the stack. 
	pop {r1}		@ Pop r1 off the stack. 
	b complete_function	@ branch to complete the function. 

skip_print:
	
	str r1, [fp, #-8]	@ Store the counter back onto the stack. 
	
	bl factorial_subroutine	@ Recursively branch link to factorial_subroutine  
	
complete_function:

	add sp, sp, #12		@ Clean up the stack frame. 
	LDMFD sp!, {fp, pc}	@ Restore frame pointer and return. 
	

@*****************
read_error:
@*****************

@ Since an invalid entry was made we now have to clear out the input buffer by 
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

	ldr r0, = errorMessage 	@ Put the address of the error message in r0
	bl printf 		@ and prints it. 

	ldr r0, = strInputPattern 
	ldr r1, = strInputError	@ Put address into r1 for read.
	bl scanf 		@ Scan the keyboard. 

	b welcome_prompt	@ Branch back to user_options. 

@*****************
read_continue_error:
@*****************

@ Since an invalid entry was made we now have to clear out the input buffer by 
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

	ldr r0, = errorRestart	@ Put the address of the error message in r0
	bl printf 		@ and prints it.

	ldr r0, = strInputPattern
	ldr r1, = strInputError	@ Put address into r1 for read.
	bl scanf 		@ Scan the keyboard. 

	b restart		@ Branch back to restart. 

@*********************
nested_functions:
@*********************

@ This section represents the nested functions/subroutines that are called from the other subroutines. These 
@ subroutines are used to clean up the stack, display overflow errors, and print the results. 

_printf:			@ This subroutine is called during the other subroutines to print off the results. 
	push {lr}		@ Push link-register on the stack frame.
	ldr r0, = functionPrint @ Put the address of the area results prompt in r0
	bl printf		@ and prints it. 
	pop {pc} 		@ Pop program counter off the stack frame. 

overflow:			@ This subroutine is called every time there is an overflow error in calculations. 
	
	push {lr}		@ Push link-register on the stack frame. 
	ldr r0, = overflowWarning @ Put the address of the overflow warning message in r0 
	bl printf		@ and prints it. 
	pop {pc}		@ Pop program counter off the stack frame. 

@*********
reset:
@********* 

	ldr r0, =strInputPattern
	ldr r1, = strInputError	@ Put address into r1 for read.
	bl scanf		@ Scan the keyboard. 

	b welcome_prompt

.data				@ Declare the strings and data needed

.balign 4
welcomePrompt: .asciz "\nWELCOME TO THE FACTORIAL CALCULATOR" @ Used to welcome the user.

.balign 4
inputPrompt: .asciz "\nPlease enter any positive integer:" @ Used to prompt the user. 

.balign 4
overflowWarning: .asciz "\nERROR: Overflow Occurred\n" @ Used to notify user. 

.balign 4
functionPrint: .asciz "\n%d! = %d\n" @ Used to print the results.

.balign 4
errorMessage: .asciz "ERROR: Invalid Input!\n" @ Used to notfiy user. 

.balign 4
errorRestart: .asciz "ERROR: Invalid Input (Please enter 'y' for yes and 'n' for no)\n" @ Used to notify user. 

.balign 4
restartMessage: .asciz "\nWould you like to try another calculation? [y/n]\n" @ Used to prompt user. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Integer format for read.

.balign 4
strInputError: .skip 100*4 @ Used to clear the input buffer for invalid input. 

.balign 4
restartInput: .asciz "%s" @ String format for read. 

.balign 4
userInput: .asciz "%d" @ Integer format fpr read.

.balign 4
input: .word 0 @ Integer for input 

.balign 4
stack: .word 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 @ Used for stack functionality. 

@ Let the assembler know these are the C library functions
.global printf
@	r0 - Contains the starting address of the string to be printed.
@	r1 - If the string contains an output parameter (%d, %c, etc.) register
@		r1 must contain the value to be printed.
.global scanf
@	r0 - Contains the address of the input format string used to read the user
@		input value.
@	r1 -Must contain the address where the input value is going to be stored. 

