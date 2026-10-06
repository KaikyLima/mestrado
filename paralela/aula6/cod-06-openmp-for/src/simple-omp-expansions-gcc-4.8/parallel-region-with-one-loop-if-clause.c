#include <omp.h>

int main (void) {
  int i, n;

  n = 2048;
  // Testar com e sem a especificação num_threads. Ver parallel.c, linha 39, gomp_resolve_num_threads
  // No libgomp quando nao é para criar um team de threads ele passa 1, cria uma thread apenas.
  // Quando passa zero ele usa o valor definido em icv.
  // Se passar um valor em num_threads
  #pragma omp parallel if(n > 1024) num_threads (32)
  {
	#pragma omp for schedule(runtime)
	for ( i = 0 ; i < n ; i ++){
		// body;
	}
  }
  return 0;
}
