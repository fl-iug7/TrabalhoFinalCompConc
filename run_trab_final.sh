#!/bin/bash

# Descrição:
# Este script fornece um menu interativo para o usuário, onde ele pode escolher entre várias opções:
# 1. Criar uma entrada única.
# 2. Criar 10 entradas com tamanhos de vetores de potências de 10 (10^1 a 10^10).
# 3. Executar o algoritmo SeqQuicksort (Quicksort sequencial).
# 4. Executar o algoritmo ConcQuicksort (Quicksort concorrente).
# 5. Executar o algoritmo SeqMinMaxSort (MinMaxSort sequencial).
# 6. Executar o algoritmo ConcMinMaxSort (MinMaxSort concorrente).
# 7. Validar os resultados de saída gerados pelos algoritmos executados.
# Dependendo da escolha, o script chama o script correspondente para executar a tarefa.

# Função para exibir o menu de opções
exibir_menu() {
    echo "Por favor, escolha uma opção:"
    echo "--------------------------------------------------"
    echo "(1) - Criar 1 Entrada"
    echo "(2) - Criar 10 Entradas (10^1 - 10^10)"
    echo "(3) - Executar Quicksort Sequencial"
    echo "(4) - Executar Quicksort Concorrente"
    echo "(5) - Executar MinMaxSort Sequencial"
    echo "(6) - Executar MinMaxSort Concorrente"
    echo "(7) - Validar Resultados"
    echo "--------------------------------------------------"
}

# Exibe o menu de opções para o usuário
exibir_menu

# Lê a escolha do usuário
read -p "Digite sua escolha [1-7]: " escolha

# Trata a escolha do usuário
case $escolha in
    1)
        # Chama o script para criar uma única entrada de dados
        echo "Criando 1 entrada..."
        echo "--------------------------------------------------"
        ./Scripts/create_input.sh
        ;;
    2)
        # Chama o script para criar 10 entradas com tamanhos variados (potências de 10)
        echo "Criando 10 entradas..."
        echo "--------------------------------------------------"
        ./Scripts/create_inputs.sh
        ;;
    3)
        # Chama o script para executar o algoritmo SeqQuicksort (Quicksort sequencial)
        echo "Executando Quicksort Sequencial..."
        echo "--------------------------------------------------"
        ./Scripts/seq_quicksort.sh
        ;;
    4)
        # Chama o script para executar o algoritmo ConcQuicksort (Quicksort concorrente)
        echo "Executando Quicksort Concorrente..."
        echo "--------------------------------------------------"
        ./Scripts/conc_quicksort.sh
        ;;
    5)
        # Chama o script para executar o algoritmo SeqMinMaxSort (MinMaxSort sequencial)
        echo "Executando MinMaxSort Sequencial..."
        echo "--------------------------------------------------"
        ./Scripts/seq_minmax.sh
        ;;
    6)
        # Chama o script para executar o algoritmo ConcMinMaxSort (MinMaxSort concorrente)
        echo "Executando MinMaxSort Concorrente..."
        echo "--------------------------------------------------"
        ./Scripts/conc_minmax.sh
        ;;
    7)
        # Chama o script para validar os resultados gerados pelos algoritmos
        echo "Validando os Resultados..."
        echo "--------------------------------------------------"
        ./Scripts/validate_output.sh
        ;;
    *)
        # Caso o usuário escolha uma opção inválida
        echo "Escolha inválida. Por favor, selecione um número entre 1 e 7."
        echo "--------------------------------------------------"
        exit 1
        ;;
esac
