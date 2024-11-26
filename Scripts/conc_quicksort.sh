#!/bin/bash

# Descrição:
# Este script automatiza o processo de compilação e execução de programas em C que implementam o algoritmo Quicksort concorrente.
# Para cada programa C encontrado no diretório especificado, o script:
# 1. Compila o programa (se necessário).
# 2. Pergunta ao usuário quantas threads o programa deve usar.
# 3. Para cada arquivo de entrada binário encontrado no diretório de entrada, o programa é executado com o número de threads especificado.
# 4. O script cria diretórios de saída organizados por número de threads e executa o programa em cada arquivo de entrada gerando arquivos de saída correspondentes.
# 5. O nome do arquivo de saída é gerado automaticamente com base no índice da execução.

# Diretório contendo os programas em C (Fonte)
diretorio_programas="Code/Quicksort/Conc"

# Diretório contendo os arquivos de entrada e saída
diretorio_arquivos="Files"

# Loop através de todos os arquivos .c no diretório de programas
for programa in "$diretorio_programas"/*.c; do
    # Obter o nome base do programa (remover a extensão .c)
    nome_programa=$(basename "$programa" .c)

    # Caminho para o arquivo compilado
    programa_compilado="$diretorio_programas/$nome_programa"

    # Verificar se o programa já foi compilado (verifica a existência do arquivo compilado)
    if [[ ! -f "$programa_compilado" ]]; then
        # Compilar o programa C caso o executável não exista
        echo "Compilando o programa $nome_programa..."
        gcc -o "$programa_compilado" "$programa"

        # Verificar se a compilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            echo "Erro ao compilar $nome_programa"
            continue
        fi
    else
        # Informar que o programa já está compilado
        echo "O programa $nome_programa já está compilado."
    fi

    # Perguntar ao usuário quantas threads o programa deve usar (apenas uma vez)
    read -p "Quantas threads o $nome_programa deve usar? " num_threads
    echo "--------------------------------------------------"

    # Obter a lista de arquivos de entrada, ordenados pela data de modificação (mais recentes primeiro)
    arquivos_entrada=($(ls -t "$diretorio_arquivos/Input"/*.bin))

    # Loop através de cada arquivo de entrada binário pelo índice
    for ((i=0; i<${#arquivos_entrada[@]}; i++)); do
        # Obter o caminho do arquivo de entrada
        arquivo_entrada="${arquivos_entrada[$i]}"

        # Gerar o nome do arquivo de saída com base no índice
        # O nome do arquivo de saída será algo como "Output0.bin", "Output1.bin", etc.
        arquivo_saida="Output$i.bin"

        # Criar um diretório com o nome do número de threads
        diretorio_threads="$diretorio_arquivos/Output/Quicksort/Conc/$num_threads threads"
        mkdir -p "$diretorio_threads"  # Cria o diretório se ele não existir

        # Exibir mensagem de status para o usuário sobre o que está sendo executado
        echo "Executando $nome_programa com $arquivo_entrada como entrada, $arquivo_saida como saída, usando $num_threads threads."

        # Executar o programa com os arquivos de entrada, saída e o número de threads como argumentos
        "$programa_compilado" "$arquivo_entrada" "$diretorio_threads/$arquivo_saida" "$num_threads"

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done
