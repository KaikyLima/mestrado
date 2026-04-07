#include "lista2.h"
#include <stdio.h>
#include <math.h>


void lerVetor(int vetor[], int tamanho){
    printf("Digite %d numeros inteiros \n", tamanho);
    for (int i = 0; i < tamanho; i++){
        scanf("%d", &vetor[i]);
    }
    imprimirInverso(vetor, tamanho);
}   

void imprimirInverso(int vetor[10], int tamanho){
    printf("Vetor na ordem inversa: \n");
    for (int i = tamanho - 1; i >= 0; i--){
        printf("%d ", vetor[i]);
    }
    printf("\n");
}

float calcularMedia(int vetor[], int tamanho){
    int soma = 0;
    for(int i = 0; i< tamanho; i++){
        soma = vetor[i] + soma;
    }
    return (float)soma / tamanho;
}

void imprimirMaiorMenor(int vetor[], int tamanho){
    float maior = 0;
    float menor = 0;

    for (int i = 0; i < tamanho; i++){
        if (vetor[i] > maior){
            maior = vetor[i];
        }
        if (vetor[i] < menor){
            menor = vetor[i];
        }
    }
    printf("O maior valor do vetor e: %f \n", maior);
    printf("O menor valor do vetor e: %f \n", menor);
}





int estaOrdenado(int vetor[], int tamanho){
    for (int i = 0; i < tamanho; i++){
        if (vetor[i] > vetor[i+1]){
            return 0;
        };
            return 1;
    }
    return 0;
}

int filtrarPares(int vOrigem[], int tamOrigem, int vDestino[]){
    int auxdestino = 0;
    for (int i = 0; i < tamOrigem; i++ ){
        int aux = vOrigem[i];
        if (aux % 2 == 0 ){
            vDestino[auxdestino] = aux;
            auxdestino++;
        } 
    }
    return auxdestino;
}

int calcularProdutoEscalar(int v1[], int v2[], int tamanho){
    int produto = 0;
    for (int i = 0; i < tamanho; i++){
        produto = produto + (v1[i] * v2[i]);
    }
    return produto;
}

void inverterVetorInPlace(int vetor[], int tamanho){
    for (int i = 0 ; i < tamanho / 2; i++ ){
        int aux = 0;
        aux = vetor[i];
        vetor[i] = vetor[tamanho - 1 -i];
        vetor[tamanho - 1 -i] = aux;

    }
}

int contarFrequencia(int vetor[], int tamanho, int x){
    int contador = 0;
    for(int i = 0; i < tamanho; i++){
        if (vetor[i] == x){
            contador++;
        }
    }
    return contador;
}

float calcularMediaPonteiros(int *vetor, int tamanho){
    float media = 0;
    for (int i = 0; i<tamanho; i++){
        media+=*(vetor+i);
    }
    return (media/tamanho);
}

int buscarElemento(int vetor[], int tamanho, int x){
    for (int i = 0; i < tamanho; i++){
        if (vetor[i] == x) return i;
    }
    return -1; 
}