.data 
	newLine: .asciiz "\n"
	outputSet :.asciiz "Searching given element in given list ... \n"
	outputIntersect: .asciiz "Intersection of given 2  subset : \n"
	outputDifference: .asciiz "Difference elements of given set  from given subset : \n"
	outputUnion: .asciiz "Union of given 2 set : \n"
	
	
	entry: .asciiz "Welcome !\n"
	unionSet: .asciiz "NOTE: First set will be union set !\n"
	setnumber: .asciiz "Enter the set number: "
	elementnumber: .asciiz "Enter the element number in set: "
	element: .asciiz "Enter the element: "
	
	tempArray: .space 200

	setUnion: .space 100 #union set in homework that is X
	#these are sets.
	set1: .space 100
	set2: .space 100
	set3: .space 100
	set4: .space 100
	set5: .space 100
	set6: .space 100
	set7: .space 100
	set8: .space 100
	set9: .space 100
	set10: .space 100	
	
	elementNumOfSets: .space 40 #this array to keep element number of sets including X.
	
	file: .asciiz "union.txt"  
	words: .space 1000 
	
.text
	.globl main
main:
	jal readConsol
	
	li $v0,4
	la $a0,outputIntersect
	syscall
	
	la $t3,elementNumOfSets
	la $a0,setUnion
	lw $a1,($t3)
	lw $a2,12($t3)
	la $a3,set3
	
	jal intersection
	
	
	la $a0,($v0)
	move $a1,$v1
	jal printSetOnScreen

	
	li $v0,4
	la $a0,outputDifference
	syscall
	
	
	la $t3,elementNumOfSets
	la $a0,setUnion
	lw $a1,($t3)
	lw $a2,12($t3)
	la $a3,set3
	
	jal difference
	
	la $a0,($v0)
	move $a1,$v1
	jal printSetOnScreen

	li $v0,4
	la $a0,outputUnion
	syscall
	
	la $t3,elementNumOfSets
	la $a0,setUnion
	lw $a1,($t3)
	lw $a2,12($t3)
	la $a3,set3
	
	jal union
	
	
	la $a0,($v0)
	move $a1,$v1
	jal printSetOnScreen

	
	
	jal exit
#this function reads file.s
readFile:
	addi $sp, $sp, -4 
	sw   $s0, 0($sp) 
	li $v0,13
	la $a0,file  #address of null-terminated string containing filename.
	li $a1,0 #for reading
	syscall

	move $s0,$v0 #save file descriptor.

	li $v0,14
	move $a0,$s0 #file descriptor.
	la $a1,words #adress of input buffer.
	li $a2,1000 
	syscall


	li $v0,4
	la $a0, words  #address of null-terminated string to print.
	syscall

	la $s0, words # get array address
	add $v0 $s0 $zero
	lw   $s0, 0($sp) 
	addi $sp, $sp, 4 
	jr $ra	
#this function reads inputs from consol.
readConsol:
	li $v0,4
	la $a0,entry
	syscall
		
	
	li $v0,4
	la $a0,unionSet
	syscall	
	
	li $v0,4
	la $a0,setnumber
	syscall	
	
	li $v0,5
	syscall
	
	
	move $s0,$v0 #keep set number.
	
	li $t0,0 #index
	li $t1,0 #inner index
	
	la $t3,setUnion #adress of first set that is union set(X)
	la $t4,setUnion #adress of first set that is union set(X).This is traverse all sets.
	
	la $t5,elementNumOfSets #element numbers of set array.
	setLoop: 
		beq  $t0, $s0, exitSetLoop
		
		li $v0,4
		la $a0,elementnumber
		syscall	
		
		li $v0,5
		syscall
		
		move $s1,$v0 
		li $t1,0
		
		sw $s1,($t5)#record element number of set.
	innerLoop:
		beq  $t1, $s1, condition # if index equal element number ofs set.
		
		li $v0,4
		la $a0,element #gets element from user.
		syscall		
		
		li $v0,5
		syscall
		
		move $t2,$v0 
		sw $t2,($t3) #record element in current set.
		
		addi $t3,$t3,4 #for next element.
		addi $t1,$t1,1 #increase index.
		
		j innerLoop
	
	condition:
		addi $t4,$t4,100  #if current set initiliazed, go adress of next set.
		move $t3,$t4
		addi $t0,$t0,1
		addi $t5,$t5,4 #to element number of other set.
		j setLoop
		
	exitSetLoop:	
		jr $ra


