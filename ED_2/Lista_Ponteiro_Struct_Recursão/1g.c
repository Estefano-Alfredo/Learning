/*
 * g) Apresente o comando para remover corretamente o nó 8 da árvore. Utilize a variável "raiz" para realizar a remoção.
 */

 free(raiz->dir->esq);
 raiz->dir->esq = NULL;