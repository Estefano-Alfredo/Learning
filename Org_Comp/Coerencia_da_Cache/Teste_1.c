#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

typedef struct cor
{
    unsigned int r, g, b;
} cor;
#define TAM 20000

int main()
{
    //Variáveis de tempo
    double ti, tf, tempo; //ti = tempo inicial // tf = tempo final
    ti = tf = tempo = 0;
    struct timeval tempo_ini, tempo_fim;
    
    //Variáveis de dados
    int i, j;
    cor *matrizCor = (cor *)malloc(TAM*TAM*sizeof(cor));
    if(matrizCor == NULL) //verificando alocação dinâmica
    {
        printf("Falha na alocação da matriz");
        return 1;
    }

    //Preenchendo matriz e verificando tempo total de operação:
    gettimeofday(&tempo_ini, NULL); //Tempo quando começaram os acessos

    for (i = 0; i < TAM; i++)
    {
        for (j = 0; j < TAM; j++)
        {
            matrizCor[i*TAM+j].r = 255;
            matrizCor[i*TAM+j].g = 255;
            matrizCor[i*TAM+j].b = 255;            
        }
    }

    //Impressão dos valores, utilizado apenas para teste da implementação
    /*
    for (i = 0; i < TAM; i++)
    {
        for (j = 0; j < TAM; j++)
        {
            printf("%d %d - ", i, j);
            printf("%d ", matrizCor[j*TAM+i].r);
            printf("%d ", matrizCor[j*TAM+i].g);
            printf("%d\n", matrizCor[j*TAM+i].b);
        }
    }
    */

    gettimeofday(&tempo_fim, NULL); //Tempo ao término dos acessos

    //cálculo \delta tempo (tempo final - inicial, resultado dado em miliegundos)
    ti = (double)tempo_ini.tv_usec + ((double)tempo_ini.tv_sec * (1000000.0)); //convertido em microsegundos
    tf = (double)tempo_fim.tv_usec + ((double)tempo_fim.tv_sec * (1000000.0)); //convertido em microsegundos
    tempo = (tf-ti)/1000; //convertido em milisegundos
    printf("%.3f\n", tempo);

    free(matrizCor);
    return 0;
}