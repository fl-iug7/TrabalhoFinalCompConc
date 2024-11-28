# Execução de Algoritmos Quicksort e MinMaxSort (Manual)

Este diretório contém implementações de algoritmos de ordenação e diversos programas utilitários para trabalhar com arrays e arquivos em C. A seguir, são apresentadas as funcionalidades e usos tanto dos algoritmos de ordenação sequenciais e concorrentes quanto dos utilitários para operações com arquivos binários, como verificação de ordem e combinação de arquivos.

---

## Introdução

### Algoritmos de Ordenação

#### MinMaxSort (Sequencial)
O **MinMaxSort** é um algoritmo que encontra iterativamente os elementos mínimo e máximo em um array, colocando-os nas posições corretas.

#### QuickSort (Sequencial)
O **QuickSort** é um algoritmo de ordenação baseado na técnica de divisão e conquista. Ele particiona o array e ordena as partes recursivamente.

#### MinMaxSort (Concorrente)
Na versão concorrente, o **MinMaxSort** divide o array em segmentos, processados em paralelo por múltiplas threads.

#### QuickSort (Concorrente)
O **QuickSort Concorrente** utiliza threads para dividir e ordenar as partições do array de maneira paralela.

---

## Funcionalidades

### Algoritmos de Ordenação
- **Manipulação de Arquivos Binários**: Leitura e gravação de Arrays a partir de arquivos binários.
- **Execução Paralela (Concorrente)**: Usando **pthreads**, as versões concorrentes dos algoritmos podem usar de múltiplas threads para acelerar o processo.
- **Medição de Desempenho**: Acompanhamento do tempo de execução e o número de threads usadas, com registro em logs para análise de desempenho.

### Programas Utilitários
- **Verificação de Ordem**: Verifica se um Array de inteiros em um arquivo binário está ordenado.
- **Geração de Arrays**: Gera Arrays de números flutuantes aleatórios ou em ordem decrescente e os grava em arquivos binários.
- **Combinação de Arquivos**: Combina arquivos de texto em um único arquivo CSV, ignorando cabeçalhos antigos e criando um novo.
- **Leitura de Arquivo Binário**: Lê e exibe Arrays de arquivos binários, mostrando o tamanho e os elementos.

---

## Requisitos

- **Compilador**: `gcc` ou qualquer compilador C com suporte à biblioteca POSIX de threads.
- **Bibliotecas**: Biblioteca padrão C (`stdlib.h`, `stdio.h`, etc.) e biblioteca POSIX de threads (`-lpthread` para versões concorrentes).

---

## Configuração e Uso

### Compilação

Compile os programas com os seguintes comandos:

#### Algoritmos de Ordenação
```bash
# Compilar MinMaxSort (Sequencial)
gcc -o SeqMinMaxSort SeqMinMaxSort.c

# Compilar QuickSort (Sequencial)
gcc -o SeqQuickSort SeqQuickSort.c

# Compilar MinMaxSort (Concorrente)
gcc -o ConcMinMaxSort ConcMinMaxSort.c -lpthread

# Compilar QuickSort (Concorrente)
gcc -o ConcQuicksort ConcQuicksort.c -lpthread
```

#### Programas Utilitários
```bash
gcc -o ValidarResultado ValidarResultado.c
gcc -o CriarEntrada CriarEntrada.c
gcc -o GerarCSV GerarCSV.c
gcc -o PrintResultado PrintResultado.c
```

### Execução

Execute os programas conforme as funcionalidades específicas de cada um.

---

## Algoritmos

### MinMaxSort (Sequencial)
1. **Seleção do Mínimo e Máximo**: Encontra repetidamente os elementos mínimo e máximo no array não ordenado.
2. **Troca**: Coloca o mínimo no início e o máximo no final.
3. **Redução Iterativa**: Repete o processo até que o array esteja ordenado.

### QuickSort (Sequencial)
1. **Particionamento**: Seleciona um pivô e rearranja os elementos para que os menores fiquem à esquerda e os maiores à direita.
2. **Ordenação Recursiva**: Ordena recursivamente as partições do array.

### MinMaxSort (Concorrente)
1. **Segmentação**: Divide o array em segmentos, com base no número de threads.
2. **Ordenação com Threads**: Cada thread ordena seu segmento utilizando MinMaxSort.
3. **Mesclagem**: Mescla os segmentos ordenados.

### QuickSort (Concorrente)
1. **Particionamento**: Divide o array em partições com base no pivô.
2. **Ordenação Recursiva com Threads**: Threads são criadas para cada partição até que o limite de threads seja atingido.
3. **Conclusão**: Ordena as partições recursivamente.

---

## Registro e Saída

Todos os programas de ordenação e utilitários registram métricas de desempenho no diretório `Data`:

- **Log do MinMaxSort**: `Data/seq_minmax.txt` (sequencial) e `Data/conc_minmax.txt` (concorrente)
- **Log do QuickSort**: `Data/seq_quicksort.txt` (sequencial) e `Data/conc_quicksort.txt` (concorrente)

Formato do log:
```
Programa,Tempo,Comprimento,Threads
```

---

## Observações

- **Arquivo de Entrada Ausente**: Verifique se o arquivo binário de entrada existe.
- **Erro de Memória**: Reduza o tamanho dos arrays ou o número de threads.
- **Erros de Registro**: Verifique as permissões de gravação no diretório `Data`.
