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
echo -e "${RED}-                 ${BLUE}Criar Entrada${RED}                  -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script gera um arquivo de entrada binário com um vetor de inteiros, 
# baseado no tamanho fornecido pelo usuário. O nome do arquivo de entrada 
# inclui um carimbo de data/hora para garantir que ele seja único. O script 
# executa um programa (CriarEntrada) para gerar esse arquivo de entrada binário.

# Diretório contendo o código-fonte do programa
diretorio_programa="Code/CreatInput"

# Nome do arquivo C que contém o código do programa
programa="CriarEntrada.c"

# Caminho completo para o programa C
caminho_programa="$diretorio_programa/$programa"

# Caminho do arquivo compilado (o programa gerado)
programa_compilado="$diretorio_programa/CriarEntrada"

# Perguntar ao usuário o tamanho do vetor que será gerado
echo -e "${BLUE}Qual é o tamanho do vetor?${GREEN}"
read tamanho_vetor
echo -e "${RESET}--------------------------------------------------"

# Gerar um carimbo de data/hora no formato DD-MM-AAAA_HH-MM-SS para o nome do arquivo
# Isso garante que o arquivo gerado terá um nome único, incluindo a data e hora de sua criação
carimbo_data_hora=$(date +%d-%m-%Y_%H-%M-%S)

# Perguntar ao usuário se deseja o array em ordem decrescente (0) ou aleatória (1)
echo -e "${BLUE}Você deseja o array em ordem decrescente (0) ou aleatória (1)?${GREEN}"
read ordem

# Definir o nome do arquivo de entrada baseado na escolha do usuário
if [[ "$ordem" == "1" ]]; then
    # Se for ordem aleatória, usar o prefixo InputRandom
    arquivo_entrada="Files/Input/InputRandom_${carimbo_data_hora}_${tamanho_vetor}.bin"
elif [[ "$ordem" == "0" ]]; then
    # Se for ordem decrescente, usar o prefixo InputDesc
    arquivo_entrada="Files/Input/InputDesc_${carimbo_data_hora}_${tamanho_vetor}.bin"
else
    # Se a opção for inválida, mostrar erro e sair
    echo -e "${RED}Opção inválida. Por favor, digite '0' para ordem decrescente ou '1' para aleatória.${RESET}"
    exit 1
fi

# O tamanho do vetor fornecido pelo usuário será passado como argumento para o programa
argumento=$tamanho_vetor  # Usando diretamente o tamanho do vetor como argumento

# Exibir informações sobre o arquivo que será criado, para o usuário
echo -e "${BLUE}Criar arquivo: $arquivo_entrada com tamanho do vetor $tamanho_vetor${RESET}"

# Perguntar ao usuário se deseja compilar o programa novamente
if [[ ! -f "$programa_compilado" ]]; then
    # Se o programa ainda não estiver compilado, compilar automaticamente
    echo "--------------------------------------------------"
    echo -e "${BLUE}O programa ainda não foi compilado. Compilando...${RESET}"
    gcc -o "$programa_compilado" "$caminho_programa"

    # Verificar se a compilação foi bem-sucedida
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Erro ao compilar o programa $programa.${RESET}"
        echo "--------------------------------------------------"
        exit 1
    fi
else
    # Caso o programa já esteja compilado, perguntar ao usuário se ele deseja recompilá-lo
    echo "--------------------------------------------------"
    echo -e "${BLUE}O programa já está compilado.${RESET}"
    echo -e "${BLUE}Você deseja compilar o programa novamente? (s/n)${GREEN}"
    read resposta
    echo -e "${RESET}--------------------------------------------------"

    # Verificar se a resposta é "s" ou "n"
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo -e "${BLUE}Recompilando o programa...${RESET}"
        gcc -o "$programa_compilado" "$caminho_programa"

        # Verificar se a recompilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Erro ao recompilar o programa $programa.${RESET}"
            echo "--------------------------------------------------"
            exit 1
        fi
    elif [[ "$resposta" == "n" || "$resposta" == "N" ]]; then
        echo -e "${BLUE}Prosseguindo com o programa já compilado...${RESET}"
    else
        echo -e "${RED}Resposta inválida. Por favor, responda com 's' para sim ou 'n' para não.${RESET}"
        echo "--------------------------------------------------"
        exit 1
    fi
fi

# Verificar a escolha do usuário e executar o programa com os parâmetros adequados
if [[ "$ordem" == "0" ]]; then
    # Se for ordem decrescente, rodar com argumento 0
    echo -e "${BLUE}Gerando array em ordem decrescente...${RESET}"
    "$programa_compilado" "$arquivo_entrada" "$argumento" 0
elif [[ "$ordem" == "1" ]]; then
    # Se for ordem aleatória, rodar com argumento 1
    echo -e "${BLUE}Gerando array em ordem aleatória...${RESET}"
    "$programa_compilado" "$arquivo_entrada" "$argumento" 1
else
    echo -e "${RED}Opção inválida. Por favor, digite '0' para ordem decrescente ou '1' para aleatória.${RESET}"
    exit 1
fi

# Separador para melhorar a legibilidade da saída no terminal
echo "--------------------------------------------------"
echo -e "${RED}**************************************************${RESET}"
