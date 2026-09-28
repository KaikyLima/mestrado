#!/bin/bash
#
# compare.sh - Executa TODAS as variantes (estatico/dinamico x master/single/critical/atomic),
#              varia o numero de threads, mede o tempo (real/user/sys), confere se o
#              resultado esta correto e gera:
#                 - um CSV com todas as execucoes
#                 - uma tabela final (variante x threads) com o tempo real medio
#
# Uso (rode na pasta aula5, onde estao as duas pastas *-mudancas):
#   ./compare.sh                          # valores padrao
#   ./compare.sh -r 10 -n 10000000 -t "1 2 4 8 12" -p 10000 -o resultados.csv
#
# Opcoes:
#   -r  repeticoes por configuracao            (padrao: 5)
#   -n  numero de elementos do vetor           (padrao: 10000000)
#   -t  lista de numeros de threads, entre "   (padrao: "1 2 4 8 12")
#   -p  tamanho da particao (so o dinamico)    (padrao: 10000)
#   -o  arquivo CSV de saida                   (padrao: resultados.csv)
#
# Variaveis de ambiente (opcionais) para apontar as pastas/executaveis:
#   STATIC_DIR, DYN_DIR         pastas com atomic.exe, critical.exe, master.exe, single.exe
#   STATIC_ORIG, DYN_ORIG       executaveis ORIGINAIS (se existirem, entram na comparacao)
#
# Observacao: precisa de bash 4+ (o do Ubuntu/WSL serve).

set -u

REPS=5
N=10000000
THREADS="1 2 4 8 12"
PART=10000
CSV="resultados.csv"

STATIC_DIR="${STATIC_DIR:-./vectoradd-omp-distribuicao-estatica-mudancas}"
DYN_DIR="${DYN_DIR:-./vectoradd-omp-distribuicao-dinamica-mudancas}"
STATIC_ORIG="${STATIC_ORIG:-./vectoradd-omp-distribuicao-estatica/vectoradd-omp-static.exe}"
DYN_ORIG="${DYN_ORIG:-./vectoradd-omp-distribuicao-dinamica/vectoradd-omp-dynamic.exe}"

while getopts "r:n:t:p:o:h" opt; do
    case $opt in
        r) REPS=$OPTARG ;;
        n) N=$OPTARG ;;
        t) THREADS=$OPTARG ;;
        p) PART=$OPTARG ;;
        o) CSV=$OPTARG ;;
        h|*) sed -n '2,25p' "$0"; exit 1 ;;
    esac
done

# O programa le o tamanho com atoi() (int de 32 bits): maximo 2147483647.
if ! [[ "$N" =~ ^[0-9]+$ ]] || [ "$N" -gt 2147483647 ]; then
    echo "ERRO: -n deve ser um inteiro entre 1 e 2147483647 (o programa usa atoi/int)."
    exit 1
fi

# ---------- monta a lista de programas: "tipo|nome|caminho" ----------
ENTRIES=()

find_exe() {   # find_exe <pasta> <tipo> <variante>  -> imprime o caminho encontrado
    local dir=$1 tipo=$2 v=$3
    if   [ -x "$dir/$v.exe" ];                        then echo "$dir/$v.exe"
    elif [ -x "$dir/vectoradd-omp-$tipo-$v.exe" ];    then echo "$dir/vectoradd-omp-$tipo-$v.exe"
    fi
}

for tipo in static dynamic; do
    dir=$STATIC_DIR; [ "$tipo" = dynamic ] && dir=$DYN_DIR
    [ -x "$( [ "$tipo" = static ] && echo "$STATIC_ORIG" || echo "$DYN_ORIG" )" ] && \
        ENTRIES+=("$tipo|original|$( [ "$tipo" = static ] && echo "$STATIC_ORIG" || echo "$DYN_ORIG" )")
    for v in master single critical atomic; do
        p=$(find_exe "$dir" "$tipo" "$v")
        if [ -n "$p" ]; then
            ENTRIES+=("$tipo|$v|$p")
        else
            echo "Aviso: nao encontrei $dir/$v.exe (nem vectoradd-omp-$tipo-$v.exe) - pulando."
        fi
    done
done

if [ ${#ENTRIES[@]} -eq 0 ]; then
    echo "ERRO: nenhum executavel encontrado. Confira STATIC_DIR / DYN_DIR (rode na pasta aula5)."
    exit 1
fi

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
TIMEFORMAT='%3R %3U %3S'
declare -A REF          # resultado de referencia por n (a soma tem que ser igual em todas as variantes)
FAILS=0

echo "tipo,variante,n,threads,particao,run,real,user,sys,resultado" > "$CSV"

echo "============================================================"
echo " n=$N  repeticoes=$REPS  threads=[$THREADS]  particao=$PART"
echo " programas: ${#ENTRIES[@]}"
echo "============================================================"

for th in $THREADS; do
    for entry in "${ENTRIES[@]}"; do
        IFS='|' read -r tipo nome exe <<<"$entry"
        if [ "$tipo" = dynamic ]; then args=("$N" "$th" "$PART"); else args=("$N" "$th"); fi

        for ((r = 1; r <= REPS; r++)); do
            # A saida do programa vai para um arquivo temporario (nao para /dev/null)
            # para podermos conferir o resultado depois.
            t=$( { time "$exe" "${args[@]}" >"$TMP" 2>&1; } 2>&1 )
            read -r real user sys <<<"$t"

            res=$(grep -E "Final Result|Resultado Final" "$TMP" | tail -1 | grep -Eo '\([^)]*\)')
            status=OK
            if [ -z "$res" ]; then
                status="FALHOU (sem resultado final)"; FAILS=$((FAILS + 1))
            elif [ -z "${REF[$N]+x}" ]; then
                REF[$N]=$res
            elif [ "$res" != "${REF[$N]}" ]; then
                status="DIVERGENTE: $res (esperado ${REF[$N]})"; FAILS=$((FAILS + 1))
            fi

            echo "$tipo,$nome,$N,$th,$PART,$r,$real,$user,$sys,\"$res\"" >> "$CSV"
            printf "%-8s %-9s thr=%-3s run=%-2s real=%8ss user=%8ss sys=%8ss  %s\n" \
            "$tipo" "$nome" "$th" "$r" "$real" "$user" "$sys"
        done
    done
done

# ---------- tabela final: tempo real medio (s) por variante x threads ----------
echo
echo "================ TEMPO REAL MEDIO (s) - n=$N ================"
awk -F',' -v threads="$THREADS" '
    NR == 1 { next }
    {
        key = $1 "/" $2
        if (!(key in seen)) { seen[key] = 1; order[++nk] = key }
        sum[key, $4] += $7; cnt[key, $4]++
    }
    END {
        nt = split(threads, T, " ")
        printf "%-20s", "variante \\ threads"
        for (i = 1; i <= nt; i++) printf " %9s", T[i]
        printf "\n"
        for (k = 1; k <= nk; k++) {
            printf "%-20s", order[k]
            for (i = 1; i <= nt; i++) {
                c = cnt[order[k], T[i]]
                if (c > 0) printf " %9.4f", sum[order[k], T[i]] / c
                else       printf " %9s", "-"
            }
            printf "\n"
        }
    }' "$CSV"

echo
if [ "$FAILS" -gt 0 ]; then
    echo "ATENCAO: $FAILS execucao(oes) falharam ou divergiram. Veja as linhas acima."
else
    echo "Todas as execucoes terminaram com o mesmo resultado final: ${REF[$N]}"
fi
echo "Todas as medicoes por execucao: $CSV"
