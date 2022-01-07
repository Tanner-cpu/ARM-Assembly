@Filename:Boswell2.s
@Author:  Tanner Boswell
@Email:   tcb0021@uah.edu
@Class:   CS413-02 
@Term: 	  Fall 2021
@Date:    9-26-2021
@Purpose: 
@	  
@	This program is used to get the student to use the stack to pass parameters to and from 
@	their own defined subroutines/functions in ARM Assembly.   
@	
@Use these commands to assemble, link, run and debug this program:
@	as -o Boswell2.o Boswell2.s
@	gcc -o Boswell2 Boswell2.o
@	./Boswell2
@	gdb --args ./Boswell2
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

@ This section prints the main menu on the screen, which introduces the program and the options available. 
@ It, then, reads in the user input and branches to the appropriate section, depending on the choice of the user. 
@ It also checks for errors in the user input (whether the user entered a string, character, negative integer, or an 
@ integer that is not considered an option). 

	ldr r0, = welcomePrompt		@ Puts the address of the string that welcomes the user in r0 
	bl printf 			@ and prints it.

user_options:				@ Used to redirect the program back to the options available 

	ldr r0, = options		@ Puts the address of the string that presents the options in r0	
	bl printf			@ and prints it. 

	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = input 		@ Load r1 with the address of where the input value will be stored.

	bl scanf 			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error. 
	beq read_error			@ If there was a read error, it branches to read_error.
	ldr r1, = input			@ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]			@ Read the contents of input and store in r1 so that it can be compared.

	cmp r1, #1			@ Compare user input with the integer 1.
	blt read_error			@ If user input is less than 1, branch to read_error.
	beq traingle_dimensions		@ If user input is equal to 1, branch to triangle_dimensions.

	cmp r1, #2			@ Compare user input with the integer 2. 
	beq rectangle_dimensions	@ If user input is equal to 2, branch to rectangle_dimensions. 

	cmp r1, #3			@ Compare user input with the integer 3.
	beq trapezoid_dimensions	@ If user input is equal to 3, branch to trapezoid_dimensions. 

	cmp r1, #4			@ Compare user input with the integer 4.
	beq square_dimensions		@ If the user input is equal to 4, branch to square_dimensions.

	cmp r1, #5			@ Compare user input with the integer 5.
	bgt read_error			@ If the user input is greater than 5, branch to read_error.
	beq exit			@ If the user input is equal to 5, branch to exit to close the program. 
 
@*****************
traingle_dimensions:
@*****************

@ This section executes whenever the user chooses the traingle option (1) on the main menu. It prompts the user
@ to enter in two separate parameters, while checking for read errors (anything that is not a postive integer). 
@ It asks for the dimensions one at a time while reprinting the updated screen to the user. Once the parameters 
@ are gathered, it pushes the values on the stack and calls the triangle_subroutine. After execution of the 
@ subroutine, the program branches to restart. 

	mov r4, #0 			@ r4 is used as counter for error detection. Since the read_dimension_error
					@ section covers all different options, register 4 acts as a point of 
					@ reference of where to branch back to.

triangle_first_dimension: 		@ This section gathers the user input for the first parameter. 

	ldr r0, = triangleParameters	@ Puts the address of the string that prompts the user in r0 
	bl printf			@ and prints it. 

	ldr r0, = userInput		@ Setup to read in one number. 
	ldr r1, = firstDimension	@ Load r1 with the address of where the input value will be stored.

	bl scanf 			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = firstDimension	@ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]			@ Read the contents of firstDimension and store in r1 so that it can be reprinted.

	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.

	mov r4, #1			@ Increase counter 

triangle_second_dimension:		@ This section gatheers the user input for the second parameter.
	
	ldr r0, = triangleParametersUpdate @ Puts the address of the updated prompt in r0
	bl printf			@ and prints it. 
	
	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = secondDimension	@ Load r1 with the address of where the input value will be stored.
 
	bl scanf			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = secondDimension	@ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1] 			@ Read the contents of secondDimension and store in r1 so that it can be compared.
	
	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.
	
	mov r2, r1			@ Move the second paramater value in r2.
	ldr r1, = firstDimension	@ Put the address of the firstDimension in r1.
	ldr r1, [r1]			@ Read the contents of firstDimension and store in r1 so that can be reprinted.

	ldr r0, = triangleParametersFinal @ Put the address of the final prompt in r0 
	bl printf 			@ and prints it. 

