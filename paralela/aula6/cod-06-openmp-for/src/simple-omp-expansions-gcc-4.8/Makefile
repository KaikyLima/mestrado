
CC=gcc-4.8
CXX=g++-4.8

all: main png pdf

main: schedule-unspecified schedule-static schedule-runtime schedule-dynamic schedule-guided schedule-auto
	# find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "*.s" \) \) -delete
	@echo "Ver os arquivos .omplower e .ompexp"

schedule-unspecified: for-schedule-unespecified-upper-bound-value.c for-schedule-unespecified-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-unespecified-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-unespecified-upper-bound-variable.c
	# .dot
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-unespecified-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-unespecified-upper-bound-variable.c
	#.png
	# dot -Tpng for-schedule-dynamic-upper-bound-value.c.015t.ompexp.dot > for-schedule-dynamic-upper-bound-value.c.015t.ompexp.png

schedule-static: for-schedule-static-upper-bound-value.c for-schedule-static-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-static-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-static-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-static-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-static-upper-bound-variable.c

	${CC} -fopenmp -fno-asynchronous-unwind-tables for-schedule-static-upper-bound-value.c -S -o for-schedule-static-upper-bound-value.s

schedule-runtime: for-schedule-runtime-upper-bound-value.c for-schedule-runtime-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-runtime-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-runtime-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-runtime-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-runtime-upper-bound-variable.c

schedule-dynamic: for-schedule-dynamic-upper-bound-value.c for-schedule-dynamic-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-dynamic-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-dynamic-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-dynamic-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-dynamic-upper-bound-variable.c

	${CC} -fopenmp for-schedule-dynamic-upper-bound-value.c -fno-asynchronous-unwind-tables  -S -o for-schedule-dynamic-upper-bound-value.s
	${CC} -fopenmp for-schedule-dynamic-upper-bound-variable.c -fno-asynchronous-unwind-tables  -S -o for-schedule-dynamic-upper-bound-variable.s

schedule-guided: for-schedule-guided-upper-bound-value.c for-schedule-guided-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-guided-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-guided-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-guided-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-guided-upper-bound-variable.c

schedule-auto: for-schedule-auto-upper-bound-value.c for-schedule-auto-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-auto-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp for-schedule-auto-upper-bound-variable.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-auto-upper-bound-value.c
	${CC} -fopenmp -fdump-tree-ompexp-graph for-schedule-auto-upper-bound-variable.c

clean:
	find . -type f \( ! \( -iname "*.c" -or -iname "Makefile" -or -iname "*.ompexp" -or -iname "dump2dot" \) \) -delete

png:
	#for i in `ls *.ompexp.dot`; do    \
	#	echo 'Processing:' $$i;    \
	#	newname=$(shell echo ${i} | tr '.' '-');    \
	#	$(shell echo 'Bla: ${newname}');    \
	#	dot -Tpng $$i > $$newname.png;    \
	#done
	../scripts/gen-png.sh

pdf:
	../scripts/gen-pdf.sh