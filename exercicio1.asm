#UFSJ - Dcomp 2018
#Amaury Ribeiro
#Gabriel Felipe 

.data 
	one: 	   .double  1.0	#constante = 1.0
	minus_one: .double -1.0  #constante = -1.0
	# angulo
	x_value:   .double  1.570 
	
.text 
# MAIN

# Initialization 
l.d  $f16, one	     #load  1 into register float16
l.d  $f18, minus_one #load -1 into register float18
l.d  $f0,  x_value    #load ANGLE into register float0

# chamando o cosseno de x
#max for n = 8
addi $a0, $zero, 8 
jal COSINE

j EXIT

# ---------------------------------------------------
# 		    Factorial(n)
# arguments: a0 -> n  
# returns:   v0 -> fat(n)
# ---------------------------------------------------
FACTORIAL:
	#checando se n == 0
	beq $a0, $zero, BASE_FAC
	
	#salvando ambos e retornando o endereço
	addi $sp, $sp, -8
	sw   $a0, 0($sp)
	sw   $ra, 4($sp)
	
	# chamo fat(n-1)
	addi $a0, $a0, -1
	jal FACTORIAL
	
	# carregando ambos e retornando o endereço
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	
	# fat(n) = n*fat(n-1)  calcula o fatorial 
	mul $v0, $v0, $a0
	jr $ra
	
BASE_FAC:
	# return 1
	addi $v0, $zero, 1
	jr $ra	
# ---------------------------------------------------
# 			Pow(x,n)
# arguments: f0 -> x a0 -> n 
# returns:   f2 -> pow(x,n)
# ---------------------------------------------------
POW:
	#caso base pow(x,1) = x  (pontencia de 1)
	slti $t0, $a0, 2 
	bne  $t0, $zero, BASE_POW
	
	#salvando e retornando o endereço
	addi $sp, $sp, -4
	sw   $ra, 4($sp)
	
	# chamando pow(x, n-1)
	addi $a0, $a0, -1
	jal POW
	
	#carregando e retornando o endereço
	lw   $ra, 4($sp)
	addi $sp, $sp, 4
	
	# pow(x,n) = x*pow(x,n-1)  
	mul.d $f2, $f2, $f0
	jr $ra
	
BASE_POW:
	#return x
	mov.d  $f2, $f0
	jr $ra

# ---------------------------------------------------
# 			Cosine(x, n)
# ---------------------------------------------------
# arguments: a0 -> n
# arguments: f0 -> x  
# returns:   f4 -> cos(x)

COSINE:
	# salvando parametros
	move  $s0,  $a0
	mov.d $f20, $f0
	WHILE:
		# se n == 0 e tambem:
		beq $s0, $zero, END_LOOP 
		
		# $f6 = (-1)^n
		mov.d $f0, $f18 
		move  $a0, $s0
		jal POW
		mov.d $f6, $f2
		
		# $f8 = x^(2n)
		mov.d $f0, $f20 
		move  $a0, $s0
		add  $a0, $a0, $a0 # 2n
		jal POW
		mov.d $f8, $f2
		
		# $f10 = (2n)!
		move  $a0, $s0
		add  $a0, $a0, $a0 # 2n
		jal FACTORIAL
		mtc1    $v0, $f10
		cvt.d.w $f10, $f10
		
		# $f12 = accumulate
		div.d $f12, $f6, $f10 
		mul.d $f12,  $f12, $f8
		
		add.d $f4, $f4, $f12
		
		# decrementando
		addi $s0, $s0, -1
		j WHILE
		
END_LOOP:
	#soma de n=0
	add.d $f4, $f4, $f16 
	j EXIT
	
EXIT:


