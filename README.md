Projeto de Arquitetura de Computadores



Pitfall Game

1. Para Jogar, faça o download o MIPS MARS 4.5, disponível em: https://drive.google.com/file/d/1bDiW40e8NAa9rSw_EKw2VwsTk15AacNk/view

2. Defina o Display em: 4x4 Unit Pixels, 512 Width x 256 Height Display

3. Abra o arquivo "index.asm" e divirta-se!



Criação

Para a criação do cenário, simulei um cenário todo no excel, pintando os seus blocos de cores com seus respectivos espaços de memória. Logo em seguida, passei para o arquivo "index.asm", em que, no momento, só haveria o cenário.



Após isso, criei de forma estática o Boneco principal do jogo e + 2 NPC's, sendo eles a Fogueira e a Cobra. Após realizar um laço o qual os NPC ficariam constantemente se mexendo, adaptei o mesmo para que a cada frame de movimento dos NPC's fosse conferido se o Jogador teclou algo no teclado. Com isso, criei a movimentação do personagem principal, na qual em seguida seria implementado o sistema de colisão entre Personagem e NPC, para que o jogo estivesse 100% funcional.