
GCC := gcc

all: exemplo-pthread

# Opção -lpthread para fazer o link com a biblioteca pthreads.
exemplo-pthread: exemplo-pthread.c
	${GCC} -lpthread exemplo-pthread.c -o exemplo-pthread.exe

clean:
	rm *.exe *.o