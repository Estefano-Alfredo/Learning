#__________________
#Guarda Constantes
#__________________
.data
fileName_name: .asciiz "frame_("
fileName_ext: .asciiz ").pgm"
fileName_buffer: .space 17 #buffer que guarna o nome completo do arquivo, guardei uns bytes extras para garantir

# "file descriptor" que retorna do syscall ao abrir arquivo
fd: .word 0 #iniciado com valor 0

# Propriedades da imagem
.align 2 #salvando no começo da próima palavra, para não guardar números em começos "esquisitos" de bits
altura: .word 0 #iniciado com valor 0
largura: .word 0 #iniciado com valor 0
# o total de pixels sera armazenado dinamicamente após calculo altura * largura

#__________________
#Programa Principal
#__________________
.text
.globl main
main:

li $s0, 1 #Frame inicial
##li S01, 20 #frame final

move $a0, $s0
la $a1, fileName_buffer
la $a2, fileName_name
la $a3, fileName_ext

jal monta_fileName

move $a0, $v0
li $v0, 4

syscall
#Montagem do nome do arquivio
#O nome do arquivo tem 3 partes, o "nome" em si, o número do frame, a extensão
#_______________________________
monta_fileName:
#Parámetros
 # $a0 = número do frame
 # $a1 = buffer (onde o nome é concatenado)
 # $a2 = nome do arquivo
 # $a3 = extensão do arquivo

  #Montando nome do arquivo
    #1: Loop que lê cada byte do nome e grava no buffer
     copia_base:
       lb $t1, 0($a2) #carregando byte e salvando no buffer (cada byte é uma letra)
       sb $t1, 0($a1)
       beqz $t1, fim_copia_base
       addi $a1, $a1, 1
       addi $a2, $a2, 1
       j copia_base
     fim_copia_base:
     addi $a1, $a1, -1 #Foi copiado o \0, voltar um garante que ele será sobrescrito
    #2: Adicionando o número do frame ao buffer
     #Salvando registradores que serão sobrescritos
     addi $sp, $sp, -12
     sw $ra, 4($sp) #Endereço de retorno para instância anterior
     sw $a3, 0($sp) #filename_ext
     #converte int para ASCII
     jal int_para_ASCII
     
    #3: Loop que lê cada byte da extensão e grava no buffer      
     #Recuperando endereço de retorno e filename_ext, 
     #não é extritamente necessário pois int_para_ASCII não deveria ter sobrescrito, mas é bom garantir
      lw $a3, 0($sp)
      lw $ra, 4($sp)
      addi $sp, $sp, 12
      
     #Repetindo loop usado para nome do arquivo, mas agora para a extensão
      copia_ext:
       lb $t1, 0($a3) #carregando byte e salvando no buffer (cada byte é uma letra)
       sb $t1, 0($a1)
       beqz $t1, fim_copia_ext
       addi $a1, $a1, 1
       addi $a3, $a3, 1
       j copia_ext
      fim_copia_ext:
      addi $a1, $a1, 1
      li $t0, 0
      sb $t0, 0($a1)
      move $v0, $a1
      
#Conversor de inteiro para ASCII
#_______________________________
int_para_ASCII:
#Parámetros
 # $a0 = Número inteiro
 # $a1 = byte no buffer do nome do arquivo onde o número deve ser inserido
 
 #1: Verifica se número a ser convertido é 0
  beqz $a0, caso_2
  
 #Criando contador e divisor para o caso 2
  li $t0, 0 #(cont = 0)
  li $t1, 10
 
 #2: Se não for 0 é necessário fazer conversão para ASCII, incluidos 1 a 9 pois uma excessão para esses casos não mudaria muito a eficiência 
  caso_1:
    divu $a0, $t1
    mflo $a0 # recebe o quociente da divisão, novo número a ser dividido
    mfhi $t2 # recebe o resto, primeiro número a ser convertido para ASCII e último a ser adicionado ao buffer
  
  #Convertendo o resto e adicionando ao $sp
   addi $t2, $t2, 48 #Converte número para seu representante "decimal" em ASCII
   addi $sp, $sp, -1
   sb $t2, 0($sp) #Guarda valor do primeiro byte no stack (geralmente valores ASCII ocupam apenas 1 BYTE)
   addi $t0, $t0, 1 #cont++
   bgtz $a0, caso_1 #Faz loop mais uma vez se quociente for maior que 0
   
  #Adicionando valores em ASCII para o buffer na ordem inversa em que foram calculados (do último para o primeiro)
  #Assuma que cont é maior que 0 pois entrou no caso 1 e relizou divisão
   add_no_buffer:
     lb $t1, 0($sp)
     sb $t1, 0($a1)
     addi $sp, $sp, 1 #Devolve 1 byte pro SO
     addi $a1, $a1, 1 #Anda para o próximo byte do buffer
     addi $t0, $t0, -1 #cont--
     bgtz $t0, add_no_buffer
     j fim_int_para_ASCII
  
  #Entrando no caso 2
   #soma 48 a 0 e salva o byte
   caso_2: 
     li $t0, 48
     sb $t0, 0($a1)
     addi $a1, $a1, 1 #Anda para o próximo byte do buffer
    
 fim_int_para_ASCII:
 #Retorna para $ra (monta_filename)
  jr $ra
#_______________________________  
  
#Diversos processor
 #1°
 #  Carrega primeiro frame, le a terceira linha e descobre altura, comprimento, n° de pixels, aloca memória para buffer soma de pixels, fecha arquivo
 #2°
 #  Carrega os frames em ordem e soma o valor dos pixels ao seu pixel correspondente no buffer
 #3°
 #  Calcula o valor médio de cinza para cada pixel no buffer
matrixOP:













