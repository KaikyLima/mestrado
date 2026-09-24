/* Compilar:
 * gcc -fopenmp helloworld-omp-02.c -o helloworld-omp-02.exe
 * ou 
 * make omp-02
 */
#include <stdio.h>
#include <pthread.h>
#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#endif

int main() {
  #pragma omp parallel
  {
    int id_omp = omp_get_thread_num();
    long int id_sys = (long int) pthread_self();
    printf("Thread[%2d, %lu]: Hello World!!!\n", id_omp, id_sys);
  }
  
  return 0;
}
