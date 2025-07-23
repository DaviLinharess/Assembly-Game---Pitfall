

.text
init:	
	jal Cenário
	
main:	# $4 registrador de parametro
	# $2 registrador de retorno
	# $22, $23, $24, $25 = registradores de operacoes da main
	# $3 vai guardar a posicao do personagem

	
	lui $3, 0x1001 		#coloca o boneco nessa posição inicial
	addiu $3, $3, 0x488c
    	
    	jal Boneco		
	
	lui $17, 0xffff 	# $17 vai guardar a habilitacao do teclado
	addi $7, $0, 'a'        # $7 vai guardar a letra 'a'
	addi $27, $0, 'd'	# $27 vai guardar a letra 'd'
	j cont
	
for2:	lw $18, 0($17)		#$18 vai guardar a verificação do teclado
	beq $18, $0, fim_for2	# se for 1, ent tem uma nova tecla pressionada, se for 0, nenhuma tecla nova na fila
	lw $18, 4($17)		#$18 deixa de ser 0 ou 1 e passa a ser o codigo da "tecla" inserida do teclado
	
	
	beq $18, $7, esq
	beq $18, $27, dir
fim_for2:
	jr $31 		#se a tecla apertada n for uma dessas de cima, ignora e continua o jogo
	 
esq:
# --- salva o endereço de retorno ---
    addi $29, $29, -4
    sw $31, 0($29)
    
# --- verifica colisão ---
    move $4, $3
    jal verificar_colisao_cobra_esquerda
    
# --- salva posição antiga antes de alguma mudança ---
    move $21, $3

# --- bug do boneco subir linha ao ir pra esquerda ---
    # Pega a posição atual (endereço % 512)
    li $8, 512
    div $3, $8
    mfhi $9              # $9 = posição atual (de 0 a 508)
    
    li $8, 8             # O tamanho do passo é 8
    slt $10, $9, $8      # $10 = 1 se a posição X < 8
    
    bne $10, $0, fazer_correc_esq # se for menor que 8, vai para a correção da posicao
    
    # se não, faz o movimento normal
    addi $3, $3, -8
    j apagar_e_desenhar_esq

fazer_correc_esq:
    # faz o tp para a direita na mesma linha
    addi $3, $3, 504     # (512 - 8)

apagar_e_desenhar_esq:
# --- apagar rastro da pos. antiga ($21) ---
    move $24, $21
    addi $24, $24, -4100
    li $22, 11
laco_esq_1:
    li $23, 7
laco_esq_2:
    lw $25, 32768($24)
    sw $25, 0($24)
    addi $24, $24, 4
    addi $23, $23, -1
    bnez $23, laco_esq_2
    addi $24, $24, -28
    addi $24, $24, 512
    add $22, $22, -1
    bnez $22, laco_esq_1
    
# --- desenha o boneco ---
    jal Boneco

# --- pega o endereço de retorno da pilha ---
    lw $31, 0($29)
    addi $29, $29, 4
    jr $31
    
dir:
# --- endereço de retorno na pilha ---
    addi $29, $29, -4
    sw $31, 0($29)
    
# --- calcular posições e salvar ---

    #verifica colisão antes de mexer
    move $4, $3 	#posição atual do boneco em $3 para $4
    jal verificar_colisao_direita

    #  $21 como  registrador temporário.
    move $21, $3             # posição ANTIGA em $21.
    addi $3, $3, 8           # posição NOVA (2 casas pra direita).

# --- apagar o rastro do boneco ---

    move $24, $21            # pincel comeca nos pés da posição antiga.
    addi $24, $24, -4100     # ajuste vertical pra subir ate o topo
	
    li $22, 11 # ALTURA  do personagem
	
laco_dir_1:
    li $23, 7 # LARGURA  do personagem
