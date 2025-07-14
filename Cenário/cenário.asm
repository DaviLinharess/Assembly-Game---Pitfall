.text

tela:
	lui $8, 0x1001		# "pincel", onde vai começar a pintar
	
	#verde escuro nas folhas (0x0031 na parte alta, 0x5a18 na parte baixa do $9)
	lui $9, 0x0031		# cor da árvore na parte alta da memória	
	ori $9, $9, 0x5a18      # cor da árvore na parte baixada memória
	
	#2304/4 = 18 (pintando as 18 primeiras linhas do Display)
	addi $10, $0, 2304      # Quantidade total de UG referente folhas
	addi $20, $0, 0         # K = contador

folhas:
	beq $10, $20, segundaparte   # condição de parada, contador ($20) = limite ($10)
	sw $9, 0($8)                 # escreve cor (do $9) no endereço ($8)
	addi $8, $8, 4               # próximo endereço ($8 + 4), pra pintar a prox. UG
	addi $20, $20, 1             # K++
	j folhas

#======================Segunda parte: Tronco e Vegetação======================

segundaparte:
	# endereço base para nova pintura: 0x10012400
	lui $8, 0x1001		     #reposicionando o "pincel"
	addiu $8, $8, 0x2400         # $8 = 0x10012400 inicia nesse endereço na memória
	# 0x2400 porque 2304 UG pintados * 4 = 9216
	#9216 em hexa é 0x2400. Ou seja, tô pulando pra linha após as das folhas
	


	#Adição da cor verde entre arvore | intuito $9 = cor verde
	lui $9, 0x006B               # Cor na parte alta 
	ori $9, $9, 0x9C42           # complementa a cor na parte baixa

	# cor marrom escuro | intuito $10 = cor marrom
	lui $10, 0x004A              # Cor na parte alta(004A)
	ori $10, $10, 0x4A00         # complementa a cor na parte baixa
	
#===============CONSTRUÇÃO DE PAISAGEM===============================================
	
	#Quantidade de linhas usada nessa parte
	addi $11, $0, 18             # objetivo final: 18 linhas
	addi $12, $0, 0              # Iteração, linha atual. Aumentará até atingir a quantidade 18

linhanoloop: #Utilizado 2304 UG (Ponto de partida para nova linha)
	beq $12, $11, terceiraparte     # Se linha atual == 18 vai para rótulo fim_linha:
	

	addi $13, $0, 0             	# no inicio de cada linha, zera o contador de tronco
loop:   				#fazer parte verde e troncos por 3

	beq $13, 3, blocofinalverde #se ja tem 3 troncos, vai pra blocofinalverde
	addi $14, $0, 0 # Zera o contador de UG's verdes
			# Vai iterar até completar 29 verdes
verdebloco:
	beq $14, 29, blocomarrom  #se pintamos 29 UG's verdes, vai pra marrom
	sw $9, 0($8)		  #se não, pinte uma UG de verde
	addi $8, $8, 4		  #avança o "Pincel" pro próximo UG
	addi $14, $14, 1	  # ++ contador de UG verde
	j verdebloco		  #repita

blocomarrom:
	addi $15, $0, 0 # Vai iterar até completar 4 marrom, zera o contador de UG's marrom
marrombloco:
	beq $15, 4, continua #se ja pintou 4 UG's marrom, "continua" a pintar verde
	sw $10, 0($8)	     #se não, pinte uma UG de marrom ($10)
	addi $8, $8, 4	     #avançe o "Pincel"
	addi $15, $15, 1     # ++ contador de UG marrom
	j marrombloco	     #repete

continua:    #após desenhar um tronco, pula pra cá
	addi $13, $13, 1
	j loop

# Após construção do primeiro padrão, vai finalizar a linha com 29 verdes restantes
blocofinalverde: #vamos pintar os 29 UG's verde restantes da linha
	addi $14, $0, 0  #zera o contador de UG verde
verdefinal:
	beq $14, 29, proximalinha #se ja deu os 29, vai pra prox. linha
	sw $9, 0($8)		  #se não, pinta de verde
	addi $8, $8, 4		  #vai pro proximo
	addi $14, $14, 1	  #adiciona 1 no contador de UG verde
	j verdefinal		  #repete

proximalinha:
	addi $12, $12, 1 #Iteração, aumentando e dando continuidade até que chegue em 15
	j linhanoloop    # acaba linha, ++contador de linha e volta pra desenhar a prox. linha

#============inicio da terceira parte==============================
terceiraparte:
	lui $8, 0x1001		#reposicionando o "Pincel"
	addiu $8, $8, 0x4800 	#Acessando esse espaço de memória 
	lui $9, 0x00BD		# cor na parte alta da memória
	ori $9, $9, 0xBD31	# restante da cor na parte baixa
	
	addi $10, $0, 512     # Quantidade total de UG referente solo
	addi $20, $0, 0        # K = contador
	
