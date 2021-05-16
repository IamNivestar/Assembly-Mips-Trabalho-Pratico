#UFSJ - Dcomp 2018
#Amaury Ribeiro
#Gabriel Felipe 

.data 

debugando: .asciiz "\n buceta \n"

toRead: .asciiz "entrada.txt"

toWrite: .asciiz "saida.txt"

mensagem: .asciiz "\nSua string ANTIGA é :\n"

resposta: .asciiz "\nSua NOVA string é :\n"

string: .space 100

.text

.globl main

main:
	
	jal leArquivo
	
	#printando antes da operação
	li $v0, 4
	la $a0, mensagem
	syscall 
	
	la $a0, string 
	li $v0, 4 
	syscall	
	
	jal manipulaString

	#printando após operação
	#mensagem
	li $v0, 4
	la $a0, resposta
	syscall 
	#string
	la $a0, string
	li $v0, 4 
	syscall
	
	jal salvaArquivo 
	
	#fim do programa
	li $v0, 10
	syscall
		
############################################################		
leArquivo:	
	#abrindo
	li $v0, 13 #codigos abrir arquivo
	la $a0, toRead
	li $a1, 0  #(0 é codigo leitura)
	syscall
	move $s0, $v0  #salvando em $s0
	
	#lendo arquivo
	li $v0, 14  #codigos para ler
	la $a1, string 
	li $a2, 100  #quantidade de caracteres
	move $a0, $s0
	syscall
	
	#fechando arquivo
	li $v0, 16
	move $a0, $s0
	syscall

	jr $ra
		
############################################################		
manipulaString:
	
	#constantes declaradas
	li $t3, 91
	li $t4, 64
	li $t5, 96
	li $t6, 123
	li $t7, 00 #quebra de linha
	
	
	li $t0, 0  # contador 
	la $s1, string
	lb $s1, string($t0)   
		
while:  beq $s1, $t7, exit	#caractere == "\n"  
	
#verificando se caractere é maiusculo    (tabela ASCII  64 < $s1 <91)
	#primeira verificação 
	slt $t1, $s1, $t3   # $s0 < 91  	
	beq $t1, $zero,skip   # caso falha a primeira pulo a segunda verificacao 
	#segunda verificação
	slt $t1, $t4, $s1  # $s1 > 64  	
	beq $t1, $zero,skip
	add $s1, $s1, 32   #somo 32 para transformar em minusculo
	sb $s1, string($t0) #realizando a troca
	addi $t0, $t0, 1   # $s1++  (passando para o proximo caractere
	lb $s1, string($t0)  #carregando byte para $t1 
	j while
skip:
#verificando se caractere é minusculo    (tabela ASCII  64 < $s1 <91)

	#primeira verificação 
	slt $t1, $s1, $t6 	 # $s1 < 123	
	beq $t1, $zero,skip2   # caso falha a primeira pulo a segunda verificacao 
	#segunda verificação
	slt $t1, $t5, $s1        # $s1 > 96
	beq $t1, $zero,skip2
	sub $s1, $s1, 32   #subtraio 32 para transformar em maiusculo
	sb $s1, string($t0) #realizando a troca
skip2:	
	addi $t0, $t0, 1   # contador ++ 
	lb $s1, string($t0)  # atualizando proximo caractere
	j while
exit: 	
	jr $ra
		
############################################################			
salvaArquivo:

	#escrevendo arquivo
	li $v0, 13 #codigos abrir arquivo
	la $a0, toWrite 
	li $a1, 1  #(1 é codigo escrita)
	syscall
	move $s1, $v0  #salvando em $s1
	
	#escrevendo arquivo
	li $v0, 15  #leitura
	move $a0,$s1
	la $a1, string		
    	la $a2,100	#quantidade de caracteres
	syscall
	
	#fechando arquivo
	li $v0,16
    	move $a0,$s1      		
    	syscall
    	#fim da função
    	
    	jr $ra
	
	
	  


