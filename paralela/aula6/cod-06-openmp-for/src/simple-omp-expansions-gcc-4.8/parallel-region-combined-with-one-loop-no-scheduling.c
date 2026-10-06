#include <omp.h>

int main (void) {
  int i, n;

  #pragma omp parallel for
  for ( i = 0 ; i < n ; i ++){
		// body;
  }
  return 0;
}