#this function prints set elements on screen.$a0 and $a1 is function parameters.
printSetOnScreen:
	addi $sp, $sp, -16
	sw $ra,	12($sp)  
	sw $s2, 8($sp) #index of loop.
	sw $s1, 4($sp) #element number of set. #a1
	sw $s0, 0($sp)	#adres of set.	  #a0
	
	la $s0,($a0) #address of set. 
	move $s1, $a1 #element number of set.
	li $s2,0 #index
	loopPrint:
		beq $s2, $s1, exitPrint # check for array end
		li $v0, 1
		lw $a0, 0($s0) # print list element
		syscall
	
		jal printNewline
		addi $s2, $s2, 1 # advance loop counter
		addi $s0, $s0, 4 # advance array element
		j loopPrint # repeat the loop
	exitPrint:
		lw   $s0, 0($sp)
		lw   $s1, 4($sp)
		lw   $s2, 8($sp)
		lw   $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
#this function search an element in given set. Functions parameters ara $a0,$a1,$a2
searching:
	addi $sp, $sp, -36
	sw $ra,	32($sp)  
	sw $s7,	28($sp)  
	sw $s6,	24($sp)  
	sw $s5,	20($sp)  
	sw $s4,	16($sp)  
	sw $s3,	12($sp)  
	sw $s2, 8($sp) 
	sw $s1, 4($sp) 
	sw $s0, 0($sp)	

		
 	li $s0,0
 	la $s1,($a2) #searching element adress.
 	move $s2,$a1 #element number of set.
 	move $s3,$a0 #adress of set.
 	li $s4, 0 #index
 	while: 
 		beq $s4, $s2, resultNotFind # branch if (i == n) to resultNotFound
 		lw $s5, 0($s3) # $s5 = set[i]  
 		beq $s5, $s1, resultFind # branch if (set[i] == target) to resultFind
 		addi $s3, $s3, 4  #to next set element.
 		addi $s4, $s4, 1 # i = i+1  
		j while # jump to while loop 
 	resultFind:
 		add $s0,$s0,1
		move  $v0, $s0 #if find assign $v0 register 1.
		lw   $s0, 0($sp)
		lw   $s1, 4($sp)
		lw   $s2, 8($sp)
		lw   $s3, 12($sp)
		lw   $s4, 16($sp)
		lw   $s5, 20($sp)
		lw   $s6, 24($sp)
		lw   $s7, 28($sp)
		lw   $ra, 32($sp)
		addi $sp, $sp, 36
		jr $ra

	resultNotFind:  
		add $s0,$s0,-1
		move  $v0, $s0 # if not find assign $v0 register 1.
		
		lw   $s0, 0($sp)
		lw   $s1, 4($sp)
		lw   $s2, 8($sp)
		lw   $s3, 12($sp)
		lw   $s4, 16($sp)
		lw   $s5, 20($sp)
		lw   $s6, 24($sp)
		lw   $s7, 28($sp)
		lw   $ra, 32($sp)
		addi $sp, $sp, 36
		jr $ra
#this function creates intesection set of given 2 set.Parameters ara $a0,$a1,$a2,$a3.		
intersection:
	addi $sp, $sp, -40
	sw $ra,	36($sp)  #array
	sw $s7,	32($sp)  #array
	sw $s6,	28($sp)  #array
	sw $s4,	24($sp)  #array
	sw $s3,	20($sp) 
	sw $s2,	16($sp) #ikincinin boyutu 
	sw $s1, 12($sp) #birincinin boyutu
	sw $s0,	8($sp)	#birincinin adresi
	sw $t1, 4($sp) 
	sw $t0, 0($sp)
	
	move $s0,$a0 #first set adress
	move $s1,$a1 #first set length.
 	move $s2,$a2 #second set length.
 	move $s3,$a3 #second set adress.
 	li $s4,0
 	li $t0,0 #number of element in intersection
  	li $t1,0 
 
	intersectionLoop: 
		beq  $t1, $s1, exitIntersection # if i = n  exit.
		#these are to call searching function.Arguments of searching function creating.
		lw $a2,0($s0)
		move $a1,$s2
		move $a0,$s3
		
		jal searching #call search function.
		move $t7,$v0
		beq  $t7, 1, createIntersection  #if that element is in other set.Go createIntersection label.
	 	
		addi $s0, $s0, 4 
 		addi $t1, $t1, 1 
 		j intersectionLoop
 	createIntersection:
 		sw $a2 tempArray($s4) #add finded element in creting intersection set.
 		
 		addi $s0, $s0, 4 
 		addi $t1, $t1, 1 
 		addi $s4, $s4, 4
 		addi $t0, $t0, 1  
 		jal intersectionLoop	
 	exitIntersection:
 		la $s4,tempArray 
 		la $v0,($s4) #return created intersection set adress.
 		move $v1,$t0 #return created intersection set length .
 		lw $t0, 0($sp)
 		lw $t1, 4($sp)
 		lw $s0, 8($sp)	
 		lw $s1, 12($sp) 
 		lw $s2, 16($sp)
 		lw $s3, 20($sp)
 		lw $s4, 24($sp)
 		lw   $s6, 28($sp)
		lw   $s7, 32($sp)
		lw   $ra, 36($sp)
		addi $sp, $sp, 40
		jr $ra
