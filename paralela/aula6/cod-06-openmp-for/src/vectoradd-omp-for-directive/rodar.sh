#!/usr/bin/env bash
# Experimento: estrategias de escalonamento do OpenMP (vectoradd).
# Uso:   ./rodar.sh                       (valores padrao)
#        N=50000000 THREADS="2 4 8" REPS=10 ./rodar.sh
# Saida: resultados.csv  (schedule,chunk,threads,rep,tempo)

SRC=${SRC:-vectoradd-omp-for.c}
N=${N:-20000000}                 # numero de elementos
THREADS=${THREADS:-"1 2 4 8"}    # contagens de threads a testar
CHUNKS=${CHUNKS:-"32 64 128 256 512"}
REPS=${REPS:-10}                 # repeticoes por configuracao
OUT=${OUT:-resultados.csv}

set -e

# ---------- 1. Compilacao ----------
echo ">> Compilando as versoes..."
gcc -O2 -fopenmp -DSCHED=""                            "$SRC" -o va-unspecified
gcc -O2 -fopenmp -DSCHED="schedule(static,partition)"  "$SRC" -o va-static
gcc -O2 -fopenmp -DSCHED="schedule(dynamic,partition)" "$SRC" -o va-dynamic
gcc -O2 -fopenmp -DSCHED="schedule(guided,partition)"  "$SRC" -o va-guided
gcc -O2 -fopenmp -DSCHED="schedule(runtime)"           "$SRC" -o va-runtime

# ---------- 2. Funcao de execucao ----------
# roda(binario, schedule, chunk, threads, [valor OMP_SCHEDULE])
roda() {
  local bin=$1 sched=$2 chunk=$3 th=$4 omp_sched=$5
  local saida tempo
  for rep in $(seq 1 "$REPS"); do
    if [ -n "$omp_sched" ]; then
      saida=$(OMP_SCHEDULE="$omp_sched" "./$bin" "$N" "$th" "$chunk")
    else
      saida=$("./$bin" "$N" "$th" "$chunk")
    fi
    tempo=$(echo "$saida" | grep '^TEMPO:' | awk '{print $2}')
    # valida o resultado (media deve ser 1.000000)
    echo "$saida" | grep -q '1\.000000)' || echo "AVISO: resultado incorreto em $sched,$chunk,$th" >&2
    echo "$sched,$chunk,$th,$rep,$tempo" >> "$OUT"
  done
}

# ---------- 3. Experimento ----------
echo "schedule,chunk,threads,rep,tempo" > "$OUT"

for th in $THREADS; do
  echo ">> threads = $th"

  # sem a clausula schedule
  roda va-unspecified "unspecified" 0 "$th"

  # static / dynamic / guided com cada chunk_size
  for tipo in static dynamic guided; do
    for ch in $CHUNKS; do
      roda "va-$tipo" "$tipo" "$ch" "$th"
    done
  done

  # runtime: o escalonamento vem da variavel OMP_SCHEDULE
  roda va-runtime "runtime:static"      0 "$th" "static"
  roda va-runtime "runtime:dynamic"     0 "$th" "dynamic"
  roda va-runtime "runtime:guided"      0 "$th" "guided"
  roda va-runtime "runtime:dynamic-64"  0 "$th" "dynamic,64"
  roda va-runtime "runtime:guided-64"   0 "$th" "guided,64"
done

echo ">> Pronto. Dados brutos em $OUT"
echo ">> Agora rode: ./resumo.sh"
