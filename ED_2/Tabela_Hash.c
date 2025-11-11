#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define M xxx // quantidade de buckets // Recomenda-se que M seja o menor número primo maior que o n estimado
#define A 0.618// constante auxiliar para método da multipliação // $A=\frac{sqrt(5)-1}{2}=0.618$ sugerido por Knuth

// Strutura complexa de dados
struct bucket
{
    int chave;
    
}bucket;


// Funções de espalhamento
 // Método da divisão
int divMethodHashFunct(double x) return (x % M);
 // Método da multiplicação
int MulMethodHashFunct(double x) 
{
    return floor(M*((x*A)%1));
}

// Resolução de colição
 // Linear probing
int linearProbing(int x, )