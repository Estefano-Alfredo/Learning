#include <stdio.h>
#include <stdlib.h>

// nó padrão AVL
typedef struct AVLNode
{
    int key;
    struct AVLNode *left;  // filho esquerdo
    struct AVLNode *right; // filho direito
    int BF; // Fator de Balanceamento
}AVLNode;

/*
 * funções da AVL
 */

// Módulo de travessia

 // pré ordem
void preOrderAVL(AVLNode **root)
{
    if (*root)
    {
        // [VISITA] 
        
        preOrderAVL(&((*root)->left));

        preOrderAVL(&((*root)->right));
    }
}

 // em ordem
void inOrderAVL(AVLNode **root)
{
    if (*root)
    {
        inOrderAVL(&((*root)->left));

        // [VISITA]

        inOrderAVL(&((*root)->right));
    }
}

 // pós ordem
void postOrderAVL(AVLNode **root)
{
    if (*root)
    {
        postOrderAVL(&((*root)->left));

        postOrderAVL(&((*root)->right));

        // [VISITA]
    }
}

// Módulo de rotação
 /*
  * Função de análise do fator de balanceamento
  * (polui o código implementar essa funcionalidade em todas as funções)
  */
int checkBalanceFactor(AVLNode *node)
{
    if(!node) return 0;
    return node->BF;
}

 /*
  * Função de aritmética de fator de balanceamento
  * (atualiza o fator de balanceamento do no inserido)
  */
void updateBF(AVLNode **node)
{
    (*node)->BF = checkBalanceFactor((*node)->right) - checkBalanceFactor((*node)->left);
}

 // Função de rotação simples para a esquerda
int rotateLeft(AVLNode **node)
{
    // manejando ponteiros
    AVLNode **pivot = &((*node)->right); // pivô da rotação
    AVLNode *temp = (*pivot)->left
    (*pivot)->left = *node; // rotação do nó com fator de balanceamento 2
    *node = *pivot; // pivô se torna raiz da subárvore
    (*node)->right = temp; // reposicionando o filho esquerdo do pivô

    // manejando fatores de balanceamento
     // fator do nó que estava desequilibrado
    updateBF(&((*node)->left));

     // fator do nó que foi pivô
    updateBF(node);

    return (*node)->BF;
}

 // Função de rotação simples para a direita
int rotateRight(AVLNode **node)
{
    // manejando ponteiros
    AVLNode **pivot = &((*node)->left); // pivô da rotação
    (*node)->left = (*pivot)->right; // reposicionando o filho esquerdo do pivô
    (*pivot)->right = *node; // rotação do nó com fator de balanceamento 2
    *node = *pivot; // pivô se torna raiz da subárvore

    // manejando fatores de balanceamento
     // fator do nó que estava desequilibrado
    (*node)->right->BF = richeckBalanceFactor((*node)->right->right) - checkBalanceFactor((*node)->right->left);

     // fator do nó que foi pivô
    (*node)->BF = checkBalanceFactor((*node)->right) - checkBalanceFactor((*node)->left);

    return (*node)->BF;
}

 // função de rotação composta esquerda direita
int rotateLR(AVLNode **node)
{
    rotateLeft(&((*node)->left));
    rotateRight(node);
}

 // função de rotação composta direita esquerda
int rotateRL(AVLNode **node)
{
    rotateRight(&((*node)->right));
    rotateLeft(node);
}

// Módulo de busca

 // Função de busca em AVL
AVLNode **searchInAVL(int key, AVLNode **root)
{
    if (*root == NULL)
        return NULL; // caso base (árvore vazia ou chave não encontrada)

    if ((*root)->key == key) // verifica chave e retorna nó caso encontrada
        return root; 

    // avança para o próximo nó
    if ((*root)->key > key)
        return searchInAVL(key, &((*root)->left));
    else
        return searchInAVL(key, &((*root)->right));
}

 // Função menor nó 
 // (busca pelo menor nó na subárvore referenciada como parâmetro)
