/*
 * 4) Apresente uma função que recebe o ponteiro para um nó de uma árvore binária de pesquisa
 *    e devolve 1 se o nó for folha ou zero caso contrário. 
 *    A entrada será um ponteiro para um nó de uma árvore binária de pesquisa. 
 *    Lembre que uma árvore pode ser vazia. Apresente a struct.
 */

//Struct utilizada para resolução do exercício
typedef struct BSTnode
{
    int key;
    struct BSTnode *left;
    struct BSTnode *right;
}BSTnode;

//Função de decisão (ou folha ou ntem filhos/vazio)
int TypeNode( BSTnode *node)
{
    /*
     * O if analisa cada condição da esquerda para a direita, para assim que encontra o primeiro retorno não nulo
     * e parte para o bloco de execução em seguida. 
     */
    if(!node || node->left || node->right) return 0;
    else return 1;
}