#this function creates differnce set of given 2 set.Parameters ara $a0,$a1,$a2,$a3.	
difference:
	addi $sp, $sp, -32
	sw $ra,	28($sp)
	sw $s4,	24($sp) 
	sw $s3,	20($sp) 
	sw $s2,	16($sp) 
	sw $s1, 12($sp) 
	sw $s0,	8($sp)	
	sw $t1, 4($sp) 
	sw $t0, 0($sp)
	
	
	move $s0,$a0 #first set adress.
	move $s1,$a1 #first set length.
 	move $s2,$a2 #second set length.
 	move $s3,$a3 #second set adress.
 	
  	li $t1,0 #i 
  	li $s4,0
 	li $t0,0
 
 
	differenceLoop: 
		beq  $t1, $s1, exitDifference # if i = n  exit.,
		#these are to call searching function.Arguments of searching function creating.
		lw $a2,0($s0)
		move $a1,$s2
		move $a0,$s3
		
		jal searching #call search function.
		move $t7,$v0
		beq  $t7, -1, createDifference #if that element is not found in other set,Go createDifference label.
	 	
		addi $s0, $s0, 4 
 		addi $t1, $t1, 1 
 		j differenceLoop
 	createDifference:
 		sw $a2 tempArray($s4)
 		
 		addi $s0, $s0, 4 
 		addi $t1, $t1, 1 
 		addi $s4, $s4, 4
 		addi $t0, $t0, 1  
 		jal differenceLoop	
 	exitDifference:
 		la $s4,tempArray #add different element in creting difference set.
 		la $v0,($s4) #return created difference set adress.
 		move $v1,$t0 #return created difference set length .
 		lw $t0, 0($sp)
 		lw $t1, 4($sp)
 		lw $s0, 8($sp)	
 		lw $s1, 12($sp) 
 		lw $s2, 16($sp)
 		lw $s3, 20($sp)
 		lw $s4, 24($sp)
 		lw $ra, 28($sp)
 		addi $sp, $sp, 32
 		jr $ra
		
#this function creates union set of given 2 set.Parameters ara $a0,$a1,$a2,$a3.		
union:
	addi $sp, $sp, -36
	sw $ra,32($sp)
	sw $s5,28($sp) 
	sw $s4,	24($sp)  
	sw $s3,	20($sp) 
	sw $s2,	16($sp)  
	sw $s1, 12($sp) 
	sw $s0,	8($sp)	
	sw $t1, 4($sp)  
	sw $t0, 0($sp)
	
	
	move $s0,$a0 #adress of first set.
	move $s1,$a1 #first set length.
 	move $s2,$a2 #second set length.
 	move $s3,$a3 #adress of second set.
 	li $s5,0
  	li $t1,0 #i
  	li $s4,0
 	li $t0,0
			
	unionLoop: 
		beq  $t1, $s1, lastStep  #if i=n go lastStep.
		#these are to call searching function.Arguments of searching function creating.
		lw $a2,0($s0)
		move $a1,$s2
		move $a0,$s3
		
		jal searching #call searching function.
		move $t7,$v0
		beq  $t7, -1, createUnion #if that element is not found in other set,Go createUnion label.
	 	
		addi $s0, $s0, 4 
 		addi $t1, $t1, 1 
 		j unionLoop
 	createUnion:
 		sw $a2 ,tempArray($s4) #add different element of first set in union set.

 		addi $s0, $s0, 4 
 		addi $t1, $t1, 1 
 		addi $s4, $s4, 4
 		addi $t0, $t0, 1  
 		jal unionLoop		
 	lastStep: #this loop to add all element of second set in union set.So union set is created.
 		beq  $s5, $s2, exitUnion 
 		lw $t7,0($s3)
 		sw $t7,tempArray($s4)
 		
 		addi $s3, $s3, 4 
 		addi $s5, $s5, 1 
 		addi $s4, $s4, 4
 		addi $t0, $t0, 1 
 		jal lastStep
 	exitUnion:
 		la $s4,tempArray
 		la $v0,($s4) #return created union array.
 		move $v1,$t0 #return created union array length.
 		lw $t0, 0($sp)
 		lw $t1, 4($sp)
 		lw $s0, 8($sp)	
 		lw $s1, 12($sp) 
 		lw $s2, 16($sp)
 		lw $s3, 20($sp)
 		lw $s4, 24($sp)
 		lw $s5, 28($sp)
 		lw $ra, 32($sp)
 		addi $sp, $sp, 36
 		jr $ra
	
