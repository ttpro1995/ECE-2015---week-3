.data  
fin: .asciiz "Input.dat"      # filename for input
	.space 2048
	.word 0
buffer: .asciiz ""
	.space 2048

row_1: .word 0
col_1: .word 0
matrix_1: .space 2048

row_2: .word 0
col_2: .word 0
matrix_2: .space 2048



	.text
main:

# Open File

	li	$v0, 13			# 13=open file
	la	$a0, fin		# $a2 = name of file to read
	add	$a1, $0, $0		# $a1=flags=O_RDONLY=0
	add	$a2, $0, $0		# $a2=mode=0
	syscall				# Open FIle, $v0<-fd
	add	$s0, $v0, $0	# store fd in $s0


# Read 4 bytes from file, storing in buffer

	li	$v0, 14			# 14=read from  file
	add	$a0, $s0, $0	# $s0 contains fd
	la	$a1, buffer		# buffer to hold int
	li	$a2, 2048			# Read 2048 bytes
	syscall




# Close File

done:
	li	$v0, 16			# 16=close file
	add	$a0, $s0, $0	# $s0 contains fd
	syscall				# close file

la $t1,buffer
la $t2,matrix_1

# process buffer
	la $s0,buffer 
	lw $s1,($s0)  # s1 = row length
	la $t1,row_1 #t1 = address of row_1
	sw $s1,($t1) # store row_1
	
	addi $s0,$s0,4 # increase $s0
	lw $s2, ($s0)  # s2 = col length
	la $t2,col_1 #t2 = address of col_1
	sw $s2,($t2) #  store col_1
	addi $s0,$s0,4  # s0 point to begin of first array
	
	addi $a0,$s0,0        # buffer of first matrix
	la $a1,matrix_1 
	addi $a2,$s1,0
	addi $a3,$s2,0 
	
	jal CopyArray
	#addi $s0,$v0,0 # point to next row length
	
	#move pointer to next matrix
	mul $t0,$s2,$s1 # t0 = row*col of matrix_1
	mul $t0,$t0,4   # t0 = t0*4 = space that matrix_1 take
	add $s0,$s0,$t0 # point to num of row of maxtrix_2	
	lw $t5,($s0) #  DEBUG 000000000000000000000000000000000 $t5 = 6 
	
	
			
	# print array
	#la $a0,matrix_1
	#addi $a1,$0,60
	#jal printArray

	# second maxtrix
	lw $s1,($s0)  # s1 = row length
	la $t1,row_2  # load  address row_2 
	sw $s1,($t1)  # store row_2
	addi $s0,$s0,4 # increase $s0
	lw $s2, ($s0)  # s2 = col length
	la $t1,col_2  # load  address row_2 
	sw $s2,($t1)  # store row_2
	addi $s0,$s0,4  # s0 point to begin of first array
	
	addi $a0,$s0,0   # buffer of second matrix 
	la $a1,matrix_2 
	addi $a2,$s1,0
	addi $a3,$s2,0 
	
	lw $t1,($a0)  #  DEBUG 000000000000000000000000000000000 $t5 = 6 
	
	
	jal CopyArray
	
	#jal new_line
	
	# print array
	#la $a0,matrix_2
	#addi $a1,$0,60
	#jal printArray

# DEBUG (check value of row_1, col_1, row_2, col_2)
la $t0,row_1  	
la $t1,col_1	
la $t2,row_2
la $t3,col_2
lw $t4,($t0) #VALUE OF ROW_1
lw $t5,($t1)	#VALUE OF COL_1
lw $t6,($t2)#VALUE OF ROW_2
lw $t7,($t3)#VALUE OF COL_2
###
#main
la $a0, matrix_1 # arg a0
la $t1,row_1     # t1 = address of row_1
la $t2,col_1	# t2 = address of row_1
lw $a1,($t1)    #arg m_arr
lw $a2,($t2)    # arg n_arr

jal checkMatrixIdentity

addi $a0,$v0, 0  # get return value from function
addi $v0,$0,1  #print int
syscall

###


li $v0,10
syscall

##############
CopyArray:  

