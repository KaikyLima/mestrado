CC=gcc -Wall

PROGS=exemplo-shm-client exemplo-shm-server

all: $(PROGS)

clean:
	rm -f *.exe

exemplo-shm-server:	exemplo-shm-server.c
	$(CC) exemplo-shm-server.c -o exemplo-shm-server.exe

exemplo-shm-client:	exemplo-shm-client.c
	$(CC) exemplo-shm-client.c -o exemplo-shm-client.exe