laco_dir_2:
    lw $25, 32768($24) 
    sw $25, 0($24)

    addi $24, $24, 4
    addi $23, $23, -1
    bnez $23, laco_dir_2 
	
    addi $24, $24, -28 # pincel correto (7 * 4 = 28)
    addi $24, $24, 512 
    add $22, $22, -1	 
    bnez $22, laco_dir_1

	jal Boneco
	
# --- restaurar o endereço de retorno da pilha ---
    lw $31, 0($29)
    addi $29, $29, 4
    
# --- voltar ---
	jr $31

cont: 
	add $4, $0, $20		#guarda em $4 o contador de frames da fogueira ($20)
	#jal animar_fogueira
	add $20, $2, $0	
	
	add $4, $0, $21		
	#jal andar_cobra
	add $21, $0, $2		
	
	jal Boneco
	
	#verificar colisões
	# 2a. checa colisao jogador com fogueira
	add $4, $3, $0 	#posição do jogador ($3)
	add $5, $14, $0 #posição da fogueira ($14)
	jal checar_colisão_personagens
	
	 # 2b. Checar colisão do Jogador com a COBRA
    	add $4, $3, $0			# Posição do Jogador ($3)
    	add $5, $15, $0			# APosição da Cobra ($15)
    	jal checar_colisão_personagens
	
	
cobra01:   jal cobraesq	
	   jal for2
	   
FogEsq:    jal fogueiraesq
	   jal for2
	   jal delayfog	 
	     
CenFog1:   jal cenariofogueira
	   jal for2
	   
	 
FogMeio:   jal fogueirameio
	   jal for2
	   jal delayfog
	   jal for2
CenFog2:   jal cenariofogueira
	   jal for2
	   
	   
FogDir:    jal fogueiradireita
	   jal for2
	   jal delayfog  
	   jal for2
CenFog3:   jal cenariofogueira
	   jal for2
   
	    
FogMeiodnv:   jal fogueirameio
	      jal for2
	      jal delayfog
	      jal for2
CenFogdnv:    jal cenariofogueira
	      jal for2

FogEsqdnv1:    jal fogueiraesq
	       jal for2
	       jal delayfog	
	       jal for2   
CenFogdnv1:    jal cenariofogueira
	       jal for2

cencobra1:     jal cencobraesq
	       jal for2
cobra02:       jal cobradir
	       jal for2

	    jal fogueiraesq
	    jal for2
	    jal delayfog	  
	    jal for2 
	    jal cenariofogueira
	    jal for2
	    
	    jal fogueirameio
	    jal for2
	    jal delayfog
	    jal for2
	    jal cenariofogueira
	    jal for2
	   
	   
	    jal fogueiradireita
	    jal for2
	    jal delayfog  
	    jal for2
	    jal cenariofogueira
	    jal for2
   
	    
	    jal fogueirameio
	    jal for2
	    jal delayfog
	    jal for2
	    jal cenariofogueira
	    jal for2


cencobra2: jal cencobradir
	   jal for2
	   j cobra01



	   
Cenário:
	lui $9, 0x0031	 	#$9 - VERDE ESCURO FOLHAS CIMA
	ori $9, $9, 0x5a18
	
	lui $10, 0x006B		#$10 - VERDE CLARO ENTRE ARVORES
	ori $10, $10, 0x9C42
	
	lui $11, 0x004A	 	#$11 - MARROM ESCURO TRONCO
	ori $11, $11, 0x4A00
	
	lui $12, 0x00BD		#$12 - SOLO
	ori $12, $12, 0xBD31
	
	lui $13, 0x0084		#$13 - SOLO INTERNO
	ori $13, $13, 0x8418

tela:
	lui $8, 0x1001		# "pincel", onde vai começar a pintar 
	
	#2304/4 = 18 		(pintando as 18 primeiras linhas do Display)
	addi $21, $0, 2304	# Quantidade total de UG referente folhas
	addi $20, $0, 0		# K = contador

folhas:
	beq $21, $20, segundaparte	# condição de parada
	sw $9, 0($8)			# Pinta o cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $9, 0($25)
	# --- FIM CÓPIA ---
	
	addi $8, $8, 4			# próximo endereço
	addi $20, $20, 1		# K++
	j folhas

