#!/usr/bin/env python3
"""Gráfico de speedup e eficiência paralela.

Uso:  python grafico_speedup.py [pasta_de_resultados]
Sem argumento, usa a pasta resultados_AAAAMMDD_HHMMSS mais recente.

Precisa estar na mesma pasta do analise.py (reaproveita a leitura do CSV).
Gera <pasta>/speedup_eficiencia.png.

  Speedup:             S(n)  = T(1) / T(n)
  Eficiência paralela: Ef(n) = S(n) / n_núcleos_físicos
As barras de erro propagam o desvio padrão dos tempos das repetições.
"""
import os
import re
import statistics as st
import sys
from collections import defaultdict

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

from analise import achar_pasta, le_linhas, num

BOX = dict(boxstyle="round,pad=0.15", fc="white", ec="none", alpha=0.85)  # fundo branco nos rótulos


def main():
    pasta = achar_pasta(sys.argv[1] if len(sys.argv) > 1 else None)

    tempos = defaultdict(list)
    with open(os.path.join(pasta, "energia.csv"), newline="", encoding="utf-8-sig") as f:
        for r in le_linhas(f):
            if r["tempo_s"]:
                tempos[r["config"]].append(num(r["tempo_s"]))
    if "p_1" not in tempos:
        sys.exit("Configuração p_1 não encontrada: ela é a referência do speedup.")

    def media_dp(c):
        v = tempos[c]
        return st.mean(v), (st.stdev(v) if len(v) > 1 else 0.0)

    T1, s1 = media_dp("p_1")

    def metricas(c, nucleos):
        T, s = media_dp(c)
        S = T1 / T
        dS = S * ((s1 / T1) ** 2 + (s / T) ** 2) ** 0.5   # propagação de erro de uma razão
        return S, dS, 100 * S / nucleos, 100 * dS / nucleos

    nomes = sorted((c for c in tempos if re.fullmatch(r"p_\d+", c)), key=lambda c: int(c[2:]))
    ns = [int(c[2:]) for c in nomes]
    dados = [metricas(c, n) for c, n in zip(nomes, ns)]
    S, dS, Ef, dEf = (list(col) for col in zip(*dados))

    ht = metricas("p_ht", 6) if "p_ht" in tempos else None   # 12 threads em 6 núcleos físicos

    fig, (a1, a2) = plt.subplots(1, 2, figsize=(12, 4.8))

    # ---- Speedup ----
    a1.plot(ns, ns, "--", color="gray", label="Ideal ($S = n$)")
    a1.errorbar(ns, S, yerr=dS, marker="o", capsize=3, label="Medido (sem HT)")
    for x, y in zip(ns, S):
        a1.annotate(f"{y:.2f}", (x, y), textcoords="offset points", xytext=(9, -13), ha="left", bbox=BOX)
    if ht:
        a1.errorbar([6], [ht[0]], yerr=[ht[1]], marker="s", color="tab:red", linestyle="none",
                    capsize=3, label="6 núcleos + HT (12 threads)")
        a1.annotate(f"{ht[0]:.2f}", (6, ht[0]), textcoords="offset points", xytext=(10, -4), ha="left", bbox=BOX)
    a1.set_xlabel("Núcleos físicos (P-cores)")
    a1.set_ylabel("Speedup  $T(1)/T(n)$")
    a1.set_title("Speedup")
    a1.set_xticks(ns)
    a1.grid(alpha=0.3)
    a1.legend(loc="upper left")

    # ---- Eficiência ----
    a2.axhline(100, linestyle="--", color="gray", label="Ideal (100%)")
    a2.errorbar(ns, Ef, yerr=dEf, marker="o", capsize=3, label="Medido (sem HT)")
    for x, y in zip(ns, Ef):
        a2.annotate(f"{y:.1f}%", (x, y), textcoords="offset points", xytext=(9, -13), ha="left", bbox=BOX)
    if ht:
        a2.errorbar([6], [ht[2]], yerr=[ht[3]], marker="s", color="tab:red", linestyle="none",
                    capsize=3, label="6 núcleos + HT (12 threads)")
        a2.annotate(f"{ht[2]:.1f}%", (6, ht[2]), textcoords="offset points", xytext=(10, -4), ha="left", bbox=BOX)
    a2.set_xlabel("Núcleos físicos (P-cores)")
    a2.set_ylabel("Eficiência paralela (%)")
    a2.set_title("Eficiência paralela  $S(n)/n$")
    a2.set_xticks(ns)
    a2.set_ylim(0, 115)
    a2.grid(alpha=0.3)
    a2.legend(loc="lower left")

    fig.tight_layout()
    saida = os.path.join(pasta, "speedup_eficiencia.png")
    fig.savefig(saida, dpi=200)
    print(f"Gráfico salvo em {saida}")


if __name__ == "__main__":
    main()
