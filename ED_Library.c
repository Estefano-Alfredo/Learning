//____________________-----------Biblioteca de Códios Pré Digitados-----------____________________

/*
 * Esse arquivo serve de repositório para armazenar funções e tipos abstratos criados por mim
 */

 //Nó padrão para ABP
typedef struct Tno
{
    int chave;
    struct Tno *dir; //filho esquerdo
    struct Tno *esq; //filho direito
}Tno;

//Função Busca Recursiva em ABP
Tno *buscaRecABP(int k, Tno *raiz)
{
    if(!raiz) return -1; //caso base (árvore vazia)

    if(raiz->chave == k) return raiz; //compara chave

    //avança para o próximo nó
    if(raiz->chave > k) return buscaRecABP(k, raiz->esq);
    else return buscaRecABP(k, raiz->dir);
}