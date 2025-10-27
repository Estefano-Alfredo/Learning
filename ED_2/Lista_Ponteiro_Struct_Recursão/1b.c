/*
 * b) Apresente o comando para imprimir na tela o endereço de memória do nó raiz 7 e o endereço da variável "raiz".
 *    Em ambos os casos, utilize a variável "raiz" para imprimir os valores requisitados.
 */

//imprime o endereço do nó raiz 7, através de raiz.
printf("%p", raiz);

//outra forma (descobri isso estudando para a lista).
#include <stddef.h> //para habilitar size_t e offsetof.

//na main, assumindo que OS forneceu memória para raiz = malloc e que raiz é um Tno padrão de ABP passado em sala.
size_t nbytes = offsetof(Tno, chave); //size_t é um tipo que recebe um "integer" representando distançia e offsetof encontra esse valor.
char *praiz = (char *)raiz; //essa operação é explicada na linha 17
praiz = (char *)(praiz + nbytes); 
printf("%p", praiz);
/*
 * Char ocupa 1 byte, o cast para char permite que a soma na aritimética de ponteiros adicione exatamente o valor de nbytes.
 * Nesse caso a operação é supérflua uma vez que chave compartilha o mesmo endereço da struct
 * e este esta diretamente armazenado em raiz.
 * Esse tipo de operação pode ser útil quando um código requer precisão na manipulação de bytes.
 */


//imprime o endereço de raiz, através de raiz.
printf("%p", &raiz); 

