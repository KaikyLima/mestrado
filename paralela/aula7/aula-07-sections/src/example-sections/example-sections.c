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

void intercala(int p, int q, int r, int v[]) {
  int *w = malloc((r - p) * sizeof(int));
  int i = p, j = q, k = 0;
  while (i < q && j < r) w[k++] = (v[i] <= v[j]) ? v[i++] : v[j++];
  while (i < q) w[k++] = v[i++];
  while (j < r) w[k++] = v[j++];
  for (i = p; i < r; i++) v[i] = w[i - p];
  free(w);
}

/* Versão sequencial (do enunciado) */
void mergesort(int p, int r, int v[]) {
  if (p < r-1) {
    int q = (p + r)/2;
    mergesort(p, q, v);
    mergesort(q, r, v);
    intercala(p, q, r, v);
  }
}

/* Versão com sections */
void mergesort_sections(int p, int r, int v[]) {
  if (p < r-1) {
    int q = (p + r)/2;
    if (r - p > 10000) {   /* só cria threads para vetores grandes */
      #pragma omp parallel sections num_threads(2)
      {
        #pragma omp section
        mergesort_sections(p, q, v);
        #pragma omp section
        mergesort_sections(q, r, v);
      }
    } else {
      mergesort(p, q, v);
      mergesort(q, r, v);
    }
    intercala(p, q, r, v);
  }
}

int main(int argc, char *argv[]) {
  int n = (argc > 1) ? atoi(argv[1]) : 10000000;
  int *a = malloc(n * sizeof(int)), *b = malloc(n * sizeof(int));
  for (int i = 0; i < n; i++) a[i] = b[i] = rand();

  omp_set_nested(1);

  double t0 = omp_get_wtime();
  mergesort(0, n, a);
  double t1 = omp_get_wtime();
  mergesort_sections(0, n, b);
  double t2 = omp_get_wtime();

  printf("n=%d  Sequencial: %.3f s  Sections: %.3f s\n", n, t1 - t0, t2 - t1);
  return 0;
}
