# Trabalho: Imputação de Valores Ausentes

## Informações
- Disciplina: Tópicos em Eng. Software - Ciência de Dados
- Professor: Prof. Eduardo Pena
- UTFPR — Câmpus Campo Mourão

## Ambiente
- Python: >= 3.10
- Sistema Operacional: Linux/Windows/macOS

## Instalação
```bash
pip install -r requirements.txt
```

Se o Jenga não instalar via pip, instale via GitHub:
```bash
pip install git+https://github.com/schelterlabs/jenga.git
```
Se o Jenga não estiver disponível, o notebook usa automaticamente
uma implementação compatível com a mesma semântica (MCAR/MAR/MNAR).

## Execução
1. Abra `notebook.ipynb` no Jupyter Lab ou Jupyter Notebook
2. Execute as células em ordem (Kernel > Restart & Run All)
3. A célula de instalação (Célula 1) instala dependências automaticamente
4. Os dados são baixados automaticamente da UCI ML Repository

## Tempo estimado de execução
- Configuração rápida (1 seed, 1 dataset): ~5 minutos
- Configuração completa (3 seeds, 4 datasets): 2-6 horas

## Resultados
Todos os arquivos de resultados ficam na pasta `results/`:

| Arquivo | Descrição |
|---------|----------|
| `dataset_summary.csv` | Tabela-resumo dos 4 datasets |
| `baseline_results.csv` | Resultados sem injeção de nulos |
| `full_results.csv` | Resultados completos (todos os cenários) |
| `classification_summary.csv` | Sumário (média ± std) para classificação |
| `regression_summary.csv` | Sumário (média ± std) para regressão |
| `fig1_performance_vs_rate.png` | Curvas de desempenho por % de nulos |
| `fig2_heatmap_mech_imputer.png` | Heatmap mecanismo × imputador |
| `fig3_model_comparison.png` | Comparação modelos básicos vs LightGBM |
| `fig4_imputation_quality_vs_performance.png` | Qualidade imputação vs desempenho |

## Nota sobre o Jenga
O Jenga é usado para injeção controlada de MCAR, MAR e MNAR conforme especificado
no trabalho (https://github.com/schelterlabs/jenga). Caso não instale por
incompatibilidade de ambiente, a implementação própria inclusa segue a mesma
semântica e foi validada para produzir as mesmas proporções de nulos.

## IA Generativa
Este trabalho utilizou Claude (Anthropic) para auxiliar na estruturação do código,
correção de bugs de compatibilidade sklearn e organização do pipeline experimental.
Todo o conteúdo científico, análise dos resultados e interpretações foram produzidos
pelo grupo.
