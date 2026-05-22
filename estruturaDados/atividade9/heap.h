#ifndef HEAP_H
#define HEAP_H

#include <stddef.h>

typedef struct heap Heap;

Heap *heap_criar(size_t capacidade);
void heap_inserir(Heap *h, int valor);
int heap_remover(Heap *h);
int heap_topo(const Heap *h);
size_t heap_tamanho(const Heap *h);
void heap_mostrar(const Heap *h);
void heap_destruir(Heap *h);

#endif