#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/stat.h>

/* 
 * Descrição:
 * Este programa lê um vetor de números inteiros de um arquivo binário,
 * ordena o vetor utilizando o algoritmo Min-Max Sort e então salva o vetor 
 * ordenado em um arquivo binário de saída. Durante o processo, ele mede e 
 * exibe o tempo de execução da ordenação. Caso o vetor já esteja ordenado, 
 * o programa apenas exibe uma mensagem informando isso.
 * 
 * Funcionalidades:
 * 1. Leitura do vetor de um arquivo binário.
 * 2. Verificação se o vetor está ordenado.
 * 3. Aplicação do algoritmo Min-Max Sort para ordenar o vetor.
 * 4. Medição do tempo de execução da ordenação.
 * 5. Salvamento do vetor ordenado em um novo arquivo binário.
 * 6. Exibição de algumas partes do vetor antes e após a ordenação.
 */

// Macro para obter o tempo atual em segundos
#define OBTER_TEMPO(agora) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    agora = t.tv_sec + t.tv_usec / 1e6; \
}

// Função para garantir que o diretório "Data" e o arquivo "seq_minmax.txt" existam
void garantirDiretorioEArquivo() {
    struct stat st = {0};
    
    // Criar o diretório Data, se não existir
    if (stat("Data", &st) == -1) {
        mkdir("Data", 0700);  // Cria o diretório com permissão 0700
    }

    // Abrir o arquivo Data/seq_minmax.txt para verificar a primeira linha
    FILE *arquivoLog = fopen("Data/seq_minmax.txt", "r+");
    if (!arquivoLog) {
        // Se o arquivo não existir, criá-lo e adicionar o cabeçalho
        arquivoLog = fopen("Data/seq_minmax.txt", "w");
        if (!arquivoLog) {
            perror("Erro ao abrir o arquivo de log");
            exit(1);
        }
        // Adicionar a linha de cabeçalho
        fprintf(arquivoLog, "Programa,Tempo,Comprimento,Threads\n");
        fclose(arquivoLog); // Fechar após escrever o cabeçalho
    } else {
        // Arquivo existe, verificar a primeira linha
        char linha[256];
        if (fgets(linha, sizeof(linha), arquivoLog)) {
            // Verificar se a primeira linha é o cabeçalho esperado
            if (linha[0] != 'T' || linha[1] != 'e' || linha[2] != 'm' || linha[3] != 'p' || linha[4] != 'o') {
                // Se não for, adicionar o cabeçalho
                fseek(arquivoLog, 0, SEEK_SET);  // Voltar para o início do arquivo
                fprintf(arquivoLog, "Programa,Tempo,Comprimento,Threads\n");
            }
        }
        fclose(arquivoLog); // Fechar o arquivo após verificação
    }
}

// Função para registrar o tempo no arquivo
void registrarTempoNoArquivo(double tempoGasto, int comprimentoA) {
    FILE *arquivoLog = fopen("Data/seq_minmax.txt", "a");
    if (!arquivoLog) {
        perror("Erro ao abrir o arquivo de log");
        exit(1);
    }

    // Adicionar a linha de log no arquivo Data/seq_minmax.txt
    fprintf(arquivoLog, "SeqMinMaxSort,%f,%d,\n", tempoGasto, comprimentoA);
    fclose(arquivoLog);
}

// // Função para verificar se o vetor já está ordenado
// int estaOrdenado(int vetor[], int n) {
//     for (int i = 1; i < n; i++) {
//         if (vetor[i - 1] > vetor[i]) {
//             return 0; // Não está ordenado
//         }
//     }
//     return 1; // Está ordenado
// }

