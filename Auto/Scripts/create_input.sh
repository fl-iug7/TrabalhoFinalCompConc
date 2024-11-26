#!/bin/bash

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
echo "Qual é o tamanho do vetor?"
read tamanho_vetor
echo "--------------------------------------------------"

# Gerar um carimbo de data/hora no formato DD-MM-AAAA_HH-MM-SS para o nome do arquivo
# Isso garante que o arquivo gerado terá um nome único, incluindo a data e hora de sua criação
carimbo_data_hora=$(date +%d-%m-%Y_%H-%M-%S)

# Criar o nome do arquivo de entrada usando o carimbo de data/hora e o tamanho do vetor fornecido
# O arquivo será salvo no diretório "../Files/Input", com o nome no formato:
# input_<data_hora>_<tamanho_vetor>.bin
arquivo_entrada="Files/Input/Input_${carimbo_data_hora}_${tamanho_vetor}.bin"

# O tamanho do vetor fornecido pelo usuário será passado como argumento para o programa
argumento=$tamanho_vetor  # Usando diretamente o tamanho do vetor como argumento

# Exibir informações sobre o arquivo que será criado, para o usuário
echo "Criar arquivo: $arquivo_entrada com tamanho do vetor $tamanho_vetor"

# Perguntar ao usuário se deseja compilar o programa novamente
if [[ ! -f "$programa_compilado" ]]; then
    # Se o programa ainda não estiver compilado, compilar automaticamente
    echo "--------------------------------------------------"
    echo "O programa ainda não foi compilado. Compilando..."
    gcc -o "$programa_compilado" "$caminho_programa"

    # Verificar se a compilação foi bem-sucedida
    if [[ $? -ne 0 ]]; then
        echo "Erro ao compilar o programa $programa."
        echo "--------------------------------------------------"
        exit 1
    fi
else
    # Caso o programa já esteja compilado, perguntar ao usuário se ele deseja recompilá-lo
    echo "--------------------------------------------------"
    echo "O programa já está compilado."
    echo "Você deseja compilar o programa novamente? (s/n)"
    read resposta
    echo "--------------------------------------------------"

    # Verificar se a resposta é "s" ou "n"
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo "Recompilando o programa..."
        gcc -o "$programa_compilado" "$caminho_programa"

        # Verificar se a recompilação foi bem-sucedida
        if [[ $? -ne 0 ]]; then
            echo "Erro ao recompilar o programa $programa."
            echo "--------------------------------------------------"
            exit 1
        fi
    elif [[ "$resposta" == "n" || "$resposta" == "N" ]]; then
        echo "Prosseguindo com o programa já compilado..."
    else
        echo "Resposta inválida. Por favor, responda com 's' para sim ou 'n' para não."
        echo "--------------------------------------------------"
        exit 1
    fi
fi

# Executar o programa compilado para gerar o arquivo binário com o vetor,
# passando o caminho do arquivo de entrada e o tamanho do vetor como argumentos
"$programa_compilado" "$arquivo_entrada" "$argumento"

# Separador para melhorar a legibilidade da saída no terminal
echo "--------------------------------------------------"
