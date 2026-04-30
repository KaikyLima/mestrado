#ifndef LISTA4_H
#define LISTA4_H

typedef int ELEMENTO;	//vamos fazer uma lista de ELEMENTO

typedef struct No {
    ELEMENTO dado;
    struct No* proximo;
} No;

typedef struct {
    No* inicio; 		//ponteiro para o primeiro elemento da lista
    No* fim;   		//ponteiro para o último elemento da lista
    int tamanho;		// variável para guardar a quantidade de elementos na lista
} Lista;

/* ALGORITMO: INICIALIZAR
 * 1. Definir os ponteiros 'inicio' e 'fim' do descritor como NULL.
 * 2. Definir o 'tamanho' como 0.
 */
void inicializar(Lista* l);

/* ALGORITMO: INSERIR ORDENADO
 * 1. Alocar memória para um novo nó.
 * 2. SE a lista estiver vazia OU o dado for menor que o 'inicio->dado':
 * - Inserir no início e atualizar o 'fim' se a lista estava vazia.
 * 3. SENÃO, SE o dado for maior ou igual ao 'fim->dado':
 * - Inserir após o 'fim' e atualizar o ponteiro 'fim' (Operação O(1)).
 * 4. SENÃO (Inserção no meio):
 * - Percorrer a lista com um ponteiro auxiliar para achar a posição.
 * - ATENÇÃO: Incrementar um contador a cada comparação de valores realizada.
 * 5. Retornar o total de comparações feitas no passo 4.
 */
int inserirOrdenado(Lista* l, ELEMENTO e);

/* DESAFIO: IMPRIMIR INVERSO
 * Objetivo: Imprimir os elementos da lista do último para o primeiro.
 * Restrição: A lista é simples (não tem ponteiro para o anterior).
 * Estratégia: Livre. Use sua criatividade!
 */
void imprimirInverso(Lista* l);

/* ALGORITMO: DESTRUIR
 * 1. Percorrer a lista liberando cada nó (free).
 * 2. Garantir que, ao final, o descritor esteja zerado.
 */
void destruir(Lista* l);

#endif