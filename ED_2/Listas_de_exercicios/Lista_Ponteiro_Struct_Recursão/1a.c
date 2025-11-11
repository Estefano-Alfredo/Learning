/*
 * a) Apresente um programa em C que reproduz o diagrama de memória dado. 
 *    Coloque todos os comandos na função main. Forneça você mesmo a struct adequada para o exemplo.
 */

#include <stdio.h>
#include <stdlib.h>

typedef struct Tno
{
    int chave;
    struct Tno *esq;
    struct Tno *dir;

}Tno;

int main()
{
    Tno *raiz = NULL;
    
    //No chave = 7
    raiz = malloc(sizeof(Tno)); //Não utilizarei cast em nenhum malloc, o tipo da variável funciona de forma semelhante (segundo o professor).
    if(raiz)
    {
        raiz->chave = 7;
        raiz->esq = NULL;
        raiz->dir = NULL;
    }
    else return -1;

    //No chave = 5.
    raiz->esq = malloc(sizeof(Tno));
    if(raiz->esq)
    {
        raiz->esq->chave = 5;
        raiz->esq->esq = NULL;
        raiz->esq->dir = NULL;
    }
    else return -1;

    //No chave = 2.
    raiz->esq->esq = malloc(sizeof(Tno));
    if(raiz->esq->esq)
    {
        raiz->esq->esq->chave = 2;
        raiz->esq->esq->esq = NULL;
        raiz->esq->esq->dir = NULL;
    }
    else return -1;

    //No chave = 6.
    raiz->esq->dir = malloc(sizeof(Tno));
    if(raiz->esq->dir)
    {
        raiz->esq->dir->chave = 6;
        raiz->esq->dir->esq = NULL;
        raiz->esq->dir->dir = NULL;
    }
    else return -1;

    //No chave = 9.
    raiz->dir = malloc(sizeof(Tno));
    if(raiz->dir)
    {
        raiz->dir->chave = 9;
        raiz->dir->esq = NULL;
        raiz->dir->dir = NULL;
    }
    else return -1;

    //No chave = 8.
    raiz->dir->esq = malloc(sizeof(Tno));
    if(raiz->dir->esq)
    {
        raiz->dir->esq->chave = 8;
        raiz->dir->esq->esq = NULL;
        raiz->dir->esq->dir = NULL;
    }
    else return -1;
    
    return 0;
}