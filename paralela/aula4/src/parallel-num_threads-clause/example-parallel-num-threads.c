/* Compile:
 * gcc -fopenmp example-parallel-num_threads.c -o example-parallel-num_threads.exe
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
#define omp_get_num_procs() (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

int main() {
		
	#pragma omp parallel num_threads(4)
	{
	    int id_omp = omp_get_thread_num();
	    long int id_sys = (long int) pthread_self();
	    printf("Thread[%d, %lu]: Hello World!!!\n", id_omp, id_sys);
	}
	
	return 0;
}
