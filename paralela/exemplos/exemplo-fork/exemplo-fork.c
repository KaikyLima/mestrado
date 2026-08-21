#include <stdio.h>
#include <stdlib.h>

int main( ){
	int  pai;
    int  valor = 0;
 	
	pai = fork( );
    if (pai){ /* este trecho é executado pelo pai */
        printf("Eu Sou o Processo Pai %d \n", pai);
        valor = 5;
        printf("Valor: %d \n", valor);
    }
    else { /* este trecho é executado pelo filho */
        printf("Eu Sou o Processo Filho %d \n", pai);
        valor = 10;
        printf("Valor: %d \n", valor);
    }
    exit(0);
}
