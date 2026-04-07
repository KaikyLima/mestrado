#include <string.h>
#include <stdio.h>
#include <math.h>
#include "lista3.h"
#define TAM 3



int somaDiagonalPrincipal( int n, int m[][n]){
    int result = 0;

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            if (i == j){
                result = result + m[i][j];
            }
        }
    }
    return result;

}

void gerarIdentidade(int tamanho, int m[][tamanho]){
    for (int i = 0; i < tamanho; i++){
        for (int j = 0; j < tamanho; j++){
            if (i == j){
                m[i][j] = 1;
            }
            else
            {
                m[i][j] = 0;
            }
            
        }
    }
}

void calcularMedias(float m[3][3]){
    float n1 = 0;
    float n2 = 0;
    for (int i = 0; i < 3; i++){
        for (int j =0; j < 3; j++){
            if (j == 0){
                n1 = m[i][j];
            }
            else if (j == 1){
                n2 = m[i][j];
            }
            else if (j == 2){
                m[i][j] = (n1+n2) / 2;
                n1 = 0;
                n2 = 0;
            }
        }
    }
}

void zerarNegativos(float m[TAM][TAM]){
    for(int i = 0; i < TAM; i++){
        for(int j =0; j < TAM; j++){
            if (m[i][j] < 0 ){
                m[i][j] = 0.0;
            }
        }
    }
}

void transposta(int origem[TAM][TAM], int destino[TAM][TAM]){
    for(int i = 0; i < TAM; i++){
        for(int j = 0; j < TAM; j++){
            destino[j][i] = origem[i][j];
        }
    }
}

int compararLinhas(int m[TAM][TAM], int l1, int l2){
    int soma1 = 0;
    int soma2 = 0;
    for(int i = 0; i < TAM; i++){
        soma1 = soma1 + m[l1][i];
        soma2 = soma2 + m[l2][i];
    }
    if (soma1 > soma2){
        return 1;  
    } else if (soma2 > soma1){
        return 2;  
    } else {
        return 0; 
    }
}


int buscarNome(char lista[ROWS][COLS], char nome[]){
    for (int i = 0; i < ROWS; i++){
        if (strcmp(lista[i], nome) == 0){
            return 1;
        }
    }
    return 0; 
}