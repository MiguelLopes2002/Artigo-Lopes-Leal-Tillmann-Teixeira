# FATORES DETERMINANTES DA PERMANÊNCIA NO EMPREGO FORMAL NO SUL DO BRASIL: Uma Análise Empírica com Modelo Logit Ordenado Generalizado

> **Repositório público com scripts Stata (.do) e material de replicação**

---

## 🇧🇷 Descrição

Este projeto investiga os determinantes da duração do vínculo de trabalho formal nos estados do Rio Grande do Sul, Santa Catarina e Paraná, utilizando microdados da RAIS 2024. A metodologia baseia-se no **Modelo Logit Ordenado Generalizado** (`gologit2`).

### 📂 Estrutura de pastas
| Pasta / arquivo            | Conteúdo                                                          |
|----------------------------|-------------------------------------------------------------------|
| `scripts/01_main.do`       | Limpeza dos dados, criação de variáveis e estimação do modelo     |
| `scripts/02_loop.do`       | Loop para escolha do melhor modelo (Wald, pseudo-R², log-L)       |
| `dados/`                   | **Não** contém microdados da RAIS (restrição legal); coloque-os aqui localmente |
| `outputs/`                 | Logs, tabelas e/ou gráficos gerados                               |
| `doc/`                     | Preprints, anexos, apresentações                                  |

### ⚙️ Execução
1. Obtenha os microdados RAIS 2024 via Ministério do Trabalho e salve em `dados/`, ou outra pasta.
2. Abra o Stata no diretório raiz do repositório.
3. Rode `do scripts/01_main.do` para reproduzir os resultados principais.  
4. Para experimentar diferentes pontos de corte, rode `do scripts/02_loop_modelos.do`.  
5. Resultados podem salvos em `outputs/`.

### 👥 Autores
- Miguel das Neves Lopes  
- Ricardo Aguirre Leal  
- Eduardo Andre Tillmann  
- Gibran da Silva Teixeira  

---

## 🇬🇧 Description

This project analyzes the determinants of formal job-duration in Brazil’s Southern states (RS, SC, PR) using RAIS 2024 microdata. We estimate **Generalised Ordered Logit models** (`gologit2`).

### 📂 Folder layout
| Folder / file              | Content                                                            |
|----------------------------|---------------------------------------------------------------------|
| `scripts/01_main.do`       | Data cleaning, variable construction, model estimation              |
| `scripts/02_loop_modelos.do`| Loop testing multiple cut-points (Wald, pseudo-R², log-L)          |
| `dados/`                   | **No raw RAIS microdata** (legal restriction) – place locally       |
| `outputs/`                 | Execution logs, tables, figures                                    |
| `doc/`                     | Preprints, appendices, slides                                      |

### ⚙️ Run
1. Obtain RAIS 2024 microdata (Ministry of Labour) and place in `dados/`, or other folder.
2. Open Stata in the repo’s root folder.
3. Run `do scripts/01_main.do` to reproduce baseline results.  
4. To explore alternative cut-points, run `do scripts/02_loop_modelos.do`.  
5. Outputs can be saved in `outputs/`.

### 👥 Authors
- Miguel das Neves Lopes  
- Ricardo Aguirre Leal  
- Eduardo Andre Tillmann  
- Gibran da Silva Teixeira  

---

## 📜 License

This repository is released under the terms of the [MIT License](./LICENSE).  
Uma tradução livre em português está disponível em [LICENSE_PT.txt](./LICENSE_PT.txt).
