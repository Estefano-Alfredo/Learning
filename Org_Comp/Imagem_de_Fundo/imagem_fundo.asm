.data
#_________________________________________________
  #msg de erro
    error_msg: .asciiz "Erro ao abrir o arquivo!\n"
  
  #Nomes arquivos
    arquivo_output: .asciiz "output.pgm"
    arquivo_input: .asciiz "f00.pgm"
    
  #Variaveis de controle
    quant_pixels: .word 0
    quant_frames: .word 20 #Escolher manualmente a quanrtidade de frames a serem lidos
    altura: .word 0
    comprimento: .word 0
    
  #Ponteiros para os arrays alocados dinamicamente
    arrayBuffer: .word 0
    tempBuffer: .word 0     # Array temporario para o frame atual (1 byte por pixel)
    outputBuffer: .word 0   # Array para a imagem de saida (1 byte por pixel)
    
    # Strings para o cabecalho PGM
    p5_string: .asciiz "P5\n"
    space_string: .asciiz " "
    newline_string: .asciiz "\n"
    max_value_string: .asciiz "255\n"
    
.text
#_______________________________________
  .globl main
  main:
    
    #Imprimindo nome dos frames
    
    la $s0, arquivo_input #carrega o nome do arquivo (usa-se o endereço para string)
    li $s1, 0 #contador de frames
    
      
    loop_impressao:
      
      j carrega nome arquivo
      
      li $v0, 4
      syscall

#______________________________________
            #PROCEDIMENTOS
#______________________________________
  #--------------Variáveis------------------
  #$a0 - buffer nome frame // $a1 - contador frames
  #-----------------------------------------
  
  carrega nome arquivo:
    #Adquire variáveis passadas como parâmetro
      move $t0, $a0 #t0 = buffer de nome do frame
      move $t1, $a1 #t1 = contador de frames lidos
    
    #Carrega a quantidade de frames
      la $t2, quant_frames
      lw $t2, 0($t2) # $t0 = &($t0) - passa o valor contigo no endereço armazenado em $t0 e sovreescreve $t0 com esse valor
  
    #Verifica qual dos 3 casos o frame atual se encaixa
      bnez $a1, pula_caso_1 #Caso 1 - frame 0 - cont == 0
        addi 
      pula_caso_1
      
      blt $a1, 

    # 2. Inicia o loop principal
    li $s1, 0                # Contador do loop, de 0 a (N-1)
    li $s2, 0                # Flag: 0 = primeira iteração, 1 = iterações subsequentes
    
main_loop:
    bge $s1, $s0, end_processing # Sai do loop se o contador for >= total de frames

    # Obtem o endereço do filename correto do array
    sll $t0, $s1, 2             # Indice do array * 4 bytes por word
    add $t0, $s3, $t0           
    lw $a0, 0($t0)              # Carrega o endereço do filename

    # Abre o arquivo
    li $v0, 13
    lw $a0, 0($t0)  # Passa o endereço do filename
    li $a1, 0               
    syscall
    bltz $v0, file_error
    
    # 3. Lê o cabeçalho e aloca memória APENAS na primeira iteração
    beq $s2, 1, skip_header_read
    
    jal read_pgm_header      
    
    # Aloca memória para os arrays
    mul $t2, $t0, $t1       # $t2 = total de pixels
    
    # Aloca array acumulador (4 bytes por pixel)
    sll $t3, $t2, 2          # $t3 = total de bytes
    li $v0, 9                
    move $a0, $t3            
    syscall                  
    sw $v0, arrayBuffer     # Salva o ponteiro para o array acumulador
    
    # Aloca array temporario (1 byte por pixel)
    li $v0, 9
    move $a0, $t2
    syscall
    sw $v0, tempBuffer      # Salva o ponteiro para o array temporario

    # 4. Zera o array acumulador
    lw $s4, arrayBuffer   # <--- USANDO NOVO REGISTRADOR $s4
    li $t0, 0
    li $t6, 0
zero_loop:
    beq $t0, $t3, end_zero_loop
    sw $t6, 0($s4)
    addi $s4, $s4, 4
    addi $t0, $t0, 4
    j zero_loop
end_zero_loop:

    # Marca a flag para pular a leitura do cabeçalho nas próximas iterações
    li $s2, 1
    
skip_header_read:
    # Lê os dados da imagem para o buffer temporário
       mul $a2, $t0, $t1       # Número de bytes a ler (total de pixels)
    syscall

    # 5. Loop interno para somar os pixels
    lw $s2, tempBuffer      # $s2 = ponteiro para o buffer temporario
    lw $s4, arrayBuffer     # $s4 = ponteiro para o array acumulador
    li $t0, 0                # Indice do pixel (começa em 0)

