/*
 * 2. Apresente um programa em C contendo uma função que realiza uma busca em um vetor de inteiros dado. 
 *    Nada sabe-se sobre o vetor. No entanto, sua função deverá utilizar uma estratégia recursiva que faz lembrar a busca binária
 *    para vetores ordenados: 
 *    i) verifique se a chave está no meio do vetor, se não estiver, 
 *    ii) procure recursivamente a chave dada no subvetor esquerdo e, se não encontrar, 
 *    iii) procure no subvetor direito.]
 *    Tome as suposições típicas de um algoritmo de busca para projetar sua função.
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int *preencheVetor(int k); // função p/ gerar e popular vetor com números aleatórios em ordem crescente, k é quantidade de n°s
int buscaRec(int k, int v[], int ini, int fim);

int main()
{
    int k, seed, tam;

    //mudando a seed para gerar números diferentes em cada execução.
    printf("semente: ");
    scanf("%d", &seed);
    setbuf(stdin, NULL);
    srand(seed);
    
    tam = rand();
    //criando vetor de quantidade de valores aleatórios, e valores inseridos aleatóriamente porém sem repetições
    int *vetor = preencheVetor(tam);

    //buscando chave k
    printf("\nChave: ");
    scanf("%d", &k);
    setbuf(stdin, NULL);


    return 0;
}

int *preencheVetor(int k)
{
    int v[k/2], i, random;
    int usados[k] = {0}; //verifica se um número já foi utilizado

    for(i = 0; i<(k/2); i++)
    {
        //lógica para garantir que os números não são repetidos(random <= k facilita implementar a não repetição)
        do
        {    
            do
            {
                random = rand();
            } while (random >= k);
        }while(usados[random] == 1);
        usados[random] = 1;
        v[i] = random;
    }

    return v;
}

//Assume vetor ordenado segundo dito em enunciado
int buscaRec(int k, int v[], int ini, int fim)
{
    if(!v) return -1;

    int meio = (ini + fim)/2;

    if(v[meio] == k) return meio;

    return 
}