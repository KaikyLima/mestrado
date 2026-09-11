/* Compilar:
 * gcc -fopenmp helloworld-omp-01.c -o helloworld-omp-01.exe
 * ou 
 * make omp-01
 */
#include <stdio.h>
#include <omp.h>

int main() {
  
#pragma omp parallel
{
  printf("Hello World!!!\n");
}
  
  return 0;
}
