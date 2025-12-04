// Bibliotecas
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mtwister.h"
#include <openssl/sha.h> // SHA256 functions enabler
#include <openssl/crypto.h> // SHA256_DIGEST_LENGTH enabler

/* Gerando seed - posicionar a seed globalmente facilita utilização de funções */
#define SEED_VALUE 1234567
MTRand seed;

#define QUANT 15 // quantidades de blocos a minerar, usado para testes

/* 
 * ---------------------------------------------------------
 *                   Structs dos blocks 
 * ---------------------------------------------------------
 */

typedef struct blockNotMined
{
    unsigned int num; // 4
    unsigned int nonce; // 4
    unsigned char data[184]; // initialize with 0s
    unsigned char previousHash[SHA256_DIGEST_LENGTH]; // 32
}blockNotMined;

typedef struct minedBlock
{
    blockNotMined block;
    unsigned char hash[SHA256_DIGEST_LENGTH]; 
    struct minedBlock *nextBlock;
    struct minedBlock *previousBlock;
}minedBlock;

/* 
 * ---------------------------------------------------------
 *                   List of function headers 
 * ---------------------------------------------------------
 */

void fillWithZeros(blockNotMined *block); /* preenche os campos 'data' e 'previoushash' com ZEROS*/
void miningOp(blockNotMined* currentBlock, unsigned char* hash); /* realiza mineração do bloco e atualiza na main o hash passado como ponteiro */
void updateWallet(unsigned int carteira[], blockNotMined block); /* atualiza carteira após minerar bloco */
int randomMiner(); /* escolhe um endereço aleatóriamente // random + 1 */
/* escolhe um endereço aleatóriamente dentro dos que tem bitcoin > 0 // função usada apenas em genBlocks() // random + 1 */
int randomMinerNotPoor(int cont, int notzero[]);
int amtOfCrypto(int balanco);
int amtOfTransactions(); /* aleatóriamente escolhe quantidade de transações em um bloco // random + 1 */

blockNotMined genGenesys(blockNotMined block); // random + 1
int genBlocks(blockNotMined* block, unsigned char hash[], unsigned int carteira[]); // gera próximo bloco

void printHash(unsigned char hash[], int length);
void printData(unsigned char data[], int length);
void printBlock(blockNotMined block);
void printblockchain(minedBlock *blockchain);

// Functions for lists

minedBlock* allocateBlock();
minedBlock* createMined(blockNotMined block, unsigned char hash[]);
minedBlock *insertIntoChain(blockNotMined block, unsigned char hash[], minedBlock* blockchain);

/* 
 * ---------------------------------------------------------
 *                   Main application 
 * ---------------------------------------------------------
 */

int main()
{
    seed = seedRand(SEED_VALUE);

    int state[5] = {0, 0, 0, 0, 0}; 
    /*
     * Guarda os estados, importante para prosseguir a partir de onde o programa parou em sua última execução
     * state[0] = guarda a quantidade de vezes que o randomizador rodou
     * state[1] = número do último bloco minerado
     * state[2] = hash do último bloco minerado
     * state[3] = 
     */
    
    /* 
     * guarda quantidade de números randomizados na última execução das funções pertinentes
     * deve descarregar seu valor em state[0] após o bloco ser minerado
     */
    int random = 0;
    unsigned int nonce;
    unsigned char hash[SHA256_DIGEST_LENGTH];
    blockNotMined currentBlock; // guarda o novo bloco gerado para minerá-lo
    minedBlock *blockchain = NULL; // começa a blockchain vazia

    /* 
     * bitcoin wallet
     * A carteira começa vazia
     */
    unsigned int carteira[256]; // cada índice é o endereço de um minerador
    int i;   
    for(i=0; i<256; i++) carteira[i] = 0; // carteira iniciada em 0
    for(i=0; i<QUANT; i++)
    {
        /* ---Mining Genesys block--- */
        if(!blockchain)
        {
            currentBlock = genGenesys(currentBlock);
            miningOp(&currentBlock, hash);
            // printHash(hash, SHA256_DIGEST_LENGTH);
            blockchain = insertIntoChain(currentBlock, hash, blockchain); // insering bloco genesis ao blockchain
            state[0]++; // incrementando o número de vezes que foi gerado um número randomico durante os processos do bloco genesis
            carteira[currentBlock.data[183]] = 50; // atualizando carteira       
        }
        else
        {
            random += genBlocks(&currentBlock, hash, carteira);     
            miningOp(&currentBlock, hash);
            insertIntoChain(currentBlock, hash, blockchain);
            updateWallet(carteira, blockchain->previousBlock->block);
            int j, sum = 0;
            printf("carteira:");
            for(j=0; j<256; j++) 
            {
                sum += carteira[j];
                printf(" %d: %d |", j, carteira[j]);
            }
            printf("\n\n sum: %d", sum);
        }
    }
    state[0] += random;
    printf("random = %d\n\n", state[0]);
    // printblockchain(blockchain);

    return 0;
}