#==================Segunda parte: Tronco e Vegetação======================

segundaparte:
	lui $8, 0x1001			#reposicionando o "pincel"
	addiu $8, $8, 0x2400	
	
	addi $21, $0, 18		# objetivo final: 18 linhas
	addi $20, $0, 0			# iteração, linha atual

linhanoloop:
	beq $21, $20, terceiraparte
	addi $13, $0, 0	
loop:
	beq $13, 3, blocofinalverde
	addi $14, $0, 0 
verdebloco:
	beq $14, 29, blocomarrom
	sw $10, 0($8)			# Pinta verde no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $10, 0($25)
	# --- FIM CÓPIA ---
	
	addi $8, $8, 4
	addi $14, $14, 1
	j verdebloco

blocomarrom:
	addi $15, $0, 0
marrombloco:
	beq $15, 4, continua
	sw $11, 0($8)		# Pinta marrom no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $11, 0($25)
	# --- FIM CÓPIA ---
	
	addi $8, $8, 4
	addi $15, $15, 1
	j marrombloco

continua:
	addi $13, $13, 1
	j loop

blocofinalverde:
	addi $13, $0, 0
	lui $13, 0x0084
	ori $13, $13, 0x8418
	
	addi $14, $0, 0
verdefinal:
	beq $14, 29, proximalinha
	sw $10, 0($8)			# Pinta verde no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $10, 0($25)
	# --- FIM DA CÓPIA ---
	
	addi $8, $8, 4
	addi $14, $14, 1
	j verdefinal

proximalinha:
	addi $20, $20, 1
	j linhanoloop

#============inicio da terceira parte==============================

terceiraparte:
	lui $8, 0x1001
	addiu $8, $8, 0x4800 	
	
	addi $21, $0, 512
	addi $20, $0, 0
solo:
	beq $21, $20, solointerno
	sw $12, 0($8)			# Pinta solo no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $12, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j solo
	
solointerno:
	lui $8, 0x1001
	addiu $8, $8, 0x5000
	
	addi $21, $0, 512
	addi $20, $0, 0
constsolointerno:
	beq $21, $20, pretointerno
	sw $13, 0($8)			# Pinta solo interno no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $13, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j constsolointerno
	
pretointerno:
	lui $8, 0x1001
	addiu $8, $8, 0x5800
	
	addi $21, $0, 1536
	addi $20, $0, 0
constpretointerno:
	beq $21, $20, soloabaixo
	sw $0, 0($8)				# Pinta preto no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $0, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j constpretointerno

soloabaixo:
	lui $8, 0x1001
	addiu $8, $8, 0x7000
	
	addi $21, $0, 512
	addi $20, $0, 0
constsolobaixo:
	beq $21, $20, folhasnovas1
	sw $13, 0($8) 				# Pinta solo interno no cenário visível
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $13, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j constsolobaixo

folhasnovas1: 
	lui $8, 0x1001
	addiu $8, $8, 0x2464
	lui $9, 0x0031
	ori $9, $9, 0x5a18
	addi $21, $0, 11
	addi $20, $0, 0
folhasdet1: 
	beq $21, $20, folhasnovas2
	sw $9, 0($8)
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $9, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j folhasdet1
	
folhasnovas2: 
	lui $8, 0x1001
	addiu $8, $8, 0x24e8
	lui $9, 0x0031
	ori $9, $9, 0x5a18
	addi $21, $0, 11
	addi $20, $0, 0
folhasdet2: 
	beq $21, $20, folhasnovas3
	sw $9, 0($8)
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $9, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j folhasdet2
	
folhasnovas3: 
	lui $8, 0x1001
	addiu $8, $8, 0x256c
	lui $9, 0x0031
	ori $9, $9, 0x5a18
	addi $21, $0, 11
	addi $20, $0, 0