sum_pixels_loop:
    mul $t3, $t1, $t2
    beq $t0, $t3, end_sum_loop  # Se o indice for igual ao total de pixels, encerra o loop

    # Carrega 1 byte (pixel) do buffer temporario
    lb $t1, 0($s2)            

    # Calcula o endereco no array acumulador
    sll $t4, $t0, 2             # Indice * 4 para o array de words
    add $t5, $s4, $t4           

    # Carrega 1 word (a soma atual)
    lw $t6, 0($t5)            

    # Soma e armazena o resultado
    add $t6, $t6, $t1           
    sw $t6, 0($t5)            

    # Incrementa e repete
    addi $s2, $s2, 1            # Incrementa ponteiro do buffer temporario
    addi $t0, $t0, 1            # Incrementa o indice
    j sum_pixels_loop
    
end_sum_loop:
    li $v0, 16
    syscall
    
    # Incrementa o contador e volta para o início do loop
    addi $s1, $s1, 1        
    
end_processing:
    # 6. Alocar buffer para a imagem final (1 byte por pixel)
    mul $t2, $t0, $t1       
    
    li $v0, 9                
    move $a0, $t2            
    syscall                  
    sw $v0, outputBuffer     # $s5 = endereco do buffer de saida

    # 7. Loop para calcular a média e salvar em um novo buffer de bytes
    lw $s5, outputBuffer     # $s5 = ponteiro de saida
    lw $s4, arrayBuffer      # $s4 = ponteiro para o array acumulador
    li $t0, 0                # $t0 = indice
    
calculate_average_loop:
    mul $t3, $t1, $t2
    beq $t0, $t3, end_average_loop # Se o indice for igual ao total, encerra

    # Calcula o endereco no array acumulador
    sll $t4, $t0, 2            
    add $t5, $s4, $t4          
    
    # Carrega o valor e divide pela quantidade de frames
    lw $t6, 0($t5)            
    div $t6, $s0              
    mflo $t6                  
    
    # Armazena o byte no buffer de saida
    sb $t6, 0($s5)            
    
    addi $s5, $s5, 1
    addi $t0, $t0, 1
    j calculate_average_loop
    
end_average_loop:
    # 8. Criar e abrir o arquivo de saida
    li $v0, 13
    li $a1, 1                
    li $a2, 0666             
    syscall
    move $s6, $v0           

    # 9. Escrever o cabecalho
    move $a0, $s6           
    jal write_pgm_header
    
    # 10. Escrever os dados dos pixels
    mul $t2, $t0, $t1
    li $v0, 15
    move $a0, $s6           
    lw $a1, outputBuffer      
    move $a2, $t2
    syscall

    # 11. Fechar o arquivo e terminar o programa
    li $v0, 16
    move $a0, $s6
    syscall
    
    li $v0, 10
    syscall

file_error:
    li $v0, 4
    la $a0, error_msg       
    syscall
    li $v0, 10
    syscall

# ----------------------------------------
# Sub-rotina: num_to_string
# Converte um inteiro para uma string ASCII
# Entrada: $a0 = numero, $a1 = endereco do buffer de saida
# Saida: $v0 = endereco do buffer de saida
# ----------------------------------------
num_to_string:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Salva registradores temporarios que serao usados
    addi $sp, $sp, -24
    sw $t0, 20($sp)
    sw $t1, 16($sp)
    sw $t2, 12($sp)
    sw $t3, 8($sp)
    sw $t4, 4($sp)
    sw $t5, 0($sp)

    move $t0, $a0           # t0 = numero
    move $t1, $a1           # t1 = buffer
    li $t2, 0               # t2 = contador de digitos
    li $t5, 10              # t5 = 10 para divisao

    # Caso especial para 0
    beqz $t0, is_zero
    
convert_loop:
    div $t0, $t5            # t0 = t0 / 10
    mfhi $t3                # t3 = t0 % 10
    addi $t3, $t3, 48       # Converte para char ASCII
    sb $t3, 0($t1)          # Armazena o digito no buffer
    addi $t1, $t1, 1        # Incrementa o ponteiro do buffer
    addi $t2, $t2, 1        # Incrementa o contador de digitos
    bgtz $t0, convert_loop  # Continua ate que t0 seja 0

    j reverse_string

is_zero:
    li $t3, 48              # ASCII '0'
    sb $t3, 0($t1)
    addi $t1, $t1, 1
    addi $t2, $t2, 1

reverse_string:
    addi $t1, $t1, -1       # Aponta para o ultimo caractere escrito
    addi $t4, $t2, -1       # t4 = contador de digitos - 1
    move $t0, $a1           # t0 = inicio do buffer
    li $t3, 0               # t3 = contador de loop

reverse_loop:
    bge $t3, $t4, end_reverse

    lb $t5, 0($t0)          # Carrega caractere do inicio
    lb $t2, 0($t1)          # Carrega caractere do fim
    sb $t2, 0($t0)          # Troca os caracteres
    sb $t5, 0($t1)
    addi $t0, $t0, 1        # Move ponteiro do inicio para frente
    addi $t1, $t1, -1       # Move ponteiro do fim para tras
    addi $t3, $t3, 1        # Incrementa contador de loop
    addi $t4, $t4, -1
    j reverse_loop

