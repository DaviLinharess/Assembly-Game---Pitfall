.text

cencobra:
	  lui $9, 0x006b			#cor da lingua
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
	   
	   
	   
	   
	   
