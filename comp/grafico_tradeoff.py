#!/usr/bin/env python3
"""Gráfico de compromisso energia x tempo (uma figura que resume a comparação).

Uso:  python grafico_tradeoff.py [pasta_de_resultados]
Sem argumento, usa a pasta resultados_AAAAMMDD_HHMMSS mais recente.

Precisa estar na mesma pasta do analise.py (reaproveita a leitura do CSV).
Gera <pasta>/tradeoff_energia_tempo.png.

Cada ponto é uma configuração (média das repetições, barras = desvio padrão).
Eixos em escala log; as linhas tracejadas cinzas são curvas de EDP constante
(E x T = k), que em log-log viram retas. Quanto mais para baixo e para a esquerda,
melhor nos dois eixos; quanto mais perto da origem das diagonais, menor o EDP.
"""
import os
import re
import statistics as st
import sys
from collections import defaultdict

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
from matplotlib.ticker import FixedLocator, FuncFormatter, NullLocator

from analise import achar_pasta, le_linhas, num

# Paleta categórica validada (slots 1-3; passa CVD e visão normal com todos os pares)
AZUL, LARANJA, AQUA = "#257de0", "#f47230", "#00b894"
SUPERFICIE, TEXTO, TEXTO2 = "#ffffff", "#191919", "#666666"
GRADE, EIXO, ISO = "#ebebeb", "#cfcfcf", "#a8a8a8"

# deslocamento (pontos) do rótulo de cada configuração; o que não estiver aqui usa o padrão
OFFSETS = {"p_1": (8, 6), "p_2": (8, 6), "p_3": (8, 6), "p_4": (8, 5), "p_5": (7, 8),
           "p_6": (-10, -17), "p_ht": (9, 2), "e_1": (-30, 9), "e_2": (8, 6), "e_3": (8, 6),
           "e_4": (8, 6), "p6_e4": (9, -14)}


