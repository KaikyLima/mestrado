set -u

REPETICOES="${1:-30}"
NUM_ELEMENTS=100000000

SOURCE="vectoradd-sequencial.c"
EXECUTAVEL="vectoradd-sequencial.exe"
DIR_RELATORIOS="relatorios"

mkdir -p "$DIR_RELATORIOS"

echo "Compilando $SOURCE..."
gcc -pthread -o "$EXECUTAVEL" "$SOURCE"

if [ $? -ne 0 ]; then
    echo "Erro na compilacao."
    exit 1
fi

ARQUIVO="$DIR_RELATORIOS/sequencial_n${NUM_ELEMENTS}_repeticoes${REPETICOES}.txt"

echo "=============================================" | tee "$ARQUIVO"
echo "BENCHMARK - DISTRIBUICAO SEQUENCIAL"           | tee -a "$ARQUIVO"
echo "=============================================" | tee -a "$ARQUIVO"
echo "Data: $(date '+%Y-%m-%d %H:%M:%S')"             | tee -a "$ARQUIVO"
echo "Configuracao: N=$NUM_ELEMENTS"                  | tee -a "$ARQUIVO"
echo "Repeticoes: $REPETICOES"                        | tee -a "$ARQUIVO"
echo "=============================================" | tee -a "$ARQUIVO"
echo ""                                               | tee -a "$ARQUIVO"

soma_real=0
soma_user=0
soma_sys=0

echo "Resultados individuais:" | tee -a "$ARQUIVO"
echo "Execucao;Real(s);User(s);Sys(s)" | tee -a "$ARQUIVO"

for ((i=1; i<=REPETICOES; i++)); do
    TEMPO=$( { /usr/bin/time -f "%e;%U;%S" "./$EXECUTAVEL" "$NUM_ELEMENTS" > /dev/null; } 2>&1 )

    REAL=$(echo "$TEMPO" | tail -n 1 | cut -d';' -f1)
    USER=$(echo "$TEMPO" | tail -n 1 | cut -d';' -f2)
    SYS=$(echo "$TEMPO" | tail -n 1 | cut -d';' -f3)

    soma_real=$(awk -v a="$soma_real" -v b="$REAL" 'BEGIN {printf "%.9f", a+b}')
    soma_user=$(awk -v a="$soma_user" -v b="$USER" 'BEGIN {printf "%.9f", a+b}')
    soma_sys=$(awk -v a="$soma_sys" -v b="$SYS" 'BEGIN {printf "%.9f", a+b}')

    echo "$i;$REAL;$USER;$SYS" | tee -a "$ARQUIVO"

done

MEDIA_REAL=$(awk -v s="$soma_real" -v n="$REPETICOES" 'BEGIN {printf "%.9f", s/n}')
MEDIA_USER=$(awk -v s="$soma_user" -v n="$REPETICOES" 'BEGIN {printf "%.9f", s/n}')
MEDIA_SYS=$(awk -v s="$soma_sys" -v n="$REPETICOES" 'BEGIN {printf "%.9f", s/n}')

echo "" | tee -a "$ARQUIVO"
echo "=============================================" | tee -a "$ARQUIVO"
echo "MEDIA FINAL"                                    | tee -a "$ARQUIVO"
echo "=============================================" | tee -a "$ARQUIVO"
echo "Media REAL: $MEDIA_REAL s"                     | tee -a "$ARQUIVO"
echo "Media USER: $MEDIA_USER s"                     | tee -a "$ARQUIVO"
echo "Media SYS : $MEDIA_SYS s"                     | tee -a "$ARQUIVO"
echo "=============================================" | tee -a "$ARQUIVO"

echo ""
echo "Relatorio salvo em: $ARQUIVO"
