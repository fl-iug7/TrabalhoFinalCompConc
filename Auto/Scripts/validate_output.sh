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
echo -e "${RED}-              ${BLUE}Validar Resultados${RED}                -"
echo -e "${RED}-                                                -"
echo -e "${RED}**************************************************${RESET}"

# Descrição:
# Este script automatiza o processo de validação de arquivos de saída gerados por programas que implementam os algoritmos MinMaxSort e Quicksort, tanto concorrentes quanto sequenciais.
# O processo de validação é feito verificando a integridade de arquivos de saída (.bin) para garantir que os resultados estão corretos.
# O script funciona da seguinte maneira:
# 1. Exibe um menu interativo para o usuário escolher o diretório a ser validado, ou escolher "Todos" para validar todos os diretórios listados.
# 2. Para cada diretório escolhido, ele busca todos os arquivos .bin de saída, e executa o programa 'ValidarResultado' para cada arquivo encontrado.
# 3. Caso não existam arquivos de saída no diretório selecionado, o script verifica se existem subdiretórios e executa o programa 'ValidarResultado' em cada subdiretório.
# 4. O script verifica se o programa de validação já foi compilado antes de tentar compilá-lo novamente.

# Diretório contendo o programa de validação
diretorio_programa="Code/ValidateOutput"

# Diretório base de saída onde os arquivos de resultado estão localizados
diretorio_saida_base="Files/Output"

# Lista de diretórios dentro de Output onde os arquivos de saída podem estar
diretorios=("MinMaxSort/Conc" "MinMaxSort/Seq" "Quicksort/Conc" "Quicksort/Seq")

# Função para verificar se o programa de validação já foi compilado
verificar_compilacao() {
    if [[ ! -f "$diretorio_programa/ValidarResultado" ]]; then
        echo -e "${BLUE}Compilando o programa ValidarResultado...${RESET}"
        gcc -o "$diretorio_programa/ValidarResultado" "$diretorio_programa/ValidarResultado.c"
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Erro ao compilar ValidarResultado. Saindo.${RESET}"
            echo "--------------------------------------------------"
            exit 1
        fi
    else
        echo -e "${BLUE}O programa ValidarResultado já foi compilado.${RESET}"
        echo -e "${BLUE}Deseja compilar o programa novamente? (s/n): ${GREEN}" 
        read resposta
        echo -e "${RESET}--------------------------------------------------"
        if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
            echo -e "${BLUE}Compilando novamente o programa ValidarResultado..${RESET}."
            echo "--------------------------------------------------"
            gcc -o "$diretorio_programa/ValidarResultado" "$diretorio_programa/ValidarResultado.c"
            if [[ $? -ne 0 ]]; then
                echo -e "${RED}Erro ao compilar o programa. Saindo.${RESET}"
                echo "--------------------------------------------------"
                exit 1
            fi
        elif [[ "$resposta" == "n" || "$resposta" == "N" ]]; then
            echo -e "${BLUE}Mantendo a versão já compilada.${RESET}"
            echo "--------------------------------------------------"
        else
            echo -e "${RED}Resposta inválida. Encerrando o script.${RESET}"
            echo "--------------------------------------------------"
            exit 1
        fi
    fi
}

# Função para rodar a validação em um diretório específico
rodar_validacao() {
    local dir=$1  # Diretório a ser validado
    echo -e "${BLUE}Rodando validação no diretório: $dir"
    echo "--------------------------------------------------"

    # Verifica a existência de arquivos .bin no diretório
    arquivos_encontrados=false
    shopt -s nullglob  # Garantir que o glob retorne uma lista vazia se não houver correspondência
    arquivos=("$diretorio_saida_base/$dir"/Output*.bin)  # Buscar arquivos .bin

    if [[ ${#arquivos[@]} -gt 0 ]]; then
        # Se arquivos .bin foram encontrados
        arquivos_encontrados=true
        for arquivo_saida in "${arquivos[@]}"; do
            echo -e "${BLUE}Rodando ValidarResultado em $arquivo_saida${RESET}"
            "$diretorio_programa/ValidarResultado" "$arquivo_saida"
            echo "--------------------------------------------------"
        done
    fi

    # Caso não existam arquivos de saída no diretório, verifica se existem subdiretórios
    if [[ "$arquivos_encontrados" == false ]]; then
        echo -e "${BLUE}Nenhum arquivo de saída encontrado em $diretorio_saida_base/$dir${RESET}"
        echo -e "${BLUE}Verificando subdiretórios...${RESET}"
        echo "--------------------------------------------------"
        # Verificando subdiretórios dentro do diretório atual
        for subdir in "$diretorio_saida_base/$dir"/*/; do
            if [[ -d "$subdir" ]]; then
                # Se for um subdiretório, chama a função de validação para ele
                # Passa o caminho relativo para o subdiretório
                subdir_relativo="${subdir#$diretorio_saida_base/}"
                echo "Subdiretório encontrado: $subdir_relativo"
                rodar_validacao "$subdir_relativo"
            fi
        done
    fi
}

# Verificar se o programa de validação já foi compilado ou compilar novamente
verificar_compilacao

# Menu interativo para o usuário escolher um diretório ou "Todos"
echo -e "${BLUE}Por favor, escolha uma opção:${RESET}"
echo -e "${RED}--------------------------------------------------"
echo -e "${RED}(1) ${BLUE}- Output/MinMaxSort/Conc${RESET}"
echo -e "${RED}(2) ${BLUE}- Output/MinMaxSort/Seq${RESET}"
echo -e "${RED}(3) ${BLUE}- Output/Quicksort/Conc${RESET}"
echo -e "${RED}(4) ${BLUE}- Output/Quicksort/Seq${RESET}"
echo -e "${RED}(5) ${BLUE}- Todos os Diretórios${RESET}"
echo -e "${RED}--------------------------------------------------"

# Ler a escolha do usuário
echo -e "${BLUE}Digite sua escolha [1-5]: ${GREEN}" 
read escolha

# Tratar a escolha do usuário com um case
case $escolha in
    1)
        # Rodar validação no diretório MinMaxSort/Conc
        rodar_validacao "MinMaxSort/Conc"
        ;;
    2)
        # Rodar validação no diretório MinMaxSort/Seq
        rodar_validacao "MinMaxSort/Seq"
        ;;
    3)
        # Rodar validação no diretório Quicksort/Conc
        rodar_validacao "Quicksort/Conc"
        ;;
    4)
        # Rodar validação no diretório Quicksort/Seq
        rodar_validacao "Quicksort/Seq"
        ;;
    5)
        # Se o usuário escolher "Todos", rodar a validação em todos os diretórios listados
        for dir in "${diretorios[@]}"; do
            rodar_validacao "$dir"
        done
        ;;
    *)
        # Caso o usuário insira uma opção inválida, exibe mensagem e sai
        echo -e "${RED}Escolha inválida. Por favor, selecione um número entre 1 e 5.${RESET}"
        exit 1
        ;;
esac

echo -e "${RED}**************************************************${RESET}"