#This is finding max intersect element set with union set function.Parameters $a0,$a1,$a2,$a3		
findMaxIntersect:
	addi $sp, $sp, -68
	sw $ra,64($sp)
	sw $t4,60($sp)
	sw $t9,	56($sp)
	sw $t8,	52($sp)
	sw $t7,	48($sp)
	sw $t6,	44($sp)
	sw $t2,	40($sp)
	sw $t1,	36($sp)
	sw $t0,	32($sp)
	sw $s7,	28($sp)
	sw $s6,	24($sp)
	sw $s5,	20($sp)
	sw $s4,16($sp) 
	sw $s3,	12($sp)  
	sw $s2,	8($sp)
	sw $s1,	4($sp) 
	sw $s0,	0($sp)	
	
	la $s0,($a0) #adress of first set.
	la $s1,($a1) #adress of union set.
	la $s2,($a2) # adress of length of all sets array.
	
	la $t4,4($s2) #1. arrayin eleman sayýsýný daima tutabilmek için  dongu içinde s2 hep deðiþiyor cunku.
	lw $t8,($s2) #union eleman sayýsýný daima tutmak için dongu içinde s2 hep deðiþiyor cunku.
	la $t9,($s0) #birincinin adresini kaybetmemek için.
	
	
	li $t1,3 #number of sets.3 is instance
	
	li $t2,0 #index
	li $s5,0
	
	loopSetCover:
		beq $t2,$t1,exitMax

		la $a0,($s0) #set adress
		lw $a1,($t4) #set length
		move $a2,$t8 #union set length
		la $a3,($s1)#union set adress.
		
		jal intersection 
		
		move $s3,$v0 #intersection set.
		move $s4,$v1 #number of intersection set.
		
		slt $t0,$s5,$s4
		bne $t0,1,exitInner
		
		la $s7,($s3) #kesisim kumesi
		move $s6,$s4 #yüksek olan sayýlýyý tutuyorum.	
		
		
	exitInner:
		addi $s0,$s0,100
		addi $t4,$t4,4 #diðer array sayýsýna eriþebilmek için.
		addi $t2,$t2,1
		
		j loopSetCover
	exitMax:
	jal printNewline
	jal printNewline
		jal printNewline
		jal printNewline
		la $a0,($s7)
		move $a1,$s6
		jal printSetOnScreen
		lw $s0, 0($sp)
 		lw $s1, 4($sp)
 		lw $s2, 8($sp)	
 		lw $s3, 12($sp) 
 		lw $s4, 16($sp)
 		lw $s5, 20($sp)
 		lw $s6, 24($sp)
 		lw $s7, 28($sp)
 		lw $t0, 32($sp)
 		lw $t1, 36($sp)
 		lw $t2, 40($sp)
 		lw $t6, 44($sp)
 		lw $t7, 48($sp)
 		lw $t8, 52($sp)
 		lw $t9, 56($sp)
 		lw $t4,60($sp)
 		lw $ra, 64($sp)
 		addi $sp, $sp, 68
 		jr $ra
#this function to print newline on screen.	
printNewline:
	addi $sp, $sp, -8
	sw $ra,4($sp)
	sw $a0,0($sp)
	
	li $v0,4
	la $a0,newLine
	syscall
	
	lw $a0, 0($sp)
 	lw $ra, 4($sp)
 	addi $sp, $sp, 8
	jr $ra

#this function to exit program.
exit:
	li $v0,16
	li $a0,1
	syscall		
