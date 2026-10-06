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

  int A[SIZE], i, id;
  printf("Thread[%d][%lu]: Before parallel region...\n", omp_get_thread_num(), (long int)pthread_self());

  
  #pragma omp parallel num_threads(4) private(id)
  {
    id = omp_get_thread_num();
    printf("Thread[%d][%lu]: Threading starting...\n", id, (long int) pthread_self());
    #pragma omp for schedule(static, 2) ordered private(i)
    for(i = 0; i < SIZE; i++){
      A[i] = i * i;  
      #pragma omp ordered
      printf("Thread[%d][%lu]: Working in [%lu] loop iteration.\n", id,
             (long int)pthread_self(), i);
    }
  }
  
  printf("Thread[%d][%lu]: After parallel region...\n", omp_get_thread_num(),
         (long int)pthread_self());
  
  return 0;
}