// Algoritmo Min-Max Sort
void minMaxSort(int vetor[], int n) {
    int indiceMin = 0, indiceMax = n - 1;

    while (indiceMin < indiceMax) {
        int posMin = indiceMin, posMax = indiceMax;

        // Procurar o menor e o maior valor no vetor
        for (int i = indiceMin; i <= indiceMax; i++) {
            if (vetor[i] < vetor[posMin]) {
                posMin = i;
            }
            if (vetor[i] > vetor[posMax]) {
                posMax = i;
            }
        }

        // Trocar o menor valor com o início do vetor
        if (posMin != indiceMin) {
            int temp = vetor[indiceMin];
            vetor[indiceMin] = vetor[posMin];
            vetor[posMin] = temp;

            // Ajustar a posição do maior valor caso tenha sido trocado com o menor
            if (posMax == indiceMin) {
                posMax = posMin;
            }
        }

        // Trocar o maior valor com o final do vetor
        if (posMax != indiceMax) {
            int temp = vetor[indiceMax];
            vetor[indiceMax] = vetor[posMax];
            vetor[posMax] = temp;
        }

        // Ajustar os índices
        indiceMin++;
        indiceMax--;
    }
}

// Função para ler o vetor a partir de um arquivo binário
int* lerVetorBinario(const char *nomeArquivo, int *n) {
    FILE *arquivo = fopen(nomeArquivo, "rb");
    if (!arquivo) {
        printf("Erro: Não foi possível abrir o arquivo de entrada.\n");
        return NULL;
    }

    // Ler o tamanho do vetor
    if (fread(n, sizeof(int), 1, arquivo) != 1) {
        printf("Erro: Falha ao ler o tamanho do vetor.\n");
        fclose(arquivo);
        return NULL;
    }

    // Alocar memória para o vetor
    int *vetor = (int *)malloc(*n * sizeof(int));
    if (!vetor) {
        printf("Erro: Falha na alocação de memória.\n");
        fclose(arquivo);
        return NULL;
    }

    // Ler os valores do vetor
    if (fread(vetor, sizeof(int), *n, arquivo) != *n) {
        printf("Erro: Falha ao ler os valores do vetor.\n");
        free(vetor);
        fclose(arquivo);
        return NULL;
    }

    fclose(arquivo);
    return vetor;
}

// Função para salvar o vetor em um arquivo binário
void salvarVetorBinario(const char *nomeArquivo, int *vetor, int n) {
    FILE *arquivo = fopen(nomeArquivo, "wb");
    if (!arquivo) {
        printf("Erro: Não foi possível criar o arquivo de saída.\n");
        return;
    }

    // Escrever o tamanho do vetor
    fwrite(&n, sizeof(int), 1, arquivo);

    // Escrever os valores do vetor
    fwrite(vetor, sizeof(int), n, arquivo);

    fclose(arquivo);
}

int main(int argc, char *argv[]) {
    // Verifica se os parâmetros de entrada foram passados corretamente
    if (argc != 3) {
        printf("Uso: %s <arquivo_entrada.bin> <arquivo_saida.bin>\n", argv[0]);
        return 1;
    }

    // Garantir que o diretório e o arquivo de log existam
    garantirDiretorioEArquivo();

    const char *arquivoEntrada = argv[1];
    const char *arquivoSaida = argv[2];
    int n;

    // Ler o vetor do arquivo binário
    int *vetor = lerVetorBinario(arquivoEntrada, &n);
    if (!vetor) {
        return 1;
    }

    printf("Tamanho do array: %d\n", n);
    // // Exibir o vetor antes da ordenação (mostra os primeiros e últimos 5 elementos, se houver muitos)
    // printf("\nVetor (antes): [ ");
    // for (int i = 0; i < (n < 10 ? n : 5); i++) {
    //     printf("%d ", vetor[i]);
    // }
    // if (n > 10) printf("... ");
    // for (int i = (n > 10 ? n - 5 : 0); i < n; i++) {
    //     if (i >= 5) printf("%d ", vetor[i]);
    // }
    // printf("]\n");

    // Ordenar o vetor e medir o tempo de execução
    double inicio, fim, tempoExecucao;

    OBTER_TEMPO(inicio);

    minMaxSort(vetor, n);

    OBTER_TEMPO(fim);

    tempoExecucao = fim - inicio;
    printf("Tempo de execução: %f segundos\n", tempoExecucao);

    // Registrar o tempo no arquivo
    registrarTempoNoArquivo(tempoExecucao, n);

    // Salvar o vetor ordenado no arquivo binário
    salvarVetorBinario(arquivoSaida, vetor, n);

    printf("Vetor ordenado salvo em: %s\n", arquivoSaida);

    // Liberar a memória alocada para o vetor
    free(vetor);

    return 0;
}