/* 
 * ---------------------------------------------------------
 *                   List of functions
 * ---------------------------------------------------------
 */

// Setup and mining functions 
void fillWithZeros(blockNotMined *block) /* preenche os campos 'data' e 'previoushash' com ZEROS*/
{
    int i;
    for(i=0; i<184; i++)
    {
        block->data[i] = 0;
        if(i<SHA256_DIGEST_LENGTH) block->previousHash[i] = 0;
    }
}

void miningOp(blockNotMined* currentBlock, unsigned char* hash)
{
    int nonce = 0;

    do
    {
        currentBlock->nonce = nonce;
        SHA256((unsigned char*)currentBlock, sizeof(blockNotMined), hash);
        // printHash(hash, SHA256_DIGEST_LENGTH);
        nonce++;
    }while (hash[0] != 0);
    // printHash(hash, SHA256_DIGEST_LENGTH);
}

void updateWallet(unsigned int carteira[], blockNotMined block)
{
    int i, end1, end2, val;

    printBlock(block);
    
    for(i=0; i<183; i+=3)
    {
        end1 = block.data[i];
        end2 = block.data[i+1];
        val = block.data[i+2];
        printf("end1: %d | end2: %d | val: %d // ", end1, end2, val);
        carteira[end1] -= val;
        carteira[end2] += val;
    }
    carteira[block.data[183]] = 50;
}

int randomMiner() /* escolhe um endereço aleatóriamente // random + 1 */
{
    return ((int)(genRand(&seed)*1000))%256; // existem 256 endereços no total
}

/* escolhe um endereço aleatóriamente dentro dos que tem bitcoin > 0 // função usada apenas em genBlocks() // random + 1 */
int randomMinerNotPoor(int cont, int notzero[])
{ 
    int val = notzero[((int)(genRand(&seed)*1000))%cont];
    return val; // existem 256 endereços no total
}

int amtOfCrypto(int balanco) // retorna quantidade aleatória de bitcoins <= a 'balanco' // função usada apenas em genBlocks()
{
    balanco++;
    return ((int)(genRand(&seed)*1000))%balanco;
}

int amtOfTransactions() /* aleatóriamente escolhe quantidade de transações em um bloco // random + 1 */
{
    return ((int)(genRand(&seed)*1000))%62; // máximo de 61 transações por bloco
}

// Generation functions
blockNotMined genGenesys(blockNotMined block) // random + 1
{
    int i;
    unsigned char phrase[70] = "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks";
    block.num = 1;
    block.nonce = 0;
    fillWithZeros(&block); // preenche 'data' e 'previousHash' com 0
    memcpy((void*)block.data, (void*)phrase, 69); // preenche a frase padrão do bloco genesis em 'data'

    block.data[183] = randomMiner(); // insere minerador genesis
    
    return block;
}

