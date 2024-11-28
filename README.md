# Trabalho Final de Computação Concorrente

Este repositório contém a implementação de algoritmos de ordenação **Quicksort** e **MinMaxSort**, tanto em versões sequenciais quanto concorrentes, utilizando a linguagem **C**. O projeto possui duas abordagens para execução dos algoritmos: uma versão automática e uma manual.

O diretório é dividido em duas pastas principais:

- **Auto**: Contém scripts para automação da execução dos algoritmos, geração de entradas e validação dos resultados.
- **Manual**: Contém as implementações dos algoritmos de ordenação e programas utilitários em C para manipulação de arquivos binários, verificação de ordenação e medição de desempenho.

---

## Estrutura do Diretório

```plaintext
TrabalhoFinalCompConc/
│
├── Auto/                             # Diretório para execução automatizada
│   ├── Files/                        # Arquivos de entrada e saída
│   │   ├── Input/                    # Arquivos de entrada
│   │   └── Output/                   # Arquivos de saída
│   ├── Code/                         # Código para automação
│   │   ├── CreatInput/               # Scripts para criar entradas
│   │   ├── GenerateCSV/              # Scripts para gerar arquivos CSV
│   │   ├── MinMaxSort/               # Algoritmos MinMaxSort
│   │   │   ├── Seq/                  # MinMaxSort sequencial
│   │   │   └── Conc/                 # MinMaxSort concorrente
│   │   ├── Quicksort/                # Algoritmos Quicksort
│   │   │   ├── Seq/                  # Quicksort sequencial
│   │   │   └── Conc/                 # Quicksort concorrente
│   │   ├── PrintOutput/              # Scripts para imprimir saída
│   │   └── ValidateOutput/           # Scripts para validação de saída
│   └── run_trab_final.sh             # Script principal com menu interativo
│
├── Manual/                           # Diretório com implementações dos algoritmos e utilitários em C
│   ├── SeqMinMaxSort.c               # Implementação do MinMaxSort sequencial
│   ├── SeqQuickSort.c                # Implementação do Quicksort sequencial
│   ├── ConcMinMaxSort.c              # Implementação do MinMaxSort concorrente
│   ├── ConcQuickSort.c               # Implementação do Quicksort concorrente
│   ├── ValidarResultado.c            # Programa para validar arquivos binários de saída
│   ├── CriarEntrada.c                # Programa para gerar entradas
│   ├── GerarCSV.c                    # Programa para combinar arquivos em um CSV
│   └── PrintResultado.c              # Programa para exibir resultados
│   └── Data/                         # Arquivos específicos dentro de "Manual"
```

---

## Funcionalidades

### 1. **Auto (Execução Automática)**
O diretório **Auto** contém um script `run_trab_final.sh`, que fornece um menu interativo para automatizar a execução dos algoritmos e a manipulação de dados.

#### Funcionalidades do Menu
- **Criar Entrada Única**: Gera um arquivo de entrada com parâmetros personalizados.
- **Criar Múltiplas Entradas**: Gera automaticamente múltiplos arquivos de entrada com tamanhos em potências de 10.
- **Executar Quicksort Sequencial**: Executa o algoritmo Quicksort de forma sequencial.
- **Executar Quicksort Concorrente**: Executa o algoritmo Quicksort utilizando múltiplas threads.
- **Executar MinMaxSort Sequencial**: Executa o algoritmo MinMaxSort sequencialmente.
- **Executar MinMaxSort Concorrente**: Executa o MinMaxSort utilizando múltiplas threads.
- **Validar Resultados**: Verifica se os resultados estão corretamente ordenados.
- **Gerar CSV dos Resultados**: Gera um arquivo CSV com os logs de execução.

#### Como Compilar e Executar
Compile o script utilizando **chmod +x**:
```bash
chmod +x run_trab_final.sh
```

### 2. **Manual (Execução Manual)**
O diretório **Manual** contém as implementações em C dos algoritmos e programas utilitários para realizar operações com arquivos binários.

#### Como Compilar e Executar
Compile os programas utilizando **gcc** com as opções adequadas, por exemplo:

```bash
# Para compilar os algoritmos de ordenação:
gcc -o SeqMinMaxSort SeqMinMaxSort.c
gcc -o SeqQuickSort SeqQuickSort.c
gcc -o ConcMinMaxSort ConcMinMaxSort.c -lpthread
gcc -o ConcQuickSort ConcQuickSort.c -lpthread

# Para compilar os utilitários:
gcc -o ValidarResultado ValidarResultado.c
gcc -o CriarEntrada CriarEntrada.c
gcc -o GerarCSV GerarCSV.c
gcc -o PrintResultado PrintResultado.c
```

---

## Requisitos
- **Compilador C**: gcc ou qualquer compilador C que suporte a biblioteca POSIX de threads.
- **Bibliotecas**: 
  - Biblioteca padrão C (`stdlib.h`, `stdio.h`, etc.)
  - Biblioteca POSIX de threads (`-lpthread` para versões concorrentes)

---

## Logs e Resultados
Os programas geram logs de execução e desempenho, que são armazenados no diretório **Data**. Os logs podem ser encontrados tanto dentro do diretório **Data** na raiz do projeto quanto nos subdiretórios dentro de **Auto/** e **Manual/**.

Exemplo de log:
```
Programa,Tempo,Comprimento,Threads
SeqMinMaxSort,0.035,1000000,1
ConcQuickSort,0.012,1000000,4
```

### Observações:
- Certifique-se de que todos os scripts e programas estão funcionando corretamente antes de executar as tarefas.
- Caso haja problemas com a memória, tente diminuir o tamanho do array ou o número de threads.
- Verifique as permissões de gravação no diretório **Data** para evitar erros ao salvar logs ou arquivos de saída.