end_reverse:
    sb $zero, 0($t1)        # Adiciona o caractere nulo
    
    lw $t0, 20($sp)
    lw $t1, 16($sp)
    lw $t2, 12($sp)
    lw $t3, 8($sp)
    lw $t4, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 24

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    move $v0, $a1           # Retorna o endereço do buffer
    jr $ra
    
# ----------------------------------------
# Sub-rotina: read_ascii_int
# Lê um número do arquivo como string e converte para inteiro.
# Entrada: $a0 = descritor de arquivo
# Saida: $v0 = o número lido
# ----------------------------------------
read_ascii_int:
    addi $sp, $sp, -8        
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    move $s0, $a0
    li $t0, 0                
    
read_char_loop:
    li $v0, 14
    move $a0, $s0
    addi $a1, $sp, 8        
    li $a2, 1
    syscall
    
    beq $v0, $zero, end_read_ascii_int

    lb $t1, 8($sp)          
    
    li $t3, ' '
    beq $t1, $t3, read_char_loop
    li $t3, '\t'
    beq $t1, $t3, read_char_loop
    li $t3, '\n'
    beq $t1, $t3, read_char_loop
    li $t3, '\r'
    beq $t1, $t3, read_char_loop

    sub $t3, $t1, 48         
    
    blt $t3, $zero, not_a_digit
    bgt $t3, 9, not_a_digit
    
    mul $t0, $t0, 10
    add $t0, $t0, $t3
    j read_char_loop
    
not_a_digit:
    move $v0, $t0            
    
    lw $ra, 4($sp)          
    lw $s0, 0($sp)
    addi $sp, $sp, 8
    jr $ra

end_read_ascii_int:
    move $v0, $t0
    
    lw $ra, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 8
    jr $ra
    
# ----------------------------------------
# Sub-rotina: read_pgm_header
# Lê o cabeçalho de um arquivo PGM P5 e retorna as dimensoes.
# Entrada: $a0 = descritor de arquivo
# Saida: $v0 = largura, $v1 = altura
# ----------------------------------------
read_pgm_header:
    addi $sp, $sp, -8        
    sw $ra, 4($sp)           
    sw $s0, 0($sp)
    
    move $s0, $a0           
    
    li $v0, 14              
    move $a0, $s0           
    addi $a1, $sp, 8        
    li $a2, 3               
    syscall
    
read_comment:
    li $v0, 14
    move $a0, $s0           
    addi $a1, $sp, 8        
    li $a2, 1
    syscall
    
    beq $v0, $zero, end_read_comment

    lb $t0, 8($sp)
    bne $t0, '#', end_read_comment

    read_comment_line:
        li $v0, 14
        move $a0, $s0       
        addi $a1, $sp, 8    
        li $a2, 1
        syscall
        lb $t0, 8($sp)
        bne $t0, '\n', read_comment_line
    j read_comment

end_read_comment:
    move $a0, $s0           
    jal read_ascii_int
    move $v0, $v0           
    
    move $a0, $s0           
    jal read_ascii_int
    move $v1, $v0           
    
    move $a0, $s0           
    jal read_ascii_int
    
    lw $ra, 4($sp)          
    lw $s0, 0($sp)
    addi $sp, $sp, 8        
    jr $ra

# ----------------------------------------
# Sub-rotina: write_pgm_header
# Escreve o cabecalho PGM para um arquivo de saida.
# Entrada: $a0=descritor de arquivo, $a1=largura, $a2=altura
# ----------------------------------------
write_pgm_header:
    addi $sp, $sp, -4        
    sw $ra, 0($sp)
    
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    
    # Escreve a string "P5\n"
    li $v0, 15
    move $a0, $s0
    la $a1, p5_string       
    li $a2, 3               
    syscall
    
    # Converte largura para string e escreve
    addi $sp, $sp, -32      # Aloca espaco para o buffer da largura
    move $a0, $s1
    move $a1, $sp
    jal num_to_string
    
    li $v0, 15
    move $a0, $s0
    move $a1, $sp           
    li $a2, 0
    
get_width_len:
    lb $t0, 0($a1)
    beqz $t0, end_width_len
    addi $a2, $a2, 1
    addi $a1, $a1, 1
    j get_width_len
end_width_len:
    syscall
    
    # Escreve o espaco apos a largura
    li $v0, 15
    move $a0, $s0
    la $a1, space_string
    li $a2, 1
    syscall
    
    # Converte altura para string e escreve
    move $a0, $s2           
    move $a1, $sp           
    jal num_to_string
    
    li $v0, 15
    move $a0, $s0
    move $a1, $sp
    li $a2, 0
    
get_height_len:
    lb $t0, 0($a1)
    beqz $t0, end_height_len
    addi $a2, $a2, 1
    addi $a1, $a1, 1
    j get_height_len
end_height_len:
    syscall

    # Libera o espaco do buffer da stack
    addi $sp, $sp, 32       

    # Escreve a linha apos a altura
    li $v0, 15
    move $a0, $s0
    la $a1, newline_string
    li $a2, 1
    syscall

    # Escreve o valor maximo
    li $v0, 15
    move $a0, $s0
    la $a1, max_value_string
    li $a2, 4
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