folhasdet3: 
	beq $21, $20, resetRegist
	sw $9, 0($8)
	
	# --- CÓPIA DO CENÁRIO ESCONDIDO ---
	addi $25, $8, 32768
	sw $9, 0($25)
	# --- FIM DA CÓPIA ---

	addi $8, $8, 4
	addi $20, $20, 1
	j folhasdet3
	
resetRegist:
		addi $20, $0, 0
		addi $21, $0, 0
		addi $14, $0, 0
		addi $15, $0, 0
		jr $31
	   
Boneco:
	
	add $8, $0, $3	    #Copia a posição de referência ($3) para um pincel temporário ($8)
	
	lui $16, 0x001e     #$16 - COR CALÇA BONECO
	ori $16, $16, 0x6f4f 
	
	lui $19, 0x0056     #$19 - COR CAMISA  BONECO 
	ori $19, $19, 0xc44f
	
	lui $26, 0x00f6	    #$26 - COR PELE BONECO
	ori $26, $26, 0x8187

	lui $28, 0x0057      #$28 - COR CABELO BONECO
	ori $28, $28, 0x1c27

calca:

	#cor da calça/pé
	sw $16, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	sw $16, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	sw $16, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	sw $16, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	addi $8, $8, 508	#pulei para a proxima linha
	sw $16, 0($8)
	
	addi $8, $8, -12	#pintei o inicio da outra perna
	sw $16, 0($8)
	
	addi $8, $8, 512	#pulei para a proxima linha
	sw $16, 0($8)
	
	addi $8, $8, 12		#pintei o inicio da outra perna
	sw $16, 0($8)
	
	addi $8, $8, 4		#pintei a pontinha do pé da frente
	sw $16, 0($8)	
	
	addi $8, $8, -12	#pintei a pontinha do pé de trás
	sw $16, 0($8)
	
	
camisa: 
	#cor da camisa	
	addi $8, $8, -1540      #sobe pro primeiro pixel da camisa
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, -508
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -512
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, 4
	sw $19, 0($8)
	
	addi $8, $8, 8
	sw $19, 0($8)
	
	addi $8, $8, -520
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
	addi $8, $8, -4
	sw $19, 0($8)
	
cabeca:
	#cor da pele
	addi $8, $8, -508
	sw $26, 0($8)
	
	addi $8, $8, -512
	sw $26, 0($8)
	
	addi $8, $8, 4
	sw $26, 0($8)
	
	addi $8, $8, 4
	sw $26, 0($8)
	
	addi $8, $8, -512
	sw $26, 0($8)
	
	addi $8, $8, -4
	sw $26, 0($8)
	
	addi $8, $8, -4
	sw $26, 0($8)
	
cabelo:
	#cor do cabelo	
	addi $8, $8, -512
	sw $28, 0($8)
	
	addi $8, $8, 4
	sw $28, 0($8)
	
	addi $8, $8, 4
	sw $28, 0($8)
	
	jr $31
	
	
	
checar_colisão_personagens: 
	# Argumento em $4: Posição do Jogador
	# Argumento em $5: Posição do NPC

	# salva os registradores que vamos usar
	addi $29, $29, -12
	sw $8, 8($29)
	sw $9, 4($29)
	sw $10, 0($29)

	# distância os dois.
	sub $8, $4, $5

	#distância não pode ser negativa
	slt $9, $8, $0
	bne $9, $0, inverte_sinal_colisao

continua_check_colisao:
	# "distância mínima" para considerar uma colisão.
	# valor ajustavel pra mudar o raio a colisao
	addi $9, $0, 24    

	# Ver se a distância é menor que o raio de colisão.
	slt $10, $8, $9
	beq $10, $0, sem_colisao # se não for menor, não colidiu.

colidiu:
	# distância < raio, jogo acaba.
	j player_morreu

inverte_sinal_colisao:
	#transformar um número negativo em positivo.
	sub $8, $0, $8
	j continua_check_colisao
    
