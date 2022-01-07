@Filename:Boswell3.s
@Author:  Tanner Boswell
@Email:   tcb0021@uah.edu
@Class:   CS413-02 
@Term: 	  Fall 2021
@Date:    10-10-2021
@Purpose: 
@	  
@	The purpose of this software is to simulate the operation of a vending machine. The machine will dispense, 
@	upon reception of the correct amount of money, a choice of Gum, Peanuts, Cheese Crackers, or M&Ms. This program 
@	is used as practice with ARM and acts as an lab assignment for CS 413-02.
@
@Use these commands to assemble, link, run and debug this program:
@	as -o Boswell3.o Boswell3.s
@	gcc -o Boswell3 Boswell3.o
@	./Boswell3
@	gdb --args ./Boswell3
@
@************************************************************************
@ SECRET CODE USED TO PRINT CURRENT INVENTORY: 'x' or 'X' 
@************************************************************************
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
inventory:
@*****************

@ This section initializes the specific registers that will be used during the program 
@ for the inventory of the vending machine, the change inserted, and the user options. 

	ldr r6, = changeInserted		@ Puts the address of the change inserted in r6 
	ldr r6, [r6] 				@ Reads the contents of changeInserted and stores it in r6

	ldr r7, = userOption 			@ Puts the address of the user option in r7
	ldr r7, [r7] 				@ Reads the contents of userOption and stores it in r7
	
	ldr r8, = gumInventory 			@ Puts the address of the gum inventory in r8
	ldr r8, [r8] 				@ Reads the contents of gumInventory and stores it in r8

	ldr r9, = peanutInventory 		@ Puts the address of the peanut inventory in r9
	ldr r9, [r9] 				@ Reads the contents of peanutInventory and stores it in r9

	ldr r10, = cheesecrackerInventory 	@ Puts the address of the cheese cracker inventory in r10
	ldr r10, [r10] 				@ Reads the contents of cheesecrackerInventory and stores it in r10

	ldr r11, = mmInventory 			@ Puts the address of the M&Ms inventory in r11
	ldr r11, [r11] 				@ Reads the contents of mmInventory and stores it in r11
		
@*****************
welcome_prompt:
@*****************

@ This section prints a welcome prompt and the options available to the screen. It scans the input for invalid inputs,
@ and uses r7 for functionality when it comes to option handling. Also, this section checks to see if the user entered
@ the secret code to print the current inventory. 

	ldr r0, = welcomePrompt		@ Puts the address of the string that welcomes the user in r0 
	bl printf 			@ and prints it.

user_options:

	ldr r0, = options 		@ Puts the address of the string that presents the options to the user in r0
	bl printf 			@ and prints it. 

	ldr r0, = userInput		@ Set up to read in one string
	ldr r1, = input 		@ Load r1 with the address of where the input value will be stored 

	bl scanf 			@ Scan the kayboard
	cmp r0, #READERROR		@ Check for read error 
	beq read_error			@ If there was a read error, it branches to read_error
	ldr r1, = input			@ Have to reload r1 because it gets wiped out 
	ldr r1, [r1] 			@ Read the contents of input and store it in r1 so that it can be compared 

	cmp r1, #'g'			@ If input is equal to 'g', 
	moveq r7, #1			@ move the integer 1 into r7.

	cmp r1, #'G'			@ If input is equal to 'G', 
	moveq r7, #1			@ move the integer 1 into r7.

	cmp r1, #'p' 			@ If input is equal to 'p', 
	moveq r7, #2			@ move the integer 2 into r7.

	cmp r1, #'P'			@ If input is equal to 'P', 
	moveq r7, #2			@ move the integer 2 into r7.

	cmp r1, #'c'			@ If input is equal to 'c', 
	moveq r7, #3			@ move the integer 3 into r7.

	cmp r1, #'C'			@ If input is equal to 'C', 
	moveq r7, #3			@ move the integer 3 into r7.

	cmp r1, #'m'			@ If input is equal to 'm', 
	moveq r7, #4			@ move the integer 4 into r7.

	cmp r1, #'M' 			@ If input is equal to 'M', 
	moveq r7, #4			@ move the integer 4 into r7.
	
	cmp r1, #'x'			@ If input is equal to 'x', 
	moveq r7, #5			@ move the integer 5 into r7.

	cmp r1, #'X'			@ If input is equal to 'X', 
	moveq r7, #5			@ move the integer 5 into r7.

	cmp r7, #5			@ If r7 is equal to 5,
	beq print_inventory_copy	@ branch to print the current inventory. 

	cmp r7, #0 			@ If r7 is still zero, 
	beq read_error			@ then none of the options were chosen so branch to read_error.

