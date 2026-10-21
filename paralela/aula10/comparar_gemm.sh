#!/usr/bin/env bash

set -u
export LC_ALL=C

# Pasta onde estão os executáveis do GEMM
DIR_EXE="/home/kaiky/mestrado/paralela/aula10/PolyBench-ACC-master/OpenMP/linear-algebra/kernels/gemm"

# Configurações dos testes
REPETICOES=5
THREADS=(1 2 4 8 12)

# Arquivos de saída (gravados na pasta onde o script é executado)
CSV="resultados_gemm.csv"
RESUMO="resumo_gemm.csv"

# Verifica se a pasta existe
if [[ ! -d "$DIR_EXE" ]]; then
    echo "ERRO: pasta não encontrada: $DIR_EXE"
    exit 1
fi

# Verifica se os executáveis existem
for exe in gemm_seq.exe gemm.exe gemm_taskloop.exe \
           gemm_simd.exe gemm_for_simd.exe gemm_taskloop_simd.exe; do
    if [[ ! -x "$DIR_EXE/$exe" ]]; then
        echo "ERRO: executável não encontrado ou sem permissão: $DIR_EXE/$exe"
        exit 1
    fi
done

# Cabeçalhos dos arquivos CSV
echo "versao,threads,repeticao,tempo_segundos" > "$CSV"
echo "versao,threads,repeticoes,mediana_segundos" > "$RESUMO"

# Arquivo temporário para armazenar os tempos
TEMP=$(mktemp)
trap 'rm -f "$TEMP"' EXIT

# Executa os testes de uma versão
executar_testes() {
    local versao="$1"
    local exe="$2"
    local threads="$3"
    local i
    local tempo
    local mediana

    : > "$TEMP"

    echo
    echo "========================================"
    echo "Versão: $versao | Threads: $threads"
    echo "========================================"

    for ((i = 1; i <= REPETICOES; i++)); do
        echo -n "Execução $i/$REPETICOES: "

        # Descarta a matriz impressa em stderr,
        # preservando o tempo impresso em stdout.
        if ! tempo=$(OMP_NUM_THREADS="$threads" "$DIR_EXE/$exe" 2>/dev/null); then
            echo "ERRO ao executar $exe"
            exit 1
        fi

        # Obtém a última linha, que contém o tempo.
        tempo=$(printf '%s\n' "$tempo" | tail -n 1)

        # Valida se o resultado é numérico.
        if [[ ! "$tempo" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
            echo "ERRO: tempo inválido recebido: $tempo"
            exit 1
        fi

        printf '%s\n' "$tempo" >> "$TEMP"
        printf '%s,%s,%s,%s\n' \
            "$versao" "$threads" "$i" "$tempo" >> "$CSV"

        echo "$tempo segundos"
    done

    # Calcula a mediana dos tempos.
    mediana=$(
        sort -n "$TEMP" |
        awk '
            { valores[NR] = $1 }
            END {
                if (NR == 0) {
                    exit 1
                } else if (NR % 2 == 1) {
                    printf "%.6f\n", valores[(NR + 1) / 2]
                } else {
                    printf "%.6f\n", \
                        (valores[NR / 2] + valores[NR / 2 + 1]) / 2
                }
            }
        '
    )

    printf '%s,%s,%s,%s\n' \
        "$versao" "$threads" "$REPETICOES" "$mediana" >> "$RESUMO"

    echo "Mediana: $mediana segundos"
}

# 1. Versão sequencial: uma thread, sem paralelismo.
executar_testes "sequencial" "gemm_seq.exe" 1

# 2. GEMM com OpenMP convencional.
for t in "${THREADS[@]}"; do
    executar_testes "openmp" "gemm.exe" "$t"
done

# 3. GEMM com OpenMP taskloop.
for t in "${THREADS[@]}"; do
    executar_testes "taskloop" "gemm_taskloop.exe" "$t"
done

# 4. Sequencial + simd: uma thread.
executar_testes "simd" "gemm_simd.exe" 1

# 5. OpenMP for + simd.
for t in "${THREADS[@]}"; do
    executar_testes "for_simd" "gemm_for_simd.exe" "$t"
done

# 6. OpenMP taskloop + simd.
for t in "${THREADS[@]}"; do
    executar_testes "taskloop_simd" "gemm_taskloop_simd.exe" "$t"
done

echo
echo "========================================"
echo "TESTES CONCLUÍDOS"
echo "========================================"
echo "Resultados individuais: $CSV"
echo "Resumo das medianas:    $RESUMO"
echo
cat "$RESUMO"