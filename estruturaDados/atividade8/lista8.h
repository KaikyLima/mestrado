#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define MAX 10

typedef struct {
    int senha;
    char nome[30];
} elemento;

typedef struct {
    elemento dados[MAX];
    int inicio;
    int fim;
} FilaEstatica;

void inicializar(FilaEstatica *f) {
    f->inicio =0;
    f->fim =0;
}

int estaVazia(FilaEstatica *f) {
    return (f->inicio == f->fim);
}

int estaCheia(FilaEstatica *f) {
    return ((f->fim + 1) % MAX == f->inicio);
}

void enfileirar(FilaEstatica *f, elemento e) {
    if (estaCheia(f)) {
        printf("Fila cheia!\n");
        return;
    }
    f->dados[f->fim] = e;
    f->fim = (f->fim + 1) % MAX;
}

elemento desenfileirar(FilaEstatica *f) {
    elemento vazio = {0, ""};
    if (estaVazia(f)) {
        printf("Fila vazia\n");
        return vazio;
    }
    elemento temp = f->dados[f->inicio];
    f->inicio = (f->inicio + 1) % MAX;
    return temp;  
}