@*********************
user_Confirmation:
@*********************

@ This section asks for confirmation of the chosen item, while checking for invalid inputs. After the user has
@ given the program confirmation, it directs the code to the appropriate section to check for current inventory. 
@ If there is still available inventory for the chosen option, it branches to the calculation portion of the program. 
@ If the chosen item is out of stock, it notifys the user and prompts the user to choose another item.  

	mov r5, #0 			@ This register is used for functionality with input errors when asking confirmation

	ldr r0, = gumConfirmation	@ Puts the address of the gum confirmation question in r0
	cmp r7, #1			@ If r7 is equal to 1 (representing the gum option), 
	bleq printf 			@ then it prints the statement. 

	ldr r0, = peanutConfirmation 	@ Puts the address of the peanut confirmation question in r0
	cmp r7, #2			@ If r7 is equal to 2 (representing the peanut option),
	bleq printf 			@ then it prints the statement. 

	ldr r0, = cheesecrackerConfirmation 	@ Puts the address of the cheese cracker confirmation question in r0
	cmp r7, #3				@ If r7 is equal to 3 (representing the cheese cracker option),
	bleq printf				@ then it prints the statement. 

	ldr r0, = mmConfirmation	@ Puts the address of the M&Ms confirmation question in r0
	cmp r7, #4			@ If r7 is equal to 4 (representing the M&Ms option),
	bleq printf 			@ then it prints the statement. 

	ldr r0, = confirmationInput	@ Setup to read in one string	
	ldr r1, = inputConfirmation 	@ Load r1 with the address of where the input value will be stored 

	bl scanf 			@ Scan the kayboard
	cmp r0, #READERROR		@ Check for read error 
	beq read_confirmation_error	@ If there was a read error, it branches to read_confirmation_error
	ldr r1, = inputConfirmation	@ Have to reload r1 because it gets wiped out 
	ldr r1, [r1] 			@ Read the contents of input and store it in r1 so that it can be compared 

	cmp r1, #'y' 			@ If the input is equal to 'y',
	moveq r5, #1			@ move the integer 1 in r5
	

	cmp r1, #'Y'			@ If the input is equal to 'Y',
	moveq r5, #1			@ move the integer 1 in r5
	

	cmp r1, #'n' 			@ If the input is equal to 'n',
	moveq r5, #2			@ move the integer 2 in r5
		
	
	cmp r1, #'N'			@ If the input is equal to 'N',
	moveq r5, #2			@ move the integer 2 in r5
		

	cmp r5, #1			@ If r5 is equal to 1, 
	beq direct			@ branch to the section that will call the calculations

	cmp r5, #2			@ If r5 is equal to 2, 
	beq reset			@ branch to reset since the program did not get confirmation

	cmp r5, #0			@ If r5 is equal to 0, 
	beq read_confirmation_error	@ then none of the options were chosen so branch to read_confirmation_error.

direct: 
	
	cmp r7, #1			@ If r7 is equal to 1, 
	beq gum_inventory		@ branch to check the gum inventory  

	cmp r7, #2			@ If r7 is equal to 2, 
	beq peanut_inventory		@ branch to check the peanut inventory 

	cmp r7, #3			@ If r7 is equal to 3, 	
	beq cheesecrackers_inventory	@ branch to check the cheese crackers inventory 

	cmp r7, #4			@ If r7 is equal to 4, 
	beq mm_inventory		@ branch to check the M&Ms inventory 

