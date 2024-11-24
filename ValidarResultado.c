#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Descrição: Este programa verifica se um array de inteiros armazenado em um arquivo binário está ordenado em ordem crescente.
// Ele recebe o nome de um arquivo binário como argumento. O programa lê o comprimento do array e os seus elementos a partir do arquivo,
// e então verifica se o array está ordenado. O resultado da verificação é impresso na tela como "True" (se ordenado) ou "False" (se não ordenado).

// Função que verifica se o array está ordenado em ordem crescente
bool estaOrdenado(int A[], int comprimento) {
    for (int i = 1; i < comprimento; i++) {
        if (A[i] < A[i - 1]) {
            return false; // Encontrou um elemento fora de ordem
        }
    }
    return true; // O array está ordenado
}

// Função que lê o array de um arquivo binário e verifica se está ordenado
void verificarArrayDoArquivo(const char *nome_arquivo) {
    FILE *arquivo = fopen(nome_arquivo, "rb");
    if (arquivo == NULL) {
        perror("Erro ao abrir o arquivo");
        return;
    }

    // Ler o comprimento do array da primeira linha do arquivo
    int comprimento;
    if (fread(&comprimento, sizeof(int), 1, arquivo) != 1) {
        perror("Erro ao ler o comprimento do array");
        fclose(arquivo);
        return;
    }

    // Ler os elementos do array da segunda linha do arquivo
    int *A = (int *)malloc(comprimento * sizeof(int));
    if (A == NULL) {
        perror("Falha na alocação de memória");
        fclose(arquivo);
        return;
    }

    if (fread(A, sizeof(int), comprimento, arquivo) != comprimento) {
        perror("Erro ao ler os elementos do array");
        free(A);
        fclose(arquivo);
        return;
    }

    // Verificar se o array está ordenado e imprimir o resultado
    if (estaOrdenado(A, comprimento)) {
        printf("True\n");
    } else {
        printf("False\n");
    }

    // Liberar memória e fechar o arquivo
    free(A);
    fclose(arquivo);
}

int main(int argc, char *argv[]) {
    // Verificar se o número de argumentos está correto
    if (argc != 2) {
        // Se não houver exatamente dois argumentos, imprime a mensagem de uso
        fprintf(stderr, "Uso: %s <nome_arquivo_binario>\n", argv[0]);
        return 1;
    }

    // O segundo argumento é o nome do arquivo binário
    const char *nome_arquivo = argv[1];
    
    verificarArrayDoArquivo(nome_arquivo);
    return 0;
}
