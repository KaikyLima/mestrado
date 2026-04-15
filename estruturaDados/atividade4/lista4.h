#ifndef LISTA4_H
#define LISTA4_H


typedef struct {
    int x;
    int y;
} Ponto;

typedef struct {
    int   ra;
    float nota;
} Aluno;

typedef struct {
    float raio;
    Ponto centro;
} Circulo;



Ponto* alocarPonto(int x, int y);
void imprimirPonto(Ponto* aponta);

Aluno* alocarTurma(int n);
void processaDados(Aluno* turma, int n);
float mediaTurma(Aluno* turma, int n);

Circulo* criarCirculo(float raio, int x, int y);
float calcularArea(Circulo* c);

Aluno* clonaTurma(Aluno* turma, int n);
Aluno* buscarAluno(Aluno* turma, int ra, int n);
void liberarMemoria(void** ponteiro);

#endif