gum_inventory:
	
	cmp r8, #0			@ If the gum inventory is equal to 0, 
	ldreq r0, = inventoryMessage 	@ print a message to notfiy the user and
	bleq printf 			@ branch to reset to prompt for antoher option.
	beq reset 

	b gum_calculation		@ If there is still some left in stock, branch to the calculation function

peanut_inventory:

	cmp r9, #0			@ If the peanut inventory is equal to 0, 
	ldreq r0, = inventoryMessage 	@ print a message to notfiy the user and
	bleq printf 			@ branch to reset to prompt for antoher option.
	beq reset 

	b peanut_calculation		@ If there is still some left in stock, branch to the calculation function

cheesecrackers_inventory:
	
	cmp r10, #0			@ If the cheese crackers inventory is equal to 0,
	ldreq r0, = inventoryMessage 	@ print a message to notfiy the user and
	bleq printf 			@ branch to reset to prompt for antoher option.
	beq reset 

	b cheesecrackers_calculation	@ If there is still some left in stock, branch to the calculation function

mm_inventory:

	cmp r11, #0			@ If the M&Ms inventory is equal to 0,
	ldreq r0, = inventoryMessage 	@ print a message to notfiy the user and
	bleq printf 			@ branch to reset to prompt for antoher option.
	beq reset 

	b mm_calculation		@ If there is still some left in stock, branch to the calculation function

@*******************
gum_calculation:
@*******************

@ This section prompts the user to enter the appropriate amount of money, gives options on what coins the user can
@ insert, and checks for errors in user input. It, then, branches to the insert section which calculates each individual 
@ coin inserted. After calculating the total inserted, it compares it to the required amount for the chosen item. If 
@ it less than what is required, it prompts the user to enter more money. If the amount inserted is greater than or 
@ equal to the required amount, it continues with the transaction by notfiying the user, returning any change, 
@ dispensing the item, and decrementing the inventory. 

	ldr r0, = gumRequirements	@ Puts the address of the string that tells the required amount in r0
	bl printf 			@ and prints it. 

	ldr r0, = coinSelection 	@ Puts the address of the string that gives the options of coins in r0 
	bl printf 			@ and prints it. 
	
	ldr r0, = changeChoice		@ Setup to read in a string 
	ldr r1, = inputChange 		@ Load r1 with the address of where the input value will be stored 

	bl scanf 			@ Scan the kayboard
	cmp r0, #READERROR		@ Check for read error 
	beq read_change_error		@ If there was a read error, it branches to read_change_error
	ldr r1, = inputChange		@ Have to reload r1 because it gets wiped out 
	ldr r1, [r1] 			@ Read the contents of inputChange and store it in r1 so that it can be compared 
	
	b insert 			@ Branch to insert to calculate the current total inserted
	
check_gum_amount: 
	
	cmp r6, #50 			@ If the current total inserted is less than 50, 
	movlt r1, r6			@ move the total to r1 and 
	ldrlt r0, = totalInserted 	@ print the total inserted to the screen
	bllt printf 
	 
	cmp r6, #50			@ If the total is greater than or equal to 50, 
	bge complete_gum_transaction	@ branch to complete the transaction 

	b reset_change			@ Branch to reset change so the user may enter more money 

complete_gum_transaction:

	mov r1, r6			@ Move the total to r1
	ldr r0, = totalInserted		@ Print the total inserted to the screen 
	bl printf 
	mov r1, r6			@ Move the total back to r1 since it gets wiped out 
	ldr r0, = enoughNotification 	@ Puts the address of the string to notifying a sufficient amount has been
	bl printf 			@ inserted to r0 and prints it 
	sub r6, r6, #50 		@ Subtract 50 from the total inserted
	mov r1, r6			@ Move the remaining change to r1 to print the message
	ldr r0, = changeReturned	@ that states how much change is returned back to the user. 
	bl printf 
	
	ldr r6, = changeInserted	@ Puts the address of the inital value of change inserted back to r6
	ldr r6, [r6]			@ Reads the contents of changeInserted and stores it in r6

	ldr r0, = gumDispense 		@ Puts the address of the string that notifys the user that the item has been
	bl printf 			@ dispensed in r0 and prints it. 

	sub r8, r8, #1 			@ Subtract one from the total inventory of gum 
	b reset				@ Branch back to reset to start again 

