#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <pthread.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#define omp_get_num_threads() 1
#define omp_get_num_procs()                             \
  (system("cat /proc/cpuinfo | grep 'processor' | wc -l"))
#endif

int main(int argc, char *argv[]) {

  int id;

  fprintf(stdout, "Thread[%lu][%lu]: Before parallel region...\n", omp_get_thread_num(), (long int) pthread_self());

  #pragma omp parallel num_threads(4)
  {
    id = omp_get_thread_num();
    #pragma omp sections firstprivate(id)
    {   
      #pragma omp section
      fprintf(stdout, " Thread[%lu][%lu]: Working on section 1.\n", id, (long int) pthread_self());
      
      #pragma omp section
      fprintf(stdout, " Thread[%lu][%lu]: Working on section 2.\n", id, (long int) pthread_self());

      #pragma omp section
      fprintf(stdout, " Thread[%lu][%lu]: Working on section 3.\n", id, (long int) pthread_self());
    }
  }

  fprintf(stdout, "Thread[%d][%lu]: After parallel region...\n", omp_get_thread_num(), (long int) pthread_self());
    
  return 0;
}
