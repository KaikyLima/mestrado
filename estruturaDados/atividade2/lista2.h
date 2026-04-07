#ifndef LISTA2_H
#define LISTA2_H

// Protótipos das funções solicitadas
void lerVetor(int vetor[], int tamanho); // Ex 1 
void imprimirInverso(int vetor[], int tamanho); // Ex 1 
float calcularMedia(int vetor[], int tamanho); // Ex 2 
void imprimirMaiorMenor(int vetor[], int tamanho); // Ex 3 
int buscarElemento(int vetor[], int tamanho, int x); // Ex 4 
int estaOrdenado(int vetor[], int tamanho); // Ex 5 
int filtrarPares(int vOrigem[], int tamOrigem, int vDestino[]); // Ex 6
int calcularProdutoEscalar(int v1[], int v2[], int tamanho); // Ex 7
void inverterVetorInPlace(int vetor[], int tamanho); // Ex 8 
int contarFrequencia(int vetor[], int tamanho, int x); // Ex 9 
float calcularMediaPonteiros(int *vetor, int tamanho); // Ex 10 

#endif