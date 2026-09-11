CC=gcc-4.8
CXX=g++-4.8

all: main

main: compile png pdf
	@echo "Ver os arquivos .omplower e .ompexp"

compile:
	${CC} -fopenmp -fdump-tree-ompexp vectoradd-omp-dynamic.c -o vectoradd-omp-dynamic.exe
	${CC} -fopenmp -fdump-tree-ompexp-graph vectoradd-omp-dynamic.c
	
	# -fno-asynchronous-unwind-tables retira Call Frame Information .cfi_startproc, .cfi_endproc
	${CC} -fopenmp 	vectoradd-omp-dynamic.c -fno-asynchronous-unwind-tables -S -o vectoradd-omp-dynamic.s	

clean:
	find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "dump2dot" -or -iname "*.sh" \) \) -delete

png:
	../scripts/gen-png.sh

pdf:
	../scripts/gen-pdf.sh