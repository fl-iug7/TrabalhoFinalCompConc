#include <stdio.h>
#include <stdlib.h>

/* 
 * Este programa lê um vetor de inteiros armazenado em um arquivo binário, 
 * imprime o vetor e seus tamanho
 */

// Função para ler o vetor de um arquivo binário
int* lerVetorBinario(const char *nomeArquivo, int *n) {
    FILE *arquivo = fopen(nomeArquivo, "rb");
    if (!arquivo) {
        printf("Erro: Não foi possível abrir o arquivo de entrada.\n");
        return NULL;
    }

    if (fread(n, sizeof(int), 1, arquivo) != 1) {
        printf("Erro: Falha ao ler o tamanho do vetor.\n");
        fclose(arquivo);
        return NULL;
    }

    int *vetor = (int *)malloc(*n * sizeof(int));
    if (!vetor) {
        printf("Erro: Falha na alocação de memória.\n");
        fclose(arquivo);
        return NULL;
    }

    if (fread(vetor, sizeof(int), *n, arquivo) != *n) {
        printf("Erro: Falha ao ler os valores do vetor.\n");
        free(vetor);
        fclose(arquivo);
        return NULL;
    }

    fclose(arquivo);
    return vetor;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Uso: %s <arquivo binário>\n", argv[0]);
        return 1;
    }

    const char *nomeArquivo = argv[1];
    int n;
    int *vetor = lerVetorBinario(nomeArquivo, &n);
    
    if (vetor == NULL) {
        return 1;
    }

    printf("Tamanho do vetor: %d\n", n);
    for (int i = 0; i < n; i++) {
        printf("%d ", vetor[i]);
    }
    printf("\n");

    free(vetor);
    return 0;
}
