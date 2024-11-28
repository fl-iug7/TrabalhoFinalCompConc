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
echo -e "${RED}-             ${BLUE}Quicksort Sequencial${RED}               -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script executa uma série de programas em C localizados em um diretório específico.
# Para cada programa, ele verifica se o arquivo compilado já existe.
# Se o programa já foi compilado, ele o executa diretamente. Caso contrário, o script compila o código fonte,
# verifica se a compilação foi bem-sucedida e, em seguida, executa o programa para processar arquivos de entrada binários,
# gerando arquivos de saída. O diretório de entrada contém arquivos binários e o diretório de saída será utilizado
# para armazenar os arquivos gerados pelos programas.

# Diretório contendo os programas em C (Fonte)
diretorio_programas="Code/Quicksort/Seq"

# Diretório contendo os arquivos de entrada e saída
diretorio_arquivos="Files"

# Loop através de todos os arquivos .c no diretório de programas
for programa in "$diretorio_programas"/*.c; do
    # Obter o nome base do arquivo do programa (sem a extensão .c)
    nome_programa=$(basename "$programa" .c)

    # Caminho completo para o programa compilado
    caminho_programa_compilado="$diretorio_programas/$nome_programa"

    # Verificar se o programa já foi compilado
    if [[ -f "$caminho_programa_compilado" ]]; then
        # Se o programa já foi compilado, perguntar ao usuário se deseja recompilar
        echo -e "${BLUE}O programa $nome_programa já foi compilado. Deseja recompilar? (s/n): ${GREEN}" 
        read resposta
        case "$resposta" in
            [Ss])
                # Se o usuário deseja recompilar, compilar o programa novamente
                echo -e "${BLUE}Compilando o programa $nome_programa...${RESET}"
                echo "--------------------------------------------------"
                gcc -o "$caminho_programa_compilado" "$programa"

                # Verificar se a compilação foi bem-sucedida (retorno 0 significa sucesso)
                if [[ $? -ne 0 ]]; then
                    # Se ocorrer erro na compilação, exibe mensagem de erro e continua com o próximo programa
                    echo -e "${RED}Erro ao compilar $nome_programa${RESET}"
                    echo "--------------------------------------------------"
                    continue
                fi
                ;;
            [Nn])
                # Se o usuário não deseja recompilar, informar que o programa será executado diretamente
                echo -e "${BLUE}O programa $nome_programa será executado sem recompilação.${RESET}"
                echo "--------------------------------------------------"
                ;;
            *)
                # Se a resposta não for válida, exibir uma mensagem de erro e cancelar a execução
                echo -e "${RED}Resposta inválida. O script será cancelado.${RESET}"
                echo "--------------------------------------------------"
                exit 1
                ;;
        esac
    else
        # Se o programa não foi compilado, compilar o programa C usando o compilador GCC
        echo -e "${BLUE}Compilando o programa $nome_programa...${RESET}"
        echo "--------------------------------------------------"
        gcc -o "$caminho_programa_compilado" "$programa"

        # Verificar se a compilação foi bem-sucedida (retorno 0 significa sucesso)
        if [[ $? -ne 0 ]]; then
            # Se ocorrer erro na compilação, exibe mensagem de erro e continua com o próximo programa
            echo -e "${RED}Erro ao compilar $nome_programa${RESET}"
            echo "--------------------------------------------------"
            continue
        fi
    fi

    # Obter a lista de arquivos de entrada binários do diretório, ordenados pela data de modificação (mais recentes primeiro)
    arquivos_entrada=($(ls -t "$diretorio_arquivos/Input"/*.bin))

    # Loop através de cada arquivo de entrada
    for ((i=0; i<${#arquivos_entrada[@]}; i++)); do
        # Obter o caminho do arquivo de entrada
        arquivo_entrada="${arquivos_entrada[$i]}"

        # Gerar o nome do arquivo de saída com base no índice e no nome do programa
        # O nome do arquivo de saída será algo como "Output0.bin", "Output1.bin", etc.
        arquivo_saida="$diretorio_arquivos/Output/Quicksort/Seq/Output$i.bin"

        # Exibir mensagem de status para informar o que está acontecendo (nome do programa, arquivo de entrada e saída)
        echo -e "${BLUE}Executando $nome_programa com $arquivo_entrada como entrada e $arquivo_saida como saída.${RESET}"

        # Executar o programa compilado com os arquivos de entrada e saída como argumentos
        "$caminho_programa_compilado" "$arquivo_entrada" "$arquivo_saida"

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done

echo -e "${RED}**************************************************${RESET}"
