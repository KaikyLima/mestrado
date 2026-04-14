#include <stdlib.h>
#include <stdio.h>
#ifndef LISTA3_H
#define LISTA3_H

typedef struct {
    int x;
    int y;
} Ponto;

typedef struct {
    int   ra;
    float nota;
} Aluno;

typedef struct  {
    float raio;
    Ponto centro;
} Circulo;

Ponto* alocarPonto(int x, int y){
    Ponto *aponta;
    aponta = (Ponto*) malloc(sizeof(Ponto));
    aponta->x = x;
    aponta->y = y;

    return aponta;  
}

void imprimirPonto (Ponto* aponta){
    printf("%d, %d", aponta->x, aponta->y);
}

Aluno* alocarTurma(int n){
    Aluno *aloca;
    aloca = (Aluno*) malloc(n*sizeof(Aluno));
    return aloca;
}

void processaDados(Aluno* turma, int n){
    for (int i = 0; i < n ; i++){
        scanf("%d", &turma[i].ra);
        scanf("%f", &turma[i].nota);
    }
}

float mediaTurma(Aluno* turma, int n){
    float media = 0;
    float soma = 0;
    for (int i = 0; i < n; i++){
        soma = soma + turma[i].nota;

    }
    media = soma / n;
    return media;
}

Aluno* buscarAluno(Aluno* turma, int ra, int n){
    for (int i = 0; i <n ; i++){
        if (turma[i].ra == ra) return &turma[i];
    }
    return NULL;
}

Circulo* criarCirculo(float raio, int x, int y){
    Circulo *bola = (Circulo*) malloc(sizeof(Circulo));

    bola->raio = raio;
    bola->centro.x = x;
    bola->centro.y = y;

    return bola;
}

Aluno* clonaTurma(Aluno* turma){
    Aluno *aloca;
    aloca = (Aluno*) malloc(sizeof(Aluno)); 
    aloca = turma;
    
    return aloca;
}

void liberarMemoria(void** ponteiro){
    free(*ponteiro);
}

#endif