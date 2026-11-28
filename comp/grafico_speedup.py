#!/usr/bin/env python3
"""Gráfico de speedup e eficiência paralela.

Uso:  python grafico_speedup.py [pasta_de_resultados]
Sem argumento, usa a pasta resultados_AAAAMMDD_HHMMSS mais recente.

Precisa estar na mesma pasta do analise.py (reaproveita a leitura do CSV).
Gera <pasta>/speedup_eficiencia.png.

  Speedup:             S(n)  = T(1) / T(n)
  Eficiência paralela: Ef(n) = S(n) / n_núcleos_físicos
  P-cores: referência p_1; E-cores: referência e_1 (cada tipo contra o seu próprio 1 núcleo).
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

    def metricas(c, base, nucleos):
        """Speedup e eficiência de c em relação à referência `base` (1 núcleo do mesmo tipo)."""
        T1, s1 = media_dp(base)
        T, s = media_dp(c)
        S = T1 / T
        dS = S * ((s1 / T1) ** 2 + (s / T) ** 2) ** 0.5   # propagação de erro de uma razão
        return S, dS, 100 * S / nucleos, 100 * dS / nucleos

    def serie(prefixo):
        nomes = sorted((c for c in tempos if re.fullmatch(prefixo + r"_\d+", c)),
                       key=lambda c: int(c.split("_")[1]))
        base = f"{prefixo}_1"
        if base not in tempos:
            return [], []
        ns = [int(c.split("_")[1]) for c in nomes]
        return ns, [metricas(c, base, n) for c, n in zip(nomes, ns)]

    ns_p, dados_p = serie("p")
    ns_e, dados_e = serie("e")
    if not ns_p:
        sys.exit("Configuração p_1 não encontrada: ela é a referência do speedup dos P-cores.")
    if not ns_e:
        print("Aviso: sem e_1, e_2...: gráfico só com P-cores (rode e_1..e_3 para os E-cores).")

    ht = metricas("p_ht", "p_1", 6) if "p_ht" in tempos else None   # 12 threads em 6 núcleos físicos

    # Eficiência de combinação P+E: tempo ideal se cada núcleo contribuísse com a sua taxa de 1 núcleo
    if "p6_e4" in tempos and ns_e and "e_1" in tempos:
        T_ideal = 1 / (6 / media_dp("p_1")[0] + 4 / media_dp("e_1")[0])
        ef_comb = 100 * T_ideal / media_dp("p6_e4")[0]
        print(f"p6_e4: tempo ideal {T_ideal:.3f} s, medido {media_dp('p6_e4')[0]:.3f} s "
              f"-> eficiência de combinação {ef_comb:.1f}%")

    grupos = [("P-cores (sem HT)", "tab:blue", "o", ns_p, dados_p)]
    if ns_e:
        grupos.append(("E-cores", "tab:green", "^", ns_e, dados_e))
    xmax = max(ns_p + ns_e)

    fig, (a1, a2) = plt.subplots(1, 2, figsize=(12, 4.8))

    # ---- Speedup ----
    a1.plot([1, xmax], [1, xmax], "--", color="gray", label="Ideal ($S = n$)")
    for nome, cor, marc, ns, dados in grupos:
        S, dS = [d[0] for d in dados], [d[1] for d in dados]
        a1.errorbar(ns, S, yerr=dS, marker=marc, color=cor, capsize=3, label=nome)
        for x, y in zip(ns, S):
            if cor == "tab:green" and x == 1:
                continue
            a1.annotate(f"{y:.2f}", (x, y), textcoords="offset points",
                        xytext=(9, -15 if cor == "tab:green" else 7), ha="left", bbox=BOX)
    if ht:
        a1.errorbar([6], [ht[0]], yerr=[ht[1]], marker="s", color="tab:red", linestyle="none",
                    capsize=3, label="6 núcleos + HT (12 threads)")
        a1.annotate(f"{ht[0]:.2f}", (6, ht[0]), textcoords="offset points", xytext=(10, -4), ha="left", bbox=BOX)
    a1.set_xlabel("Núcleos físicos (referência: 1 núcleo do mesmo tipo)")
    a1.set_ylabel("Speedup  $T(1)/T(n)$")
    a1.set_title("Speedup")
    a1.set_xticks(range(1, xmax + 1))
    a1.grid(alpha=0.3)
    a1.legend(loc="upper left")

    # ---- Eficiência ----
    a2.axhline(100, linestyle="--", color="gray", label="Ideal (100%)")
    for nome, cor, marc, ns, dados in grupos:
        Ef, dEf = [d[2] for d in dados], [d[3] for d in dados]
        a2.errorbar(ns, Ef, yerr=dEf, marker=marc, color=cor, capsize=3, label=nome)
        for x, y in zip(ns, Ef):
            if cor == "tab:green" and x == 1:
                continue
            a2.annotate(f"{y:.1f}%", (x, y), textcoords="offset points",
                        xytext=(9, -15 if cor == "tab:green" else 7), ha="left", bbox=BOX)
    if ht:
        a2.errorbar([6], [ht[2]], yerr=[ht[3]], marker="s", color="tab:red", linestyle="none",
                    capsize=3, label="6 núcleos + HT (12 threads)")
        a2.annotate(f"{ht[2]:.1f}%", (6, ht[2]), textcoords="offset points", xytext=(10, -4), ha="left", bbox=BOX)
    a2.set_xlabel("Núcleos físicos")
    a2.set_ylabel("Eficiência paralela (%)")
    a2.set_title("Eficiência paralela  $S(n)/n$")
    a2.set_xticks(range(1, xmax + 1))
    a2.set_ylim(0, 125)
    a2.grid(alpha=0.3)
    a2.legend(loc="lower left")

    fig.tight_layout()
    saida = os.path.join(pasta, "speedup_eficiencia.png")
    fig.savefig(saida, dpi=200)
    print(f"Gráfico salvo em {saida}")


if __name__ == "__main__":
    main()