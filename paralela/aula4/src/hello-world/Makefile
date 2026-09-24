CC = gcc

all:	seq omp-01 omp-02 omp-02b omp-03

seq:	helloworld-seq.c
	${CC} helloworld-seq.c -o helloworld-seq.exe

omp-01:	helloworld-omp-01.c
	${CC} -fopenmp helloworld-omp-01.c -o helloworld-omp-01.exe

omp-02:	helloworld-omp-02.c
	${CC} -fopenmp -lpthread helloworld-omp-02.c -o helloworld-omp-02.exe

omp-02b:	helloworld-omp-02.c
	${CC} -lpthread helloworld-omp-02.c -o helloworld-omp-02b.exe

omp-03:	helloworld-omp-03.c
	${CC} -fopenmp -lpthread helloworld-omp-03.c -o helloworld-omp-03.exe

clean:
	rm *.exe

