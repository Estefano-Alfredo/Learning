.data
#_________________________________________________
  #msg de debug
    msg_erro: .asciiz "Erro ao abrir o arquivo!\n"
    msg_sucesso: .asciiz "pulado com sucesso.\n"
  
  #Nomes arquivos
    arquivo_output: .asciiz "modelo_de_fundo.pgm"
    arquivo_input: .asciiz "f00.pgm"
    
  #Variaveis de controle
    altura: .word 0
    altura_string: .asciiz "   " #3 bytes
    comprimento: .word 0
    comprimento_string: .asciiz "   " #3 bytes
    quant_pixels: .word 0 #altura * comprimento = quantidade de pixels
    byte_comparacao: .byte 0 #buffer para comparar os bytes nos arquivos
    
  #Ponteiros para os arrays alocados dinamicamente
    ponteiro_matriz_temp: .word 0
    #tempBuffer: .word 0     # Array temporario para o frame atual (1 byte por pixel)
    #outputBuffer: .word 0   # Array para a imagem de saida (1 byte por pixel)
    
    # Strings para o cabecalho PGM
    tipo_pgm: .asciiz "P5\n" #3 bytes
    comentario_arquivo: .asciiz "#De fato deu trabalho, professor!\n" #34 bytes
    espaco: .asciiz " " #1 byte
    pula_linha: .asciiz "\n" #1 bytes
    cinza_maximo: .asciiz "255\n" #4 bytes
    
