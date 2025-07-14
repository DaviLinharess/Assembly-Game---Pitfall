##TENTATIVA DE PINTAR O BONECO

.text

calca:  lui $9, 0x001e     #cor da cal�a/p�
	ori $9, $9, 0x6f4f
	
	lui $8, 0x1001		#muda o pincel pra c�
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
	
	addi $8, $8, 4		#pintei a pontinha do p� da frente
	sw $9, 0($8)	
	
	addi $8, $8, -12	#pintei a pontinha do p� de tr�s
	sw $9, 0($8)
	
	
camisa: lui $9, 0x0056     	#cor da camisa
	ori $9, $9, 0xc44f
	
	lui $8, 0x1001		#muda o pincel pra c�
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
	
	lui $8, 0x1001		#muda o pincel pra c�
	addiu $8, $8, 0x3E90
	
	sw $9, 0($8)
	addi $8, $8, -512	#sobe uma linha
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, 4
	
	sw $9, 0($8)
	addi $8, $8, -512	#sobe outra linha de cabe�a
	
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
	
	
	