sem_colisao:
	# restaura os registradores
	lw $10, 0($29)
	lw $9, 4($29)
	lw $8, 8($29)
	addi $29, $29, 12

	#não houve colisão.
	jr $31
player_morreu:
	li $4 'V'
	li $2 11
	syscall
	li $4 'O'
	li $2 11
	syscall
	li $4 'C'
	li $2 11
	syscall
	li $4 'E'
	li $2 11
	syscall
	li $4 ' '
	li $2 11
	syscall
	li $4 'P'
	li $2 11
	syscall
	li $4 'E'
	li $2 11
	syscall
	li $4 'R'
	li $2 11
	syscall
	li $4 'D'
	li $2 11
	syscall
	li $4 'E'
	li $2 11
	syscall
	li $4 'U'
	li $2 11
	syscall
	li $4 '\n'
	li $2 11
	syscall
	addi $2 $0 10
	syscall

cobraesq: 
		lui $21, 0x00ff		# $21 - COR VERMELHA
		ori $21, $21, 0x0000
		
		lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
	   	ori $10, $10, 0x9C42
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
		# $0 COR PRETA


		#cor da lingua
	  lui $15, 0x1001		#muda o pincel pra cá
	  addiu $15, $15, 0x45a8
	   
	  sw $21, 0($15)  		#pinta a area marcada
	  addi $15, $15, 4		#vai pro do lado
	  
	   #cor preta
	  sw $0, 0($15)
	  addi $15, $15, 4		#do lado
	   
	  sw $0, 0($15)
	  addi $15, $15, 4		#do lado
	   
	  #cor do fundo verde
	  
	  sw $10, 0($15)
	  addi $15, $15, 4
	  
	  sw $10, 0($15)
	  addi $15, $15, 4
	  
	  sw $10, 0($15)
	  addi $15, $15, 512 		#proxima linha
	  
	  sw $10, 0($15)			#pinta de verde
	  addi $15, $15, -4		#vai voltando 1 ug
	  
	  sw $10, 0($15)			#pinta de verde
	  addi $15, $15, -4		#vai voltando 1 ug
	  
	  sw $10, 0($15)			#pinta de verde
	  addi $15, $15, -4		#vai voltando 1 ug
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  #cor do fundo verde
	  sw $10, 0($15)			#pinta de "verde"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $10, 0($15)
	  addi $15, $15, 512		#pula de linha
	  
	  #cor do piso	  
	  sw $12, 0($15)
	  addi $15, $15, 4		#pro lado
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 512
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 512		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 512		#ultima linha
	  
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  jr $31

	  
cencobraesq: 
	   	lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
	   	ori $10, $10, 0x9C42
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
	  #cor do fundo  
	   lui $15, 0x1001		#muda o pincel pra cá
	   addiu $15, $15, 0x45A8
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 512
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, 512
	   
		#cor do piso
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 512
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, 512
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 512
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   jr $31
	   
cobradir: 
		lui $21, 0x00ff		# $21 - COR VERMELHA
		ori $21, $21, 0x0000
		
		lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
	   	ori $10, $10, 0x9C42
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
		# $0 COR PRETA


		#cor da lingua
	  lui $15, 0x1001		#muda o pincel pra cá
	  addiu $15, $15, 0x45AC
	   
	  sw $21, 0($15)  		#pinta a area marcada
	  addi $15, $15, 4		#vai pro do lado
	  
	   #cor preta
	  sw $0, 0($15)
	  addi $15, $15, 4		#do lado
	   
	  sw $0, 0($15)
	  addi $15, $15, 4		#do lado
	   
	  #cor do fundo verde
	  
	  sw $10, 0($15)
	  addi $15, $15, 4
	  
	  sw $10, 0($15)
	  addi $15, $15, 4
	  
	  sw $10, 0($15)
	  addi $15, $15, 512 		#proxima linha
	  
	  sw $10, 0($15)			#pinta de verde
	  addi $15, $15, -4		#vai voltando 1 ug
	  
	  sw $10, 0($15)			#pinta de verde
	  addi $15, $15, -4		#vai voltando 1 ug
	  
	  sw $10, 0($15)			#pinta de verde
	  addi $15, $15, -4		#vai voltando 1 ug
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  #cor do fundo verde
	  sw $10, 0($15)			#pinta de "verde"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $10, 0($15)
	  addi $15, $15, 512		#pula de linha
	  
	  #cor do piso	  
	  sw $12, 0($15)
	  addi $15, $15, 4		#pro lado
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 512
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 512		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, 4		# vai pro lado
	  
	  #cor do piso
	  sw $12, 0($15)
	  addi $15, $15, 512		#ultima linha
	  
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  sw $12, 0($15)
	  addi $15, $15, -4
	  
	  #muda pra cor da cobra (mexer pra preta dnv)
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  sw $0, 0($15)			#pinta de "preto"
	  addi $15, $15, -4		# vai pro lado
	  
	  jr $31
	  
