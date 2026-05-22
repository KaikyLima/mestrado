#include "heap.h"
#include <stdlib.h>
#include <stdio.h>

struct heap {
    int *dados;
    size_t tamanho;
    size_t capacidade;
};

static void troca(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

static void subir(Heap *h, size_t i) {
    while (i > 0) {
        size_t pai = (i - 1) / 2;
        if (h->dados[i] <= h->dados[pai])
            return;
        troca(&h->dados[i], &h->dados[pai]);
        i = pai;
    }
}

static void descer(Heap *h, size_t i) {
    size_t tamanho = h->tamanho;
    while (2*i + 1 < tamanho) {
        size_t esq = 2*i + 1;
        size_t dir = 2*i + 2;
        size_t maior = esq;
        if (dir < tamanho && h->dados[dir] > h->dados[esq])
            maior = dir;
        if (h->dados[i] >= h->dados[maior])
            return;
        troca(&h->dados[i], &h->dados[maior]);
        i = maior;
    }
}

Heap *heap_criar(size_t capacidade) {
    Heap *h = malloc(sizeof(Heap));
    h->dados = malloc(sizeof(int) * capacidade);
    h->tamanho = 0;
    h->capacidade = capacidade;
    return h;
}

void heap_inserir(Heap *h, int valor) {
    if (h->tamanho == h->capacidade) {
        h->capacidade *= 2;
        h->dados = realloc(h->dados, sizeof(int) * h->capacidade);
    }
    h->dados[h->tamanho] = valor;
    subir(h, h->tamanho);
    h->tamanho++;
}

int heap_remover(Heap *h) {
    if (h->tamanho == 0) {
        fprintf(stderr, "Erro: heap vazio\n");
        exit(1);
    }
    int raiz = h->dados[0];
    h->tamanho--;
    h->dados[0] = h->dados[h->tamanho];
    descer(h, 0);
    return raiz;
}

int heap_topo(const Heap *h) {
    if (h->tamanho == 0) {
        fprintf(stderr, "Erro: heap vazio\n");
        exit(1);
    }
    return h->dados[0];
}

size_t heap_tamanho(const Heap *h) {
    return h->tamanho;
}

void heap_mostrar(const Heap *h) {
    if (h->tamanho == 0) {
        printf("(heap vazio)\n");
        return;
    }
    size_t nivel = 0;
    size_t elementos_no_nivel = 1;
    size_t i = 0;
    while (i < h->tamanho) {
        printf("Nivel %zu: ", nivel);
        for (size_t j = 0; j < elementos_no_nivel && i < h->tamanho; j++, i++) {
            printf("%d ", h->dados[i]);
        }
        printf("\n");
        nivel++;
        elementos_no_nivel *= 2;
    }
}

void heap_destruir(Heap *h) {
    free(h->dados);
    free(h);
}