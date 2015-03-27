.data  
fin: .asciiz "Input.dat"      # filename for input
	.word 0
buffer: .asciiz ""
	.space 2048

row_1: .word 0
col_1: .word 0
matrix_1: .space 1024

row_2: .word 0
col_2: .word 0
matrix_2: .word 1024



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
	addi $s0,$s0,4 # increase $s0
	lw $s2, ($s0)  # s2 = col length
	addi $s0,$s0,4  # s0 point to begin of first array
	
	addi $a0,$s0,0
	la $a1,matrix_1 
	addi $a2,$s1,0
	addi $a3,$s2,0 
	
	jal CopyArray
	addi $s0,$v0,4 # point to next row length
	# print array
	la $a0,matrix_1
	addi $a1,$0,60
	jal printArray



	

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
sw $s7, 0($sp)#store $s0
sw $s6, 4($sp)#store $s1
sw $s5, 8($sp)#store $s2
sw $s4, 12($sp)#store $s3
sw $s3, 16($sp)#store $s4
sw $s2, 20($sp)#store $s5
sw $s1, 24($sp)#store $s6
sw $s0, 28($sp)#store $s7
addi $sp,$sp,32  #increase stack pointer  by 32 byte
jr $ra
##############

############
#printArray:
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
j forPrint
forPrintLoop:
#for (int i=0;i<length;i++)
#Thai Thien 1351040
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
#Thai Thien 1351040
jal new_line  # go to new line

lw $ra,($sp)   #restore %ra
addi $sp,$sp,4    #adjust stack pointer

 
addi $s2,$s2,1   #increase i   
forPrint:
slt $t0,$s2,$s1  # i<length then $t0 =1
bne $t0, $0, forPrintLoop #continue loop


#restore saved register
sw $s7, 0($sp)#store $s0
sw $s6, 4($sp)#store $s1
sw $s5, 8($sp)#store $s2
sw $s4, 12($sp)#store $s3
sw $s3, 16($sp)#store $s4
sw $s2, 20($sp)#store $s5
sw $s1, 24($sp)#store $s6
sw $s0, 28($sp)#store $s7
addi $sp,$sp,32  #increase stack pointer  by 32 byte

jr $ra

#########################

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