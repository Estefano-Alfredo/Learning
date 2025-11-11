#include <stdio.h>
#include <stdlib.h>

// parâmetros tabela e métodos
#define SIZE 11 //números primos são mais adequados
#define EMPTY -1
#define A 0.618

// structs
typedef struct Node
{
    int key;
    struct  Node *next;
} Node;

typedef struct Bucket
{
    int key;
} Bucket;

// métodos hash
int divHASH(int key) // método de divisão
{
    return key % SIZE;
}

int multiHASH(int key) // método de multiplicação
{
    float index = (float)key * A;
    index = index - (long)index;
    return (int)(SIZE * index);
}