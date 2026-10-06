/* Compilar:
 * gcc vet-reduction.c -o vet-reduction -fopenmp
 * ou 
 * make omp-03
 */
#include <stdio.h>
#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#endif

#define SIZE 16

int main() {
  int A[SIZE], i, sum;
	
  #pragma omp parallel for schedule(static, 2) num_threads(4) ordered
  for(i = 0; i < SIZE; i++){ 
    A[i] = i * i;  
    printf("Th[%d]: %02d = %03d\n", omp_get_thread_num(), i, A[i]);
  }
  
  #pragma omp parallel for reduction(+:sum)
  for(i = 0; i < SIZE; i++){ 
    sum += A[i];
		printf("Th[%d]: %02d, %03d sum: %03d\n", omp_get_thread_num(), i, A[i], sum);
  }
  
  printf("Th[%d] sum: %02d\n", omp_get_thread_num(), sum);
  
  return 0;
}
