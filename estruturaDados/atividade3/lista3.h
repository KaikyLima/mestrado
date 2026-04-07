#ifndef LISTA3_H
#define LISTA3_H

#define TAM 3
#define ROWS 4
#define COLS 20

// 1. Soma da diagonal principal
int somaDiagonalPrincipal(int n, int m[n][n]);

// 2. Gerar matriz identidade
void gerarIdentidade(int tamanho, int m[][tamanho]);

// 3. Calcular médias (coluna 2)
void calcularMedias(float m[3][3]);

// 4. Zerar valores negativos
void zerarNegativos(float m[TAM][TAM]);

// 5. Matriz transposta
void transposta(int origem[TAM][TAM], int destino[TAM][TAM]);

// 6. Comparar soma de linhas
int compararLinhas(int m[TAM][TAM], int l1, int l2);

// 7. Buscar nome
int buscarNome(char lista[ROWS][COLS], char nome[]);

// 8. Contar vogais
void contarVogais(char lista[ROWS][COLS]);

// 9. Inverter strings
void inverterStrings(char lista[ROWS][COLS]);

// 10. Formatar identificadores
void formatarIdentificadores(char lista[ROWS][COLS]);


#endif