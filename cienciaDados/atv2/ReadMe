# Trabalho: Imputação de Valores Ausentes

## Descrição

Este projeto avalia experimentalmente como diferentes técnicas de imputação de valores ausentes se comportam sob diferentes mecanismos (MCAR, MAR, MNAR) e níveis de ausência (1% a 30%), medindo o impacto no desempenho de modelos preditivos em quatro datasets públicos.

---

## Requisitos

- **Python:** 3.9
- **Sistema Operacional:** Windows 10/11
- **Git** instalado e disponível no PATH
- **PowerShell** (para execução do instalador)


## Instalação

### 1. Instalar o Python 3.9

Baixe e instale o Python 3.9 em: https://www.python.org/downloads/release/python-390/

> Durante a instalação, marque a opção **"Add Python to PATH"**.

### 2. Clonar o repositório

```bash
git clone https://github.com/KaikyLima/mestrado.git
cd cienciaDados/atv2
```

### 3. Executar o instalador

Execute o script `Instalador.bat` na raiz do projeto. Ele irá:

- Criar o ambiente virtual com Python 3.9
- Ativar o ambiente virtual
- Instalar todas as dependências do `requirements.txt`
- Clonar e configurar a biblioteca Jenga

```powershell
.\Instalador.bat
```

O instalador executa internamente:

```powershell
py -3.9 -m venv venv
.\venv\Scripts\Activate.ps1

pip install --upgrade pip
pip install setuptools==65.5.0
pip install wheel

pip install -r requirements.txt

# Clona o Jenga
git clone https://github.com/schelterlabs/jenga.git

# Remove o .git interno do Jenga
Remove-Item -Recurse -Force jenga\.git
```

---

## Ordem de Execução

Após a instalação, abra o Jupyter Notebook com o ambiente virtual ativado e execute os notebooks na seguinte ordem:

### 1. `lab2_base.ipynb` — Experimento principal

Execute as células em ordem:

| Célula | Descrição |
|--------|-----------|
| 1 | Configuração do path |
| 2 | Importação de bibliotecas |
| 3 | Metadados dos datasets |
| 4 | Download dos datasets |
| 5 | Funções de imputação e treinamento |
| 6 | Configuração da execução (seeds, mecanismos) |
| 7 | Barra de progresso |
| **8** | **Execução principal** — roda todos os experimentos |
| 9 | Geração das tabelas do relatório (salva em `tables/`) |
| 10+ | Geração dos gráficos (salva em `figures/`) |

> ⚠️ A célula 8 é a mais demorada. Em modo completo, o tempo de execução é de aproximadamente **500 minutos** com 6 workers paralelos (`n_jobs=6`).

### 2. `utils.ipynb` — Utilitários (opcional)

Contém três células independentes que podem ser rodadas a qualquer momento:

- **Monitor:** acompanha o progresso da execução em tempo real
- **Nucleos:** acompanha quais nucleos da máquina estão em uso
- **Limpeza:** apaga o cache para reiniciar os experimentos do zero

---

## Estrutura de Arquivos

```
.
├── Instalador.bat              # Script de instalação do ambiente
├── requirements.txt            # Dependências Python
├── README.md                   # Este arquivo
│
├── lab2Test_modified.ipynb     # Notebook principal dos experimentos
├── utils.ipynb                 # Utilitários
│
├── jenga/                      # Biblioteca Jenga (clonada pelo instalador)
│
├── data/                       # Datasets e resultados
│   ├── adult/
│   ├── bank_marketing/
│   ├── air_quality_uci/
│   ├── communities_crime/
│   ├── all_results.csv         # Resultados completos (7.386 linhas)
│   └── summary_results.csv     # Resumo com média e desvio padrão
│
├── tables/                     # Tabelas geradas para o relatório
│   ├── tab1_baseline.csv
│   ├── tab2_mecanismo_classificacao.csv
│   ├── tab2_mecanismo_regressao.csv
│   ├── tab3_percentual_classificacao.csv
│   ├── tab3_percentual_regressao.csv
│   ├── tab4_imputadores_classificacao.csv
│   ├── tab4_imputadores_regressao.csv
│   ├── tab5_qualidade_imputacao.csv
│   ├── tab6_modelos_classificacao.csv
│   ├── tab6_modelos_regressao.csv
│   ├── tab7_completa_media_std.csv
│   └── tabelas_relatorio.xlsx  # Todas as tabelas em abas separadas
│
├── figures/                    # Gráficos gerados
│   ├── fig1_curvas_percentual.png
│   ├── fig2_mcar_mar_mnar.png
│   ├── fig3_heatmap.png
│   ├── fig4_imp_quality_vs_pred.png
│   ├── fig5_robustos_vs_simples.png
│   └── fig6_modelos.png
│
└── cache_experimentos/         # Cache dos experimentos (gerado automaticamente)
```

---

## Onde estão os resultados

| Arquivo | Descrição |
|---------|-----------|
| `data/all_results.csv` | Todos os resultados: 7.386 linhas com média por seed, mecanismo, taxa, imputador e modelo |
| `data/summary_results.csv` | Resumo agrupado por dataset, mecanismo, taxa, imputador e modelo |
| `tables/tab7_completa_media_std.csv` | Média e desvio padrão entre as 3 seeds para todas as combinações |
| `tables/tabelas_relatorio.xlsx` | Tabelas prontas para o relatório, organizadas por aba |
| `figures/` | Todos os gráficos usados no relatório |

---

## Tempo Aproximado de Execução
| n_jobs=6 | ~500 minutos |

> O sistema de checkpoint salva o progresso a cada experimento concluído em `cache_experimentos/`. Se a execução for interrompida, ao rodar novamente ela retoma de onde parou automaticamente.

---

## Limitações Conhecidas

- O instalador foi testado apenas em **Windows 10/11** com PowerShell.
- O miceforest foi executado com `iterations=1` e `max_cols=30` por limitação computacional.
