#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int identidadeMemoria (int, float, char);
int somarValores (int, int);
int multiplicarValores (int, int);
float conversorTemp(float);
float calcularVolumeEsfera(float);
float calcularVolumeCilindro(float, float);
float calcularAreaTriangulo(float);
float calcularAreaHexagono(float);
int verificarTriangulo(float, float, float);
float calcularBasakara(float, float, float);
float calcularCoordenadas(float, float, float, float);
void testar(int n);

int main()
{
    int i = 5;
    printf("Endereço fora da função:  %p\n", &i);
    testar(i);
    return 0;
}

int identidadeMemoria(int valor1, float valor2, char valor3){
    printf("Valor inteiro é: %d\n", valor1);
    printf("Endereço do Valor inteiro é: %p\n", &valor1);
    printf("Tamanho da memoria em bytes do valor inteiro é: %d\n", sizeof(valor1));

    printf("Valor real é: %f\n", valor2);
    printf("Endereço do Valor real é: %p\n", &valor2);
    printf("Tamanho da memoria em bytes do valor real é: %d\n", sizeof(valor2));

    printf("Caractere é: %c\n", valor3);    
    printf("Endereço do Caractere é: %p\n", &valor3);
    printf("Tamanho da memoria em bytes do caractere é: %d\n", sizeof(valor3));

    return 0;
}           

int somarValores(int valor1, int valor2){

    int resultado = valor1 + valor2;
    printf("A soma dos valores é: %d\n", resultado);

    return 0;
}

int multiplicarValores(int valor1, int valor2){
    int resultado = valor1 * valor2;
    printf("A multiplicação dos valores é: %d\n", resultado);

    return 0;
}

float conversorTemp(float temperatura){
    float resultado = (temperatura * 1.8) + 32;
    printf("A temperatura em Fahrenheit é: %f\n", resultado);

    return 0;
}


float calcularVolumeEsfera(float raio){
    
    float pi = 3.14;
    float potenciacao = pow(raio, 3);
    float v = (4.0/3.0) * (pi * potenciacao);

    printf("O volume da esfera é: %f\n", v);

    return 0;
}

float calcularVolumeCilindro(float raio, float altura){
    float pi = 3.14;
    float potenciacao = pow(raio, 2);
    float v = pi * potenciacao * altura;

    printf("O volume do cilindro é: %f\n", v);

    return 0;
}

float calcularAreaTriangulo(float lado){
    float altura = lado * (sqrt(3) / 2);
    float area = (lado * altura) / 2;

    return area;
}

float calcularAreaHexagono(float lado){
    float area = 6 * calcularAreaTriangulo(lado);
    printf("A área do hexágono é: %f\n", area);
    return 0;
}

int verificarTriangulo(float lado1, float lado2, float lado3){
    if (lado1 < lado2 + lado3 && lado2 < lado1 + lado3 && lado3 < lado1 + lado2) {
        printf("Os lados formam um triângulo.\n");
        return 1;
    } else {
        printf("Os lados não formam um triângulo.\n");
        return 0;
    }
}

float calcularBasakara(float a, float b, float c){
    float delta = pow(b, 2) - 4 * a * c;

    if (delta < 0) {
        printf("A equacao não pode ser negativa\n");
        return 0;
    } else if (delta == 0) {
        float raiz = -b / (2 * a);
        printf("A equação é 0, só retorna uma raiz:  %f\n", raiz);
        return 0;
    } else {
        float raiz1 = (-b + sqrt(delta)) / (2 * a);
        float raiz2 = (-b - sqrt(delta)) / (2 * a);
        printf("A equação retorna duas raizes:  %f e %f\n", raiz1, raiz2);
        return 0;
    }
}

float calcularCoordenadas(float x1, float y1, float x2, float y2){
    float distancia = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    printf("A distancia entre os pontos é: : %f\n", distancia);
    return 0;
}

void testar(int n){
    n = n + 5;
    printf("Endereço dentro da função:  %p\n", &n);
    //O endereço dentro da função é diferente do de fora da função, pois são variáveis diferentes, mesmo que tenham o mesmo nome. Cada variável tem seu próprio espaço de memória, e o endereço reflete isso.
}