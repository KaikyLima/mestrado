
#include <omp.h>

void body(){
	int b = 0;
}

int main (void) {
  int i, a;

  a = 0;
  #pragma omp parallel
  {
  	#pragma omp for
  	for (i = 0; i < 1024; i++){
    	// body();
  	}	
  }
  return 0;
}
