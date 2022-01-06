@Filename:Boswell.s
@Author:  Tanner Boswell
@Email:   tcb0021@uah.edu
@Class:   CS413-02 
@Term: 	  Fall 2021
@Date:    9/8/2021
@Purpose: A program that utilizes auto-indexing and subroutines to add together two arrays and print them onto the
@	  screen for the user to view. The user is able to choose 1 of 3 options (positives, negatives, or zeros)
@	  of what kind of values from the third array they would like to view. Used as an assignment to target 
@	  the functionality of subroutines and their relation to the stack.	
@
@Use these commands to assemble, link, run and debug this program:
@	as -o Boswell.o Boswell.s
@	gcc -o Boswell Boswell.o
@	./Boswell
@	gdb --args ./Boswell
@
@************************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a 
@ label declared in the .data section
@************************************************************************
@
@ If you get an error and it does not call out a line 
@ number, check the current default directory.

.global main @Have to use main because of C library uses.

main:
		
	ldr r0, = welcomeMessage 	@ Puts the address of the string that introduces the 
	bl printf		 	@ program and prints it
	

	ldr r9, = first_array	 	@ Puts the address of the first array in r9
	ldr r8, = second_array	 	@ Puts the address of the second array in r8
	ldr r7, = third_array	 	@ Puts the address of the third array in r7

	mov r10, #0	         	@ Moves the value zero into r10 as space for the options
				 	@ chosen by the user and counter for functionality

@*************************************
@ Adding Arrays 
@*************************************
@ This section uses post-indexing auto-indexing in a for loop construct to add the first 
@ and second array. The results are stored in the third array for later functionality. 

	mov r3, #10 		 	@ Moves the value ten into r3 as a counter 

check2: 
	cmp r3, #0		 	@ Compares the counter with the value zero
	bne addarray		 	@ If the counter is not equal to zero branch to addarray
	b createdummy		 	@ Addition complete, branch to the next portion of the program 

addarray:

	ldr r5, [r9], #4         	@ Grab a value from the first array using post-index auto-index
	ldr r6, [r8], #4	 	@ Grab a value from the second array using post-index auto-index
	add r4, r5, r6	         	@ Add the previous two values together and store it in r4
	str r4, [r7], #4	 	@ Store the result from r4 into the third array using auto-index
	sub r3, r3, #1		 	@ Increment the counter
	b check2		 	@ Branch back to check2


@*************************************
@ Calling Functions To Print Arrays 
@*************************************
@ This section represents the part of the code that determines which addresses to utilize and calls
@ the print subroutine. This portion prints all three arrays along with overhead titles by using r10, 
@ which acts a counter. 

createdummy:

	mov fp, #123 		 	@ Dummy value to keep track of the frame pointer

directing:
	
	add r10, #1		 	@ Add one to the counter

	cmp r10, #1		 	@ Compare the counter to the value one
	beq printArray1		 	@ If the counter equals one, then branch to printArray1

	cmp r10, #2		 	@ Compare the counter to the value two
	beq printArray2		 	@ If the counter equals two, then branch to printArray2
	
	cmp r10, #3		 	@ Compare the counter to the value three
	beq printArray3		 	@ If the counter equals three, then branch to printArray3
	
	cmp r10, #4		 	@ Compare the counter to the value four
	beq input 		 	@ If the counter equals four, then branch to the input section
	
	

