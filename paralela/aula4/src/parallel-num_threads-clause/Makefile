CC=gcc-4.8
CXX=g++-4.8

all: main

main: parallel-region png pdf
	@echo "Ver os arquivos .omplower e .ompexp"

parallel-region:
	${CC} -fopenmp -fdump-tree-ompexp example-parallel-num-threads.c -o example-parallel-num-threads.exe
	${CC} -fopenmp -fdump-tree-ompexp-graph example-parallel-num-threads.c
	${CC} -fopenmp -fdump-tree-ompexp example-parallel-omp_set_num_threads-function.c -o example-parallel-omp_set_num_threads-function.exe
	${CC} -fopenmp -fdump-tree-ompexp-graph example-parallel-omp_set_num_threads-function.c

	# -fno-asynchronous-unwind-tables retira Call Frame Information .cfi_startproc, .cfi_endproc
	${CC} -fopenmp example-parallel-num-threads.c -fno-asynchronous-unwind-tables -S -o example-parallel-num-threads.s
	${CC} -fopenmp example-parallel-omp_set_num_threads-function.c -fno-asynchronous-unwind-tables -S -o example-parallel-omp_set_num_threads-function.s

clean:
	find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "dump2dot" -or -iname "*.sh" \) \) -delete

png:
	../scripts/gen-png.sh

pdf:
	../scripts/gen-pdf.sh