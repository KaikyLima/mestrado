GCC := gcc-4.8

all:	omp-parallel-if ompexp-parallel-if ompexp-graph-parallel-if

omp-parallel-if:	example-parallel-if-false.c example-parallel-if-true.c
	${GCC} -fopenmp example-parallel-if-false.c -o example-parallel-if-false.exe
	${GCC} -fopenmp example-parallel-if-true.c -o example-parallel-if-true.exe

ompexp-parallel-if:
	# Generate the expanded OpenMP code.
	${GCC} -fopenmp -fdump-tree-ompexp example-parallel-if-false.c -o example-parallel-if-false.exe
	${GCC} -fopenmp -fdump-tree-ompexp example-parallel-if-true.c -o example-parallel-if-true.exe

ompexp-graph-parallel-if:
	# Generate the graph of expanded OpenMP code.
	${GCC} -fopenmp -fdump-tree-ompexp-graph example-parallel-if-false.c -o example-parallel-if-false.exe
	${GCC} -fopenmp -fdump-tree-ompexp-graph example-parallel-if-true.c -o example-parallel-if-true.exe	

	../scripts/gen-png.sh
	../scripts/gen-pdf.sh

clean:
	rm *.o *.exe