.text
#_______________________________________
  .globl main
  main:
    
    #guardando dados da imagem (altura, comprimento), calculando quantidade de pixels e alocando memória suficiente para a matriz valor dos pixels
      li $v0, 13
      la $a0, arquivo_input
      li $a1, 0
      syscall
      move $s0, $v0
      bne $s0, -1, aquisicao_dados #se o file descriptor for -1, a abertura de arquivo falhou
      jal erro_abrir_pgm #imprime msg de erro e encerra o programa
      
      aquisicao_dados:
        #Pulando linhas no arquivo até obter os dados importantes
          move $a0, $s0
          jal pula_linha_arquivo #pulando linha, chegamos à linha com as medidas da imagem

        #Procedimento para carregar os dados importantes
        move $a0, $s0
        jal le_altura_comprimento #chama pela primeira vez, vai até o " " depois do comprimento
        sw $v0, comprimento
        
        #lw $a0, comprimento
        #li $v0, 1
        #syscall    
        #li $v0, 4
        #la $a0, pula_linha
        #syscall
        
        move $a0, $s0
        jal le_altura_comprimento #chama pela segunda vez, vai até o "\n" depois da altura
        sw $v0, altura
        
        #lw $a0, altura
        #li $v0, 1
        #syscall    
        #li $v0, 4
        #la $a0, pula_linha
        #syscall


        #escrevendo comprimento e altura em strings para mais tarde colocar no cabeçalho do arquivo de saída
          lw $a0, comprimento
          la $a1, comprimento_string
          jal converte_para_string
          
          #la $a0, comprimento_string
          #li $v0, 4
          #syscall
          #la $a0, pula_linha
          #syscall

          lw $a0, altura
          la $a1, altura_string
          jal converte_para_string
          
          #la $a0, altura_string
          #li $v0, 4
          #syscall
          #la $a0, pula_linha
          #syscall

        #calculando e amazenando quantidade de pixels
          lw $t1, comprimento
          lw $t2, altura
          mul $t0, $t1, $t2 #t0 = comprimento * altura
          sw $t0, quant_pixels #salva a quantidade de pixels em variável reservada

          #alocando memória dinamicamente para a matriz temporária
            li $v0, 9
            lw $t5, quant_pixels
            mul $t5, $t5, 4 #alocando matriz com 4 bytes para cada elemento
            move $a0, $t5 #a0 = quantidade de pixels * 4, (bytes que serão alocadas)
            syscall
            sw $v0, ponteiro_matriz_temp #ponteiro para a memória alocada de altura*comprimento bytes
          
          #preenchendo matriz com 0
            lw $a1, quant_pixels
          jal preenche_matriz_0

      #fechando o arquivo
        li $v0, 16
        move $a0, $s0
        syscall

    #guardando valor dos pixels de cada frame
    li $s1, 20 #quantidade de frames, deve ser atualizado manualmente para outros valores, implementação permite avaliar ate 99 frames
    li $s0, 0 #contador
    loop_pixels:
      #Carrega contador, gera o nome do arquivo que vai ser aberto e salva retorno do procedimento de volta no contador
        beq $s0, $s1, pula_loop_pixels 
        move $a0, $s0
        jal carrega_nome_arquivo
        move $s0, $v0
      
      #Imprime nome do arquivo sendo avaliado e pula linha
        #la $a0, arquivo_input
        #li $v0, 4
        #syscall
        #la $a0, pula_linha
        #syscall

      #Abre frame atual para leitura, salva dados relevantes e fecha o arquivo
        li $v0, 13
        la $a0, arquivo_input
        li $a1, 0
        syscall
        move $s2, $v0 #s2 = file descriptor
        bne $s2, -1, linhas_inuteis #se o file descriptor for -1, a abertura de arquivo falhou
        jal erro_abrir_pgm #imprime msg de erro e encerra o programa

        #Pulando linhas
        linhas_inuteis:
          move $a0, $s2
          jal pula_linha_arquivo #pula "P5"
          jal pula_linha_arquivo #Pula medidas
          jal pula_linha_arquivo #Pula escala de cinza

        #lendo pixel a pixel
        move $a0, $s2
          lw $a1, quant_pixels #quantidade de pixels em 1 frame
          jal preenche_matriz

        #fechando o arquivo
          li $v0, 16
          move $a0, $s2
          syscall

    j loop_pixels
    
    pula_loop_pixels:

    #tirando a média de cada pixel na matriz
      lw $a1, quant_pixels #a1 = quant pixels
      move $a2, $s1 # a2 = quant frames
      jal tira_media

    #gerando arquivo de saída
      #abrindo arquivo de saída
        li $v0, 13
        la $a0, arquivo_output
        li $a1, 1
        syscall
        move $s2, $v0 #s1 = file descriptor
        bne $s2, -1, escreve_cabecalho #se o file descriptor for -1, a abertura de arquivo falhou
        jal erro_abrir_pgm #imprime msg de erro e encerra o programa
        
      #Escrevendo linhas de cabeçalho
        escreve_cabecalho:
          #tipo PGM
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, tipo_pgm #a1 = string
          li $a2, 3 #a2 = quant bytes na string a1
          syscall

          #comentário
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, comentario_arquivo #a1 = string
          li $a2, 34 #a2 = quant bytes na string a1
          syscall

          #tamanho da imagem
          ##comprimento
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, comprimento_string #a1 = string
          li $a2, 3 #a2 = quant bytes na string a1
          syscall
          ##espaço
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, espaco #a1 = string
          li $a2, 1 #a2 = quant bytes na string a1
          syscall
          ##altura
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, altura_string #a1 = string
          li $a2, 3 #a2 = quant bytes na string a1
          syscall
          ##pula linha
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, pula_linha #a1 = string
          li $a2, 1 #a2 = quant bytes na string a1
          syscall

          ##escala de cinza
          li $v0, 15 # v0 = op code do syscall
          move $a0, $s2 #a0 = file descriptor
          la $a1, cinza_maximo #a1 = string
          li $a2, 4 #a2 = quant bytes na string a1
          syscall
        
      #Escrevendo pixels no arquivo
        lw $a1, quant_pixels #a1 = quantidade de pixels
        move $a0, $s2 #a0 = file descriptor
        jal preenche_arquivo

      #fechando arquivo de saída
        li $v0, 16
          move $a0, $s2
          syscall

    exit:
    #Finalizando o programa
      li $v0, 10
      syscall