solo: #512 UGTotal / 128UGLinha  = 4 Linhas
	beq $10, $20, solointerno    #se ja tiver pintado as 4 linhas, vai p solointerno
	sw $9, 0($8)                 # escreve cor no endereço
	addi $8, $8, 4               # próximo endereço
	addi $20, $20, 1             # K++
	j solo
	
solointerno:
	lui $8, 0x1001		#Reposicionando novamente o Pincel
	addiu $8, $8,0x5000 	#Acessando esse espaço de memória 
	lui $9, 0x0084		# cor na parte alta da memória
	ori $9, $9, 0x8418	# restante da cor na parte baixa
	
	addi $10, $0, 512     # Quantidade total de UG referente solo interno (+4 linhas)
	addi $20, $0, 0       # K = contador
	
constsolointerno: 
	beq $10, $20, pretointerno   #se ja tiver acabado, vai p pretointerno
	sw $9, 0($8)                 # escreve cor no endereço
	addi $8, $8, 4               # próximo endereço
	addi $20, $20, 1             # K++
	j constsolointerno
	
pretointerno:
	lui $8, 0x1001		#Reposicionando Pincel
	addiu $8, $8, 0x5800 	#Acessando esse espaço de memória
	addiu $9, $0, 0		#coloca a cor preta no $9

	addi $10, $0, 1536     # Quantidade total de UG referente solo interno (12 Linhas)
	addi $20, $0, 0       # K = contador
constpretointerno: 
	beq $10, $20, soloabaixo     #se acabar, vai pro soloabaixo
	sw $9, 0($8)                 # escreve cor no endereço
	addi $8, $8, 4               # próximo endereço
	addi $20, $20, 1             # K++
	j constpretointerno	     #repete

soloabaixo:
	lui $8, 0x1001		#reposiciona Pincel
	addiu $8, $8, 0x7000 	#Acessando esse espaço de memória
	lui $9, 0x0084		# cor na parte alta da memória
	ori $9, $9, 0x8418	# restante da cor na parte baixa
	
	addi $10, $0, 512     # Quantidade total de UG referente solo interno (4 Linhas)
	addi $20, $0, 0       # K = contador
	
constsolobaixo:
	beq $10, $20, folhasnovas1	     #se ja deu 4 linhas, fim
	sw $9, 0($8)                 # escreve cor no endereço
	addi $8, $8, 4               # próximo endereço
	addi $20, $20, 1             # K++
	j constsolobaixo	     #repete

folhasnovas1: lui $8, 0x1001	     #muda "pincel" de canto
	     addiu $8, $8, 0x2464	     
	     lui $9, 0x0031
	     ori $9, $9, 0x5a18
	     addi $10, $0, 11
	     addi $20, $0, 0
	     
folhasdet1: beq $10, $20, folhasnovas2
	   sw $9, 0($8)
	   addi $8, $8, 4
	   addi $20, $20, 1
	   j folhasdet1
	
folhasnovas2: lui $8, 0x1001	     #muda "pincel" de canto
	     addiu $8, $8, 0x24e8	     #
	     lui $9, 0x0031
	     ori $9, $9, 0x5a18
	     addi $10, $0, 11
	     addi $20, $0, 0
	     
folhasdet2: beq $10, $20, folhasnovas3
	   sw $9, 0($8)
	   addi $8, $8, 4
	   addi $20, $20, 1
	   j folhasdet2
	   
folhasnovas3: lui $8, 0x1001	     #muda "pincel" de canto
	     addiu $8, $8, 0x256c    
	     lui $9, 0x0031
	     ori $9, $9, 0x5a18
	     addi $10, $0, 11
	     addi $20, $0, 0
	     
folhasdet3: beq $10, $20, calca
	   sw $9, 0($8)
	   addi $8, $8, 4
	   addi $20, $20, 1
	   j folhasdet3


# === BONECO ESTÀTICO ===

calca:  lui $9, 0x001e     #cor da calça/pé
	ori $9, $9, 0x6f4f
	
	lui $8, 0x1001		#muda o pincel pra cá
	addiu $8, $8, 0x488c
	
	sw $9, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	sw $9, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	sw $9, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	sw $9, 0($8)  		#pinta a area marcada
	addi $8, $8, 4		#vai pro do lado
	
	addi $8, $8, 508	#pulei para a proxima linha
	sw $9, 0($8)
	
	addi $8, $8, -12	#pintei o inicio da outra perna
	sw $9, 0($8)
	
	addi $8, $8, 512	#pulei para a proxima linha
	sw $9, 0($8)
	
	addi $8, $8, 12		#pintei o inicio da outra perna
	sw $9, 0($8)
	
	addi $8, $8, 4		#pintei a pontinha do pé da frente
	sw $9, 0($8)	
	
	addi $8, $8, -12	#pintei a pontinha do pé de trás
	sw $9, 0($8)
	
	
