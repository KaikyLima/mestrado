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
  int A[SIZE], B[SIZE], i;
  int id, dot = 0;
  
  for(i = 0; i < SIZE; i++){ 
       A[i] = i;
       B[i] = i; 
  }

  printf("Thread[%d][%lu]: Before parallel region...\n", omp_get_thread_num(), (long int)pthread_self());
  
  #pragma omp parallel
  {
    id = omp_get_thread_num();
    printf("Thread[%d][%lu]: Threading starting...\n", id, (long int)pthread_self());
    
    #pragma omp for reduction (+:dot)
    for(i = 0; i < SIZE; i++){ 
       dot += A[i] * B[i]; 
       printf("Thread[%d][%lu]: Working in %lu loop iteration %d * %d = %d -> %d.\n", id,
             (long int)pthread_self(), i, A[i], B[i], (A[i] * B[i]), dot);
    }

    #pragma omp master
    printf("Thread[%d][%lu]: dot at the loop final: %d.\n", omp_get_thread_num(),
         (long int)pthread_self(), dot);
  }

  printf("Thread[%d][%lu]: After parallel region dot: %d...\n", omp_get_thread_num(),
         (long int)pthread_self(), dot);
  
  return 0;
}