call_triangle_subroutine:		@ This section pushes the entered parameters on the stack and calls the subroutine. 
	

	ldr r7, = firstDimension 	@ Puts the address of the firstDimension in r7.
	ldr r7, [r7] 			@ Read the contents of the firstDimension in r7. 

	ldr r8, = secondDimension 	@ Puts the address of the secondDimension in r8.
	ldr r8, [r8] 			@ Read the contents of the secondDimension in r8.
	
	ldr r1, = stack			@ Puts the address of the stack in r1. 
	mov fp, #123			@ Gives frame pointer a dummy value as a point of reference. 
	push {r7}			@ Push r7 on the stack.
	push {r8}			@ Push r8 on the stack. 
	bl triangle_subroutine		@ Branch Link triangle_subroutine.

	b restart			@ Branch to restart. 

@*****************
rectangle_dimensions:
@*****************

@ This section executes whenever the user chooses the rectangle option (2) on the main menu. It prompts the user
@ to enter in two separate parameters, while checking for read errors (anything that is not a postive integer). 
@ It asks for the dimensions one at a time while reprinting the updated screen to the user. Once the parameters 
@ are gathered, it pushes the values on the stack and calls the rectangle_subroutine. After execution of the 
@ subroutine, the program branches to restart. 

	mov r4, #2			@ Moves the integer 2 to the counter. 

rectangle_first_dimension:		@ This section gathers the user input for the first parameter. 

	ldr r0, = rectangleParameters	@ Puts the address of the string that prompts the user in r0 
	bl printf 			@ and prints it. 

	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = firstDimension	@ Load r1 with the address of where the input value will be stored.

	bl scanf 			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = firstDimension	@ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]			@ Read the contents of secondDimension and store in r1 so that it can be compared.

	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.

	mov r4, #3			@ Moves the integer 3 to the counter. 

rectangle_second_dimension:		@ This section gathers the user input for the second parameter. 
	
	ldr r0, = rectangleParametersUpdate @ Puts the address of the updated prompt in r0 
	bl printf			@ and prints it. 
	
	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = secondDimension	@ Load r1 with the address of where the input value will be stored.

	bl scanf			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = secondDimension	@ Have to reload r1 because it gets wiped out.
	ldr r1, [r1] 			@ Read the contents of secondDimension and store in r1 so that it can be compared.
	
	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.

	mov r2, r1			@ Move the second paramater value in r2.
	ldr r1, = firstDimension	@ Put the address of the firstDimension in r1.
	ldr r1, [r1]			@ Read the contents of firstDimension and store in r1 so that can be reprinted.

	ldr r0, = rectangleParametersFinal @ Put the address of the final prompt in r0 
	bl printf 			@ and prints it. 

call_rectangle_subroutine:		@ This section pushes the entered parameters on the stack and calls the subroutine.
	

	ldr r7, = firstDimension 	@ Puts the address of the firstDimension in r7.
	ldr r7, [r7] 			@ Read the contents of the firstDimension in r7. 

	ldr r8, = secondDimension 	@ Puts the address of the secondDimension in r8.
	ldr r8, [r8] 			@ Puts the address of the secondDimension in r8.
	
	ldr r1, = stack			@ Puts the address of the stack in r1.
	mov fp, #123			@ Gives frame pointer a dummy value as a point of reference. 
	push {r7}			@ Push r7 on the stack.
	push {r8}			@ Push r8 on the stack.
	bl rectangle_subroutine		@ Branch Link triangle_subroutine.

	b restart			@ Branch to restart. 

@*****************
trapezoid_dimensions:
@*****************

@ This section executes whenever the user chooses the trapezoid option (3) on the main menu. It prompts the user
@ to enter in three separate parameters, while checking for read errors (anything that is not a postive integer). 
@ It asks for the dimensions one at a time while reprinting the updated screen to the user. Once the parameters 
@ are gathered, it pushes the values on the stack and calls the rectangle_subroutine. After execution of the 
@ subroutine, the program branches to restart. 

	mov r4, #4			@ Moves the integer 4 to the counter. 

