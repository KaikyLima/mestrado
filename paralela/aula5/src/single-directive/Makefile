CC=gcc-4.8
CXX=g++-4.8

all: main

main: parallel-region png pdf
	@echo "Ver os arquivos .omplower e .ompexp"

parallel-region:
	${CC} -fopenmp -fdump-tree-ompexp example-single-directive.c -o example-single-directive.exe
	${CC} -fopenmp -fdump-tree-ompexp-graph example-single-directive.c
	
	# -fno-asynchronous-unwind-tables retira Call Frame Information .cfi_startproc, .cfi_endproc
	${CC} -fopenmp example-single-directive.c -fno-asynchronous-unwind-tables -S -o example-single-directive.s	

clean:
	find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "dump2dot" -or -iname "*.sh" \) \) -delete

png:
	../scripts/gen-png.sh

pdf:
	../scripts/gen-pdf.sh