.text
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
	  	
		