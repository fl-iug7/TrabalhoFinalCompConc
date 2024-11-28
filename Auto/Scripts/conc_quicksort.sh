#!/bin/bash

# Definir cores para melhor visibilidade
RED="\033[1;31m"
BLUE="\033[1;34m"
WHITE="\033[1;37m"
GREEN="\033[1;32m"
RESET="\033[0m"

# Banner
echo -e "${RED}**************************************************"
echo -e "${RED}-                                                -"
echo -e "${RED}-             ${BLUE}Quicksort Concorrente${RED}              -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script automatiza o processo de compilação e execução de programas em C que implementam o algoritmo Quicksort concorrente.
# Para cada programa C encontrado no diretório especificado, o script:
# 1. Compila o programa (se necessário).
# 2. Pergunta ao usuário quantas threads o programa deve usar.
# 3. Para cada arquivo de entrada binário encontrado no diretório de entrada, o programa é executado com o número de threads especificado.
# 4. O script cria diretórios de saída organizados por número de threads e executa o programa em cada arquivo de entrada gerando arquivos de saída correspondentes.
# 5. O nome do arquivo de saída é gerado automaticamente com base no índice da execução.

# Diretório contendo os programas em C (Fonte)
diretorio_programas="Code/Quicksort/Conc"

# Diretório contendo os arquivos de entrada e saída
diretorio_arquivos="Files"

# Perguntar ao usuário se deseja rodar 5 vezes para cada arquivo
echo -e "${BLUE}Deseja rodar o programa 5 vezes para cada arquivo no diretório? (s/n): ${GREEN}" 
read rodar_5_vezes
echo -e "${RESET}--------------------------------------------------"

# Verificar se a resposta é válida (s ou n)
if [[ "$rodar_5_vezes" != "s" && "$rodar_5_vezes" != "S" && "$rodar_5_vezes" != "n" && "$rodar_5_vezes" != "N" ]]; then
    echo -e "${RED}Resposta inválida. A execução será cancelada.${RESET}"
    echo "--------------------------------------------------"
    exit 1
fi

# Loop através de todos os arquivos .c no diretório de programas
for programa in "$diretorio_programas"/*.c; do
    # Obter o nome base do programa (remover a extensão .c)
    nome_programa=$(basename "$programa" .c)

    # Caminho para o arquivo compilado
    programa_compilado="$diretorio_programas/$nome_programa"

    # Verificar se o programa já foi compilado (verifica a existência do arquivo compilado)
    if [[ ! -f "$programa_compilado" ]]; then
        # Compilar o programa C caso o executável não exista
        echo -e "${BLUE}Compilando o programa $nome_programa...${RESET}"
        echo "--------------------------------------------------"
        gcc -o "$programa_compilado" "$programa"

        # Verificar se a compilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Erro ao compilar $nome_programa${RESET}"
            echo "--------------------------------------------------"
            continue
        fi
    else
        # Perguntar ao usuário se deseja recompilar o programa
        echo -e "${BLUE}O programa $nome_programa já foi compilado. Deseja recompilá-lo? (s/n): ${GREEN}"  
        read resposta
        echo -e "${RESET}--------------------------------------------------"
        if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
            echo -e "${BLUE}Recompilando o programa $nome_programa...${RESET}"
            echo "--------------------------------------------------"
            gcc -o "$programa_compilado" "$programa"
            
            # Verificar se a recompilação foi bem-sucedida
            if [[ $? -ne 0 ]]; then
                echo -e "${RED}Erro ao recompilar $nome_programa${RESET}"
                echo "--------------------------------------------------"
                continue
            fi
        elif [[ "$resposta" != "n" && "$resposta" != "N" ]]; then
            # Caso a resposta não seja nem "s" nem "n", imprimir uma mensagem de erro e cancelar a execução
            echo -e "${RED}Resposta inválida. A execução será cancelada.${RESET}"
            echo "--------------------------------------------------"
            exit 1
        fi
    fi

    # Perguntar ao usuário quantas threads o programa deve usar (apenas uma vez)
    echo -e "${BLUE}Quantas threads o $nome_programa deve usar?  ${GREEN}" 
    read num_threads
    echo -e "${RESET}--------------------------------------------------"

    # Obter a lista de arquivos de entrada, ordenados pela data de modificação (mais recentes primeiro)
    arquivos_entrada=($(ls -t "$diretorio_arquivos/Input"/*.bin))

    # Loop através de cada arquivo de entrada binário pelo índice
    for ((i=0; i<${#arquivos_entrada[@]}; i++)); do
        # Obter o caminho do arquivo de entrada
        arquivo_entrada="${arquivos_entrada[$i]}"

        # Criar um diretório com o nome do número de threads
        diretorio_threads="$diretorio_arquivos/Output/Quicksort/Conc/$num_threads threads"
        mkdir -p "$diretorio_threads"  # Cria o diretório se ele não existir

        # Exibir mensagem de status para o usuário sobre o que está sendo executado
        echo -e "${BLUE}Executando $nome_programa com $arquivo_entrada como entrada, usando $num_threads threads.${RESET}"

        # Verificar se o usuário deseja rodar 5 vezes para cada arquivo
        if [[ "$rodar_5_vezes" == "s" ]]; then
            for ((j=1; j<=5; j++)); do
                # Gerar o nome do arquivo de saída com base no índice e execução (ex: Output0_1.bin, Output0_2.bin, etc.)
                arquivo_saida="Output${i}_${j}.bin"
                echo -e "${BLUE}Execução $j de 5...${RESET}"
                
                # Executar o programa com os arquivos de entrada, saída e o número de threads como argumentos
                "$programa_compilado" "$arquivo_entrada" "$diretorio_threads/$arquivo_saida" "$num_threads"
            done
        else
            # Caso contrário, rodar uma vez
            arquivo_saida="Output$i.bin"
            "$programa_compilado" "$arquivo_entrada" "$diretorio_threads/$arquivo_saida" "$num_threads"
        fi

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done

echo -e "${RED}**************************************************${RESET}"