#--------------PROCEDIMENTOS----------------
#--------Carrega nome arquivo-------------
  #$t0 - nome arquivo frame // $a0-$t1 - contador
  #-----------------------------------------

  carrega_nome_arquivo: 
    #Carrega a string do nome e o contador
      la $t0, arquivo_input #t0 = endereço da string "nome do arquivo de input"
      move $t1, $a0 #t1 = cont
     

    #Verifica qual dos 3 casos o frame atual se encaixa
      bnez $t1, pula_caso_1 #Caso 1 - frame 0: if cont != 0, pular
        addi $t1, $t1, 1 #cont++
        move $v0, $t1 #retorna contador atualizado
        jr $ra
      pula_caso_1:
      
      li $t2, 9 #usado na comparação da linha 64
      bgt $t1, $t2, pula_caso_2 #Caso 2 - frames 1-9: if cont > 9, pular
        move $t3, $t1 #t3 = cont
        addi $t3, $t3, 48 #número segundo a tabela ASCII, entre 0 e 9 é só somar 48
        addi $t0, $t0, 2 #anda na string até o indice a ser alterado
        sb $t3, 0($t0) #adiciona o numero do frame atual na string, no índice apropriado, altera direto no enderço e não precisa salvar
        addi, $t1, $t1, 1 #cont++
        move $v0, $t1 #retorna contador atualizado
        jr $ra
      pula_caso_2:
      
      li $t2, 10 #usado para realizar divisão e pegar os algorismos
      #caso 3 - frames 10 ou maior, meu exemplo usa 20 frames e essa implementação permite avaliar 99 frames
        move $t3, $t1 #t3 = cont
        div $t3, $t2 #(cont/10)
        mfhi $t4 #t4 = resto
        mflo $t3 #t3 = quociente
        addi $t4, $t4, 48 #número segundo a tabela ASCII como resto<10, posso apenar somar 48 e adicionar ao índice correto
        addi $t0, $t0, 2 #anda na string até o indice a ser alterado
        sb $t4, 0($t0)
        div $t3, $t2 #(resto/10)
        mfhi $t4 #t4 = resto, de novo
        addi $t4, $t4, 48 #número segundo a tabela ASCII como resto<10, posso apenar somar 48 e adicionar ao índice correto
        addi $t0, $t0, -1 #anda na string até o indice a ser alterado
        sb $t4, 0($t0) #ambos comandos sb salvam seus resptivivos algorismos nos índices corretos dentro da string
        addi $t1, $t1, 1 #cont++
        move $v0, $t1 #retorna contador atualizado
        jr $ra #return

#--------mensagem de erro e finalizar-------------
  #$a0 - msg de erro // $v0 - op code, syscall
  #-----------------------------------------

  erro_abrir_pgm:
    la $a0, msg_erro
    li $v0, 4
    syscall

    j exit

#--------Salva medidas da imagem-------------
  #$t0 - buffer altura/comprimento // $v0 - op code, syscall // $a0 - file descriptor(parâmetro) // $a1 - byte_comparacao // $a2 - quant bytes lidos por loop
  #-----------------------------------------
  
  le_altura_comprimento:
    li $t0, 0 #t0 = 0, guarda a medida
    li $t2, 32 #32 é ASCII para " "
    li $t3, 10 #10 é ASCII para "\n"
    loop_medida:
      li $v0, 14
      la $a1, byte_comparacao
      li $a2, 1
      syscall #chamado para ler 1 byte do arquivo (1 caracter)
      lb $t1, byte_comparacao #carrega o byte lido
      beq $t1, $t2, pula_medida #se for " " então terminou de ler o comprimento
      beq $t1, $t3, pula_medida #se for "\n" então terminou de ler a altura
      addi $t1, $t1, -48 #converte ASCII para int (0 a 9)
      #guardando no buffer
      li $t4, 10 #t4 = 10
      mul $t0, $t0, $t4 #essa multiplicação garante que os números estarão na casa decimal correta, conforme o loop corre
      add $t0, $t0, $t1
      j loop_medida
      
    pula_medida:
      move $v0, $t0 #retorna valor salvo em t0  
      jr $ra #return

#--------pula linhas no arquivo-------------
  #$v0 - op code, syscall // $a0 - file descriptor(parâmetro) // $a1 - byte_comparacao // $a2 - quant bytes lidos por loop
  #-----------------------------------------

  pula_linha_arquivo:
    li $t0, 10 #10 é \n em ASCII
    li $v0, 14
    la $a1, byte_comparacao
    li $a2, 1
    syscall #chamado para ler 1 byte do arquivo (1 caracter)
    lb $t1, byte_comparacao #carrega o byte lido
    bne $t1, $t0, pula_linha_arquivo #continua lendo até encontrar \n
    jr $ra #return

#--------preenche matriz com 0-------------
  # $a1 - quant pixel
  #-----------------------------------------

    preenche_matriz_0:
      li $t0, 0 #contador de pixels lidos
      move $t1, $a1 #t1 = quant pixels total
      la $t2, ponteiro_matriz_temp #t2 = endereço da matriz
      li $t3, 0 #t3 = 0

      loop_zero:
        beq $t0, $t1, pula_loop_zero #if cont == quant_pixels, return;

        sw $t3, 0($t2) #salva na posição pertinente dentro da matriz

        addi $t0, $t0, 1 #cont++
        addi $t2, $t2, 4 #avança para a próxima palavra da matriz
      j loop_zero

      pula_loop_zero:
       jr $ra #return