#store saved register
addi $sp, $sp, -32   # decrease stack pointer by 32 byte all 8 register
sw $s0, 28($sp)    #store $s0
sw $s1, 24($sp)	#store $s1
sw $s2, 20($sp)#store $s2
sw $s3, 16($sp)#store $s3
sw $s4, 12($sp)#store $s4
sw $s5, 8($sp)#store $s5
sw $s6, 4($sp)#store $s6
sw $s7, 0($sp)#store $s7
# $a0: source
# $a1: dest
# $a2: row
# $a3: col
addi $s0,$a0,0  # s0 = source address
addi $s1,$a1,0  # s1 = dest address
addi $s2,$a2,0  # s2 row
addi $s3,$a3,0  # s3 col

mul $s4,$s2,$s3 # s4 = row*col


addi $s7,$0,0   # $s7 counter unit
forLoop10:
####for (int i=0;i<s4;i++)
slt $t0,$s7,$s4   # if i<s4 then t0=1
beq $t0,$0,doneforLoop10 

lw $t1,($s0) #t1 =tmp
sw $t1,($s1) #store tmp into dest arr
addi $s0,$s0,4 #increase pointer by 1 int
addi $s1,$s1,4 #increase pointer by 1 int




addi $s7,$s7,1    #i++
j forLoop10
doneforLoop10:

addi $v0,$s0,0  # v0 return pointer which point to last element of array


#restore saved register
lw $s7, 0($sp)# restore $s0
lw $s6, 4($sp)#restore $s1
lw $s5, 8($sp)#restore $s2
lw $s4, 12($sp)#restore $s3
lw $s3, 16($sp)#restore $s4
lw $s2, 20($sp)#restore $s5
lw $s1, 24($sp)#restore $s6
lw $s0, 28($sp)#restore $s7
addi $sp,$sp,32  #increase stack pointer  by 32 byte
jr $ra
##############



############new_line############
new_line: # go to next line
addi $sp,$sp,-4 # decrease $sp by 4
addi $t0,$0,10  # $t0 = 10 = LF ascii code
sw $t0,0($sp) #store LF into stack
addi $a0,$sp,0  #$a0 = address of LF 
addi $v0,$0,4	# $v0=4, print_string
syscall		#print_string 
addi $sp,$sp,4 # increase $sp by 4
jr $ra

#########################
#################################
printArray:
# $a0 arr
# $a1 length
#store saved register
addi $sp, $sp, -32   # decrease stack pointer by 32 byte all 8 register
sw $s0, 28($sp)    #store $s0
sw $s1, 24($sp)	#store $s1
sw $s2, 20($sp)#store $s2
sw $s3, 16($sp)#store $s3
sw $s4, 12($sp)#store $s4
sw $s5, 8($sp)#store $s5
sw $s6, 4($sp)#store $s6
sw $s7, 0($sp)#store $s7


add $s0,$a0,$0  #s0 = base address of arr
add $s1,$a1,$0  #s1 = length
addi $s6,$0,8   #space bar
addi $s2,$0,0  # $s2 = i = 0
j forPrint11
forPrintLoop11:
#for (int i=0;i<length;i++)
 # print(a[i])
add $t5,$s2,$s2  # t5 =i*2
add $t5,$t5,$t5  # t5 = 4*t5
add $t5,$t5,$s0   #t5 = address of arr[i]
lw  $t6,($t5)    #t6 = arr[i]

add $a0,$t6,$0 #load arr[i] into $a0 to print
addi $v0,$0,1  # $v0 = 1 print int

addi $sp,$sp,-4 #adjust stack pointer
sw $ra,($sp)     #store $ra
syscall   #print arr[i]

jal new_space  # space between number

lw $ra,($sp)   #restore %ra
addi $sp,$sp,4    #adjust stack pointer

 
addi $s2,$s2,1   #increase i   
forPrint11:
slt $t0,$s2,$s1  # i<length then $t0 =1
bne $t0, $0, forPrintLoop11 #continue loop
#restore saved register
lw $s7, 0($sp)#store $s0
lw $s6, 4($sp)#store $s1
lw $s5, 8($sp)#store $s2
lw $s4, 12($sp)#store $s3
lw $s3, 16($sp)#store $s4
lw $s2, 20($sp)#store $s5
lw $s1, 24($sp)#store $s6
lw $s0, 28($sp)#store $s7
addi $sp,$sp,32  #increase stack pointer  by 32 byte
jr $ra  #return