int genBlocks(blockNotMined* block, unsigned char hash[], unsigned int carteira[]) // gera próximo bloco
{
    int i;
    unsigned int copiaCarteira[256];
    memcpy((void*)copiaCarteira, (void*)carteira, sizeof(int)*256);
    int cont = 0; // começa em 0 e após o FOR conterá a quantidade de endereços que tem bitcoin > 0
    int notZero[256]; // guarda os endereços que tem bitcoins > 0 começando em notzero[0]
    for(i=0; i<256; i++)
    {
        if(copiaCarteira[i] != 0)
        {
            notZero[cont] = i;
            cont++;
        }
    }
    block->num += 1; // incremente o número do bloco para o próximo valor
    block->nonce = 0;
    fillWithZeros(block);
    // preenche novo bloco
    memcpy((void* )block->previousHash, (void* )hash, SHA256_DIGEST_LENGTH);
    block->data[183] = randomMiner(); // random + 1
    int random = 1;

    int j = 0;
    int end1, end2, balanco;
    int quant = amtOfTransactions(); // quantidade de transações no bloco (0 ~ 61)
    random++;
    for(i=0; i<quant; i++)
    {
        end1 = randomMinerNotPoor(cont, notZero); // quem está transferindo bitcoins
        end2 = randomMiner(); // quem está recebendo bitcoins
        balanco = copiaCarteira[end1]; // quantos bitcoins o minerador em end1 tem
        block->data[j] = end1;
        j++;
        block->data[j] = end2;
        j++;
        if(balanco == 0)
        {
            block->data[j] = 0; // quantos bitcoins estão sendo transferidos]
            random += 2;
        }
        else 
        {
            int transactionValue = amtOfCrypto(balanco);
            balanco = copiaCarteira[end1] -= transactionValue;
            block->data[j] = copiaCarteira[end2] = transactionValue;
            random += 3;
        }
        j++;
    }
    // printBlock(*block);
    return random;
}

// Printing functions
void printHash(unsigned char hash[], int length)
{
    int i;
    for(i=0;i<length;++i)
        printf("%02x", hash[i]);
    printf("\n");
    printf("\n");

    /* for(i=0;i<length;++i)
        printf("%d", hash[i]);
    printf("\n"); */
}

void printData(unsigned char data[], int length)
{
    int i, n=0;
    if(data[0] == 'T')
    {
        for(i=0;i<length;++i)
            printf("%c", (char)data[i]);
        printf("...  ...%d", data[183]);
        printf("\n");
    }
    else
    {
        for(i=0;i<length;++i)
        {
            if(n == 3)
            {
                printf("\\ ");
                n = 0;
            }
            printf("%d ", data[i]);
            n++;
        }
            
        printf("\n");
    }
}

void printBlock(blockNotMined block)
{
    printf("num = %d // nonce = %d\ndata:\n", block.num, block.nonce);
    printData(block.data, 184);
    printf("hash anterior:\n");
    printHash(block.previousHash, SHA256_DIGEST_LENGTH);
}

void printblockchain(minedBlock *blockchain)
{
    int flag = 0;
    printf("\n");
    while(flag<1)
    {
        printBlock(blockchain->block);
        printf("hash:\n");
        printHash(blockchain->hash, SHA256_DIGEST_LENGTH);
        blockchain = blockchain->nextBlock;
        if(blockchain->block.num == 1) flag++;
    }
}

// Simple List functions
minedBlock* allocateBlock()
{
    minedBlock* block = (minedBlock*)malloc(sizeof(minedBlock));
    if(!block) return NULL;
    block->nextBlock = NULL;
    block->previousBlock = NULL;
    return block;
}

minedBlock* createMined(blockNotMined block, unsigned char hash[])
{
    minedBlock* chainBlock = allocateBlock();  // aloca espaço na memória para bloco minerado
    if(!chainBlock) return NULL;
    memcpy((void*)&(chainBlock->block), (void*)&block, sizeof(blockNotMined)); // copia bloco minerado
    memcpy((void*)chainBlock->hash, (void*)hash, SHA256_DIGEST_LENGTH); // copia hash com 00
    return chainBlock;
}

minedBlock *insertIntoChain(blockNotMined block, unsigned char hash[], minedBlock* blockchain)
{
    minedBlock* chainBlock = createMined(block, hash);
    if(!chainBlock)
    {
        printf("Falha na alocação do bloco");
        return NULL;
    }

    if(!blockchain)
    {
        chainBlock->nextBlock = chainBlock->previousBlock = chainBlock;
        return chainBlock;
    }

    // insere novo bloco no blockchain, NÃO é necessário usar o retorno
    blockchain->previousBlock->nextBlock = chainBlock;
    chainBlock->previousBlock = blockchain->previousBlock;
    chainBlock->nextBlock = blockchain;
    blockchain->previousBlock = chainBlock;
    return chainBlock; // retorna endereço do novo bloco
}