#!/bin/bash

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
        echo "Compilando o programa $nome_programa..."
        gcc -o "$programa_compilado" "$programa"

        # Verificar se a compilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            # Se ocorrer erro na compilação, exibe mensagem e continua com o próximo programa
            echo "Erro ao compilar $nome_programa"
            continue
        fi
    else
        # Se o programa já foi compilado, exibe mensagem e continua
        echo "$nome_programa já compilado, pulando a compilação."
        echo "--------------------------------------------------"
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
        echo "Executando $nome_programa com $arquivo_entrada como entrada e $arquivo_saida como saída."

        # Executar o programa compilado com os arquivos de entrada e saída como argumentos
        "$programa_compilado" "$arquivo_entrada" "$arquivo_saida"

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done