camisa: lui $9, 0x0056     	#cor da camisa
	ori $9, $9, 0xc44f
	
	lui $8, 0x1001		#muda o pincel pra cá
	addiu $8, $8, 0x408C
	
	sw $9, 0($8)		#pintei o pixel de cima da camisa
	addi $8, $8, 4		#vai pro do lado
	
	sw $9, 0($8)		#pintei o 2 pixel de cima da camisa
	addi $8, $8, 4		#vai pro do lado
	
	sw $9, 0($8)		#pintei o 3 pixel de cima da camisa
	addi $8, $8, 4		#vai pro do lado
	
	sw $9, 0($8)		#pintei o 4 pixel de cima da camisa
	addi $8, $8, 512	#vai pra proxima linha
	
	sw $9, 0($8)		#ultimo pixel da 2 linha
	addi $8, $8, -4
	
	sw $9, 0($8)		#terceiro pixel da 2 linha
	addi $8, $8, -4
	
	sw $9, 0($8)		#segundo pixel da 2 linha
	addi $8, $8, -4
	
	sw $9, 0($8)		#primeiro pixel da 2 linha
	addi $8, $8, -4		#primeiro pixel da mochila na 2 linha
	
	sw $9, 0($8)
	addi $8, $8, 512	#segundo pixel da mochila na linha 3
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 512	#ultima linha da camisa
	
	sw $9, 0($8)
	addi $8, $8, -4
	
	sw $9, 0($8)
	addi $8, $8, -4
	
	sw $9, 0($8)
	addi $8, $8, -4
	
	sw $9, 0($8)
	addi $8, $8, -4
	
	
cabeca: lui $9, 0x00f6     	#cor da pele
	ori $9, $9, 0x8187
	
	lui $8, 0x1001		#muda o pincel pra cá
	addiu $8, $8, 0x3E90
	
	sw $9, 0($8)
	addi $8, $8, -512	#sobe uma linha
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, -512	#sobe outra linha de cabeça
	
	sw $9, 0($8)
	addi $8, $8, -4
	
	sw $9, 0($8)
	addi $8, $8, -4
	
	sw $9, 0($8)
	addi $8, $8, -512
	

cabelo: lui $9, 0x0057     	#cor do cabelo
	ori $9, $9, 0x1c27
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	
# === LOOP's DOS NPC's
	         
cobra01:   jal cobraesq	
	   
FogEsq:    jal fogueiraesq
	   jal delayfog	   
CenFog1:    jal cenariofogueira
	   
	 
FogMeio:   jal fogueirameio
	   jal delayfog
CenFog2:    jal cenariofogueira
	   
	   
FogDir:    jal fogueiradireita
	   jal delayfog  
CenFog3:    jal cenariofogueira
   
	    
FogMeiodnv:   jal fogueirameio
	      jal delayfog
CenFogdnv:    jal cenariofogueira

FogEsqdnv1:    jal fogueiraesq
	       jal delayfog	   
CenFogdnv1:    jal cenariofogueira

cencobra1: jal cencobraesq
cobra02: jal cobradir

	    jal fogueiraesq
	    jal delayfog	   
	    jal cenariofogueira
	
	    jal fogueirameio
	    jal delayfog
	    jal cenariofogueira
	   
	   
	    jal fogueiradireita
	    jal delayfog  
	    jal cenariofogueira
   
	    
	    jal fogueirameio
	    jal delayfog
	    jal cenariofogueira


cencobra2: jal cencobradir
	   j cobra01
	
fim:	
	addi $2, $0, 10
	syscall
	
# ======= FIM DO CENÁRIO =========

# ====== INÍCIO DOS NPC ==========

	
	
cobraesq: lui $9, 0x00a5		#cor da lingua
	  ori $9, $9, 1818
	  
	  
	  lui $8, 0x1001		#muda o pincel pra cá
	  addiu $8, $8, 0x45a8
	   
	  sw $9, 0($8)  		#pinta a area marcada
	  addi $8, $8, 4		#vai pro do lado
	   
	  lui $9 0x0000			#cor da cobra(mudar pra 0 que é preto)
	  sw $9, 0($8)
	  addi $8, $8, 4		#do lado
	   
	  sw $9, 0($8)
	  addi $8, $8, 4		#do lado
	   
	  lui $9, 0xff6b		#cor do fundo verde
	  ori $9, $9, 0x9c42
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 512 		#proxima linha
	  
	  sw $9, 0($8)			#pinta de verde
	  addi $8, $8, -4		#vai voltando 1 ug
	  
	  sw $9, 0($8)			#pinta de verde
	  addi $8, $8, -4		#vai voltando 1 ug
	  
	  sw $9, 0($8)			#pinta de verde
	  addi $8, $8, -4		#vai voltando 1 ug
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  lui $9, 0xff6b		#cor do fundo verde
	  ori $9, $9, 0x9c42
	  sw $9, 0($8)			#pinta de "verde"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)
	  addi $8, $8, 512		#pula de linha
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31		
	  
	  sw $9, 0($8)
	  addi $8, $8, 4		#pro lado
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 512
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 512		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 512		#ultima linha
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  jr $31
	  