AVLNode **smallestAVL(AVLNode **node) 
{
    while (*node && (*node)->left)
        node = &((*node)->left);
    return node;
}

 // Função maior nó
AVLNode **biggestAVL(AVLNode **node)
{
    while (*node && (*node)->right)
        node = &((*node)->right);
    return node;
}

// Módulo inserção

 // Função de alocação de nó em AVL
AVLNode *allocateAVLNode(int key)
{
    AVLNode *node = (AVLNode *)malloc(sizeof(AVLNode));
    if (!node)
        return NULL;
    node->key = key;
    node->left = NULL;
    node->right = NULL;
    node->FB = 0; // inicializa o Fator de Balanceamento com 0
    return node;
}

 // Função para inserção de nó em AVL
int insertAVLNode(int key, AVLNode **root)
{
    if (*root == NULL)
    {
        *root = allocateAVLNode(key);
        if(*root == NULL) return -2; // avisa que o problema foi alocar memória
        return 1;
    }

    if ((*root)->key == key)
        return -1; // AVisa que o problema foi a chave já existir

    if ((*root)->key > key)
    {
        int growth = insertAVLNode(key, &((*root)->left)); // avança para o próximo nó
        if(growth <= 0) return growth; // se FBFromChild < 0, então ocorreu erro ou não houve crescimento

        // verificando qual é a dinâmica na FB
        if(abs((*root)->BF -= growth) == 1) return 1; // houve mudança na altura

        /*
         * se chegou até aqui, então está desbalanceado
         * (como está vindo da esquerda, o fator "quebrado" sempre será -2)
         */
        if((*root)->left->BF < 0) return rotateRight(root); // sinais iguais -> rotação símples
        else return rotateLR(root);
    }

    else
    {
        int growth = insertAVLNode(key, &((*root)->right)); // avança para o próximo nó
        if(growth <= 0) return growth; // se FBFromChild < 0, então ocorreu erro ou não houve crescimento

        // verificando qual é a dinâmica na FB
        if(abs((*root)->BF += growth) == 1) return 1; // houve mudança na altura

        /*
         * se chegou até aqui, então está desbalanceado
         * (como está vindo da direita, o fator "quebrado" sempre será +2)
         */
        if((*root)->left->BF < 0) return rotateLeft(root); // sinais iguais -> rotação símples
        else return rotateRL(root);
    }
}

// Módulo remoção
// Função de remoção de nó em AVL
// ATENÇÃO: Esta função *não* implementa o balanceamento de AVL após a remoção.
void rmovAVLNode(int key, AVLNode **node)
{
    node = searchInAVL(key, node); // busca o nó a ser removido
    if (node != NULL)
    {
        // A lógica de remoção (if/else if/else) precisa ser corrigida 
        // para evitar falha de segmentação, conforme a análise anterior.
        
        // nó com 1 ou nenhum filho
        if ((*node)->left == NULL)
        {
            AVLNode *temp = (*node)->right;
            free(*node);
            *node = temp;
        }
        else if ((*node)->right == NULL) // Corrigido para 'else if'
        {
            AVLNode *temp = (*node)->left;
            free(*node); // Corrigido: era freeBSTNode, agora é free
            *node = temp;
        }

        // nó com dois filhos
        else 
        {
            AVLNode **smallest = SmallestAVL(&((*node)->right)); // procura o menor dos maiores
            (*node)->key = (*smallest)->key;
            // A chamada recursiva deve remover o nó sucessor.
            rmovAVLNode((*smallest)->key, smallest);
        }
        
        // EM AVL: AQUI entra a verificação e rotação (balanceamento)
    }
}

// Função para remover a AVL
void rmovAllAVL(AVLNode **root)
{
    if (*root)
    {
        // Chamadas recursivas para remoção (Pós-Ordem)
        rmovAllAVL(&((*root)->left));

        rmovAllAVL(&((*root)->right));

        // Libera o nó atual
        free(*root);
    }

    *root = NULL; // Importante: Garante que a raiz original seja NULL
}