#--------preenche matriz com valores dos pixels-------------
  #$v0 - op code, syscall // $a0 - file descriptor(parâmetro) // $a1 - quant pixel
  #-----------------------------------------

    preenche_matriz:
      li $t0, 0 #contador de pixels lidos
      move $t1, $a1 #t1 = quant pixels total
      la $t2, ponteiro_matriz_temp #t2 = endereço da matriz
      
      loop_matriz:
        beq $t0, $t1, pula_loop_matriz #if cont == quant_pixels, return;

        li $v0, 14
        la $a1, byte_comparacao
        li $a2, 1
        syscall #le 1 byte do arquivo
        lb $t3, byte_comparacao #carrega pixel lido no arquivo
        lw $t4, 0($t2) #carrega pixel atual na matriz
        add $t4, $t3, $t4 #t3 = pixel matriz + pixel arquivo
        sw $t4, 0($t2) #salva na posição pertinente dentro da matriz

        addi $t0, $t0, 1 #cont++
        addi $t2, $t2, 4 #avança para o próximo byte da matriz
        j loop_matriz

      pula_loop_matriz:
       jr $ra #return

#--------tira media de cada pixel-------------
  # $a1 - quant pixels // $a2 - quant frames
  #-----------------------------------------

  tira_media:
      li $t0, 0 #contador de pixels lidos
      move $t1, $a1 #t1 = quant pixels total
      move $t3, $a2 #t3 = quant frames
      la $t2, ponteiro_matriz_temp #t2 = endereço da matriz (em word)
      la $t5, ponteiro_matriz_temp #t5 = endereço da matriz (em byte)
      

      loop_media:
        beq $t0, $t1, pula_loop_media #if cont == quant_pixels, return;

        lw $t4, 0($t2) #carrega palavra atual
        div $t4, $t3 #t4 = valor pixel/n° frames
        mflo $t4
        sb $t4, 0($t5) #guarda o valor da média na palavra atual
        addi $t0, $t0, 1 #cont++
        addi $t2, $t2, 4 #avança para a próxima palavra da matriz
        addi $t5, $t5, 1 #avança para o próximo byte da matriz
      j loop_media

      pula_loop_media:
       jr $ra #return

#--------int para string-------------
  # $a0 - inteiro que será convertido // $a1 - string que receberá inteiro convertido
  #-----------------------------------------

  converte_para_string:
    li $t2, 3 #t2 = 3 / cont = 3
    li $t3, 10 #divisor
    move $t0, $a0 #t0 = numero
    move $t1, $a1 #t1 = string vazia
    addi $t1, $t1, 2 #string será preenchida do fim para o começo
    #realizando conversão
      loop_conversao:
      beqz $t2, pula_loop_conversao #if cont == 0, return
      div $t0, $t3 #numero/10
      mflo $t0 #t0 = quociente, será o novo dividendo
      mfhi $t4 #t4 = resto, será gravado na string após conversão
      addi $t4, $t4, 48 #convertido em ASCII
      sb $t4, 0($t1)

      addi $t1, $t1, -1 #string retorna para um byte anterior
      addi $t2, $t2, -1 #cont--
      j loop_conversao
      
    pula_loop_conversao:
      jr $ra #return

#--------preenche arquivo de saida com os pixels da matriz-------------
  #$v0 - op code, syscall // $a0 - file descriptor(parâmetro) // $a1 - quant pixel
  #-----------------------------------------

    preenche_arquivo:
      li $t0, 0 #contador de pixels lidos
      move $t1, $a1 #t1 = quant pixels total
      la $t2, ponteiro_matriz_temp #t2 = endereço da matriz
      move $s6, $a0
     
      loop_arquivo:
        beq $t0, $t1, pula_loop_arquivo #if cont == quant_pixels, return;

        lb $t3, 0($t2) #t3 = pixel atual
        li $v0, 15
        move $a0, $s6
        la $a1, byte_comparacao #a1 = endereço do buffer
        sb $t3, byte_comparacao #buffer = pixel atual
        li $a2, 1
        syscall
       
        addi $t0, $t0, 1 #cont++
        addi $t2, $t2, 1 #avança para o próximo byte da matriz
        j loop_arquivo

      pula_loop_arquivo:
       jr $ra #return
