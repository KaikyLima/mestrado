/* Compile:
 * gcc -fopenmp example-parallel-num_threads.c -o
 * example-parallel-num_threads.exe
 * or
 * make omp-parallel-num_threads
 */
#include <stdio.h>
#include <stdlib.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs()                             \
  (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

int main() {
  int id_omp, n = 0;

  #pragma omp parallel default(none) private(id_omp) shared(n)
  {
    id_omp = omp_get_thread_num();
    long int id_sys = (long int) pthread_self();
    printf("Thread[%d, %lu]: Valor de n: %d antes.\n", id_omp, id_sys, n);
    n = n + id_omp;
    printf("Thread[%d, %lu]: Valor de n: %d depois.\n", id_omp, id_sys, n);
  }

  printf("Thread[%d, %lu]: Valor final de n: %d.\n", omp_get_thread_num(), (long int) pthread_self(), n);

  return 0;
}
