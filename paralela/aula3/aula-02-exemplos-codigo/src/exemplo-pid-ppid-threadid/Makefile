# Variáveis.
CC = gcc
CFLAGS = -Wall -lpthread
TARGET = exemplo-pid-ppid-threadid
EXT = exe

# Alvo padrão executado ao digitar apenas 'make'.
all: $(TARGET)

# Regra para gerar o executável final.
$(TARGET): $(TARGET).o
	$(CC) $(CFLAGS) $^ -o $(TARGET).$(EXT)

# Regra para compilar o arquivo objeto.o.
$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) -c $^

# Alvo para limpar arquivos gerados.
clean:
	rm -f *.o $(TARGET).$(EXT)
