#!/bin/bash

# Descrição:
# Este script automatiza a compilação e execução de programas em C que implementam o algoritmo MinMaxSort concorrente.
# O script segue as etapas abaixo:
# 1. Verifica se cada programa C já foi compilado. Se não, compila o programa.
# 2. Pergunta ao usuário quantas threads o programa deve usar.
# 3. Para cada arquivo de entrada binário no diretório de entrada, o programa é executado com o número de threads especificado.
# 4. Os resultados são armazenados em arquivos de saída com base no índice de execução.
# 5. Cada conjunto de arquivos de saída é organizado em um diretório com o nome do número de threads.
# O script processa todos os arquivos de entrada binários, executando o programa para cada um e gerando os arquivos de saída correspondentes.

# Diretório contendo o programa em C (Fonte)
diretorio_programas="Code/MinMaxSort/Conc"

# Diretório contendo os arquivos de entrada e saída
diretorio_arquivos="Files"

# Loop através de todos os arquivos .c no diretório de programas
for programa in "$diretorio_programas"/*.c; do
    # Obter o nome base do programa (sem a extensão .c)
    nome_programa=$(basename "$programa" .c)

    # Verificar se o programa já foi compilado. Se não, compilar o programa C.
    if [[ -f "$diretorio_programas/$nome_programa" ]]; then
        # Perguntar ao usuário se deseja compilar novamente
        read -p "$nome_programa já foi compilado. Deseja compilar novamente? (s/n): " resposta
        echo "--------------------------------------------------"
        if [[ "$resposta" != "s" && "$resposta" != "n" ]]; then
            echo "Resposta inválida. Encerrando a execução."
            echo "--------------------------------------------------"
            exit 1
        elif [[ "$resposta" == "s" ]]; then
            # Compilar novamente o programa
            echo "Compilando $nome_programa novamente..."
            echo "--------------------------------------------------"
            gcc -o "$diretorio_programas/$nome_programa" "$programa"
            
            # Verificar se a compilação foi bem-sucedida
            if [[ $? -ne 0 ]]; then
                # Caso haja erro na compilação, exibe a mensagem de erro e continua para o próximo programa
                echo "Erro ao compilar $nome_programa. Continuando com o próximo programa."
                echo "--------------------------------------------------"
                continue
            fi
        fi
    else
        # Compilar o programa se não estiver compilado
        echo "Compilando $nome_programa..."
        echo "--------------------------------------------------"
        gcc -o "$diretorio_programas/$nome_programa" "$programa"
        
        # Verificar se a compilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            # Caso haja erro na compilação, exibe a mensagem de erro e continua para o próximo programa
            echo "Erro ao compilar $nome_programa. Continuando com o próximo programa."
            echo "--------------------------------------------------"
            continue
        fi
    fi

    # Perguntar ao usuário quantas threads o programa deve usar (apenas uma vez por programa)
    read -p "Quantas threads o $nome_programa deve usar? " num_threads
    echo "--------------------------------------------------"

    # Obter a lista de arquivos de entrada, ordenados pela data de modificação (mais recentes primeiro)
    arquivos_entrada=($(ls -t "$diretorio_arquivos/Input"/*.bin))

    # Loop através de cada arquivo de entrada pelo índice
    for ((i=0; i<${#arquivos_entrada[@]}; i++)); do
        # Obter o caminho do arquivo de entrada
        arquivo_entrada="${arquivos_entrada[$i]}"

        # Gerar o nome do arquivo de saída com base no índice (ex: Output0.bin, Output1.bin, etc.)
        arquivo_saida="Output$i.bin"

        # Criar um diretório com o nome do número de threads (ex: "4 threads")
        diretorio_threads="$diretorio_arquivos/Output/MinMaxSort/Conc/$num_threads threads"
        mkdir -p "$diretorio_threads"  # Cria o diretório se ele não existir

        # Exibir mensagem de status para o usuário sobre o que está sendo executado
        echo "Executando $nome_programa com $arquivo_entrada como entrada, $arquivo_saida como saída, usando $num_threads threads."

        # Executar o programa com os arquivos de entrada, saída e o número de threads como argumentos
        "$diretorio_programas/$nome_programa" "$arquivo_entrada" "$diretorio_threads/$arquivo_saida" "$num_threads"

        # Separador visual para clareza no terminal entre execuções de programas
        echo "--------------------------------------------------"
    done
done