@*********************
peanut_calculation:
@*********************

@ This section prompts the user to enter the appropriate amount of money, gives options on what coins the user can
@ insert, and checks for errors in user input. It, then, branches to the insert section which calculates each individual 
@ coin inserted. After calculating the total inserted, it compares it to the required amount for the chosen item. If 
@ it less than what is required, it prompts the user to enter more money. If the amount inserted is greater than or 
@ equal to the required amount, it continues with the transaction by notfiying the user, returning any change, 
@ dispensing the item, and decrementing the inventory. 

	ldr r0, = peanutRequirements	@ Puts the address of the string that tells the required amount in r0
	bl printf 			@ and prints it.

	ldr r0, = coinSelection 	@ Puts the address of the string that gives the options of coins in r0 
	bl printf 			@ and prints it.
	
	ldr r0, = changeChoice		@ Setup to read in a string 
	ldr r1, = inputChange 		@ Load r1 with the address of where the input value will be stored 

	bl scanf 			@ Scan the kayboard
	cmp r0, #READERROR		@ Check for read error 
	beq read_change_error		@ If there was a read error, it branches to read_change_error
	ldr r1, = inputChange		@ Have to reload r1 because it gets wiped out 
	ldr r1, [r1] 			@ Read the contents of inputChange and store it in r1 so that it can be compared

	b insert 			@ Branch to insert to calculate the current total inserted

check_peanut_amount: 
	
	cmp r6, #55 			@ If the current total inserted is less than 55,
	movlt r1, r6			@ move the total to r1 and
	ldrlt r0, = totalInserted	@ print the total inserted to the screen
	bllt printf 
	 
	cmp r6, #55			@ If the total is greater than or equal to 55,
	bge complete_peanut_transaction	@ branch to complete the transaction 

	b reset_change			@ Branch to reset change so the user may enter more money 

complete_peanut_transaction:

	mov r1, r6			@ Move the total to r1
	ldr r0, = totalInserted		@ Print the total inserted to the screen 
	bl printf 
	mov r1, r6			@ Move the total back to r1 since it gets wiped out 
	ldr r0, = enoughNotification 	@ Puts the address of the string to notifying a sufficient amount has been
	bl printf 			@ inserted to r0 and prints it 
	sub r6, r6, #55 		@ Subtract 55 from the total inserted
	mov r1, r6			@ Move the remaining change to r1 to print the message
	ldr r0, = changeReturned	@ that states how much change is returned back to the user. 
	bl printf 
	
	ldr r6, = changeInserted	@ Puts the address of the inital value of change inserted back to r6
	ldr r6, [r6] 			@ Reads the contents of changeInserted and stores it in r6

	ldr r0, = peanutDispense 	@ Puts the address of the string that notifys the user that the item has been
	bl printf 			@ dispensed in r0 and prints it. 

	sub r9, r9, #1			@ Subtract one from the total inventory of peanuts 
	b reset				@ Branch back to reset to start again

@****************************
cheesecrackers_calculation:
@****************************

@ This section prompts the user to enter the appropriate amount of money, gives options on what coins the user can
@ insert, and checks for errors in user input. It, then, branches to the insert section which calculates each individual 
@ coin inserted. After calculating the total inserted, it compares it to the required amount for the chosen item. If 
@ it less than what is required, it prompts the user to enter more money. If the amount inserted is greater than or 
@ equal to the required amount, it continues with the transaction by notfiying the user, returning any change, 
@ dispensing the item, and decrementing the inventory. 

	ldr r0, = cheesecrackerRequirements	@ Puts the address of the string that tells the required amount in r0
	bl printf 				@ and prints it.

	ldr r0, = coinSelection 	@ Puts the address of the string that gives the options of coins in r0 
	bl printf 			@ and prints it.
	
	ldr r0, = changeChoice		@ Setup to read in a string 
	ldr r1, = inputChange 		@ Load r1 with the address of where the input value will be stored 

	bl scanf 			@ Scan the kayboard
	cmp r0, #READERROR		@ Check for read error 
	beq read_change_error		@ If there was a read error, it branches to read_change_error
	ldr r1, = inputChange		@ Have to reload r1 because it gets wiped out 
	ldr r1, [r1] 			@ Read the contents of inputChange and store it in r1 so that it can be compared

	b insert 			@ Branch to insert to calculate the current total inserted

