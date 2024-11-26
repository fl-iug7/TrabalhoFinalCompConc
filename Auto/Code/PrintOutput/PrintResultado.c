#include <stdio.h>
#include <stdlib.h>

/* 
 * Este programa lê um vetor de inteiros armazenado em um arquivo binário, 
 * imprime o tamanho do vetor e seus elementos, e então libera a memória alocada.
 *
 * A função 'lerVetorBinario' abre um arquivo binário, lê o tamanho do vetor 
 * e seus elementos, aloca memória para o vetor e retorna o ponteiro para 
 * o vetor preenchido. Se ocorrer algum erro durante a leitura ou alocação, 
 * o programa imprime uma mensagem de erro e retorna 'NULL'.
 * 
 * A função 'main' recebe o nome do arquivo binário como argumento, chama 
 * a função 'lerVetorBinario', imprime os dados lidos e libera a memória alocada.
 */

// Função para ler o vetor de um arquivo binário
int* lerVetorBinario(const char *nomeArquivo, int *n) {
    // Tenta abrir o arquivo binário no modo leitura ("rb")
    FILE *arquivo = fopen(nomeArquivo, "rb");
    if (!arquivo) {
        // Se falhar ao abrir o arquivo, imprime a mensagem de erro e retorna NULL
        printf("Erro: Não foi possível abrir o arquivo de entrada.\n");
        return NULL;
    }

    // Lê o tamanho do vetor do arquivo (primeiro inteiro)
    if (fread(n, sizeof(int), 1, arquivo) != 1) {
        // Se falhar ao ler o tamanho, imprime a mensagem de erro e fecha o arquivo
        printf("Erro: Falha ao ler o tamanho do vetor.\n");
        fclose(arquivo);
        return NULL;
    }

    // Aloca memória para o vetor com o tamanho especificado
    int *vetor = (int *)malloc(*n * sizeof(int));
    if (!vetor) {
        // Se falhar na alocação de memória, imprime a mensagem de erro e fecha o arquivo
        printf("Erro: Falha na alocação de memória.\n");
        fclose(arquivo);
        return NULL;
    }

    // Lê os elementos do vetor do arquivo
    if (fread(vetor, sizeof(int), *n, arquivo) != *n) {
        // Se falhar ao ler os valores, imprime a mensagem de erro, libera a memória e fecha o arquivo
        printf("Erro: Falha ao ler os valores do vetor.\n");
        free(vetor);
        fclose(arquivo);
        return NULL;
    }

    // Fecha o arquivo após a leitura bem-sucedida
    fclose(arquivo);
    return vetor;  // Retorna o ponteiro para o vetor lido
}

int main(int argc, char *argv[]) {
    // Verifica se o número correto de argumentos foi passado (nome do arquivo binário)
    if (argc != 2) {
        printf("Uso: %s <arquivo binário>\n", argv[0]);
        return 1;
    }

    const char *nomeArquivo = argv[1];  // Obtém o nome do arquivo binário da linha de comando
    int n;  // Variável para armazenar o tamanho do vetor
    // Chama a função para ler o vetor do arquivo binário
    int *vetor = lerVetorBinario(nomeArquivo, &n);
    
    // Se a leitura falhar (vetor for NULL), termina a execução com erro
    if (vetor == NULL) {
        return 1;
    }

    // Imprime o tamanho do vetor
    printf("Tamanho do vetor: %d\n", n);
    printf("Elementos do vetor: ");
    // Imprime cada elemento do vetor
    for (int i = 0; i < n; i++) {
        printf("%d ", vetor[i]);
    }
    printf("\n");

    // Libera a memória alocada para o vetor
    free(vetor);

    return 0;  // Finaliza o programa com sucesso
}