trapezoid_first_dimension:		@ This section gathers the user input for the first parameter. 
	
	ldr r0, = trapezoidParameters	@ Puts the address of the string that prompts the user in r0 
	bl printf 			@ and prints it.

	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = firstDimension	@ Load r1 with the address of where the input value will be stored.


	bl scanf 			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = firstDimension	@ Have to reload r1 because it gets wiped out.
	ldr r1, [r1]			@ Read the contents of firstDimension and store in r1 so that it can be compared.

	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.

	mov r4, #5			@ Moves the integer 5 to the counter. 

trapezoid_second_dimension:		@ This section gathers the user input for the second parameter. 

	ldr r0, = trapezoidParametersUpdate  @ Puts the address of the updated prompt in r0 
	bl printf			@ and prints it. 

	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = secondDimension	@ Load r1 with the address of where the input value will be stored.

	bl scanf			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = secondDimension	@ Have to reload r1 because it gets wiped out.
	ldr r1, [r1] 			@ Read the contents of secondDimension and store in r1 so that it can be compared.

	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.

	mov r4, #6			@ Moves the integer 6 to the counter. 

	mov r2, r1			@ Move the second paramater value in r2.
	ldr r1, = firstDimension	@ Put the address of the firstDimension in r1.
	ldr r1, [r1]			@ Read the contents of firstDimension and store in r1 so that can be reprinted.

trapezoid_third_dimension:		@ This section gathers the user input for the third parameter. 

	ldr r0, = trapezoidParametersSecondUpdate @ Puts the address of the updated prompt in r0 
	bl printf 			@ and prints it.

	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = thirdDimension	@ Load r1 with the address of where the input value will be stored.

	bl scanf			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = thirdDimension	@ Have to reload r1 because it gets wiped out.	
	ldr r1, [r1] 			@ Read the contents of thirdDimension and store in r1 so that it can be compared.

	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.

	mov r3, r1			@ Move the third parameter in r3.
	ldr r1, = firstDimension	@ Put the address of the firstDimension in r1.
	ldr r1, [r1] 			@ Read the contents of firstDimension and store in r1 so that can be reprinted.
	ldr r2, = secondDimension	@ Put the address of the secondDimension in r2.
	ldr r2, [r2] 			@ Read the contents of secondDimension and store in r2 so that can be reprinted.

	ldr r0, = trapezoidParametersFinal @ Puts the address of the final prompt in r0 
	bl printf 			@ and prints it. 

call_trapezoid_subroutine:		@ This section pushes the entered parameters on the stack and calls the subroutine.
	

	ldr r7, = firstDimension 	@ Puts the address of the firstDimension in r7.
	ldr r7, [r7] 			@ Read the contents of the firstDimension in r7. 

	ldr r8, = secondDimension 	@ Puts the address of the secondDimension in r8.
	ldr r8, [r8] 			@ Read the contents of the secondDimension in r8.
	
	ldr r9, = thirdDimension	@ Puts the address of the thirdDimension in r9.
	ldr r9, [r9] 			@ Read the contents of the thirdDimension in r9.
	
	ldr r1, = stack			@ Puts the address of the stack in r1. 
	mov fp, #123			@ Gives frame pointer a dummy value as a point of reference.
	push {r7}			@ Push r7 on the stack.
	push {r8}			@ Push r8 on the stack.
	push {r9}			@ Push r9 on the stack.
	bl trapezoid_subroutine		@ Branch Link trapezoid_subroutine. 

	b restart			@ Branch to restart. 

@*****************
square_dimensions:
@*****************

@ This section executes whenever the user chooses the square option (4) on the main menu. It prompts the user
@ to enter in one parameter, while checking for read errors (anything that is not a postive integer). 
@ It asks for the dimensions one at a time while reprinting the updated screen to the user. Once the parameters 
@ are gathered, it pushes the values on the stack and calls the rectangle_subroutine. After execution of the 
@ subroutine, the program branches to restart. 

	mov r4, #7			@ Moves the integer 7 to the counter.
	
square_dimension:			@ This section gathers the user input for the parameter. 

	ldr r0, = squareParameters	@ Puts the address of the string that prompts the user in r0 
	bl printf 			@ and prints it. 

	ldr r0, = userInput		@ Setup to read in one number.
	ldr r1, = firstDimension	@ Load r1 with the address of where the input value will be stored.

	bl scanf 			@ Scan the keyboard.
	cmp r0, #READERROR		@ Check for a read error.
	beq read_dimension_error	@ If there was a read error, it branches to read_dimension_error.
	ldr r1, = firstDimension	@ Have to reload r1 because it gets wiped out.	
	ldr r1, [r1]			@ Read the contents of firstDimension and store in r1 so that it can be compared.	

	cmp r1, #1			@ Compare parameter to the integer 1.
	blt read_dimension_error	@ If the user input is less than 1, branch to read_dimension_error.
	
	ldr r0, = squareParametersFinal	@ Puts the address of the final prompt in r0 
	bl printf			@ and prints it. 

call_square_subroutine:			@ This section pushes the entered parameter on the stack and calls the subroutine.	
	

	ldr r7, = firstDimension 	@ Puts the address of the firstDimension in r7.
	ldr r7, [r7] 			@ Read the contents of the firstDimension in r7. 
	
	ldr r1, = stack			@ Puts the address of the stack in r1. 
	mov fp, #123			@ Gives frame pointer a dummy value as a point of reference.
	push {r7}			@ Push r7 on the stack.
	bl square_subroutine		@ Branch Link square_subroutine. 

	b restart			@ Branch to restart.

@********************
triangle_subroutine:
@********************

