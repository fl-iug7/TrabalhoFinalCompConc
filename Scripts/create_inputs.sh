#!/bin/bash

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

# Verificar se o programa já foi compilado (se o arquivo executável existe)
if [[ ! -f "$programa_compilado" ]]; then
    # Se o programa não estiver compilado, compilá-lo
    echo "Compilando o programa $programa..."
    gcc -o "$programa_compilado" "$caminho_programa"

    # Verificar se a compilação foi bem-sucedida
    if [[ $? -ne 0 ]]; then
        echo "Erro ao compilar o programa $programa."
        exit 1
    fi
else
    # Caso o programa já esteja compilado, informar ao usuário
    echo "O programa $programa já está compilado. Prosseguindo com a execução..."
    echo "--------------------------------------------------"
fi

# Loop de 0 a 9 para criar e executar os arquivos de entrada com diferentes tamanhos de vetor
for ((i=0; i<=9; i++)); do
    # Construir o nome do arquivo de entrada (input1.bin, input2.bin, ..., input10.bin)
    arquivo_entrada="Files/Input/input$((i+1)).bin"

    # Gerar o argumento como potências de 10: 10, 100, 1000, ..., 1000000000
    argumento=$((10 ** (i+1)))  # 10^1, 10^2, 10^3, ..., 10^10
    indice=$((i+1))

    # Exibir as informações da iteração
    echo "Iteração $indice: CriarEntrada $arquivo_entrada $argumento"

    # Executar o programa compilado com o arquivo de entrada e o argumento gerado
    "$programa_compilado" "$arquivo_entrada" "$argumento"

    # Separador para melhorar a legibilidade da saída no terminal
    echo "--------------------------------------------------"
done
