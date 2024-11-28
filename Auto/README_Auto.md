# Execução de Algoritmos Quicksort e MinMaxSort (Automático)

Este diretório possui um script (run_trab_final.sh) que fornece um menu interativo para gerenciar e executar várias tarefas, como: uso de algoritmos de ordenação, geração de entradas, validação e agregação de resultados. Além disso, o script possibilita que os usuários interajam de forma simples com outros scripts, garantindo um fluxo de trabalho automatizado. Por fim, ao final da execução, cada algoritmo gera um arquivo binário correspondente a entrada ordenada.

---

## Funcionalidades

1. **Criar Entrada Única**  
   Gera um arquivo de entrada único com parâmetros personalizados.

2. **Criar Múltiplas Entradas**  
   Gera automaticamente 10 arquivos de entrada, cada um com tamanhos de vetor em potências de 10 (10¹ a 10¹⁰).

3. **Executar Quicksort Sequencial**  
   Executa o algoritmo Quicksort Sequencial.

4. **Executar Quicksort Concorrente**  
   Executa o algoritmo Quicksort Concorrente.

5. **Executar MinMaxSort Sequencial**  
   Executa o algoritmo MinMaxSort Sequencial.

6. **Executar MinMaxSort Concorrente**  
   Executa o algoritmo MinMaxSort Concorrente.

7. **Validar Resultados**  
   Verifica se os arquivos de saída gerados pelos algoritmos de ordenação estão corretamente ordenados.

8. **Gerar CSV dos Resultados**  
   Agrega e gera um arquivo CSV a partir dos logs dos algoritmos executados.

9. **Sair**  
   Sai do menu.

---

## Design do Menu

```plaintext
==================================================
    Trabalho Final de Programação Concorrente
           Quicksort x MinMaxSort
==================================================
(1) - Criar 1 Entrada
(2) - Criar N Entradas (10^1, 10^2, ..., 10^N)
(3) - Executar Quicksort Sequencial
(4) - Executar Quicksort Concorrente
(5) - Executar MinMaxSort Sequencial
(6) - Executar MinMaxSort Concorrente
(7) - Validar Resultados
(8) - Gerar CSV dos Resultados
(9) - Sair
==================================================
    Universidade Federal do Rio de Janeiro
==================================================
Digite sua escolha [1-9]:
```

---

## Uso

### 1. Verificar Permissões do Script
Antes de executar o script, certifique-se de que ele tenha permissões de execução:
```bash
chmod +x run_trab_final.sh
```

### 2. Executar o Script
Execute o script do run_trab_final:
```bash
./run_trab_final.sh
```

### 3. Seguir o Menu Interativo
Use os prompts na tela para selecionar opções, digitando um número entre 1 e 9.

---

## Fluxo de Trabalho do Script

### Gerenciamento de Permissões
O script verifica dinamicamente se os scripts de destino (na pasta `Scripts`) têm permissões de execução. Caso contrário, ele aplica as permissões apropriadas usando `chmod +x`.

### Execução das Tarefas
Cada opção do menu corresponde a um script separado localizado na pasta `Scripts`:
- `create_input.sh`: Gera um arquivo de entrada único.
- `create_inputs.sh`: Gera múltiplos arquivos de entrada.
- `seq_quicksort.sh`: Executa o Quicksort Sequencial.
- `conc_quicksort.sh`: Executa o Quicksort Concorrente.
- `seq_minmax.sh`: Executa o MinMaxSort Sequencial.
- `conc_minmax.sh`: Executa o MinMaxSort Concorrente.
- `validate_output.sh`: Valida arquivos de saída.
- `generate_csv.sh`: Combina logs em um arquivo CSV.

### Gerenciamento de Saída
A opção `9` termina o loop do menu e sai do script de forma limpa.

---

## Estrutura do Diretório

```plaintext
├── Auto/                             # Diretório para execução automatizada
    ├── Files/                        # Arquivos de entrada e saída
    │   ├── Input/                    # Arquivos de entrada
    │   └── Output/                   # Arquivos de saída
    ├── Code/                         # Código para automação
    │   ├── CreatInput/               # Scripts para criar entradas
    │   ├── GenerateCSV/              # Scripts para gerar arquivos CSV
    │   ├── MinMaxSort/               # Algoritmos MinMaxSort
    │   │   ├── Seq/                  # MinMaxSort sequencial
    │   │   └── Conc/                 # MinMaxSort concorrente
    │   ├── Quicksort/                # Algoritmos Quicksort
    │   │   ├── Seq/                  # Quicksort sequencial
    │   │   └── Conc/                 # Quicksort concorrente
    │   ├── PrintOutput/              # Scripts para imprimir saída
    │   └── ValidateOutput/           # Scripts para validação de saída
    └── run_trab_final.sh             # Script principal com menu interativo

```

---

## Observações

- Certifique-se de que todos os scripts referenciados no diretório `Scripts` existam e funcionem corretamente.
- Arquivos de saída e logs são armazenados no diretório `Data`.