check_cheesecrackers_amount: 
	
	cmp r6, #65 			@ If the current total inserted is less than 65,
	movlt r1, r6			@ move the total to r1 and
	ldrlt r0, = totalInserted	@ print the total inserted to the screen
	bllt printf 
	 
	cmp r6, #65				@ If the total is greater than or equal to 65,
	bge complete_cheesecrackers_transaction	@ branch to complete the transaction 

	b reset_change			@ Branch to reset change so the user may enter more money 

complete_cheesecrackers_transaction:

	mov r1, r6			@ Move the total to r1
	ldr r0, = totalInserted		@ Print the total inserted to the screen 
	bl printf 
	mov r1, r6			@ Move the total back to r1 since it gets wiped out 
	ldr r0, = enoughNotification 	@ Puts the address of the string to notifying a sufficient amount has been
	bl printf 			@ inserted to r0 and prints it 
	sub r6, r6, #65 		@ Subtract 65 from the total inserted
	mov r1, r6			@ Move the remaining change to r1 to print the message
	ldr r0, = changeReturned	@ that states how much change is returned back to the user.
	bl printf 
	
	ldr r6, = changeInserted	@ Puts the address of the inital value of change inserted back to r6
	ldr r6, [r6] 			@ Reads the contents of changeInserted and stores it in r6

	ldr r0, = cheesecrackersDispense 	@ Puts the address of the string that notifys the user that the item has been
	bl printf 				@ dispensed in r0 and prints it. 

	sub r10, r10, #1		@ Subtract one from the total inventory of cheese crackers
	b reset				@ Branch back to reset to start again

@*******************
mm_calculation: 
@*******************

@ This section prompts the user to enter the appropriate amount of money, gives options on what coins the user can
@ insert, and checks for errors in user input. It, then, branches to the insert section which calculates each individual 
@ coin inserted. After calculating the total inserted, it compares it to the required amount for the chosen item. If 
@ it less than what is required, it prompts the user to enter more money. If the amount inserted is greater than or 
@ equal to the required amount, it continues with the transaction by notfiying the user, returning any change, 
@ dispensing the item, and decrementing the inventory. 


	ldr r0, = mmRequirements	@ Puts the address of the string that tells the required amount in r0
	bl printf 			@ and prints it.

	ldr r0, = coinSelection 	@ Puts the address of the string that gives the options of coins in r0 
	bl printf 			@ and prints it.
	
	ldr r0, = changeChoice		@ Setup to read in a string 
	ldr r1, = inputChange 		@ Load r1 with the address of where the input value will be stored

	bl scanf 			@ Scan the kayboard
	cmp r0, #READERROR		@ Check for read error 
	beq read_change_error		@ If there was a read error, it branches to read_change_error
	ldr r1, = inputChange		@ Have to reload r1 because it gets wiped out
	ldr r1, [r1] 			@ Read the contents of inputChange and store it in r1 so that it can be compared

	b insert 			@ Branch to insert to calculate the current total inserted

check_mm_amount: 
	
	cmp r6, #100 			@ If the current total inserted is less than 100,
	movlt r1, r6			@ move the total to r1 and
	ldrlt r0, = totalInserted	@ print the total inserted to the screen
	bllt printf 
	 
	cmp r6, #100			@ If the total is greater than or equal to 100,
	bge complete_mm_transaction	@ branch to complete the transaction 

	b reset_change			@ Branch to reset change so the user may enter more money 

