.data
    # ----------------------------------------
    # File Paths and Messages
    # ----------------------------------------
    input_filename:  .asciiz "frame_(1).pgm"
    output_filename: .asciiz "output.pgm"
    error_msg:       .asciiz "Erro ao abrir o arquivo!\n"
    
    # Mensagens de debug
    prompt_msg:      .asciiz "Lendo a imagem. Largura x Altura: "
    x_msg:           .asciiz " x "
    
    # ----------------------------------------
    # Variables and Buffers
    # ----------------------------------------
    fd_in:  .word 0
    fd_out: .word 0
    width:  .word 0
    height: .word 0
    image_buffer: .word 0

    # ----------------------------------------
    # PGM Header Components
    # ----------------------------------------
    p5_string:      .asciiz "P5\n"
    space_string:   .asciiz " "
    newline_string: .asciiz "\n"
    max_value_string: .asciiz "255\n"
    
    .align 2
    string_buffer: .space 32 # Ensure this buffer is aligned
    
.text
    .globl main
main:
    # 1. Abre o arquivo de entrada
    li $v0, 13              
    la $a0, input_filename
    li $a1, 0               
    syscall
    sw $v0, fd_in           
    bltz $v0, file_error    

    # 2. Lê o cabeçalho do PGM
    lw $a0, fd_in           
    jal read_pgm_header     
    sw $v0, width           
    sw $v1, height          
    
    # ---- Seção de Debug ----
    li $v0, 4
    la $a0, prompt_msg
    syscall
    lw $a0, width
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, x_msg
    syscall
    lw $a0, height
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline_string
    syscall
    # ------------------------

    # 3. Aloca dinamicamente o buffer para os pixels
    lw $t0, width           
    lw $t1, height
    mul $a0, $t0, $t1       
    li $v0, 9               
    syscall
    sw $v0, image_buffer    

    # 4. Lê os dados dos pixels para o buffer alocado
    li $v0, 14              
    lw $a0, fd_in           
    lw $a1, image_buffer    
    lw $t0, width
    lw $t1, height
    mul $a2, $t0, $t1       
    syscall
    
    # 5. Fecha o arquivo de entrada
    li $v0, 16              
    lw $a0, fd_in
    syscall

    # 6. Cria e abre o arquivo de saida
    li $v0, 13              
    la $a0, output_filename
    li $a1, 1               
    li $a2, 0666            
    syscall
    sw $v0, fd_out          
    bltz $v0, file_error    

    # 7. Escreve o cabeçalho no novo arquivo
    lw $a0, fd_out          
    lw $a1, width            
    lw $a2, height           
    jal write_pgm_header
    
    # 8. Escreve os pixels para o novo arquivo
    li $v0, 15              
    lw $a0, fd_out          
    lw $a1, image_buffer    
    lw $t0, width
    lw $t1, height
    mul $a2, $t0, $t1       
    syscall

    # 9. Fecha o arquivo de saida
    li $v0, 16              
    lw $a0, fd_out
    syscall
    
    # 10. Encerra o programa
    li $v0, 10
    syscall

file_error:
    li $v0, 4
    la $a0, error_msg       
    syscall
    li $v0, 10
    syscall

# ----------------------------------------
# Sub-rotina: read_ascii_int (NOVA)
# Reads an ASCII integer from a file.
# ----------------------------------------
read_ascii_int:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 0           # Initialize return value to 0
    li $t0, 0           # t0 = current character
    li $t1, 0           # t1 = buffer
    
read_int_loop:
    li $v0, 14          # Read 1 byte
    li $a2, 1
    addi $a1, $sp, 4    
    syscall
    
    lb $t0, 4($sp)
    
    li $t2, ' '
    beq $t0, $t2, read_int_loop
    li $t2, '\n'
    beq $t0, $t2, read_int_loop
    li $t2, '\t'
    beq $t0, $t2, read_int_loop
    li $t2, '\r'
    beq $t0, $t2, read_int_loop
    
    # Found first digit, process rest
    
    li $v0, 0           # Reset v0 for return value
    