@ This section is the traingle subroutine. It sets up a temporary stack, calculates the average with the given 
@ parameters, and branch links into another subroutine that prints out the results. It also checks for overflow 
@ during calculations to notfiy the user in neccessary.
	
	mov r9, #0 		@ This register is used as a boolean statment for error detection. 
	STMFD sp!, {fp, lr}	@ Push frame-pointer ansd link-register. 
	mov fp, sp		@ Frame pointer at the bottom of the frame. 
	sub sp, sp, #4		@ Create the stack frame (one word).
	ldr r1, [fp, #12]	@ Get first pushed parameter.
	ldr r2, [fp, #8]	@ Get second pushed parameter. 
	
	umull r3, r4, r1, r2	@ Multiply the two parameters. 
	mov r3, r3, LSR #1	@ Divide the result by two. 
	
	cmp r4, #0 		@ Compare r4 with 0. 
	movne r9, #1 		@ If r4 does not equal 0, then move the integer 1 into r9.
	blne overflow		@ If r4 does not equal 0, branch to overflow. 

	str r3, [fp, #-4]	@ Store the result in the stack frame. 
	ldr r1, [fp, #-4]	@ Load the result back into r1. 
	
	cmp r9, #1		@ Compare r9 with 1.
	beq complete		@ If r9 equals 1, skip over the print portion and complete the subroutine. 

	push {r1}		@ Push r1 on the stack. 
	bl _printf		@ Branch Link to _printf.
	pop {r1}		@ Pop r1 off the stack. 
	
	b complete		@ Branch to complete. 

@********************
rectangle_subroutine:
@********************

@ This section is the rectangle subroutine. It sets up a temporary stack, calculates the average with the given 
@ parameters, and branch links into another subroutine that prints out the results. It also checks for overflow 
@ during calculations to notfiy the user in neccessary.

	mov r9, #0 		@ This register is used as a boolean statment for error detection. 
	STMFD sp!, {fp, lr}	@ Push frame-pointer ansd link-register. 
	mov fp, sp		@ Frame pointer at the bottom of the frame. 
	sub sp, sp, #4		@ Create the stack frame (one word).
	ldr r1, [fp, #12]	@ Get first pushed parameter.
	ldr r2, [fp, #8]	@ Get second pushed parameter.
	
	umull r3, r4, r1, r2	@ Multiply the two parameters. 
	
	cmp r4, #0 		@ Compare r4 with 0. 
	movne r9, #1 		@ If r4 does not equal 0, then move the integer 1 into r9.
	blne overflow		@ If r4 does not equal 0, branch to overflow. 

	str r3, [fp, #-4]	@ Store the result in the stack frame. 
	ldr r1, [fp, #-4]	@ Load the result back into r1. 
	
	cmp r9, #1		@ Compare r9 with 1.
	beq complete		@ If r9 equals 1, skip over the print portion and complete the subroutine. 

	push {r1}		@ Push r1 on the stack. 
	bl _printf		@ Branch Link to _printf.
	pop {r1}		@ Pop r1 off the stack. 
	
	b complete		@ Branch to complete. 

@*******************
trapezoid_subroutine:
@*******************

@ This section is the trapezoid subroutine. It sets up a temporary stack, calculates the average with the given 
@ parameters, and branch links into another subroutine that prints out the results. It also checks for overflow 
@ during calculations to notfiy the user in neccessary.

	mov r9, #0 		@ This register is used as a boolean statment for error detection. 
	STMFD sp!, {fp, lr}	@ Push frame-pointer ansd link-register. 
	mov fp, sp		@ Frame pointer at the bottom of the frame. 
	sub sp, sp, #4		@ Create the stack frame (one word).
	ldr r1, [fp, #16]	@ Get first pushed parameter.
	ldr r2, [fp, #12]	@ Get second pushed parameter.
	ldr r3, [fp, #8] 	@ Get third pushed parameter. 

	add r4, r1, r2		@ Add the first and second parameter. 
	mov r4, r4, LSR #1	@ Divide the result by 2.
	umull r5, r6, r4, r3	@ Multiply the result by the third parameter. 
	
	cmp r6, #0		@ Compare r4 with 0. 
	movne r9, #1		@ If r4 does not equal 0, then move the integer 1 into r9.
	blne overflow		@ If r4 does not equal 0, branch to overflow.

	str r5, [fp, #-4] 	@ Store the result in the stack frame. 
	ldr r1, [fp, #-4] 	@ Load the result back into r1. 
	
	cmp r9, #1		@ Compare r9 with 1.
	beq complete 		@ If r9 equals 1, skip over the print portion and complete the subroutine. 

	push {r1}		@ Push r1 on the stack. 
	bl _printf		@ Branch Link to _printf.
	pop {r1} 		@ Pop r1 off the stack. 
	
	b complete 		@ Branch to complete. 

@********************
square_subroutine:
@********************

@ This section is the square subroutine. It sets up a temporary stack, calculates the average with the given 
@ parameter, and branch links into another subroutine that prints out the results. It also checks for overflow 
@ during calculations to notfiy the user in neccessary.

	mov r9, #0 		@ This register is used as a boolean statment for error detection. 
	STMFD sp!, {fp, lr}	@ Push frame-pointer ansd link-register. 
	mov fp, sp		@ Frame pointer at the bottom of the frame.
	sub sp, sp, #4		@ Create the stack frame (one word).
	ldr r1, [fp, #8]	@ Get the pushed parameter.

	umull r3, r4, r1, r1	@ Multiply the parameter with itself. 
	
	cmp r4, #0		@ Compare r4 with 0. 
	movne r9, #1		@ If r4 does not equal 0, then move the integer 1 into r9.
	blne overflow 		@ If r4 does not equal 0, branch to overflow.

	str r3, [fp, #-4]	@ Store the result in the stack frame. 
	ldr r1, [fp, #-4] 	@ Load the result back into r1. 
	
	cmp r9, #1		@ Compare r9 with 1.
	beq complete		@ If r9 equals 1, skip over the print portion and complete the subroutine.

	push {r1}		@ Push r1 on the stack. 
	bl _printf		@ Branch Link to _printf.
	pop {r1}		@ Pop r1 off the stack.

	b complete		@ Branch to restart 

@*********************
nested_functions:
@*********************

@ This section represents the nested functions/subroutines that are called from the other subroutines. These 
@ subroutines are used to clean up the stack, display overflow errors, and print the results. 

complete:			@ This section is called to clean up the stack within a subroutine and return.

	str r1, [fp, #-4]	@ Store the result in the stack frame.
	add sp, sp, #4		@ Clean up the stack frame. 
	LDMFD sp!, {fp, pc}	@ Restore frame pointer and return. 

overflow:			@ This subroutine is called every time there is an overflow error in calculations. 
	
	push {lr}		@ Push link-register on the stack frame. 
	ldr r0, = overflowWarning @ Put the address of the overflow warning message in r0 
	bl printf		@ and prints it. 
	pop {pc}		@ Pop program counter off the stack frame. 

_printf:			@ This subroutine is called during the other subroutines to print off the results. 
	push {lr}		@ Push link-register on the stack frame.
	ldr r0, = areaResults 	@ Put the address of the area results prompt in r0
	bl printf		@ and prints it. 
	pop {pc} 		@ Pop program counter off the stack frame. 

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

	b user_options		@ Branch back to user_options .

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

@*****************
read_dimension_error:
@*****************

@ Since an invalid entry was made we now have to clear out the input buffer by 
@ reading with this format %[^\n] which will read the biffer until the user 
@ presses the CR. 

	ldr r0, = dimensionMessage 	@ Put the address of the error message in r0
	bl printf 			@ and prints it.

	ldr r0, = strInputPattern
	ldr r1, = strInputError		@ Put address into r1 for read.
	bl scanf 			@ Scan the keyboard. 

@ r4, being a point of refernence lets the program know where to branch back to. 

	cmp r4, #0 			@ Compare r4 with 0. 
	beq triangle_first_dimension 	@ If r4 equals 0, branch back to triangle_first_dimension.

	cmp r4, #1			@ Compare r4 with 1.
	ldreq r1, = firstDimension 	@ If r4 equals 1, load the address of the firstDimension in r1.
	ldreq r1, [r1] 			@ Read the contents of firstDimension and store in r1 so that can be reprinted.
	beq triangle_second_dimension	@ Branch to traingle_second_dimension

	cmp r4, #2			@ Compare r4 with 2. 
	beq rectangle_first_dimension	@ If r4 equals 0, branch back to rectangle_first_dimension.

	cmp r4, #3			@ Compare r4 with 3.
	ldreq r1, = firstDimension	@ If r4 equals 1, load the address of the firstDimension in r1.
	ldreq r1, [r1]			@ Read the contents of firstDimension and store in r1 so that can be reprinted.
	beq rectangle_second_dimension	@ Branch to rectangle_second_dimension

	cmp r4, #4			@ Compare r4 with 4.
	beq trapezoid_first_dimension	@ If r4 equals 0, branch back to trapezoid_first_dimension.

	cmp r4, #5			@ Compare r4 with 5.
	ldreq r1, = firstDimension	@ If r4 equals 1, load the address of the firstDimension in r1.
	ldreq r1, [r1]			@ Read the contents of firstDimension and store in r1 so that can be reprinted.
	beq trapezoid_second_dimension	@ Branch to trapezoid_second_dimension

	cmp r4, #6			@ Compare r4 with 6.
	ldreq r1, = firstDimension 	@ If r4 equals 1, load the address of the firstDimension in r1.
	ldreq r1, [r1]			@ Read the contents of firstDimension and store in r1 so that can be reprinted.
	ldreq r2, = secondDimension	@ If r4 equals 1, load the address of the secondDimension in r2.
	ldreq r2, [r2] 			@ Read the contents of secondDimension and store in r2 so that can be reprinted.
	beq trapezoid_third_dimension	@ Branch to trapezoid_second_dimension

	cmp r4, #7			@ Compare r4 with 7.
	beq square_dimension		@ If r4 equals 0, branch back to square_dimension.

@**************
restart:
@**************

@ This section reads in the input from the user and directs if the program continues or does not. 

	mov r8, #0		@ r8 is used as a boolean statement to depict user input. 

	ldr r0, = restartMessage @ Put the address of the restart message in r0 
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

@*********
reset:
@*********

	mov r4, #0 @ Reset the counter. 

	ldr r0, =strInputPattern
	ldr r1, = strInputError	@ Put address into r1 for read.
	bl scanf		@ Scan the keyboard. 

	b user_options

exit:		
	ldr r0, = endOfProgram
	bl printf 
	mov r7, #0x01			@ End of my code. Force the exit and return control to OS
	svc 0 				@ Make the system call


.data					@ Declare the strings and data needed

.balign 4
errorMessage: .asciz "ERROR: Invalid Input/Option (Please select options [1-5])\n" @ Used to notfiy user. 

.balign 4
errorRestart: .asciz "ERROR: Invalid Input (Please enter 'y' for yes and 'n' for no)\n" @ Used to notify user. 

.balign 4
dimensionMessage: .asciz "ERROR: Invalid Input (Please enter a postive integer)\n" @ Used to notify user.

.balign 4
strInputPattern: .asciz "%[^\n]" @ Integer format for read.

.balign 4
strInputError: .skip 100*4 @ Used to clear the input buffer for invalid input. 

.balign 4
welcomePrompt: .asciz "\nWelcome to The Areas of Plane Shapes Calculator!" @ Used to welcome user. 

.balign 4
options: .asciz "\nPlease select an area calculation type below by\nentering in the corresponding option number.\nOption (1): Triangle\nOption (2): Rectangle\nOption (3): Trapezoid\nOption (4): Square\nOption (5): Quit Program\n\n" @ Used to prompt user.

.balign 4
rectangleParameters: .asciz "\nENTER RECTANGLE DIMENSIONS (0/2)\nLength of 1st Dimension (Width):\n\n" @ Used to prompt user. 

.balign 4
rectangleParametersUpdate: .asciz "\nENTER RECTANGLE DIMENSIONS (1/2)\nLength of 1st Dimension (Width):%d\nLength of 2nd Dimension (Length):\n\n" @ Used to prompt user. 

.balign 4
rectangleParametersFinal: .asciz "\nENTER RECTANGLE DIMENSIONS (2/2)\nLength of 1st Dimension (Width):%d\nLength of 2nd Dimension (Length):%d\n" @ Used to prompt user. 

.balign 4
triangleParameters: .asciz "\nENTER TRIANGLE DIMENSIONS (0/2)\nLength of 1st Dimension (Sides/Base):\n\n" @ Used to prompt user. 

.balign 4
triangleParametersUpdate: .asciz "\nENTER TRIANGLE DIMENSIONS (1/2)\nLength of 1st Dimension (Sides/Base):%d\nLength of 2nd Dimension (Sides/Base):\n\n" @ Used to prompt user. 

.balign 4
triangleParametersFinal: .asciz "\nENTER TRIANGLE DIMENSIONS (2/2)\nLength of 1st Dimension (Sides/Base):%d\nLength of 2nd Dimension (Sides/Base):%d\n" @ Used to prompt user. 

.balign 4
trapezoidParameters: .asciz "\nENTER TRAPEZOID DIMENSIONS (0/3)\nLength of 1st Dimension [Short Base (a)]:\n\n" @ Used to prompt user. 

.balign 4
trapezoidParametersUpdate: .asciz "\nENTER TRAPEZOID DIMENSIONS (1/3)\nLength of 1st Dimension [Short Base (a)]:%d\nLength of 2nd Dimension [Long Base (b)]:\n\n" @ Used to prompt user. 

.balign 4
trapezoidParametersSecondUpdate: .asciz "\nENTER TRAPEZOID DIMENSIONS (2/3)\nLength of 1st Dimension [Short Base (a)]:%d\nLength of 2nd Dimension [Long Base (b)]:%d\nLength of 3rd Dimension [Height (h)]:\n\n" @ Used to prompt user. 

.balign 4
trapezoidParametersFinal: .asciz "\nENTER TRAPEZOID DIMENSIONS (3/3)\nLength of 1st Dimension [Short Base (a)]:%d\nLength of 2nd Dimension [Long Base (b)]:%d\nLength of 3rd Dimension [Height (h)]:%d\n" @ Used to prompt user. 

.balign 4
squareParameters: .asciz "\nENTER SQUARE DIMENSIONS (0/1)\nLength of Dimensions (Width/Height):\n\n" @ Used to prompt user. 

.balign 4
squareParametersFinal: .asciz "\nENTER SQUARE DIMENSIONS (1/1)\nLength of Dimensions (Width/Height):%d\n" @ Used to prompt user. 

.balign 4
areaResults: .asciz "\nAREA RESULTS: %d square units\n" @ Used to print results.

.balign 4
overflowWarning: .asciz "\nERROR: Overflow Occurred\n" @ Used to notify user. 

.balign 4
restartMessage: .asciz "\nWould you like to continue with another calculation? [y/n]\n\n" @ Used to prompt user. 

.balign 4
endOfProgram: .asciz "\nEND OF PROGRAM\n" @ Used to notify user. 

.balign 4
userInput: .asciz "%d" @ Integer format fpr read.

.balign 4
restartInput: .asciz "%s" @ String format for read. 

.balign 4
baseInput: .asciz "%d" @ String format for read. 

.balign 4
input: .word 0 @ Integer for input 

.balign 4
firstDimension: .word 0 @ Integer for parameter.

.balign 4
secondDimension: .word 0 @ Integer for parameter.

.balign 4 
thirdDimension: .word 0 @ Integer for parameter.

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
