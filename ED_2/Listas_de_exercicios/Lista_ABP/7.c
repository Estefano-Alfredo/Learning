//  7) Apresente um programa que faz uma busca em uma árvore binária. Note que a árvore não necessariamente é de pesquisa.

/*
 * Ideia: 
 *  Passo 1) travessia para a esquerda
 *  Passo 2) visita
 *  Passo 3) travessia para a direita
 */
#include <stdio.h>
#include <stdlib.h>

void emOrdem(TNoAB *raiz, int chave)
{
    if(!raiz) return;
    
    emOrdem(raiz->esq, chave);    
    if(raiz->chave == chave) printf("Nó encontrado no endereço: %p", &(raiz->chave));
    emOrdem(raiz->dir, chave);
}