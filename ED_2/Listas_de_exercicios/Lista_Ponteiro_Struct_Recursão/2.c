/*
 * 2) Apresente um programa em C contendo uma função que realiza uma busca em um vetor de inteiros dado. 
 *    Nada sabe-se sobre o vetor. No entanto, sua função deverá utilizar uma estratégia recursiva que faz lembrar a busca binária
 *    para vetores ordenados: 
 *    i) verifique se a chave está no meio do vetor, se não estiver, 
 *    ii) procure recursivamente a chave dada no subvetor esquerdo e, se não encontrar, 
 *    iii) procure no subvetor direito.
 *    Tome as suposições típicas de um algoritmo de busca para projetar sua função.
 */

#include <stdio.h>
#include <stdlib.h>

void preencheVetor(int k, int v[]); //função p/ popular vetor, k é tamanho do vetor.
int buscaTipoRec(int v[], int chave, int ini, int fim);

int main()
{
    int tam, vetor[100], chave;
    tam = 100;

    //gerando valores para o vetor
    preencheVetor(tam, vetor);

    //travessia e pesquisa pela chave
    printf("Informar chave: ");
    scanf("%d", &chave);
    //chave = buscaTipoRec(vetor, chave, 0, tam - 1); //reutilizando chave, não precisa de mais variável

    //verificando resultado
    printf("indice: %d, chave: %d", chave, vetor[chave]);

    return 0;
}

void preencheVetor(int tam, int v[])
{
    int i;

    for(i = 0; i<tam; i++)
    {
        v[i] = i;
        printf("\n%d", v[i]);
    }
}

int buscaTipoRec(int v[], int chave, int ini, int fim)
{
    int meio = (ini + fim)/2; //elemento central do vetor (passo 1 da busca segundo enunciado)
    
    //caso base (vetor vazio), retorna erro
    if(ini > fim) return -1;

    //match (visita)(se casou chave com valor no vetor), retorna índice
    if(v[meio] == chave) return meio;

    buscaTipoRec(v, chave, ini, meio -1); //travessia à esquerda
    buscaTipoRec(v, chave, meio + 1, fim); //travessia à direita

    //retorna -1 depois da exaustão
    return -1;
}