printArray1:

	ldr r0, = firstArrayTitle 	@ Load the address of the string for the title of the first array into r0
	bl printf			@ Branch link print the title
	ldr r1, = first_array		@ Load the address of the first array into r1
	str r1, [sp, #-4]!		@ Store the address of the first array on the stack
	bl printArray			@ Branch link to the printArray subroutine
	b directing			@ Branch back to the directing portion of this section 

printArray2:

	ldr r0, = secondArrayTitle 	@ Load the address of the string for the title of the second array into r0
	bl printf			@ Branch link print the title
	ldr r1, = second_array		@ Load the address of the second array into r1
	str r1, [sp, #-4]!		@ Store the address of the second array on the stack
	bl printArray			@ Branch link to the printArray subroutine 
	b directing			@ Branch back to the directing portion of this section 

printArray3:

	ldr r0, = thirdArrayTitle 	@ Load the address of the string for the title of the third array into r0 
	bl printf			@ Branch link print the title
	ldr r1, = third_array		@ Load the address of the third array into r1
	str r1, [sp, #-4]!		@ Store the address of the third array on the stack
	bl printArray			@ Branch link to the printArray subroutine
	b directing			@ Branch back to the directing portion of this section 

	
@************************************
@ User Input
@************************************
@ In this section,the program reads in the option chosen by the user, prints the appropriate titles,
@ loads in data on the stack to use in the printArray subroutine, and calls the printArray subroutine. 
@ The program compares the option selected, and passes in the correct data with r10, which is used 
@ later on for functionality. 

input:

	ldr r0, = optionGuide		@ Loads the address of the string that presents the options to the user 
	bl printf			@ into r0 and prints it

	LDR r0, = optionSelected	@ Set up to read in one character
	LDR r1, = Charinput		@ Load r1 with the address of where the input value will be stored

	bl scanf 			@ Branch link scanf
	LDR r1, = Charinput		@ Have to reload r1 becasue it gets wiped out
	LDR r1, [r1] 			@ Read the contents of of the input and store it in r1 so it can be read

	cmp r1, #'1'			@ Compare what the user entered in with the value one
	beq callOptionOne		@ If the user entered one, branch to callOptionOne

	cmp r1, #'2'			@ Compare what the user entered in with the value two 
	beq callOptionTwo		@ If the user entered two, branch to callOptionTwo

	cmp r1, #'0'			@ Compare what the user entered in with the value zero
	beq callOptionThree		@ If the user entered zero, branch to callOptionThree

callOptionOne: 

	moveq r10, #11 			@ Move the value 11 into r10 
	ldreq r0, = positivesOnlyTitle 	@ Load the address of the string for the correct title into r0 
	bleq printf 			@ Branch link print title
	ldreq r1, = third_array		@ Load the address of the third array into r1
	streq r10, [sp, #-4]!		@ Store the value r10 onto the stack which is used for option functionality
	streq r1, [sp, #-4]!		@ Store the value of the address for the third array onto the stack 
	bl printArray			@ Branch link the printArray subroutine
	b exit 				@ Branch exit

callOptionTwo:

	moveq r10, #22			@ Move the value 22 into r10
	ldreq r0, = negativesOnlyTitle 	@ Load the address of the string for the correct title into r0 
	bleq printf 			@ Branch link print title 
	ldreq r1, = third_array		@ Load the address of the third array into r1
	streq r10, [sp, #-4]!		@ Store the value r10 onto the stack which is used for option functionality
	streq r1, [sp, #-4]!		@ Store the value of the address for the third array onto the stack 
	bl printArray			@ Branch link the printArray subroutine 
	b exit 				@ Branch exit 

callOptionThree:
	
	moveq r10, #33			@ Move the value 33 into r10 
	ldreq r0, = zerosOnlyTitle	@ Load the address of the string for the correct title into r0 
	bleq printf 			@ Branch link print title 
	ldreq r1, = third_array		@ Load the address of the third array into r1
	streq r10, [sp, #-4]!		@ Store the value r10 onto the stack which is used for option functionality
	streq r1, [sp, #-4]!		@ Store the value of the address for the third array onto the stack
	bl printArray			@ Branch link the printArray subroutine
	b exit				@ Branch exit

exit:				
	mov r7, #0x01			@ End of my code. Force the exit and return control to OS
	svc 0 				@ Make the system call


@************************************
@ PRINT ARRAY SUBROUTINE
@************************************
@ This is the logic for the printArray subroutine, which prints all three intial arrays and then prints off 
@ the (positive, negative, or zero) values of the third array depending on the user input. It uses a for loop 
@ construct, auto-indexing, stack manipulation to print off the correct data. 

printArray: 				@ Create another stack on top of the previous
	
	stmfd sp!, {fp, lr} 		@ Push frame pointer and link register on the stack
	mov fp, sp			@ Move frame pointer at the bottom of the frame
	sub sp, sp, #4			@ Create the stack frame (one word)
	
	mov r4, #0			@ Move the value 0 into r4, r3, and r2 to prevent garabage values
	mov r3, #0
	mov r2, #0

check:
	
	ldr r1, [fp, #8] 		@ Load the address of the current value in r1
	ldr r4, [fp, #12]		@ Load the option data (from r10 earlier in the program) into r4

	cmp r3, #10			@ Compare the value 10 to r3, which acts as a counter
	bne loop			@ If the counter does not equal to 10, then branch to loop 

	add sp, sp, #4			@ Clean up the stack frame
	ldmfd sp!, {fp, pc}		@ Restore frame pointer and return 

loop:
	
	lsl r2, r3, #2			@ Multiply the index by 4 to get the array offset
	add r2, r1, r2			@ Increase the element address and store it in r2
	ldr r1, [r2]			@ Load the element address into new address

	cmp r4, #11			@ Compare the value 11 to r4 
	beq positivesOnly 		@ If r4 is equal to 11, the user chose option one so branch to positivesOnly

	cmp r4, #22			@ Compare the value 22 to r4
	beq negativesOnly		@ If r4 is equal to 22, the user chose option two so branch to negativesOnly

	cmp r4, #33			@ Compare the value 33 to r4
	beq zerosOnly			@ If r4 is equal to 33, the user chose option three so branch to zerosOnly


printValue:				@ This portion does the actual printing 

	push {r4}			@ Push r4 onto the stack for backup
	push {r3}			@ Push r3 onto the stack for backup
	push {r1}			@ Push r1 onto the stack for backup
	push {r2}			@ Push r2 onto the stack for backup
	mov r2, r1 			@ Move array value to r2 for printing
	mov r1, r3			@ Move array index to r1 for printing 
	bl _printf			@ Branch link print 
	pop {r2}			@ Restore r2 by popping it off the stack
	pop {r1}			@ Restore r1 by popping it off the stack
	pop {r3}			@ Restore r3 by popping it off the stack
	pop {r4}			@ Restore r4 by popping it off the stack

nextValue:				@ This portion skips the printing of certain values
	add r3, r3, #1			@ Increment the counter
	b check				@ Branch back to check

positivesOnly:				@ This portion is used to implement option one
	cmp r1, #0 			@ Compare the value zero and r1
	ble nextValue			@ If r1 is less than less than or equal to zero, branch to next value
	b printValue 			@ If not, branch to print value

negativesOnly:				@ This portion is used to implement option two
	cmp r1, #0 			@ Compare the value zero and r1
	bge nextValue			@ If r1 is greater than or equal to zero, branch to next value
	b printValue			@ If not, branch to print value

zerosOnly:				@ This portion is used to implement option three
	cmp r1, #0 			@ Compare the value zero and r1
	bne nextValue			@ If r1 is not equal to zero, branch to next value
	b printValue			@ Else, branch to print value 

_printf:
	push {lr}			@ Store the return address
	ldr r0, = printarray		@ Load the address of the string that holds the values into r0
	bl printf			@ Branch link print value
	pop {pc}			@ Restore the stack pointer and return 



.data					@ Decalare the strings and data needed

.balign 4
first_array: .word 50, 5, 75, -50, 50, 70, 65, 80, 20, 10 @ Initialization of the first array

.balign 4 
second_array: .word -10, -20, -30, -40, -50, -60, -70, -80, -90, -100 @ Initialization of the second array

.balign 4
third_array: .word 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 @ Dedicated space for the third array

.balign 4
welcomeMessage: .asciz "\nHello user! This program has three arrays.\nThe first and second arrays are initialized in our\nprogram and the third is the sum of the two together.\n"
@ Used to introduce the program and welcome the user

.balign 4
optionGuide: .asciz "\nPlease choose an option [number] to recieve values from the third array.\nPostive Numbers [1] --- Negative Numbers [2] --- Zeros Only [0]\n"
@ Used to present the options to the user 

.balign 4
firstArrayTitle: .asciz "\nFIRST ARRAY\n" @ Used as a title for the first array

.balign 4
secondArrayTitle: .asciz "\nSECOND ARRAY\n" @ Used as a title for the second array

.balign 4
thirdArrayTitle: .asciz "\nTHIRD ARRAY\n" @ Used as a title for the third array

.balign 4
positivesOnlyTitle: .asciz "\nPOSITIVES ONLY\n" @ Used as a title for the postives only array

.balign 4
negativesOnlyTitle: .asciz "\nNEGATIVES ONLY\n" @ Used as a title for the negative only array

.balign 4
zerosOnlyTitle: .asciz "\nZEROS ONLY\n" @ Used as a title for the zeros only array 

.balign 4 
printarray: .asciz "array[%d] = %d\n" @ Integer format for read

.balign 4
optionSelected: .asciz "%s" @ String format for read user input

.balign 4
Charinput: .word 0 @ Word space dedicated for user input 

@ Let the assembler know these are the C library functions
.global printf
@	r0 - Contains the starting address of the string to be printed.
@	r1 - If the string contains an output parameter (%d, %c, etc.) register
@		r1 must contain the value to be printed.
.global scanf
@	r0 - Contains the address of the input format string used to read the user
@		input value.
@	r1 -Must contain the address where the input value is going to be stored. 


