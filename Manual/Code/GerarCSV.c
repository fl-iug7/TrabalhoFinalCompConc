#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>  // Para a função access() verificar a existência do arquivo

/*
    Este programa combina o conteúdo de arquivos .txt encontrados em um diretório especificado 
    e os salva em um único arquivo CSV. Ele ignora o cabeçalho de cada arquivo .txt 
    e escreve apenas as linhas subsequentes no arquivo de saída. O programa também 
    verifica se o arquivo de saída já existe e permite que o usuário escolha 
    entre substituir ou adicionar os dados.
*/

#define MAX_LINE_LENGTH 1024

// Função para verificar se um arquivo tem a extensão .txt
int e_arquivo_txt(const char *nome_arquivo) {
    const char *ext = strrchr(nome_arquivo, '.');  // Procura a última ocorrência do ponto (.) no nome do arquivo
    return ext != NULL && strcmp(ext, ".txt") == 0;  // Retorna verdadeiro se a extensão for .txt
}

// Função para adicionar o conteúdo de um arquivo de entrada ao arquivo de saída (CSV)
void adicionar_arquivo_ao_csv(FILE *arquivo_saida, const char *nome_arquivo_entrada) {
    FILE *arquivo_entrada = fopen(nome_arquivo_entrada, "r");  // Abre o arquivo de entrada para leitura
    if (arquivo_entrada == NULL) {
        perror("Erro ao abrir o arquivo de entrada");
        return;
    }

    char linha[MAX_LINE_LENGTH];
    int primeira_linha = 1;  // Variável para controlar a primeira linha (cabeçalho)

    // Lê o arquivo de entrada linha por linha
    while (fgets(linha, sizeof(linha), arquivo_entrada)) {
        // Pula a primeira linha, pois é o cabeçalho, e só escreve as linhas subsequentes
        if (primeira_linha) {
            primeira_linha = 0;
        } else {
            fprintf(arquivo_saida, "%s", linha);  // Adiciona a linha ao arquivo de saída
        }
    }

    fclose(arquivo_entrada);  // Fecha o arquivo de entrada
}

// Função para verificar se o arquivo de saída já existe
int arquivo_existe(const char *nome_arquivo) {
    return access(nome_arquivo, F_OK) != -1;  // Retorna verdadeiro se o arquivo existir
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Uso: %s <diretorio> <arquivo_saida>\n", argv[0]);
        return 1;
    }

    const char *diretorio = argv[1];  // Diretório onde os arquivos .txt estão localizados
    const char *arquivo_saida_nome = argv[2];  // Caminho para o arquivo CSV de saída

    FILE *arquivo_saida;

    // Verifica se o arquivo de saída já existe
    if (arquivo_existe(arquivo_saida_nome)) {
        char escolha;
        printf("O arquivo %s já existe. Deseja substituí-lo? (s/n): ", arquivo_saida_nome);
        printf("--------------------------------------------------\n");
        scanf(" %c", &escolha);  // Espaço antes de %c para consumir qualquer caractere de nova linha restante

        // Verifica se a escolha é válida
        if (escolha != 's' && escolha != 'S' && escolha != 'n' && escolha != 'N') {
            printf("Resposta inválida! O programa será encerrado.\n");
            return 1;  // Encerra a execução se a resposta não for 's' ou 'n'
        }

        // Se o usuário não quiser substituir, abre o arquivo no modo de anexação
        if (escolha != 's' && escolha != 'S') {
            printf("O programa não irá sobrescrever o arquivo existente. Adicionando dados...\n");
            printf("--------------------------------------------------\n");
            arquivo_saida = fopen(arquivo_saida_nome, "a");  // Modo de anexação
            if (arquivo_saida == NULL) {
                perror("Erro ao abrir o arquivo de saída no modo de anexação");
                return 1;
            }
        } else {
            // Se o usuário quiser substituir, abre o arquivo no modo de escrita
            arquivo_saida = fopen(arquivo_saida_nome, "w");
            if (arquivo_saida == NULL) {
                perror("Erro ao abrir o arquivo de saída");
                return 1;
            }
        }
    } else {
        // Se o arquivo não existir, cria o arquivo de saída
        arquivo_saida = fopen(arquivo_saida_nome, "w");
        if (arquivo_saida == NULL) {
            perror("Erro ao abrir o arquivo de saída");
            return 1;
        }
    }

    // Abre o diretório especificado para leitura
    DIR *dir = opendir(diretorio);
    if (dir == NULL) {
        perror("Erro ao abrir o diretório");
        fclose(arquivo_saida);
        return 1;
    }

    // Flag para controlar se o cabeçalho já foi escrito
    int cabecalho_escrito = 0;

    // Se o arquivo de saída estiver vazio, escreve o cabeçalho
    if (ftell(arquivo_saida) == 0) {  // Verifica se o arquivo de saída está vazio
        fprintf(arquivo_saida, "Programa,Tempo,Comprimento,Threads\n");  // Cabeçalho CSV
        cabecalho_escrito = 1;
    }

    // Lê o diretório e processa cada arquivo .txt encontrado
    struct dirent *entrada;
    while ((entrada = readdir(dir)) != NULL) {
        // Verifica se o arquivo é um .txt
        if (e_arquivo_txt(entrada->d_name)) {
            char caminho_arquivo[1024];
            snprintf(caminho_arquivo, sizeof(caminho_arquivo), "%s%s", diretorio, entrada->d_name);  // Cria o caminho completo do arquivo

            // Adiciona o conteúdo do arquivo ao arquivo de saída
            adicionar_arquivo_ao_csv(arquivo_saida, caminho_arquivo);
        }
    }

    // Fecha o diretório e o arquivo de saída
    closedir(dir);
    fclose(arquivo_saida);

    // Mensagem de sucesso ao concluir o processo
    printf("Arquivos CSV combinados com sucesso em %s\n", arquivo_saida_nome);
    return 0;
}