complete_mm_transaction:

	mov r1, r6			@ Move the total to r1
	ldr r0, = totalInserted		@ Print the total inserted to the screen
	bl printf 
	mov r1, r6			@ Move the total back to r1 since it gets wiped out 
	ldr r0, = enoughNotification 	@ Puts the address of the string to notifying a sufficient amount has been
	bl printf 			@ inserted to r0 and prints it 
	sub r6, r6, #100 		@ Subtract 100 from the total inserted
	mov r1, r6			@ Move the remaining change to r1 to print the message
	ldr r0, = changeReturned	@ that states how much change is returned back to the user.
	bl printf 
	
	ldr r6, = changeInserted	@ Puts the address of the inital value of change inserted back to r6
	ldr r6, [r6] 			@ Reads the contents of changeInserted and stores it in r6

	ldr r0, = mmDispense 		@ Puts the address of the string that notifys the user that the item has been
	bl printf 			@ dispensed in r0 and prints it. 

	sub r11, r11, #1		@ Subtract one from the total inventory of M&Ms
	b reset				@ Branch back to reset to start again

@**************
insert:
@**************
	
@ This section checks the input of the user by comparing it to multiple options that represent a certain coin. 
@ The program then adds the appropriate coin to the total inserted amount, while checking for invalid inputs. 
@ Then, it branches back to the appropriate calculation function, depending on the option chosen. 

	mov r4, #0 			@ r4 is used for functionality with input choice 

	cmp r1, #'d'			@ If input is equal to 'd',
	moveq r4, #1			@ the move the integer 1 in r4

	cmp r1, #'D'			@ If input is equal to 'D',
	moveq r4, #1			@ the move the integer 1 in r4

	cmp r1, #'q'			@ If input is equal to 'q',
	moveq r4, #2			@ the move the integer 2 in r4

	cmp r1, #'Q'			@ If input is equal to 'Q',
	moveq r4, #2			@ the move the integer 2 in r4

	cmp r1, #'b' 			@ If input is equal to 'b',
	moveq r4, #3			@ the move the integer 3 in r4
	
	cmp r1, #'B' 			@ If input is equal to 'B',
	moveq r4, #3			@ the move the integer 3 in r4

	cmp r4, #1			@ If r4 is equal to 1, or a dime was inserted,
	addeq r6, r6, #10 		@ add 10 to the total inserted 

	cmp r4, #2			@ If r4 is equal to 2, or a quarter was inserted, 
	addeq r6, r6, #25		@ add 25 to the total inserted 
	
	cmp r4, #3			@ If r4 is equal to 3, or a dollar was inserted, 
	addeq r6, r6, #100		@ add 100 to the total inserted

	cmp r4, #0			@ If none of the available options were chosen, 
	beq read_change_error		@ branch to read_change_error

	cmp r7, #1			@ If the user option is equal to 1, 
	beq check_gum_amount		@ branch back to finish the gum calculation 
	
	cmp r7, #2			@ If the user option is equal to 2,
	beq check_peanut_amount		@ branch back to finish the peanut calculation 
	
	cmp r7, #3			@ If the user option is equal to 3, 
	beq check_cheesecrackers_amount @ branch back to finish the cheese crackers calculation 

	cmp r7, #4			@ If the user option is equal to 4, 
	beq check_mm_amount 		@ branch back to finish the M&Ms calculation 


@**************
reset:
@**************

@ This section clears the input buffer and the option chosen by the user. It, then, checks to see if the
@ vending machine has enough inventory to run again. 

	mov r7, #0			@ resets the user option chosen 
	ldr r0, =strInputPattern 	
	ldr r1, = strInputError 	@ Put address into r1 for read.
	bl scanf 			@ Scan the keyboard

	cmp r8, #0 			@ If the inventory of gum is equal to 0,  
	cmpeq r9, #0			@ and if the inventory of peanuts is equal to 0, 
	cmpeq r10, #0			@ and if the inventory of cheese crackers is equal to 0, 
	cmpeq r11, #0 			@ and if the inventory of M&Ms is equal to 0, 
	beq exit			@ then branch to exit to shut down the program.

	b user_options			@ else, branch to user_options to restart process 

@**************
reset_change:
@**************

