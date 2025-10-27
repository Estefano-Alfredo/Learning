/* 8) Apresente um programa para ordenar um vetor dado. Seu programa necessariamente deverá utilizar uma árvore binária 
 *    de pesquisa como estratégia intermediária da ordenação. DICA: use uma travessia em ordem para preencher o vetor ordenado. 
 *    Discuta e compare o desempenho deste algoritmo de ordenação com o algoritmo QuickSort.
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
 
typedef struct TNoABP
{
    int chave;
    struct TNoABP *esq;
    struct TNoABP *dir;
}TNoABP;

TNoABP *insereNo(TNoABP **no, int chave);
void emOrdemOrganizar(TNoABP *raiz, int vetor[], int *i);

int main()
{
    int vetor[11] = {10, 43, 12, 0, 33,2, 9,222, 54, 4, 32}, i;
    TNoABP *raiz = NULL;

    //vetor conhecido de tamanho 11
    for(i = 0; i < 11; i++)
    {
        insereNo(&raiz, vetor[i]);
    }

    //ordenando o vetor
    i = 0;
    emOrdemOrganizar(raiz, vetor, &i);

    //imprimindo o vetor para testar resultado
    for(i = 0; i < 11; i++)
    {
        printf("-%d", vetor[i]);
    }
        
    return 0;
}

TNoABP *insereNo(TNoABP **raiz, int chave)
{
    assert(raiz != NULL);
    if(*raiz == NULL)
    {
        *raiz = (TNoABP *)malloc(sizeof(TNoABP));
        if(*raiz == NULL) return NULL;

        (*raiz)->chave = chave;
        (*raiz)->dir = NULL;
        (*raiz)->esq = NULL;

        return *raiz;
    }

    if(chave < (*raiz)->chave) return insereNo(&((*raiz)->esq), chave);
    else return insereNo(&((*raiz)->dir), chave);
}
 
void emOrdemOrganizar(TNoABP *raiz, int vetor[], int *i)
{
    if(!raiz) return;

    emOrdemOrganizar(raiz->esq, vetor, i);
    vetor[*i] = raiz->chave;
    *i += 1;
    emOrdemOrganizar(raiz->dir, vetor, i);
}