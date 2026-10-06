/* Compile:
 * gcc -fopenmp example-for-private-clause.c -o
 * example-for-private-clause.exe
 * or
 * make for-private-clause
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs()                                                    \
  (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

#define SIZE 16

int main() {
  int id, i, j = 0;

  printf("Thread[%d][%lu]: Before parallel region...\n", omp_get_thread_num(),
         (long int)pthread_self());

  #pragma omp parallel num_threads(4) private(id)
  {
    id = omp_get_thread_num();
    printf("Thread[%d][%lu]: Threading starting with...\n", id,
             (long int)pthread_self());

    #pragma omp for schedule(runtime)
    for (i = 0; i < SIZE; i++){
      printf("LOOP 1: Thread[%d][%lu]: Working in %lu loop iteration...\n", id,
             (long int)pthread_self(), i);
    }

    #pragma omp for schedule(dynamic, 2)
    for (j = 0; j < SIZE; j++){
      printf("LOOP 2: Thread[%d][%lu]: Working in %lu loop iteration...\n", id,
             (long int)pthread_self(), j);
    }
  }

  printf("Thread[%d][%lu]: After parallel region...\n", omp_get_thread_num(),
         (long int)pthread_self());

  return 0;
}
