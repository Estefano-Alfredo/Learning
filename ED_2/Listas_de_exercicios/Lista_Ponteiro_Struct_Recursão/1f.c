/*
 * f) Apresente o comando para imprimir na tela o valor do campo esq do nó 7 e o endereço onde reside o campo dir do mesmo nó. 
 *    Em ambos os casos, utilize a variável "r" para imprimir os valores requisitados.
 */

 printf("%p %p", (*r)->esq, &((*r)->dir));