@ This section clears the input buffer and branches back to the appropriate calculation depending on the option
@ chosen by the user. 

	ldr r0, = strInputPattern 	
	ldr r1, = strInputError 	@ Put address into r1 for read.
	bl scanf 			@ Scan the keyboard

	cmp r7, #1			@ If the option chosen by the user is gum, 
	beq gum_calculation		@ branch back to the gum calculation. 

	cmp r7, #2			@ If the option chosen by the user is peanuts, 
	beq peanut_calculation		@ branch back to the peanut calculation. 

	cmp r7, #3			@ If the option chosen by the user is cheese crackers,
	beq cheesecrackers_calculation 	@ branch back to the cheese crackers calculation. 
	
	cmp r7, #4			@ If the option chosen by the user is M&Ms, 
	beq mm_calculation		@ branch back to the M&Ms calculation. 


@**********************
print_inventory_copy:
@**********************

@ This section is the secret option to display the current inventory to the user. 

	mov r1, r11			@ Move the inventory of the M&Ms in r1
	mov r2, r10			@ Move the inventory of the cheese crackers in r2

	ldr r0, = inventoryPrompt	@ Puts the address of the string that displays the current inventory in r0
	bl printf 			@ and prints it. 

	mov r1, r9			@ Move the inventory of the peanuts in r1
	mov r2, r8			@ Move the inventory of the gum in r2

	ldr r0, = inventoryPrompt2	@ Puts the address of the string that displays the current inventory in r0
	bl printf 			@ and prints it.

	b reset				@ Branch to reset 

@********	
exit:		
@********

@ This section notifys to that user that the inventory is empty, forces the exit, and returns control back to OS. 
	
	ldr r0, = inventoryEmpty 	@ Puts the address of the notice in r0 
	bl printf 			@ and prints it. 

	mov r7, #0x01			@ End of my code. Force the exit and return control to OS
	svc 0 				@ Make the system call

@*****************
read_change_error:
@*****************

@ Since an invalid entry was made we now have to clear out the input buffer by 
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

	ldr r0, = changeMessage @ Put the address of the error message in r0
	bl printf 		@ and prints it. 

	ldr r0, = strInputPattern 
	ldr r1, = strInputError	@ Put address into r1 for read.
	bl scanf 		@ Scan the keyboard. 
	
	cmp r7, #1		@ If r7 is equal to 1,
	beq gum_calculation	@ branch back to gum_calculation

	cmp r7, #2		@ If r7 is equal to 2,
	beq peanut_calculation 	@ branch back to peanut_calculation

	cmp r7, #3			@ If r7 is equal to 3,
	beq cheesecrackers_calculation	@ branch back to cheesecrackers_calculation

	cmp r7, #4		@ If r7 is equal to 4,
	beq mm_calculation	@ branch back to mm_calculation

@*****************
read_confirmation_error:
@*****************

@ Since an invalid entry was made we now have to clear out the input buffer by 
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

	ldr r0, = confirmationMessage 	@ Put the address of the error message in r0
	bl printf 		@ and prints it. 

	ldr r0, = strInputPattern 
	ldr r1, = strInputError	@ Put address into r1 for read.
	bl scanf 		@ Scan the keyboard. 
	
	
	b user_Confirmation	@ Branch back to user_Confirmation

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
	
	
	b user_options		@ Branch back to user_options 	

.data				@ Declare the strings and data needed

.balign 4
totalInserted: .asciz "Total Change Inserted: %d cents\n" @ Used to notfiy the total amount inserted.

.balign 4
enoughNotification: .asciz "\nEnough Money Entered\n" @ Used to notify the user. 

.balign 4
inventoryEmpty: .asciz "\nThere is no more inventory for this vending machine.\nPlease notify maintenance to restock.\nPROGRAM END\n" @ Used to notify the user. 

.balign 4
changeReturned: .asciz "Change of %d cents has been returned.\n" @ Used to notfiy the user. 

.balign 4 
welcomePrompt: .asciz "\nWelcome to Mr. Zippy's vending machine.\nCost of Gum ($0.50), Peanuts ($0.55), Cheese Crackers ($0.65), or M&Ms ($1.00).\n" @ Used as a welcome screen. 

.balign 4
inventoryMessage: .asciz "\nThis item is currently out of stock." @ Used to notfiy the user. 

