/*
 * h) Apresente o comando para remover corretamente o nó 8 da árvore. Utilize a variável "r" para realizar a remoção.
 */

 free((*r)->dir->esq);
 (*r)->dir->esq = NULL;