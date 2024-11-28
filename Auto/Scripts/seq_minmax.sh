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
echo -e "${RED}-              ${BLUE}MinMaxSort Sequencial${RED}             -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script automatiza a execução de programas C no diretório especificado.
# Para cada programa C encontrado, ele verifica se o programa já foi compilado.
# Se o programa não foi compilado, ele é compilado, caso contrário, o script apenas executa o programa.
# Após a compilação (ou verificação da existência do programa compilado), o script executa cada programa em uma série de arquivos de entrada binários.
# O programa gerará arquivos de saída correspondentes, com base na execução de algoritmos de ordenação (como MinMaxSort).
# O script processa todos os arquivos de entrada binários localizados no diretório "Input" e gera arquivos de saída no diretório "Output".
# Cada programa é executado uma vez para cada arquivo de entrada binário.

# Diretório contendo os programas em C (Fonte)
diretorio_programas="Code/MinMaxSort/Seq"

# Diretório contendo os arquivos de entrada e saída
diretorio_arquivos="Files"

# Loop através de todos os arquivos .c no diretório de programas
for programa in "$diretorio_programas"/*.c; do
    # Obter o nome base do programa (sem a extensão .c)
    nome_programa=$(basename "$programa" .c)

    # Caminho do programa compilado (gerado pelo gcc)
    programa_compilado="$diretorio_programas/$nome_programa"

    # Verificar se o programa já foi compilado (se o arquivo compilado existe)
    if [[ ! -f "$programa_compilado" ]]; then
        # Se o programa não foi compilado, compilar o programa C
        echo -e "${BLUE}Compilando o programa $nome_programa...${RESET}"
        echo "--------------------------------------------------"
        gcc -o "$programa_compilado" "$programa"

        # Verificar se a compilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            # Se ocorrer erro na compilação, exibe mensagem e continua com o próximo programa
            echo -e "${RED}Erro ao compilar $nome_programa${RESET}"
            continue
        fi
    else
        # Perguntar ao usuário se deseja compilar o programa novamente
        while true; do
            echo -e "${BLUE}$nome_programa já compilado.${RESET}"
            echo -e "${BLUE}Você deseja compilar novamente? (s/n): ${GREEN}" 
            read resposta

            if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
                # Compilar novamente
                echo -e "${BLUE}Compilando novamente $nome_programa...${RESET}"
                echo "--------------------------------------------------"
                gcc -o "$programa_compilado" "$programa"

                # Verificar se a compilação foi bem-sucedida
                if [[ $? -ne 0 ]]; then
                    # Se ocorrer erro na compilação, exibe mensagem e continua com o próximo programa
                    echo -e "${RED}Erro ao compilar $nome_programa novamente.${RESET}"
                    echo "--------------------------------------------------"
                    continue 2
                fi
                break
            elif [[ "$resposta" == "n" || "$resposta" == "N" ]]; then
                echo -e "${BLUE}$nome_programa será executado sem recompilação.${RESET}"
                echo "--------------------------------------------------"
                break
            else
                # Resposta inválida
                echo -e "${RED}Resposta inválida. Por favor, digite 's' para sim ou 'n' para não.${RESET}"
                echo "--------------------------------------------------"
                continue
            fi
        done
    fi

    # Obter a lista de arquivos de entrada, ordenados pela data de modificação (mais recentes primeiro)
    arquivos_entrada=($(ls -t "$diretorio_arquivos/Input"/*.bin))

    # Loop através de cada arquivo de entrada binário pelo índice
    for ((i=0; i<${#arquivos_entrada[@]}; i++)); do
        # Obter o caminho do arquivo de entrada
        arquivo_entrada="${arquivos_entrada[$i]}"

        # Gerar o nome do arquivo de saída com base no nome do programa e no índice
        # O nome do arquivo de saída será algo como "Output0.bin", "Output1.bin", etc.
        arquivo_saida="$diretorio_arquivos/Output/MinMaxSort/Seq/Output$i.bin"

        # Exibir mensagem de status para o usuário sobre o que está sendo executado
        echo -e "${BLUE}Executando $nome_programa com $arquivo_entrada como entrada e $arquivo_saida como saída.${RESET}"

        # Executar o programa compilado com os arquivos de entrada e saída como argumentos
        "$programa_compilado" "$arquivo_entrada" "$arquivo_saida"

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done

echo -e "${RED}**************************************************${RESET}"