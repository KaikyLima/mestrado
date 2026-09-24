CC=gcc-4.8
CXX=g++-4.8

all: main

main: parallel-region png pdf
	@echo "Ver os arquivos .omplower e .ompexp"

parallel-region:
	${CC} -fopenmp -fdump-tree-ompexp example-nested-parallel.c -o example-nested-parallel.exe
	${CC} -fopenmp -fdump-tree-ompexp-graph example-nested-parallel.c
	
	# -fno-asynchronous-unwind-tables retira Call Frame Information .cfi_startproc, .cfi_endproc
	${CC} -fopenmp example-nested-parallel.c -fno-asynchronous-unwind-tables -S -o example-nested-parallel.s	

clean:
	find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "dump2dot" -or -iname "*.sh" \) \) -delete

png:
	../scripts/gen-png.sh

pdf:
	../scripts/gen-pdf.sh