process_digits:
    li $t2, 48
    sub $t3, $t0, $t2
    
    blt $t3, $zero, end_read_int
    bgt $t3, 9, end_read_int
    
    mul $v0, $v0, 10
    add $v0, $v0, $t3
    
    li $t2, 14          # Read next byte
    li $a2, 1
    addi $a1, $sp, 4    
    syscall
    
    lb $t0, 4($sp)
    
    j process_digits

end_read_int:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
# ----------------------------------------
# Sub-rotina: read_pgm_header
# Reads a PGM P5 header and returns dimensions.
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
    
    # --------------------------------------
    # Corrigido: Escrita da largura e altura
    # --------------------------------------
    
    # Converte largura para string
    move $a0, $s1
    la $a1, string_buffer
    jal num_to_string
    
    # Calcula o tamanho da string
    li $t0, 0
    la $t1, string_buffer
count_len_width:
    lb $t2, 0($t1)
    beqz $t2, end_count_len_width
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j count_len_width
end_count_len_width:
    
    # Escreve a largura
    li $v0, 15
    move $a0, $s0
    la $a1, string_buffer
    move $a2, $t0
    syscall
    
    # Escreve o espaco
    li $v0, 15
    move $a0, $s0
    la $a1, space_string
    li $a2, 1
    syscall
    
    # Converte altura para string
    move $a0, $s2           
    la $a1, string_buffer           
    jal num_to_string
    
    # Calcula o tamanho da string da altura
    li $t0, 0
    la $t1, string_buffer
count_len_height:
    lb $t2, 0($t1)
    beqz $t2, end_count_len_height
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j count_len_height
end_count_len_height:
    
    # Escreve a altura
    li $v0, 15
    move $a0, $s0
    la $a1, string_buffer
    move $a2, $t0
    syscall

    # Escreve a newline
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
    
# ----------------------------------------
# Sub-rotina: num_to_string
# Converts an integer to an ASCII string.
# ----------------------------------------
num_to_string:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # The string_buffer is now in .data, no need to allocate on stack
    li $t0, 0               # t0 = counter
    li $t1, 0               # t1 = buffer pointer
    move $t2, $a0           # t2 = number
    li $t5, 10              # t5 = 10 for division
    la $t1, string_buffer   # t1 now points to the aligned buffer

    # Case for 0
    beqz $t2, is_zero_str
    
convert_loop_str:
    div $t2, $t5            # t2 = t2 / 10
    mfhi $t3                # t3 = t2 % 10
    addi $t3, $t3, 48       # Convert to ASCII char
    sb $t3, 0($t1)          # Store the digit
    addi $t1, $t1, 1        # Increment buffer pointer
    addi $t0, $t0, 1        # Increment digit count
    bgtz $t2, convert_loop_str

    j reverse_string

is_zero_str:
    li $t3, 48              # ASCII '0'
    sb $t3, 0($t1)
    addi $t1, $t1, 1
    addi $t0, $t0, 1

reverse_string:
    addi $t1, $t1, -1       # Point to the last character written
    addi $t4, $t0, -1       # t4 = digit count - 1
    la $t2, string_buffer   # t2 = start of the buffer
    li $t3, 0               # t3 = loop counter

reverse_loop_str:
    bge $t3, $t4, end_reverse_str

    lb $t5, 0($t2)          # Load char from start
    lb $t0, 0($t1)          # Load char from end
    sb $t0, 0($t2)          # Swap characters
    sb $t5, 0($t1)
    addi $t2, $t2, 1        # Move start pointer forward
    addi $t1, $t1, -1       # Move end pointer backward
    addi $t3, $t3, 1        # Increment loop counter
    addi $t4, $t4, -1
    j reverse_loop_str

end_reverse_str:
    sb $zero, 0($t1)        # Add null terminator
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra