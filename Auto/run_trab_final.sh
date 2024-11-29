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
# 8. Gerar um arquivo CSV dos resultados gerados pelos algoritmos executados.
# 9. Sair do script.
# Dependendo da escolha, o script chama o script correspondente para executar a tarefa.

# Função para garantir que o script tenha permissão de execução
dar_permissao_execucao() {
    BLUE="\033[1;34m"
    if [ ! -x "$1" ]; then
        sudo chmod +x "$1"
        echo -e "${BLUE}chmod +x $1${RESET}"
        echo "--------------------------------------------------"
    fi
}

# Função para exibir o menu de opções
exibir_menu() {
    # Definir cores para melhor visibilidade
    RED="\033[1;31m"
    BLUE="\033[1;34m"
    WHITE="\033[1;37m"
    RESET="\033[0m"
    
    # Título do menu com formatação
    echo -e "${RED}=================================================="
    echo -e "${BLUE}    Trabalho Final de Programação Concorrente"
    echo -e "${BLUE}           Quicksort x MinMaxSort"
    echo -e "${RED}==================================================${RESET}"
    
    # Exibir as opções com destaque
    echo -e "${RED}(1)${BLUE} - Criar 1 Entrada"
    echo -e "${RED}(2)${BLUE} - Criar N Entradas (10^1, 10^2, ..., 10^N)"
    echo -e "${RED}(3)${BLUE} - Executar Quicksort Sequencial"
    echo -e "${RED}(4)${BLUE} - Executar Quicksort Concorrente"
    echo -e "${RED}(5)${BLUE} - Executar MinMaxSort Sequencial"
    echo -e "${RED}(6)${BLUE} - Executar MinMaxSort Concorrente"
    echo -e "${RED}(7)${BLUE} - Validar Resultados"
    echo -e "${RED}(8)${BLUE} - Gerar CSV dos Resultados"
    echo -e "${RED}(9)${BLUE} - Sair"
    
    # Separador final
    echo -e "${RED}==================================================${RESET}"
    
    # Mensagem de instrução
    echo -e "${BLUE}    Universidade Federal do Rio de Janeiro${RESET}"

    # Separador final
    echo -e "${RED}==================================================${RESET}"
}



# Loop principal
while true; do
    # Definir cores para melhor visibilidade
    RED="\033[1;31m"
    BLUE="\033[1;34m"
    WHITE="\033[1;37m"
    RESET="\033[0m"
    GREEN="\033[1;32m"

    # Exibe o menu de opções para o usuário
    exibir_menu

    # Lê a escolha do usuário
    echo -e "${BLUE}Digite sua escolha [1-9]: ${GREEN}" 
    read escolha
    # Separador final
    echo -e "${RED}==================================================${RESET}"

    # Trata a escolha do usuário
    case $escolha in
        1)
            # Chama o script para criar uma única entrada de dados
            echo -e "${BLUE}Criando 1 entrada...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/create_input.sh
            echo -e "\n\n"
            ./Scripts/create_input.sh
            echo -e "\n\n"
            ;;
        2)
            # Chama o script para criar 10 entradas com tamanhos variados (potências de 10)
            echo -e "${BLUE}Criando 10 entradas...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao ./Scripts/create_inputs.sh
            echo -e "\n\n"
            ./Scripts/create_inputs.sh
            echo -e "\n\n"
            ;;
        3)
            # Chama o script para executar o algoritmo SeqQuicksort (Quicksort sequencial)
            echo -e "${BLUE}Executando Quicksort Sequencial...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/seq_quicksort.sh
            echo -e "\n\n"
            ./Scripts/seq_quicksort.sh
            echo -e "\n\n"
            ;;
        4)
            # Chama o script para executar o algoritmo ConcQuicksort (Quicksort concorrente)
            echo -e "${BLUE}Executando Quicksort Concorrente...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/conc_quicksort.sh
            echo -e "\n\n"
            ./Scripts/conc_quicksort.sh
            echo -e "\n\n"
            ;;
        5)
            # Chama o script para executar o algoritmo SeqMinMaxSort (MinMaxSort sequencial)
            echo -e "${BLUE}Executando MinMaxSort Sequencial...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/seq_minmax.sh
            echo -e "\n\n"
            ./Scripts/seq_minmax.sh
            echo -e "\n\n"
            ;;
        6)
            # Chama o script para executar o algoritmo ConcMinMaxSort (MinMaxSort concorrente)
            echo -e "${BLUE}Executando MinMaxSort Concorrente...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/conc_minmax.sh
            echo -e "\n\n"
            ./Scripts/conc_minmax.sh
            echo -e "\n\n"
            ;;
        7)
            # Chama o script para validar os resultados gerados pelos algoritmos
            echo -e "${BLUE}Validando os Resultados...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/validate_output.sh
            echo -e "\n\n"
            ./Scripts/validate_output.sh
            echo -e "\n\n"
            ;;
        8)
            # Chama o script para gerar o CSV dos resultados gerados pelos algoritmos
            echo -e "${BLUE}Gerando CSV dos Resultados...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            dar_permissao_execucao $(pwd)/Scripts/generate_csv.sh
            echo -e "\n\n"
            ./Scripts/generate_csv.sh
            echo -e "\n\n"
            ;;
        9)
            # Sair do script
            echo -e "${BLUE}Saindo do script...${RESET}"
            echo -e "${RED}==================================================${RESET}"
            exit 0
            ;;
        *)
            # Caso o usuário escolha uma opção inválida
            echo -e "${BLUE}Escolha inválida. Por favor, selecione um número entre 1 e 9.${RESET}"
            echo -e "${RED}==================================================${RESET}"
            ;;
    esac
done