#########################

###################new_space###############
new_space: # go to next line
addi $sp,$sp,-4 # decrease $sp by 4
addi $t0,$0,32  # $t0 = 32 = space ascii code
sw $t0,0($sp) #store LF into stack
addi $a0,$sp,0  #$a0 = address of LF 
addi $v0,$0,4	# $v0=4, print_string
syscall		#print_string 
addi $sp,$sp,4 # increase $sp by 4
jr $ra	#return


#########################################
##########matrix function start from here ###############3

##########################################
#int checkMatrixIdentity(int * arr1, int m_arr, int n_arr)
checkMatrixIdentity: 
# $a0 = base address of arr
# %a1 = m_arr = row 
# $a2 = n_arr = column
addi $sp, $sp, -32   # decrease stack pointer by 32 byte all 8 register
sw $s0, 28($sp)    #store $s0
sw $s1, 24($sp)	#store $s1
sw $s2, 20($sp)#store $s2
sw $s3, 16($sp)#store $s3
sw $s4, 12($sp)#store $s4
sw $s5, 8($sp)#store $s5
sw $s6, 4($sp)#store $s6
sw $s7, 0($sp)#store $s7


addi $s0,$a0,0 # s0 = base address
addi $s1,$a1,0 # s1 = row
addi $s2,$a2,0 # s2 = col

addi $s3,$0,1  # s3 = flag = 1
#int flag = 1;
#	/*  Check for unit (or identity) matrix */


#for (int i = 0; i < row; i++)
addi $s4,$0,0 # s4 = i =0 
outerLoop1:
slt $t0,$s4,$s1   # if (i<row) t0 =1
beq $t0,$0,endouterLoop1

#		for (int j = 0; j < col; j++)
addi $s5,$s5,0   #s5 = j =0
innerLoop1:
slt $t0,$s5,$s2  # if (i<col) t0 =1
beq $t0,$0,endinnerLoop1

#			if (arr1[i][j] != 1 && arr1[j][i] != 0)
# get arr1[i][j]
mul $t1,$s4,$s2         # t1 = i*col
mul $t1,$t1,4           # t1 = 4*i*col
mul $t2,$s5,4           # t2 = j*4

add $t3,$t1,$t2         # t3 = 4*i*col+4*j
add $t3,$t3,$s0         # t3 = address of arr1[i][j]

lw $t6,($t3)            #t6 = arr1[i][j]

# get arr1[j][i]
mul $t1,$s5,$s2         # t1 = j*col
mul $t1,$t1,4           # t1 = 4*j*col
mul $t2,$s4,4           # t2 = i*4

add $t3,$t1,$t2         # t3 = 4*j*col+4*i
add $t3,$t3,$s0         # t3 = address of arr1[j][i]

lw $t7,($t3)            #t7 = arr1[j][i]


addi $t1,$0,1  #t1 =1 
beq $t6,$t1,endif1  # if arr1[i][j]==1 then go out of if condition
beq $t7,$0,endif1   # if arr1[j][i] ==1 go out if condition
#{if body
addi $s3,$0,1  # flag = 0
j break1     #break
#}



endif1:
j innerLoop1			
endinnerLoop1:		
#
addi $s4,$s4,1   # i++
j outerLoop1
endouterLoop1:
#	return flag;
#



break1:
addi $v0,$s3,0   # set return value



#restore saved register
lw $s7, 0($sp)#store $s0
lw $s6, 4($sp)#store $s1
lw $s5, 8($sp)#store $s2
lw $s4, 12($sp)#store $s3
lw $s3, 16($sp)#store $s4
lw $s2, 20($sp)#store $s5
lw $s1, 24($sp)#store $s6
lw $s0, 28($sp)#store $s7
addi $sp,$sp,32  #increase stack pointer  by 32 byte
jr $ra  #return













