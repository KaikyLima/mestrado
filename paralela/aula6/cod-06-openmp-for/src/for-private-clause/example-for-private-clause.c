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

int main() {
  int id, i, a = 0;

  printf("Thread[%d][%lu]: Before parallel region a: %d...\n", omp_get_thread_num(),
         (long int)pthread_self(), a);

  #pragma omp parallel num_threads(4) private(id, a)
  {
    // All threads executes this code.
    id = omp_get_thread_num();
    a = 1;
    printf("Thread[%d][%lu]: Threading starting with a: %d...\n", id,
             (long int)pthread_self(), a);

    #pragma omp for private(a)
    for (i = 0; i < 8; i++) {
      a = 2;
      printf("Thread[%d][%lu]: Working in %lu loop iteration a: %d...\n", id,
             (long int)pthread_self(), i, a);
    }
    assert(a == 1);
    printf("Thread[%d][%lu]: After the for loop a: %d...\n", id,
             (long int)pthread_self(), a);
  }

  printf("Thread[%d][%lu]: After parallel region a: %d...\n", omp_get_thread_num(),
         (long int)pthread_self(), a);

  return 0;
}
