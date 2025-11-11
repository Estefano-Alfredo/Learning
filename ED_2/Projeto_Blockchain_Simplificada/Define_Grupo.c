#include <stdio.h>
#include <stdlib.h>

int funcaoDeEspalhamento(int ra)
{
    return ra%7;
}

int main()
{
    int ra, flag;
    flag = 0;

    printf("\nra: ");
    scanf("%d", &ra);

    do
    {
        printf("hash: %d", funcaoDeEspalhamento(ra));

        printf("\nTerminar?[1]SIM [0]NAO");
        scanf("%d", &flag);
        ra++;

    } while (flag==0);
    

    return 0;
}