cencobraesq: 
	  lui $9, 0x006b		#cor do fundo
	  ori $9, $9, 0x9c42
	  
	  
	   lui $8, 0x1001		#muda o pincel pra cá
	   addiu $8, $8, 0x45A8
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   lui $9, 0x00bd		#cor do piso
	   ori $9, $9, 0xbd31
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   jr $31
	   
cobradir:
          lui $9, 0x00a5		#cor da lingua
	  ori $9, $9, 1818
	  
	  
	  lui $8, 0x1001		#muda o pincel pra cá
	  addiu $8, $8, 0x45AC
	   
	  sw $9, 0($8)  		#pinta a area marcada
	  addi $8, $8, 4		#vai pro do lado
	   
	  lui $9 0x0000			#cor da cobra(mudar pra 0 que é preto)
	  sw $9, 0($8)
	  addi $8, $8, 4		#do lado
	   
	  sw $9, 0($8)
	  addi $8, $8, 4		#do lado
	   
	  lui $9, 0xff6b		#cor do fundo verde
	  ori $9, $9, 0x9c42
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 512 		#proxima linha
	  
	  sw $9, 0($8)			#pinta de verde
	  addi $8, $8, -4		#vai voltando 1 ug
	  
	  sw $9, 0($8)			#pinta de verde
	  addi $8, $8, -4		#vai voltando 1 ug
	  
	  sw $9, 0($8)			#pinta de verde
	  addi $8, $8, -4		#vai voltando 1 ug
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  lui $9, 0xff6b		#cor do fundo verde
	  ori $9, $9, 0x9c42
	  sw $9, 0($8)			#pinta de "verde"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)
	  addi $8, $8, 512		#pula de linha
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31		
	  
	  sw $9, 0($8)
	  addi $8, $8, 4		#pro lado
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 512
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 512		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 512		#ultima linha
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  lui $9 0x0000			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  jr $31
	  
cencobradir:
	  lui $9, 0x006b		#cor do fundo
	  ori $9, $9, 0x9c42
	  
	  
	   lui $8, 0x1001		#muda o pincel pra cá
	   addiu $8, $8, 0x45AC
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   lui $9, 0x00bd		#cor do piso
	   ori $9, $9, 0xbd31
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 4
	   
	   sw $9, 0($8)
	   addi $8, $8, 512
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   sw $9, 0($8)
	   addi $8, $8, -4
	   
	   jr $31
	   
fogueiraesq:
		lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  
	  
	   	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo vermelho
	  	ori $9, $9, 0x0000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo vermelho
	  	ori $9, $9, 0x0000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00         
		
		sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x004A              # cor marrom e ultima linha
		ori $9, $9, 0x4A00 
		
		sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x004A              # cor marrom
		ori $9, $9, 0x4A00 
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	jr $31
	  	
fogueirameio:	lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  
	  
	   	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo vermelho
	  	ori $9, $9, 0x0000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00
		
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00
		
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	jr $31
	  	
fogueiradireita: lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  
	  
	   	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo vermelho
	  	ori $9, $9, 0x0000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo vermelho
	  	ori $9, $9, 0x0000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00ff		#cor do fogo laranja
	  	ori $9, $9, 0xc000
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00
		
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	lui $9, 0x004A              # cor marrom 
		ori $9, $9, 0x4A00
		
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	jr $31
	  	
cenariofogueira:
		 lui $9, 0xff6b		#cor do fundo verde
	  	ori $9, $9, 0x9c42
	  
	   	lui $8, 0x1001		#muda o pincel pra cá
	   	addiu $8, $8, 0x4718
	   	
	   	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	lui $9, 0x00bd		#cor do piso
	  	ori $9, $9, 0xbd31
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, -4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 512
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8, 4
	  	
	  	sw $9, 0($8)
	  	addi $8, $8,512
	  	jr $31



#=== DELAYS ===
delaycobra:
	addi $24, $0, 100000		
lacoD:  beq $24, $0, fimD
        nop
        nop
        addi $24, $24, -1
        j lacoD
fimD:   jr $31

delayfog:
	addi $24, $0, 20000		
lacoD2:  beq $24, $0, fimD2
        nop
        nop
        addi $24, $24, -1
        j lacoD2
fimD2:   jr $31


	   
	  
