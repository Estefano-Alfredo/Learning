/*
 * 3) Apresente um programa eficiente em C contendo uma função que realiza uma busca em um vetor de inteiros dado. 
 *    Assuma que segunda metade do vetor está ordenada.
 *    Tome as suposições típicas de um algoritmo de busca para projetar sua função.
 */

#include <stdio.h>
#include <stdlib.h>

void preencheVetor(int tam, int v[]);
int buscaMeioaMeio(int v[], int chave, int ini, int fim);
int buscaEsq(int v[], int chave, int ini, int fim);
int buscaDir(int v[], int chave, int ini, int fim);

int main()
{
    int v[100], chave = 100, ind;
    preencheVetor(100, v);

    ind = buscaMeioaMeio(v, chave, 0, 99);
    printf("indice retornado: %d", ind);
    if(ind != -1) printf("\nconfere v[%d]: %d", ind, v[ind]);
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

int buscaEsq(int v[], int chave, int ini, int fim)
{
    if(ini>fim) return -1; //caso base
    if(v[fim] == chave) return fim;
    return buscaEsq(v, chave, ini, fim - 1);
}

int buscaDir(int v[], int chave, int ini, int fim)
{
    int meio = (ini + fim)/2;

    if(ini>fim) return -1; //caso base
    if(v[meio] == chave) return meio;
    if(v[meio]<chave) return buscaDir(v, chave, meio+1, fim);
    else return buscaDir(v, chave, ini, meio-1);
    
}

int buscaMeioaMeio(int v[], int chave, int ini, int fim)
{

    if(ini>fim) return -1; //caso base

    int meio = (ini + fim)/2;
    if(v[meio] == chave) return meio;

    if(fim%2 == 0) //se fim for par, meio fica na segunda metade e portanto está dentro da parte ordenada
    {
        if(v[meio]<chave) return buscaDir(v, chave, meio+1, fim);
        return buscaEsq(v, chave, ini, meio-1);
    }
    
    /*
     * Se fim for ímpar, não entra na condicional. Meio fica exatamente na metade do vetor.
     * Como não sabemos se o elemento do meio faz parte da metade ordenada, empurramos o meio pra direita (meio+1)
     * e assim ele estará na metade ordenada.
     */
    meio++;
    if(v[meio] == chave) return meio;
    if(v[meio]<chave) return buscaDir(v, chave, meio+1, fim);
    else return buscaEsq(v, chave, ini, meio-2);
}