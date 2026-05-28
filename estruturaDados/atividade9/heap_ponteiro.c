#include "heap.h"
#include <stdlib.h>
#include <stdio.h>

typedef struct no {
    int valor;
    struct no *pai;
    struct no *esq;
    struct no *dir;
} No;

struct heap {
    No *raiz;
    size_t tamanho;
};

static No *achar_no(No *raiz, size_t idx) {
    if (idx == 1) return raiz;
    size_t bits[64];
    int n = 0;
    for (size_t t = idx; t > 1; t /= 2)
        bits[n++] = t % 2;
    No *atual = raiz;
    for (int i = n - 1; i >= 0; i--)
        atual = bits[i] ? atual->dir : atual->esq;
    return atual;
}

static void troca(No *a, No *b) {
    int tmp = a->valor;
    a->valor = b->valor;
    b->valor = tmp;
}

static void subir(No *no) {
    while (no->pai && no->valor > no->pai->valor) {
        troca(no, no->pai);
        no = no->pai;
    }
}

static void descer(No *no) {
    while (1) {
        No *maior = no;
        if (no->esq && no->esq->valor > maior->valor) maior = no->esq;
        if (no->dir && no->dir->valor > maior->valor) maior = no->dir;
        if (maior == no) break;
        troca(no, maior);
        no = maior;
    }
}

Heap *heap_criar(size_t capacidade) {
    (void)capacidade;
    Heap *h = malloc(sizeof(Heap));
    h->raiz = NULL;
    h->tamanho = 0;
    return h;
}

void heap_inserir(Heap *h, int valor) {
    No *novo = malloc(sizeof(No));
    novo->valor = valor;
    novo->esq = novo->dir = novo->pai = NULL;
    h->tamanho++;
    if (!h->raiz) { h->raiz = novo; return; }
    No *pai = achar_no(h->raiz, h->tamanho / 2);
    novo->pai = pai;
    if (!pai->esq) pai->esq = novo;
    else           pai->dir = novo;
    subir(novo);
}

int heap_remover(Heap *h) {
    if (!h->tamanho) { fprintf(stderr, "Erro: heap vazio\n"); exit(1); }
    int raiz = h->raiz->valor;
    if (h->tamanho == 1) { free(h->raiz); h->raiz = NULL; h->tamanho = 0; return raiz; }
    No *ultimo = achar_no(h->raiz, h->tamanho);
    h->raiz->valor = ultimo->valor;
    if (ultimo->pai->dir == ultimo) ultimo->pai->dir = NULL;
    else                            ultimo->pai->esq = NULL;
    free(ultimo);
    h->tamanho--;
    descer(h->raiz);
    return raiz;
}

int heap_topo(const Heap *h) {
    if (!h->tamanho) { fprintf(stderr, "Erro: heap vazio\n"); exit(1); }
    return h->raiz->valor;
}

size_t heap_tamanho(const Heap *h) { return h->tamanho; }

void heap_mostrar(const Heap *h) {
    if (!h->tamanho) { printf("(heap vazio)\n"); return; }
    No **fila = malloc(sizeof(No *) * h->tamanho);
    size_t ini = 0, fim = 0, nivel = 0, por_nivel = 1;
    fila[fim++] = h->raiz;
    while (ini < fim) {
        printf("Nivel %zu: ", nivel++);
        for (size_t k = 0; k < por_nivel && ini < fim; k++) {
            No *n = fila[ini++];
            printf("%d ", n->valor);
            if (n->esq) fila[fim++] = n->esq;
            if (n->dir) fila[fim++] = n->dir;
        }
        printf("\n");
        por_nivel *= 2;
    }
    free(fila);
}

static void destruir_rec(No *no) {
    if (!no) return;
    destruir_rec(no->esq);
    destruir_rec(no->dir);
    free(no);
}

void heap_destruir(Heap *h) { destruir_rec(h->raiz); free(h); }