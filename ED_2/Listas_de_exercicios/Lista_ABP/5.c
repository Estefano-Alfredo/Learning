/*
 * 5) Apresente um programa que preenche uma árvore binária de pesquisa com um milhão de chaves geradas aleatoriamente. 
 *    Após cada inserção, grave em um arquivo de textos a quantidade de nós da árvore e a altura da árvore. 
 *    Gere um arquivo PDF contendo o gráfico quantidade de nós vs altura e uma breve discussão indicando se 
 *    a árvore pode ser considerada tão rápida quanto a busca binária em um vetor ordenado ou não. 
 *    DICA: você pode manter uma variável chamada altura (inicializada com valor -1)
 *    e atualizá-la toda vez que o nó recém-inserido for colocado em um nível maior que a variável altura.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//struct utilizada, guarda o nível do nó para ajudar a registrar no arquivo.
typedef struct BSTnode
{
    int key;
    int depth;
    struct BSTnode *left;
    struct BSTnode *right;
}BSTnode;

BSTnode **BSTSearch(BSTnode **root, int key, int *depth);
BSTnode *BSTMalloc(int key, int depth);

int main()
{
    BSTnode *root = NULL, **nextNode = NULL;

    int key, i, hight = -1, amountNode = 0, depth = -1;

    FILE *report = fopen("treeReport.txt", "w");
    if(report == NULL) return -1;
    fprintf(report, "Quantidade,Altura\n", amountNode, hight); 

    srand(68296723); 

    for(i=0; i<1000000; i++)
    {
        key = rand()%2000000;
        while (!(nextNode = BSTSearch(&root, key, &depth))) //enquanto não tiver um lugar para o novo nó (se a chave for repetida)
        {
            key++; //soma + 1 a chave até não encontrar repetição
        }

        //incluindo nó na árvore
        depth++; //o nível na variavel é do nó anterior ao novo, subir em 1

        *nextNode = BSTMalloc(key, depth);

        amountNode++; //quantidade de nós

        if(depth>hight) hight++; //Se o nível for mais que a altura, então a altura tem que aumentar
        fprintf(report, "%d,%d\n", amountNode, hight); //registrando no relatório
    }

    fclose(report);
    return 0;
}

/*
 * Busca onde a chave deve ser incluida, se já houver chave com o mesmo valor retorna NULL.
 * Nível(depth) tem seu valor guardado por referencia facilitando encontrar o nível do próximo nó
 */
BSTnode **BSTSearch(BSTnode **root, int key, int *depth)
{
    if(!(*root)) return root;
    *depth = (*root)->depth;
    if((*root)->key == key) return NULL;

    if((*root)->key < key) return BSTSearch(&((*root)->right), key, depth);
    else return BSTSearch(&((*root)->left), key, depth);
}

/*
 * Gera um nó folha e retorna endereço do nó alocado ou null.
 */
BSTnode *BSTMalloc(int key, int depth)
{
    BSTnode *node = malloc(sizeof(BSTnode));
    if(!node) return NULL;

    node->key = key;
    node->depth = depth;
    node->left = NULL;
    node->right = NULL;

    return node;
}

