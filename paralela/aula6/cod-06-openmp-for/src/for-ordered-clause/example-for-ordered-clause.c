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

  int i, j, k, id;
  printf("Thread[%d][%lu]: Before parallel region...\n", omp_get_thread_num(), (long int)pthread_self());
  
  #pragma omp parallel num_threads(4) private(id)
  {
    id = omp_get_thread_num();
    printf("Thread[%d][%lu]: Threading starting...\n", id, (long int) pthread_self());
    #pragma omp for collapse(2) ordered private(i, k, j)
    for (k=0; k<=2; k++){
      for (j=0; j<=2; j++){
        for (i=0; i<=2; i++){
          #pragma omp ordered
          printf("Thread[%d][%lu]: Working in [%lu,%lu,%lu] loop iteration.\n", id,
             (long int)pthread_self(), i, j, k);
        }
      }
    }
  }

  printf("Thread[%d][%lu]: After parallel region...\n", omp_get_thread_num(),
         (long int)pthread_self());
  
  return 0;
}
