// 6) Apresente um programa que remove o menor nó de uma árvore binária de pesquisa.

TNoABP **buscaMenor(TNoABP **raiz); //retorna ponteiro de ponteiro do nó procurado
{
    if(!raiz) return NULL;
    if(!(*raiz)) return NULL;
    if((*raiz)->esq == NULL) return raiz;
    else return buscaMenor(&((*raiz)->esq), chave);
}

void removeMenor(TNoABP **raiz, int chave)
{
    TNoABP **noAlvo = buscaMenor(raiz, chave); //busca pelo ponteiro de ponteiro do nó a ser removido
    TNoABP *filho = NULL;

    //Caso 1: Nó folha
    if((*raiz)->dir == NULL) //não checa o lado esquerdo, pois o menor nó por definição de uma ABP não pode ter filho esquerdo
    {
        free(*noAlvo);
        *noAlvo = NULL;
    }
    //Case 2: 1 filho, não haverá caso com 2 filhos pois por definição o menor nó não tem filho esquerdo em uma ABP
    else
    {
        filho = (*noALvo)->dir; //var filho recebe o nó filho de noAlvo
        free(*noAlvo);
        *noAlvo = filho; //noAlvo agora tem o conteudo de nó filho
        return;
    }

}