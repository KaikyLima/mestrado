#!/usr/bin/env bash
export LC_ALL=C
# Le resultados.csv e calcula media e desvio padrao (amostral) por configuracao.
# Usa apenas awk/sort (nativos do Ubuntu). Gera resumo.csv e imprime a tabela.

IN=${1:-resultados.csv}
OUT=${2:-resumo.csv}

awk -F, '
NR == 1 { next }                       # pula o cabecalho
{
  chave = $3 "," $1 "," $2             # threads,schedule,chunk
  n[chave]++
  soma[chave]  += $5
  soma2[chave] += $5 * $5
}
END {
  for (k in n) {
    media = soma[k] / n[k]
    if (n[k] > 1) {
      var = (soma2[k] - n[k] * media * media) / (n[k] - 1)
      if (var < 0) var = 0
      dp = sqrt(var)
    } else dp = 0
    cv = (media > 0) ? 100 * dp / media : 0
    printf "%s,%d,%.6f,%.6f,%.1f\n", k, n[k], media, dp, cv
  }
}' "$IN" | sort -t, -k1,1n -k2,2 -k3,3n > /tmp/resumo_tmp.csv

# CSV final
{ echo "threads,schedule,chunk,n,media_s,desvio_s,cv_pct"; cat /tmp/resumo_tmp.csv; } > "$OUT"

# Tabela na tela
awk -F, '
BEGIN { printf "%3s %-20s %5s %3s %10s %10s %6s\n", "thr","schedule","chunk","n","media(s)","desvio(s)","cv%" }
{
  if (atual != "" && $1 != atual) print ""
  atual = $1
  printf "%3d %-20s %5s %3d %10.6f %10.6f %6.1f\n", $1, $2, ($3 == 0 ? "-" : $3), $4, $5, $6, $7
}' /tmp/resumo_tmp.csv

rm -f /tmp/resumo_tmp.csv
echo
echo "Resumo salvo em $OUT"
