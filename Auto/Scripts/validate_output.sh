#!/bin/bash

# Descrição:
# Este script automatiza o processo de validação de arquivos de saída gerados por programas que implementam os algoritmos MinMaxSort e Quicksort, tanto concorrentes quanto sequenciais.
# O processo de validação é feito verificando a integridade de arquivos de saída (.bin) para garantir que os resultados estão corretos.
# O script funciona da seguinte maneira:
# 1. Exibe um menu interativo para o usuário escolher o diretório a ser validado, ou escolher "Todos" para validar todos os diretórios listados.
# 2. Para cada diretório escolhido, ele busca todos os arquivos .bin de saída, e executa o programa 'ValidarResultado' para cada arquivo encontrado.
# 3. Caso não existam arquivos de saída no diretório selecionado, o script informa o usuário.
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
        echo "Compilando o programa ValidarResultado..."
        gcc -o "$diretorio_programa/ValidarResultado" "$diretorio_programa/ValidarResultado.c"
        if [[ $? -ne 0 ]]; then
            echo "Erro ao compilar ValidarResultado. Saindo."
            echo "--------------------------------------------------"
            exit 1
        fi
    else
        echo "O programa ValidarResultado já foi compilado."
        read -p "Deseja compilar o programa novamente? (s/n): " resposta
        echo "--------------------------------------------------"
        if [[ "$resposta" == "s" ]]; then
            echo "Compilando novamente o programa ValidarResultado..."
            echo "--------------------------------------------------"
            gcc -o "$diretorio_programa/ValidarResultado" "$diretorio_programa/ValidarResultado.c"
            if [[ $? -ne 0 ]]; then
                echo "Erro ao compilar o programa. Saindo."
                echo "--------------------------------------------------"
                exit 1
            fi
        elif [[ "$resposta" == "n" ]]; then
            echo "Mantendo a versão já compilada."
            echo "--------------------------------------------------"
        else
            echo "Resposta inválida. Encerrando o script."
            echo "--------------------------------------------------"
            exit 1
        fi
    fi
}

# Função para rodar a validação em um diretório específico
rodar_validacao() {
    local dir=$1  # Diretório a ser validado
    echo "Rodando validação no diretório: $dir"

    # Loop através de todos os arquivos Output*.bin no diretório selecionado
    for arquivo_saida in "$diretorio_saida_base/$dir"/Output*.bin; do
        # Verifica se o arquivo existe
        if [[ -f "$arquivo_saida" ]]; then
            # Se o arquivo de saída existir, roda a validação com o programa 'ValidarResultado'
            echo "Rodando ValidarResultado em $arquivo_saida"
            "$diretorio_programa/ValidarResultado" "$arquivo_saida"
            echo "--------------------------------------------------"
        else
            # Caso não existam arquivos de saída no diretório, exibe uma mensagem
            echo "Nenhum arquivo de saída encontrado em $diretorio_saida_base/$dir"
            echo "--------------------------------------------------"
        fi
    done
}

# Verificar se o programa de validação já foi compilado ou compilar novamente
verificar_compilacao

# Menu interativo para o usuário escolher um diretório ou "Todos"
echo "Por favor, escolha uma opção:"
echo "--------------------------------------------------"
echo "(1) - Output/MinMaxSort/Conc"
echo "(2) - Output/MinMaxSort/Seq"
echo "(3) - Output/Quicksort/Conc"
echo "(4) - Output/Quicksort/Seq"
echo "(5) - Todos os Diretórios"
echo "--------------------------------------------------"

# Ler a escolha do usuário
read -p "Digite sua escolha [1-5]: " escolha

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
        echo "Escolha inválida. Por favor, selecione um número entre 1 e 5."
        exit 1
        ;;
esac
