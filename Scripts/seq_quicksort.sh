#!/bin/bash

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
    if [[ ! -f "$caminho_programa_compilado" ]]; then
        # Se o programa não existir, compilar o programa C usando o compilador GCC
        echo "Compilando o programa $nome_programa..."
        gcc -o "$caminho_programa_compilado" "$programa"

        # Verificar se a compilação foi bem-sucedida (retorno 0 significa sucesso)
        if [[ $? -ne 0 ]]; then
            # Se ocorrer erro na compilação, exibe mensagem de erro e continua com o próximo programa
            echo "Erro ao compilar $nome_programa"
            continue
        fi
    else
        # Se o programa já foi compilado, informar que ele já está pronto para ser executado
        echo "O programa $nome_programa já foi compilado. Iniciando execução..."
        echo "--------------------------------------------------"
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
        echo "Executando $nome_programa com $arquivo_entrada como entrada e $arquivo_saida como saída."

        # Executar o programa compilado com os arquivos de entrada e saída como argumentos
        "$caminho_programa_compilado" "$arquivo_entrada" "$arquivo_saida"

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done
