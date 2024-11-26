#!/bin/bash

# Este script verifica se o arquivo executável de um programa C já existe.
# Se o executável existir, ele pergunta ao usuário se deseja compilar novamente.
# Se o executável não existir, o script compila o código fonte e depois executa o programa,
# passando parâmetros padrão para a execução.

# Define os diretórios e nomes de arquivos
DIRETORIO_CODIGO="Code/GenerateCSV"
ARQUIVO_FONTE="GerarCSV.c"
ARQUIVO_EXEC="$DIRETORIO_CODIGO/GerarCSV"
ENTRADA_PADRAO="Data/"
SAIDA_PADRAO="Data/Metricas.csv"

# Verifica se o arquivo executável já existe
if [ -f "$ARQUIVO_EXEC" ]; then
    # Se o executável existir, pergunta se o usuário deseja compilar novamente
    read -p "$ARQUIVO_EXEC já existe. Você deseja compilar novamente? (s/n): " escolha
    if [[ "$escolha" =~ ^[Ss]$ ]]; then
        # Caso o usuário escolha compilar novamente, compila o programa
        echo "Compilando novamente..."
        echo "--------------------------------------------------"
        gcc "$DIRETORIO_CODIGO/$ARQUIVO_FONTE" -o "$ARQUIVO_EXEC"
    else
        # Caso o usuário escolha não compilar, o script apenas pula a compilação
        echo "Pulando a compilação."
        echo "--------------------------------------------------"
    fi
else
    # Se o executável não existir, compila-o
    echo "Compilando o programa..."
    echo "--------------------------------------------------"
    gcc "$DIRETORIO_CODIGO/$ARQUIVO_FONTE" -o "$ARQUIVO_EXEC"
fi

# Executa o programa com os parâmetros padrão, se compilado
if [ -f "$ARQUIVO_EXEC" ]; then
    # Executa o arquivo compilado
    "$ARQUIVO_EXEC" "$ENTRADA_PADRAO" "$SAIDA_PADRAO"
else
    # Caso ocorra um erro na compilação, exibe uma mensagem de erro
    echo "Erro: A compilação falhou. Não é possível executar o programa."
    echo "--------------------------------------------------"
fi
