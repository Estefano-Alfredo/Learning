// nó padrão
typedef struct BSTNode
{
    int key;
    struct BSTNode *left; //filho esquerdo
    struct BSTNode *right; //filho direito
}BSTNode;

/*
 * funções da ABP
 */


// Módulo de travessia

 // pré ordem
void preOrderBST(BSTNode **root)
{
    if(*root)
    {
        //visita

        preOrderBST(&((*root)->left));

        preOrderBST(&((*root)->right));
    }
}

 // em ordem
void inOrderBST(BSTNode **root)
{
    if(*root)
    {   
        inOrderBST(&((*root)->left));

        //visita

        inOrderBST(&((*root)->right));
    }
}

 // pós ordem
void postOrderBST(BSTNode **root)
{
    if(*root)
    {
        postOrderBST(&((*root)->left));

        postOrderBST(&((*root)->right));

        //visita
    }
}

// Módulo de busca

  // Função de busca em ABP
BSTNode **searchInBST(int key, BSTNode **root)
{
    if(*root == NULL) return NULL; //caso base (árvore vazia)

    if((*root)->key == key) return root; //compara chave

    //avança para o próximo nó
    if((*root)->key > key) return SearchInBST(key, &((*root)->left));
    else return SearchInBST(key, &((*root)->right));
}

  // Função menor nó
BSTNode **smallestBST(BSTNode **node)
{
    while (*node && (*node)->left) node = &((*node)->left);
    return node;
}

  // Função maior nó
BSTNode **biggestBST(BSTNode **node)
{
    while (*node && (*node)->right) node = &((*node)->right);
    return node;
}

// Módulo inserção
  // Função de busca para inserção em ABP
BSTNode **searchForBSTInsert(int key, BSTNode **root)
{
    if(*root == NULL) return root; //caso base (árvore vazia)

    if((*root)->key == key) return NULL; //compara chave

    //avança para o próximo nó
    if((*root)->key > key) return searchForBSTInsert(key, &((*root)->left));
    else return searchForBSTInsert(key, &((*root)->right));
}

  // Função de alocação de nó em ABP
BSTNode **allocateBSTNode(int key, BSTNode **node)
{
    *node = (BSTNode *)malloc(sizeof(BSTNode));
    if(*node == NULL) return NULL;
    (*node)->key = key;
    (*node)->left = NULL;
    (*node)->right = NULL;
    return node;
}

  // Função para inserção de nó em ABP
BSTNode *InsertBSTNode(int key, BSTNode **root)
{
    root = searchForBSTInsert(key, root);
    if(root == NULL) return NULL; //chave já existe
    return allocateBSTNode(key, root); //aloca e retorna novo nó ou nulo se a alocação falhar
}

// Módulo remoção

 // Função de remoção de nó em ABP
void rmovBSTNode(int key, BSTNode **node)
{
    node = searchInBST(key, node); // busca o nó a ser removido
    if(node != NULL)
    {
        // nó com 1 ou nenhum filho
        if((*node)->left == NULL)
        {
            BSTNode *temp = (*node)->right;
            free(*node);
            *node = temp;
        }

        if((*node)->right == NULL)
        {
            BSTNode *temp = (*node)->left;
            freeBSTNode(*node);
            *node = temp;
        }

        // nó com dois filhos
        if((*node)->left && (*node)->right)
        {
            BSTNode **smallest = SmallestBST(&((*node)->right)); // procura o menor dos maiores
            (*node)->key = (*smallest)->key;
            rmovBSTNode((*smallest)->key, smallest);
        }

    }
}

  // Função para remover a ABP
  void rmovAllBST(BSTNode **root)
{
    if(*root)
    {
        postOrderBST(&((*root)->left));

        postOrderBST(&((*root)->right));   

        free(*root);
    }

    *root = NULL;
}
