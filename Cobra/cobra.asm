##TENTATIVA DE PINTAR A COBRA
#SEU BLOCO VAI SER 6X6
#lingua vai ser $9 0x00a51818
#verdefundo vai ser $17 0x6b9c42

.text
	
	
cobra:   lui $9, 0x00a5			#cor da lingua
	  ori $9, $9, 1818
	  
	  
	   lui $8, 0x1001		#muda o pincel pra cá
	   addiu $8, $8, 0x45a8
	   
	   sw $9, 0($8)  		#pinta a area marcada
	   addi $8, $8, 4		#vai pro do lado
	   
	   lui $9 0xffff		#cor da cobra(mudar pra 0 que é preto)
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
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
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
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
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
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  sw $9, 0($8)
	  addi $8, $8, -4
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
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
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, 4		# vai pro lado
	  
	  lui $9, 0x00bd		#cor do piso
	  ori $9, $9, 0xbd31
	  sw $9, 0($8)
	  addi $8, $8, 4
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
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
	  
	  lui $9 0xffff			#muda pra cor da cobra (mexer pra preta dnv)
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
	  
	  sw $9, 0($8)			#pinta de "preto"
	  addi $8, $8, -4		# vai pro lado
