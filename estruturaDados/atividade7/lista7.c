#include "lista7.h"

/*
========================================
PILHA ESTÁTICA
========================================
*/

void inicializarPilhaEstatica(PilhaEstatica *p) {
    p->topo = -1;
}

int pilhaVaziaEstatica(PilhaEstatica *p) {
    return p->topo == -1;
}

int pilhaCheiaEstatica(PilhaEstatica *p) {
    return p->topo == MAX - 1;
}

void pushEstatica(PilhaEstatica *p, char valor) {

    if (pilhaCheiaEstatica(p)) {
        printf("Erro: Pilha estatica cheia.\n");
        exit(1);
    }

    p->itens[++p->topo] = valor;
}

char popEstatica(PilhaEstatica *p) {

    if (pilhaVaziaEstatica(p)) {
        return '\0';
    }

    return p->itens[p->topo--];
}

char topoEstatica(PilhaEstatica *p) {

    if (pilhaVaziaEstatica(p)) {
        return '\0';
    }

    return p->itens[p->topo];
}

/*
========================================
PILHA ENCADEADA
========================================
*/

void inicializarPilhaEncadeada(PilhaEncadeada *p) {
    p->topo = NULL;
}

int pilhaVaziaEncadeada(PilhaEncadeada *p) {
    return p->topo == NULL;
}

void pushEncadeada(PilhaEncadeada *p, double valor) {

    No *novo = (No*) malloc(sizeof(No));

    if (novo == NULL) {
        printf("Erro de memoria.\n");
        exit(1);
    }

    novo->valor = valor;
    novo->prox = p->topo;

    p->topo = novo;
}

double popEncadeada(PilhaEncadeada *p) {

    if (pilhaVaziaEncadeada(p)) {
        printf("Erro: Pilha vazia.\n");
        exit(1);
    }

    No *temp = p->topo;

    double valor = temp->valor;

    p->topo = temp->prox;

    free(temp);

    return valor;
}

/*
========================================
FUNÇÕES AUXILIARES
========================================
*/

int ehOperador(char c) {
    return c == '+' || c == '-' ||
           c == '*' || c == '/';
}

int precedencia(char c) {

    if (c == '(') {
        return 0;
    }

    if (c == '+' || c == '-') {
        return 1;
    }

    if (c == '*' || c == '/') {
        return 2;
    }

    return -1;
}

/*
========================================
INFIXA -> POSFIXA
========================================
*/

void converterParaPosfixa(char *expressao,
                          char *saida) {

    PilhaEstatica pilha;

    inicializarPilhaEstatica(&pilha);

    char copia[MAX];

    strcpy(copia, expressao);

    char *token = strtok(copia, " ");

    saida[0] = '\0';

    while (token != NULL) {

        if (isdigit(token[0]) ||
           (token[0] == '-' && isdigit(token[1]))) {

            strcat(saida, token);
            strcat(saida, " ");
        }

        else if (token[0] == '(') {
            pushEstatica(&pilha, '(');
        }

        else if (token[0] == ')') {

            while (!pilhaVaziaEstatica(&pilha) &&
                   topoEstatica(&pilha) != '(') {

                char op = popEstatica(&pilha);

                strncat(saida, &op, 1);

                strcat(saida, " ");
            }

            popEstatica(&pilha);
        }

        else if (ehOperador(token[0])) {

            while (!pilhaVaziaEstatica(&pilha) &&
                   precedencia(topoEstatica(&pilha)) >=
                   precedencia(token[0])) {

                char op = popEstatica(&pilha);

                strncat(saida, &op, 1);

                strcat(saida, " ");
            }

            pushEstatica(&pilha, token[0]);
        }

        token = strtok(NULL, " ");
    }

    while (!pilhaVaziaEstatica(&pilha)) {

        char op = popEstatica(&pilha);

        strncat(saida, &op, 1);

        strcat(saida, " ");
    }
}

/*
========================================
AVALIAÇÃO PÓS-FIXA
========================================
*/

double avaliarPosfixa(char *expressaoPosfixa) {

    PilhaEncadeada pilha;

    inicializarPilhaEncadeada(&pilha);

    char copia[MAX];

    strcpy(copia, expressaoPosfixa);

    char *token = strtok(copia, " ");

    while (token != NULL) {

        if (isdigit(token[0]) ||
           (token[0] == '-' && isdigit(token[1]))) {

            pushEncadeada(&pilha, atof(token));
        }

        else if (ehOperador(token[0])) {

            double B = popEncadeada(&pilha);

            double A = popEncadeada(&pilha);

            double resultado;

            switch (token[0]) {

                case '+':
                    resultado = A + B;
                    break;

                case '-':
                    resultado = A - B;
                    break;

                case '*':
                    resultado = A * B;
                    break;

                case '/':

                    if (B == 0) {
                        printf("Erro: divisao por zero.\n");
                        exit(1);
                    }

                    resultado = A / B;
                    break;
            }

            pushEncadeada(&pilha, resultado);
        }

        token = strtok(NULL, " ");
    }

    return popEncadeada(&pilha);
}