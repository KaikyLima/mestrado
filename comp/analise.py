#!/usr/bin/env python3
"""Analisa os resultados do run_benchmark.sh.

Uso:  python3 analise.py [pasta_de_resultados]
Sem argumento, usa a pasta resultados_AAAAMMDD_HHMMSS mais recente.

Calcula por configuração: média e desvio de energia, tempo, potência média e
energia líquida (descontando a potência de idle). Para as configurações p_1..p_6
calcula também o custo marginal de cada núcleo adicionado.
Só usa a biblioteca padrão; os gráficos exigem matplotlib (opcional).
"""
import csv
import glob
import os
import re
import statistics as st
import sys
from collections import OrderedDict


def num(s):
    return float(str(s).strip().replace(",", "."))


def achar_pasta(arg):
    if arg:
        return arg
    pastas = [d for d in sorted(glob.glob("resultados_[0-9]*"))
              if os.path.exists(os.path.join(d, "energia.csv"))]
    if not pastas:
        sys.exit("Nenhuma pasta resultados_AAAAMMDD_HHMMSS com energia.csv encontrada.")
    return pastas[-1]


def potencia_idle(pasta):
    txt = open(os.path.join(pasta, "idle.txt")).read()
    j = re.search(r"([\d.,]+)\s+Joules", txt)
    t = re.search(r"([\d.,]+)\s+seconds time elapsed", txt)
    if not (j and t):
        sys.exit("Não consegui ler Joules/tempo de idle.txt")
    return num(j.group(1)) / num(t.group(1))


def media_dp(v):
    return (st.mean(v), st.stdev(v) if len(v) > 1 else 0.0)


def main():
    pasta = achar_pasta(sys.argv[1] if len(sys.argv) > 1 else None)
    p_idle = potencia_idle(pasta)
    print(f"Pasta: {pasta}")
    print(f"Potência de idle: {p_idle:.2f} W\n")

    grupos = OrderedDict()
    with open(os.path.join(pasta, "energia.csv"), newline="") as f:
        for r in csv.DictReader(f):
            if not r["energia_pkg_J"] or not r["tempo_elapsed_s"]:
                continue
            g = grupos.setdefault(r["config"], {"threads": int(r["threads"]), "linhas": []})
            e = num(r["energia_pkg_J"])
            el = num(r["tempo_elapsed_s"])
            t = num(r["tempo_s"]) if r["tempo_s"] else float("nan")
            g["linhas"].append({"E": e, "t": t, "el": el,
                                "P": e / el, "Eliq": e - p_idle * el})

    resumo = []
    for nome, g in grupos.items():
        L = g["linhas"]
        E = media_dp([x["E"] for x in L])
        Eliq = media_dp([x["Eliq"] for x in L])
        P = media_dp([x["P"] for x in L])
        t = media_dp([x["t"] for x in L])
        resumo.append({"config": nome, "threads": g["threads"], "n": len(L),
                       "E": E, "Eliq": Eliq, "P": P, "t": t})

    cab = f"{'config':<8}{'thr':>4}{'n':>4}  {'E (J)':>16}  {'E líq (J)':>16}  {'P (W)':>14}  {'tempo (s)':>16}"
    print(cab)
    print("-" * len(cab))
    for r in resumo:
        print(f"{r['config']:<8}{r['threads']:>4}{r['n']:>4}  "
              f"{r['E'][0]:>9.2f} ±{r['E'][1]:>5.2f}  "
              f"{r['Eliq'][0]:>9.2f} ±{r['Eliq'][1]:>5.2f}  "
              f"{r['P'][0]:>7.2f} ±{r['P'][1]:>4.2f}  "
              f"{r['t'][0]:>9.4f} ±{r['t'][1]:>6.4f}")

    # Custo marginal por núcleo adicionado (p_1 .. p_6)
    seq = sorted((r for r in resumo if re.fullmatch(r"p_\d+", r["config"])),
                 key=lambda r: r["threads"])
    if len(seq) > 1:
        print("\nCusto marginal por P-core adicionado (sem HT)")
        print(f"{'passo':<10}{'ΔP (W)':>10}{'ΔE líq (J)':>13}")
        ant_P, ant_E, ant_nome = p_idle, 0.0, "idle"
        for r in seq:
            print(f"{ant_nome}->{r['config']:<6}{r['P'][0] - ant_P:>10.2f}{r['Eliq'][0] - ant_E:>13.2f}")
            ant_P, ant_E, ant_nome = r["P"][0], r["Eliq"][0], r["config"]
        print("(ΔP = variação de potência média; é a medida mais comparável, já que o tempo muda entre configs.)")

    # Salva resumo
    saida = os.path.join(pasta, "resumo.csv")
    with open(saida, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["config", "threads", "n", "E_media_J", "E_dp_J", "Eliq_media_J", "Eliq_dp_J",
                    "P_media_W", "P_dp_W", "tempo_media_s", "tempo_dp_s"])
        for r in resumo:
            w.writerow([r["config"], r["threads"], r["n"], *r["E"], *r["Eliq"], *r["P"], *r["t"]])
    print(f"\nResumo salvo em {saida}")

    # Gráficos (opcional)
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError:
        print("matplotlib não instalado: gráficos não gerados (pip install --user matplotlib).")
        return

    nomes = [r["config"] for r in resumo]
    fig, ax = plt.subplots(1, 3, figsize=(15, 4.5))
    for a, chave, titulo, un in ((ax[0], "Eliq", "Energia líquida por execução", "J"),
                                 (ax[1], "P", "Potência média", "W"),
                                 (ax[2], "t", "Tempo de execução", "s")):
        a.bar(nomes, [r[chave][0] for r in resumo], yerr=[r[chave][1] for r in resumo], capsize=3)
        a.set_title(titulo)
        a.set_ylabel(un)
        a.tick_params(axis="x", rotation=45)
    fig.tight_layout()
    png = os.path.join(pasta, "grafico.png")
    fig.savefig(png, dpi=150)
    print(f"Gráfico salvo em {png}")


if __name__ == "__main__":
    main()
