/* Compile:
 * gcc -fopenmp example-parallel-num_threads.c -o
 * example-parallel-num_threads.exe
 * or
 * make omp-parallel-num_threads
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <math.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs()                             \
  (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

int main() {
  int id, n = 0;

  printf("Thread[%d][%lu]: Before parallel region...\n", omp_get_thread_num(), (long int) pthread_self());

  #pragma omp parallel num_threads(4) default(none) private(id) shared(n)
  {
    id = omp_get_thread_num();
    printf("Thread[%d][%lu]: Before... n: %d\n", id, (long int) pthread_self(), n);
    #pragma omp atomic update
    n = n + pow(id,3);
    
    printf("Thread[%d][%lu]: After.... n: %d\n", id, (long int) pthread_self(), n);
  }
  
  printf("Thread[%d][%lu]: After parallel region...\n", omp_get_thread_num(), (long int) pthread_self());
  printf("Thread[%d][%lu]: Final.... n: %d\n", omp_get_thread_num(), (long int) pthread_self(), n);

  return 0;
}