cencobradir:
		lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
		ori $10, $10, 0x9C42
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
		
		#cor do fundo	  
	   lui $15, 0x1001		#muda o pincel pra cá
	   addiu $15, $15, 0x45AC
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 4
	   
	   sw $10, 0($15)
	   addi $15, $15, 512
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, -4
	   
	   sw $10, 0($15)
	   addi $15, $15, 512
	   
	   #cor do piso	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 512
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, 512
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 4
	   
	   sw $12, 0($15)
	   addi $15, $15, 512
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   sw $12, 0($15)
	   addi $15, $15, -4
	   
	   jr $31
	   
fogueiraesq:
		lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
		ori $10, $10, 0x9C42
		
		lui $11, 0x004A 	#$11 - MARROM ESCURO
		ori $11, $11, 0x4A00
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
		
		lui $20, 0x00ff  	#$20 - COR LARANJA FOGUEIRA
		ori $20, $20, 0xc000
		
		 lui $21, 0x00ff	#$21 - COR VERMELHA 
		 ori $21, $21, 0x0000
		 
		#cor do fundo verde
	     	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
		#cor do fogo laranja	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fundo verde  	
	  	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 512
	  	
		#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo vermelho  	
	  	sw $21, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do piso  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
		#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo vermelho	  	
	  	sw $21, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $21, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do piso  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	# cor marrom 
		sw $11, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
	  	# cor marrom e ultima linha	
		sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
	  	# cor marrom  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	jr $31
	  	
fogueirameio:	

		lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
		ori $10, $10, 0x9C42
		
		lui $11, 0x004A 	#$11 - MARROM ESCURO
		ori $11, $11, 0x4A00
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
		
		lui $20, 0x00ff  	#$20 - COR LARANJA FOGUEIRA
		ori $20, $20, 0xc000
		
		 lui $21, 0x00ff	#$21 - COR VERMELHA 
		 ori $21, $21, 0x0000
		 
		#cor do fundo verde 
	   	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fundo verde  	
	  	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 512
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
	  	#cor do fogo laranja
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo vermelho	  	
	  	sw $21, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $21, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo laranja
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 512
	  	
	  	#cor do piso
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	# cor marrom	  	
	  	sw $11, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
	  	# cor marrom 	  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
		# cor marrom 
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $11, 0($8)
	  	
		jr $31
	  	