def main():
    pasta = achar_pasta(sys.argv[1] if len(sys.argv) > 1 else None)

    tempo, energia = defaultdict(list), defaultdict(list)
    with open(os.path.join(pasta, "energia.csv"), newline="", encoding="utf-8-sig") as f:
        for r in le_linhas(f):
            if r["tempo_s"] and r["energia_pkg_J"]:
                tempo[r["config"]].append(num(r["tempo_s"]))
                energia[r["config"]].append(num(r["energia_pkg_J"]))
    if not tempo:
        sys.exit("Nenhuma medição encontrada em energia.csv.")

    def mdp(v):
        return st.mean(v), (st.stdev(v) if len(v) > 1 else 0.0)

    pts = {c: (*mdp(tempo[c]), *mdp(energia[c])) for c in tempo}   # (T, dT, E, dE)

    def ordenadas(prefixo):
        return sorted((c for c in pts if re.fullmatch(prefixo + r"_\d+", c)),
                      key=lambda c: int(c.split("_")[1]))

    # (rótulo na legenda, cor, marcador, configurações em ordem, oco?, ligar com linha?)
    series = [
        ("P-cores sem HT", AZUL, "o", ordenadas("p"), False, True),
        ("P-cores com HT (12 threads)", AZUL, "s", [c for c in ("p_ht",) if c in pts], True, False),
        ("E-cores", LARANJA, "^", ordenadas("e"), False, True),
        ("6 P-cores + 4 E-cores", AQUA, "D", [c for c in ("p6_e4",) if c in pts], False, False),
    ]

    plt.rcParams.update({"font.size": 10, "axes.edgecolor": EIXO, "axes.labelcolor": TEXTO2,
                         "xtick.color": TEXTO2, "ytick.color": TEXTO2})
    fig, ax = plt.subplots(figsize=(9.5, 6.2), facecolor=SUPERFICIE)
    ax.set_facecolor(SUPERFICIE)

    xs = [pts[c][0] for c in pts]
    ys = [pts[c][2] for c in pts]
    xmin, xmax = min(xs) * 0.72, max(xs) * 1.28
    ymin, ymax = min(ys) * 0.88, max(ys) * 1.1
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlim(xmin, xmax)
    ax.set_ylim(ymin, ymax)

    # curvas de EDP constante (referência recessiva), rotuladas no ponto onde entram no gráfico
    k_vals = [k for k in (400, 800, 1600, 3200, 6400, 12800)
              if k / xmax < ymax and k / xmin > ymin]
    for k in k_vals:
        ts = [xmin, xmax]
        ax.plot(ts, [k / t for t in ts], linestyle=(0, (4, 4)), color=ISO, linewidth=1, zorder=1)
        t_lab = max(xmin * 1.02, k / (ymax * 0.97))
        e_lab = k / t_lab
        if e_lab < ymin * 1.03:
            continue
        ax.text(t_lab, e_lab, f" EDP = {k:g} J·s", color=TEXTO2, fontsize=8, va="bottom",
                ha="left", zorder=2)

    for nome, cor, marc, cfgs, oco, ligar in series:
        if not cfgs:
            continue
        T = [pts[c][0] for c in cfgs]
        E = [pts[c][2] for c in cfgs]
        if ligar and len(cfgs) > 1:
            ax.plot(T, E, color=cor, linewidth=2, alpha=0.9, zorder=3)
        for c in cfgs:
            t, dt, e, de = pts[c]
            ax.errorbar(t, e, xerr=dt, yerr=de, fmt="none", ecolor=cor, elinewidth=1.2,
                        capsize=2.5, alpha=0.85, zorder=4)
            ax.plot(t, e, marker=marc, markersize=9 if marc != "D" else 8,
                    markerfacecolor=SUPERFICIE if oco else cor, markeredgecolor=cor if oco else SUPERFICIE,
                    markeredgewidth=2 if oco else 1.5, linestyle="none", zorder=5)
            dx, dy = OFFSETS.get(c, (8, 6))
            ax.annotate(c, (t, e), textcoords="offset points", xytext=(dx, dy), ha="left",
                        fontsize=9, color=TEXTO, zorder=6,
                        bbox=dict(boxstyle="round,pad=0.12", fc=SUPERFICIE, ec="none", alpha=0.85))

    # menor EDP = melhor compromisso
    melhor = min(pts, key=lambda c: pts[c][0] * pts[c][2])
    t, e = pts[melhor][0], pts[melhor][2]
    ax.annotate(f"menor EDP: {melhor}\n({t * e:.0f} J·s)", (t, e), textcoords="offset points",
                xytext=(-8, 62), ha="center", fontsize=9, color=TEXTO, zorder=7,
                arrowprops=dict(arrowstyle="-", color=TEXTO2, linewidth=0.8, shrinkA=2, shrinkB=7),
                bbox=dict(boxstyle="round,pad=0.25", fc=SUPERFICIE, ec=EIXO, linewidth=0.8))

    # eixos
    xt = [t for t in (2, 3, 4, 5, 7, 10, 15, 20, 30) if xmin <= t <= xmax]
    yt = [v for v in (130, 150, 175, 200, 250, 300) if ymin <= v <= ymax]
    ax.xaxis.set_major_locator(FixedLocator(xt))
    ax.yaxis.set_major_locator(FixedLocator(yt))
    ax.xaxis.set_minor_locator(NullLocator())
    ax.yaxis.set_minor_locator(NullLocator())
    fmt = FuncFormatter(lambda v, _: f"{v:g}")
    ax.xaxis.set_major_formatter(fmt)
    ax.yaxis.set_major_formatter(fmt)
    ax.grid(color=GRADE, linewidth=1, zorder=0)
    ax.set_axisbelow(True)
    for lado in ("top", "right"):
        ax.spines[lado].set_visible(False)
    ax.set_xlabel("Tempo de execução (s, escala log)")
    ax.set_ylabel("Energia do pacote por execução (J, escala log)")
    ax.set_title("Energia × tempo por configuração (menor é melhor nos dois eixos)",
                 loc="left", fontsize=12, color=TEXTO, pad=12)

    # legenda (4 entradas: o HT usa a cor dos P-cores e se distingue pelo marcador)
    handles = [Line2D([0], [0], marker=m, color=c if lig else "none", linewidth=2,
                      markersize=8, markerfacecolor=SUPERFICIE if oco else c,
                      markeredgecolor=c, markeredgewidth=2 if oco else 1, label=n)
               for n, c, m, cfgs, oco, lig in series if cfgs]
    handles.append(Line2D([0], [0], color=ISO, linestyle=(0, (4, 4)), linewidth=1,
                          label="EDP constante (E × T)"))
    leg = ax.legend(handles=handles, loc="lower right", frameon=True, fontsize=9,
                    labelcolor=TEXTO, facecolor=SUPERFICIE, edgecolor="none", framealpha=0.92)

    fig.tight_layout()
    saida = os.path.join(pasta, "tradeoff_energia_tempo.png")
    fig.savefig(saida, dpi=200, facecolor=SUPERFICIE)
    print(f"Gráfico salvo em {saida}\n")

    # visão em tabela (equivalente textual do gráfico)
    print(f"{'config':<8}{'tempo (s)':>11}{'energia (J)':>13}{'EDP (J·s)':>12}")
    for c in sorted(pts, key=lambda c: pts[c][0] * pts[c][2]):
        t, _, e, _ = pts[c]
        print(f"{c:<8}{t:>11.3f}{e:>13.1f}{t * e:>12.1f}")


if __name__ == "__main__":
    main()
