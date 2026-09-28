#!/bin/bash
#
# benchmark.sh - Executa um programa N vezes, mede o tempo com o "time" do bash
#                (real, user, sys) e calcula a média, para montar a tabela do relatório.
#
# Uso:
#   ./benchmark.sh <repeticoes> <executavel> [args...]
#
# Exemplos:
#   ./benchmark.sh 10 ./src/vectoradd/vectoradd.exe
#   ./benchmark.sh 10 ./src/vectoradd-omp-distribuicao-estatica/vectoradd-omp-static.exe 100000000 12
#   ./benchmark.sh 10 ./src/vectoradd-omp-distribuicao-dinamica/vectoradd-omp-dynamic.exe 100000000 12 10000
#
# Opcional: para salvar os tempos de cada execução em CSV, defina a variável CSV_OUT:
#   CSV_OUT=resultado.csv ./benchmark.sh 10 ./meu-exe arg1 arg2

set -u

if [ $# -lt 2 ]; then
    echo "Uso: $0 <repeticoes> <executavel> [args...]"
    exit 1
fi

REPS=$1
shift
CMD=("$@")

if [ ! -x "${CMD[0]}" ]; then
    echo "Aviso: '${CMD[0]}' não parece ser um executável válido (verifique o caminho/permissão)."
fi

TIMEFORMAT='%R %U %S'

reals=()
users=()
syss=()

echo "Executando: ${CMD[*]}"
echo "Repeticoes: $REPS"
echo "-------------------------------------------------"
printf "%-5s %10s %10s %10s\n" "Run" "Real(s)" "User(s)" "Sys(s)"

if [ -n "${CSV_OUT:-}" ]; then
    echo "run,real,user,sys" > "$CSV_OUT"
fi

for ((i = 1; i <= REPS; i++)); do
    # Saída do programa (stdout/stderr) é descartada para não distorcer o tempo medido
    # e para não poluir o terminal com as milhares de linhas de log do vectoradd.
    t=$( { time "${CMD[@]}" >/dev/null 2>&1; } 2>&1 )

    real=$(awk '{print $1}' <<<"$t")
    user=$(awk '{print $2}' <<<"$t")
    sys=$(awk '{print $3}' <<<"$t")

    reals+=("$real")
    users+=("$user")
    syss+=("$sys")

    printf "%-5d %10s %10s %10s\n" "$i" "$real" "$user" "$sys"

    if [ -n "${CSV_OUT:-}" ]; then
        echo "$i,$real,$user,$sys" >> "$CSV_OUT"
    fi
done

echo "-------------------------------------------------"

avg() {
    printf '%s\n' "$@" | awk '{s+=$1; n++} END {if (n>0) printf "%.4f", s/n; else print "0"}'
}

real_avg=$(avg "${reals[@]}")
user_avg=$(avg "${users[@]}")
sys_avg=$(avg "${syss[@]}")

printf "%-5s %10s %10s %10s\n" "MEDIA" "$real_avg" "$user_avg" "$sys_avg"

if [ -n "${CSV_OUT:-}" ]; then
    echo "media,$real_avg,$user_avg,$sys_avg" >> "$CSV_OUT"
    echo
    echo "Resultados salvos em: $CSV_OUT"
fi