.balign 4
options: .asciz "\nEnter item selection:\n(G) Gum\n(P) Peanuts\n(C) Cheese Crackers\n(M) M&Ms\n\n" @ Used to prompt the user. 

.balign 4
inventoryPrompt: .asciz "\nCURRENT INVENTORY:\nM&Ms - %d\nCheese Crackers - %d\n" @ Used to display inventory. 

.balign 4
inventoryPrompt2: .asciz "Peanuts - %d\nGum - %d\n" @ Used to display inventory. 

.balign 4
gumConfirmation: .asciz "\nYou selected Gum. Is this correct? (Y/N)?\n" @ Used for confirmation. 

.balign 4
peanutConfirmation: .asciz "\nYou selected Peanuts. Is this correct? (Y/N)?\n"  @ Used for confirmation. 

.balign 4
cheesecrackerConfirmation: .asciz "\nYou selected Cheese Crackers. Is this correct? (Y/N)?\n"  @ Used for confirmation. 

.balign 4
mmConfirmation: .asciz "\nYou selected M&Ms. Is this correct? (Y/N)?\n"  @ Used for confirmation. 

.balign 4
gumRequirements: .asciz "\nEnter at least 50 cents for selection.\n" @ Used to notfiy the user. 

.balign 4
mmRequirements: .asciz "\nEnter at least 100 cents for selection.\n" @ Used to notfiy the user. 

.balign 4
peanutRequirements: .asciz "\nEnter at least 55 cents for selection.\n" @ Used to notfiy the user. 

.balign 4
cheesecrackerRequirements: .asciz "\nEnter at least 65 cents for selection.\n" @ Used to notfiy the user. 

.balign 4
mmDispense: .asciz "M&Ms have been dispensed.\n" @ Used to notfiy the user. 

.balign 4
cheesecrackersDispense: .asciz "Cheese Crackers have been dispensed.\n" @ Used to notfiy the user. 

.balign 4
peanutDispense: .asciz "Peanuts have been dispensed.\n" @ Used to notfiy the user. 

.balign 4
gumDispense: .asciz "Gum has been dispensed.\n" @ Used to notfiy the user. 

.balign 4
coinSelection: .asciz "Dimes (D), Quarters (Q) and Dollar Bills (B):\n\n" @ Used to prompt the user. 

.balign 4
userInput: .asciz "%s" @ String format for read.

.balign 4
confirmationInput: .asciz "%s" @ String format for read.

.balign 4
changeChoice: .asciz "%s" @ String format for read.

.balign 4
inputConfirmation: .word 0 @ Integer for input 

.balign 4
input: .word 0 @ Integer for input 

.balign 4
inputChange: .word 0 @ Integer for input 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Integer format for read.

.balign 4
strInputError: .skip 100*4 @ Used to clear the input buffer for invalid input. 

.balign 4
errorMessage: .asciz "ERROR: Invalid Input/Option (Please select options [G, P, C, or M])\n" @ Used to notfiy user. 

.balign 4
changeMessage: .asciz "ERROR: Invalid Input/Option (Please select options [D, Q, or B])\n" @ Used to notfiy user. 

.balign 4
confirmationMessage: .asciz "ERROR: Invalid Input/Option (Please enter [Y] for yes or [N] for no.)\n" @ Used to notfiy user. 

.balign 4
userOption: .word 0 @ Integer for option

.balign 4
changeInserted: .word 0 @ Integer to keep track of user input. 

.balign 4
gumInventory: .word 2 @ Inventory 

.balign 4
peanutInventory: .word 2 @ Inventory 

.balign 4 
cheesecrackerInventory: .word 2 @ Inventory 

.balign 4
mmInventory: .word 2 @ Inventory 

@ Let the assembler know these are the C library functions
.global printf
@	r0 - Contains the starting address of the string to be printed.
@	r1 - If the string contains an output parameter (%d, %c, etc.) register
@		r1 must contain the value to be printed.
.global scanf
@	r0 - Contains the address of the input format string used to read the user
@		input value.
@	r1 -Must contain the address where the input value is going to be stored.
 