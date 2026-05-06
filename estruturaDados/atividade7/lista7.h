#ifndef LISTA7_H
#define LISTA7_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX 1000

/*
========================================
PILHA ESTÁTICA
========================================
*/

typedef struct {
    char itens[MAX];
    int topo;
} PilhaEstatica;

void inicializarPilhaEstatica(PilhaEstatica *p);

int pilhaVaziaEstatica(PilhaEstatica *p);

int pilhaCheiaEstatica(PilhaEstatica *p);

void pushEstatica(PilhaEstatica *p, char valor);

char popEstatica(PilhaEstatica *p);

char topoEstatica(PilhaEstatica *p);

/*
========================================
PILHA ENCADEADA
========================================
*/

typedef struct No {
    double valor;
    struct No *prox;
} No;

typedef struct {
    No *topo;
} PilhaEncadeada;

void inicializarPilhaEncadeada(PilhaEncadeada *p);

int pilhaVaziaEncadeada(PilhaEncadeada *p);

void pushEncadeada(PilhaEncadeada *p, double valor);

double popEncadeada(PilhaEncadeada *p);

/*
========================================
FUNÇÕES AUXILIARES
========================================
*/

int ehOperador(char c);

int precedencia(char c);

/*
========================================
PROCESSAMENTO
========================================
*/

void converterParaPosfixa(char *expressao, char *saida);

double avaliarPosfixa(char *expressaoPosfixa);

#endif