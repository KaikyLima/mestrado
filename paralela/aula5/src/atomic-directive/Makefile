CC=gcc
CXX=g++

all: main

main: parallel-region png pdf
	@echo "Ver os arquivos .omplower e .ompexp"

parallel-region:
	${CC} -fopenmp -lm -fdump-tree-ompexp example-atomic-directive.c -o example-atomic-directive.exe
	${CC} -fopenmp -lm -fdump-tree-ompexp-graph example-atomic-directive.c
	
	# -fno-asynchronous-unwind-tables retira Call Frame Information .cfi_startproc, .cfi_endproc
	${CC} -fopenmp -lm example-atomic-directive.c -fno-asynchronous-unwind-tables -S -o example-atomic-directive.s	

clean:
	find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "dump2dot" -or -iname "*.sh" \) \) -delete

png:
	../scripts/gen-png.sh

pdf:
	../scripts/gen-pdf.sh
