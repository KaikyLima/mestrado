GCC      := gcc
GXX      := g++
CC       := clang
CXX      := clang++
LLVMCFG  := llvm-config
OPT      := opt

CFLAGS = -Wall `$(LLVMCFG) --cflags` -fopenmp
LDFLAGS = -Wall `$(LLVMCFG) --libs --system-libs` `$(LLVMCFG) --ldflags` -fopenmp

# Descoberta de arquivos-fonte e definicao dos alvos
SRCS       := $(wildcard *.c)
GCC_EXES   := $(patsubst %.c,%-gcc.exe,$(SRCS))
CLANG_EXES := $(patsubst %.c,%-clang.exe,$(SRCS))
ASMS       := $(patsubst %.c,%.s,$(SRCS))
LLS        := $(patsubst %.c,%.ll,$(SRCS))

.PHONY: all main compile-gcc compile-clang gen-figures clean lls pngs exes

# Alvo padrao: executa o pipeline completo (GCC, Clang e geracao de figuras)
all: main

main: compile-gcc compile-clang gen-figures
	@echo "Ver os arquivos de dump (.ompexp, etc.) e os grafos (.dot / .png / .pdf)"

# Targets agrupadores genericos
compile-gcc: $(GCC_EXES) $(ASMS)

compile-clang: $(CLANG_EXES) $(LLS)

lls: $(LLS)

pngs: gen-figures

exes: $(GCC_EXES) $(CLANG_EXES)

# ==============================================================================
# Regras genericas com variaveis automaticas ($^ = pre-requisitos, $@ = alvo)
# ==============================================================================

# Compilacao GCC: gera executavel, dump de expansao OpenMP (.ompexp) e grafo dot
%-gcc.exe: %.c
	$(GCC) $(CFLAGS) -fdump-tree-ompexp -fdump-tree-ompexp-graph $^ -o $@

# Assembly com GCC sem Call Frame Information (.cfi_startproc, .cfi_endproc)
%.s: %.c
	$(GCC) $(CFLAGS) -fno-asynchronous-unwind-tables -S $^ -o $@

# Compilacao Clang: gera executavel com suporte OpenMP
%-clang.exe: %.c
	$(CC) $(CFLAGS) $^ -o $@

# Clang + LLVM IR: emite .ll preservando nomes e gera os grafos CFG (.dot) via opt
%.ll: %.c
	$(CC) $(CFLAGS) -fno-discard-value-names -S -emit-llvm $^ -o $@
	$(OPT) -passes=dot-cfg -disable-output $@

# Geracao de figuras (PNG e PDF) a partir de todos os arquivos .dot gerados (inclusive ocultos .*.dot)
gen-figures: $(LLS) $(GCC_EXES)
	@for i in $$(ls *.dot .*.dot 2>/dev/null); do \
		echo "Processando figura: $$i"; \
		dot -Tpng "$$i" -o "$$i.png"; \
		dot -Tpdf "$$i" -o "$$i.pdf"; \
	done

clean:
	rm -rvf *.out *.o *.s *.exe out*.ll *.bc *.ll *.png .*.png *.dot .*.dot *.pdf .*.pdf *ompexp*
