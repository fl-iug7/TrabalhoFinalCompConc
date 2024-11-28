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
echo -e "${RED}-              ${BLUE}MinMaxSort Concorrente${RED}            -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script automatiza a compilação e execução de programas em C que implementam o algoritmo MinMaxSort concorrente.
# O script segue as etapas abaixo:
# 1. Verifica se cada programa C já foi compilado. Se não, compila o programa.
# 2. Pergunta ao usuário quantas threads o programa deve usar.
# 3. Para cada arquivo de entrada binário no diretório de entrada, o programa é executado com o número de threads especificado.
# 4. Os resultados são armazenados em arquivos de saída com base no índice de execução.
# 5. Cada conjunto de arquivos de saída é organizado em um diretório com o nome do número de threads.
# O script processa todos os arquivos de entrada binários, executando o programa para cada um e gerando os arquivos de saída correspondentes.

# Diretório contendo o programa em C (Fonte)
diretorio_programas="Code/MinMaxSort/Conc"

# Diretório contendo os arquivos de entrada e saída
diretorio_arquivos="Files"

# Perguntar ao usuário quer rodar 5 vezes para cada arquivo
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
    # Obter o nome base do programa (sem a extensão .c)
    nome_programa=$(basename "$programa" .c)

    # Verificar se o programa já foi compilado. Se não, compilar o programa C.
    if [[ -f "$diretorio_programas/$nome_programa" ]]; then
        # Perguntar ao usuário quer compilar novamente
        echo -e "${BLUE}$nome_programa já foi compilado. Deseja compilar novamente? (s/n): ${GREEN}" 
        read resposta
        echo -e "${RESET}--------------------------------------------------"
        if [[ "$resposta" != "s" && "$resposta" != "n" && "$resposta" != "S" && "$resposta" != "N" ]]; then
            echo -e "${RED}Resposta inválida. Encerrando a execução.${RESET}"
            echo "--------------------------------------------------"
            exit 1
        elif [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
            # Compilar novamente o programa
            echo -e "${BLUE}Compilando $nome_programa novamente...${RESET}"
            echo "--------------------------------------------------"
            gcc -o "$diretorio_programas/$nome_programa" "$programa"
            
            # Verificar se a compilação foi bem-sucedida
            if [[ $? -ne 0 ]]; then
                # Caso haja erro na compilação, exibe a mensagem de erro e continua para o próximo programa
                echo -e "${RED}Erro ao compilar $nome_programa. Continuando com o próximo programa.${RESET}"
                echo "--------------------------------------------------"
                continue
            fi
        fi
    else
        # Compilar o programa se não estiver compilado
        echo -e "${BLUE}Compilando $nome_programa...${RESET}"
        echo "--------------------------------------------------"
        gcc -o "$diretorio_programas/$nome_programa" "$programa"
        
        # Verificar se a compilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            # Caso haja erro na compilação, exibe a mensagem de erro e continua para o próximo programa
            echo -e "${RED}Erro ao compilar $nome_programa. Continuando com o próximo programa.${RESET}"
            echo "--------------------------------------------------"
            continue
        fi
    fi

    # Perguntar ao usuário quantas threads o programa deve usar 
    echo -e "${BLUE}Quantas threads o $nome_programa deve usar? ${GREEN}" 
    read num_threads
    echo -e "${RESET}--------------------------------------------------"

    # Obter a lista de arquivos de entrada, ordenados pela data de modificação (mais recentes primeiro)
    arquivos_entrada=($(ls -t "$diretorio_arquivos/Input"/*.bin))

    # Loop através de cada arquivo de entrada pelo índice
    for ((i=0; i<${#arquivos_entrada[@]}; i++)); do
        # Obter o caminho do arquivo de entrada
        arquivo_entrada="${arquivos_entrada[$i]}"

        # Gerar o nome do arquivo de saída com base no índice (Output0.bin, Output1.bin, etc.)
        arquivo_saida="Output$i.bin"

        # Criar um diretório com o nome do número de threads 
        diretorio_threads="$diretorio_arquivos/Output/MinMaxSort/Conc/$num_threads threads"
        mkdir -p "$diretorio_threads"  # Cria o diretório se ele não existir

        # Exibir mensagem de status para o usuário sobre o que está sendo executado
        echo -e "${BLUE}Executando $nome_programa com $arquivo_entrada como entrada, $arquivo_saida como saída, usando $num_threads threads.${RESET}"

        # Verificar se o usuário deseja rodar 5 vezes para cada arquivo
        if [[ "$rodar_5_vezes" == "s" ]]; then
            for ((j=1; j<=5; j++)); do
                echo -e "${BLUE}Execução $j de 5...${RESET}"
                # Executar o programa com os arquivos de entrada, saída e o número de threads como argumentos
                "$diretorio_programas/$nome_programa" "$arquivo_entrada" "$diretorio_threads/$arquivo_saida" "$num_threads"
                # Adicionar um sufixo para a saída (Output0_1.bin, Output0_2.bin, etc.)
                arquivo_saida="Output${i}_${j}.bin"
            done
        else
            # Caso contrário, rodar uma vez
            "$diretorio_programas/$nome_programa" "$arquivo_entrada" "$diretorio_threads/$arquivo_saida" "$num_threads"
        fi

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done
echo -e "${RED}**************************************************${RESET}"