fogueiradireita: 

		lui $10, 0x006B 		#$10 - VERDE CLARO ENTRE ARVORES
		ori $10, $10, 0x9C42
		
		lui $11, 0x004A 	#$11 - MARROM ESCURO
		ori $11, $11, 0x4A00
		
		lui $12, 0x00BD  	#$12 - SOLO
		ori $12, $12, 0xBD31
		
		lui $20, 0x00ff  	#$20 - COR LARANJA FOGUEIRA
		ori $20, $20, 0xc000
		
		 lui $21, 0x00ff	#$21 - COR VERMELHA 
		 ori $21, $21, 0x0000
		 
		#cor do fundo verde
	   	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fundo verde	  	
	  	sw $10, 0($8)
	  	addi $8, $8, 512
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo vermelho  	
	  	sw $21, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo vermelho	  	
	  	sw $21, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $21, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $20, 0($8)
	  	addi $8, $8, 512
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	# cor marrom 	  	
	  	sw $11, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do fogo laranja	  	
	  	sw $20, 0($8)
	  	addi $8, $8, -4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 512
	  	
	  	# cor marrom 	  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	#cor do piso	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $12, 0($8)
	  	addi $8, $8, 4
	  	
	  	# cor marrom 		
	  	sw $11, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $11, 0($8)
	  	jr $31
	  	
cenariofogueira:
		 lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  
	   	lui $14, 0x1001		#muda o pincel pra cá
	   	addiu $14, $14, 0x4718
	   	
	   	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 512
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 512
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, -4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 512
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14, 4
	  	
	  	sw $9, 0($14)
	  	addi $14, $14,512
	  	jr $31
	  	
	  	
	

# verifica TODA a borda da direita do boneco contra a cor do fogo.
# $4 como posição de referência do jogador (pé)
# $20 como a cor do fogo
verificar_colisao_direita:
    # prepara ponteiros e contadores
    add $8, $4, 24            # pincel a 1 pixel dos pés do boneco
    addi $8, $8, -2560       # sobe o pincel para a altura da cintura
    li $9, 11                # contador de altura (11 pixels)

laco_verificar_direita:
    beq $9, $0, nao_colidiu_fogo 	# se o contador = 0, sem colisão
    
    lw $10, 0($8)            		# carrega a cor do pixel da tela em $10
    beq $10, $20, colidiu_fogo 		# se cor da tela == cor do fogo, colidiu
    
    addi $8, $8, 512         		# move o pincel para a linha de baixo
    addi $9, $9, -1          		# diminui o contador de altura
    j laco_verificar_direita
    

# verifica TODA borda da esquerda do personagem contra a cor do fogo.
# $4 = Posição de referência do jogador (pé)
# $20 como a cor do fogo
verificar_colisao_esquerda:
    # prepara os ponteiros e contadores
    add $8, $4, -4           # começa 1 pixel à esquerda dos pés
    addi $8, $8, -2560       # sobe o pincel para a altura da cintura
    li $9, 11                # contador de altura (11 pixels para verificar)

laco_verificar_esquerda:
    beq $9, $0, nao_colidiu_fogo
    
    lw $10, 0($8)
    beq $10, $20, colidiu_fogo
    
    addi $8, $8, 512
    addi $9, $9, -1
    j laco_verificar_esquerda

# resultado
colidiu_fogo:
    j player_morreu

nao_colidiu_fogo:
    jr $31
    
    

# mesma coisa pra cobra
verificar_colisao_cobra_esquerda:
    # sensor a 1 pixel da esquerda do boneco
    add $8, $4, -4
    
  
	# Sobe o pincel para a altura da cintura
    addi $8, $8, -2560       
    
    li $9, 11                # contador de altura (11 pixels para verificar).

laco_verificar_esq_cobra:
    beq $9, $0, nao_colidiu_cobra # se contador = 0, sem colisão.
    
    lw $10, 0($8)            # cor do pixel em $10.
    
    # compara a cor da tela com a cor da COBRA ($0).
    beq $10, $0, colidiu_cobra
    
    addi $8, $8, 512         # pincel para a linha de baixo.
    addi $9, $9, -1          # diminui o contador de altura.
    j laco_verificar_esq_cobra

# --- resultado ---
colidiu_cobra:
    j player_morreu

nao_colidiu_cobra:
    jr $31
    
#=== DELAYS ===
delayfog:
	addi $24, $0, 20000		
lacoD2:  beq $24, $0, fimD2
        nop
        nop
        addi $24, $24, -1
        j lacoD2
fimD2:   jr $31
