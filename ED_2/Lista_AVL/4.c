/*
 * 4) À semelhança da questão 3, implemente cada um dos procedimentos de rotação dupla da AVL e da árvore splay.
 */

//Serão utilizadas as funções: FB(), retacaoEsq() e rotacaoDir() implementados no exercício 3) dessa mesma lista

int rotaçãoEsqDir(TNoAVL **pp)
{
    //realizamos a primeira rotação e atualizamos o FB do pai do nó dado como parâmetro para a rotação
    (*pp)->fb = FB(rotacaoEsq(&((*pp)->esq))) + FB((*pp)->dir);
    return rotaçãoDir(pp);
}

int rotaçãoDirEsq(TNoAVL **pp)
{
    //realizamos a primeira rotação e atualizamos o FB do pai do nó dado como parâmetro para a rotação
    (*pp)->fb = FB(rotacaoDir(&((*pp)->dir))) + FB((*pp)->esq);
    return rotaçãoEsq(pp);
}