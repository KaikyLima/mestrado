/* lista.h  */

#ifndef LISTA_H
#define LISTA_H

//atividade 1
//#define MAX 12

//Atividade 2
#define MAX 8
typedef float elemento;

typedef struct {
    elemento itens[MAX];
    int quantidade;
} Lista;

// --- OPERAÇÕES ---

void inicializar(Lista *l);
int tamanho(Lista *l);
int esta_cheia(Lista *l);
int esta_vazia(Lista *l);

// Retornam 1 para Sucesso e 0 para Falha
int inserir_fim(Lista *l, elemento e);
int inserir_posicao(Lista *l, elemento e, int pos);
int remover_posicao(Lista *l, int pos);
int remover_elemento(Lista *l, elemento e);

int buscar(Lista *l, elemento e);
int obter_elemento(Lista *l, int pos, elemento *e);

void imprimir(Lista *l);
int alterar_elemento(Lista *l, int pos, elemento e);

#endif