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
echo -e "${RED}-                ${BLUE}Criar Entradas${RED}                  -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script executa um programa chamado "CriarEntrada" em uma série de arquivos de entrada binária gerados.
# Ele passa um argumento para o programa, que é uma potência de 10 (10, 100, 1000, etc.), e o executa para
# criar arquivos de saída baseados nos arquivos de entrada e seus respectivos argumentos.
# O programa "CriarEntrada" é compilado apenas uma vez, antes do loop de execução, caso ainda não tenha sido compilado.

# Diretório contendo o programa que irá gerar os arquivos de entrada
diretorio_programa="Code/CreatInput"

# Nome do arquivo C que contém o código do programa
programa="CriarEntrada.c"

# Caminho completo para o arquivo C
caminho_programa="$diretorio_programa/$programa"

# Caminho do programa compilado
programa_compilado="$diretorio_programa/CriarEntrada"

# Função para compilar o programa
compilar_programa() {
    echo -e "${BLUE}Compilando o programa $programa...${RESET}"
    echo "--------------------------------------------------"
    gcc -o "$programa_compilado" "$caminho_programa"

    # Verificar se a compilação foi bem-sucedida
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Erro ao compilar o programa $programa.${RESET}"
        echo "--------------------------------------------------"
        exit 1
    fi
}

# Verificar se o programa já foi compilado (se o arquivo executável existe)
if [[ ! -f "$programa_compilado" ]]; then
    # Se o programa não estiver compilado, compilar automaticamente
    compilar_programa
else
    # Caso o programa já esteja compilado, perguntar se deseja recompilar
    echo -e "${BLUE}O programa $programa já está compilado. Você deseja compilá-lo novamente? (s/n): ${GREEN}" 
    read resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        compilar_programa
    elif [[ "$resposta" == "n" || "$resposta" == "N" ]]; then
        echo -e "${BLUE}Prosseguindo com a execução do programa já compilado...${RESET}"
        echo "--------------------------------------------------"
    else
        echo -e "${RED}Resposta inválida. A execução foi cancelada.${RESET}"
        echo "--------------------------------------------------"
        exit 1
    fi
fi

# Perguntar ao usuário até qual valor de N ele deseja executar o loop
echo -e "${BLUE}Digite o valor para N (número inteiro): ${GREEN}"  
read max_value
echo -e "${RESET}--------------------------------------------------"
# Validar se o valor inserido é um número inteiro
if ! [[ "$max_value" =~ ^-?[0-9]+$ ]]; then
    echo -e "${RED}Valor inválido. Por favor, insira um número inteiro.${RESET}"
    exit 1
fi

# Perguntar ao usuário se deseja o array em ordem decrescente (0) ou aleatória (1)
echo -e "${BLUE}Você deseja o array em ordem decrescente (0) ou aleatória (1)?${GREEN}"
read ordem
echo -e "${RESET}--------------------------------------------------"
# Verificar a escolha do usuário e executar o programa com os parâmetros adequados
if [[ "$ordem" == "0" ]]; then
    # Se for ordem decrescente, rodar com argumento 0
    echo -e "${BLUE}Gerando array em ordem decrescente...${RESET}"
elif [[ "$ordem" == "1" ]]; then
    # Se for ordem aleatória, rodar com argumento 1
    echo -e "${BLUE}Gerando array em ordem aleatória...${RESET}"
else
    echo -e "${RED}Opção inválida. Por favor, digite '0' para ordem decrescente ou '1' para aleatória.${RESET}"
    exit 1
fi

# Loop até o valor informado pelo usuário
for ((i=0; i<=max_value-1; i++)); do
    # Gerar o argumento como potências de 10: 10^1, 10^2, 10^3, ..., 10^10
    argumento=$((10 ** (i+1)))
    indice=$((i+1))

    # Executar o programa compilado com o arquivo de entrada e o argumento gerado
    if [[ "$ordem" == "0" ]]; then
        # Construir o nome do arquivo de entrada 
        arquivo_entrada="Files/Input/InputDesc$((i+1)).bin"
        # Exibir as informações da iteração
        echo -e "${BLUE}Iteração $indice: CriarEntrada $arquivo_entrada $argumento${RESET}"
        # Se for ordem decrescente, rodar com argumento 0
        "$programa_compilado" "$arquivo_entrada" "$argumento" 0

    elif [[ "$ordem" == "1" ]]; then
        # Construir o nome do arquivo de entrada 
        arquivo_entrada="Files/Input/InputRadom$((i+1)).bin"
        # Exibir as informações da iteração
        echo -e "${BLUE}Iteração $indice: CriarEntrada $arquivo_entrada $argumento${RESET}"
        # Se for ordem aleatória, rodar com argumento 1
        "$programa_compilado" "$arquivo_entrada" "$argumento" 1
    
    fi

    # Separador para melhorar a legibilidade da saída no terminal
    echo "--------------------------------------------------"
done

echo -e "${RED}**************************************************${RESET}"
