#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/time.h>
#include <sys/stat.h>

/*
 * Descrição do programa:
 * Este programa implementa um algoritmo de ordenação Min-Max usando múltiplas threads.
 * O array de inteiros é dividido em segmentos que são ordenados paralelamente em diferentes threads.
 * Após a ordenação de cada segmento, os segmentos ordenados são mesclados em um único array ordenado.
 * O programa lê um array de inteiros de um arquivo binário de entrada, ordena o array e salva o resultado em um arquivo binário de saída.
 * O número de threads é fornecido como parâmetro de entrada.
 */

// Função para garantir que o diretório "Data" e o arquivo "conc_minmax.txt" existam
void garantirDiretorioEArquivo() {
    struct stat st = {0};
    
    // Criar o diretório Data, se não existir
    if (stat("Data", &st) == -1) {
        mkdir("Data", 0700);  // Cria o diretório com permissão 0700
    }

    // Criar ou abrir o arquivo Data/conc_minmax.txt para adicionar o log do tempo
    FILE *arquivoLog = fopen("Data/conc_minmax.txt", "a");
    if (!arquivoLog) {
        perror("Erro ao abrir o arquivo de log");
        exit(1);
    }
    fclose(arquivoLog); // Apenas fechar para garantir que o arquivo foi criado
}

// Função para registrar o tempo no arquivo
void registrarTempoNoArquivo(double tempoGasto, int comprimentoA, int numThreads) {
    FILE *arquivoLog = fopen("Data/conc_minmax.txt", "a");
    if (!arquivoLog) {
        perror("Erro ao abrir o arquivo de log");
        exit(1);
    }

    // Adicionar a linha de log no arquivo Data/conc_minmax.txt
    fprintf(arquivoLog, "Tempo: %f; Comprimento: %d; Threads: %d\n", tempoGasto, comprimentoA, numThreads);
    fclose(arquivoLog);
}

// Estrutura para armazenar dados de cada thread (segmento de array)
typedef struct {
    int *arr;   // Ponteiro para o array
    int inicio; // Índice de início do segmento
    int fim;    // Índice final do segmento
} DadosDaThread;

// Macro para obter o tempo em segundos
#define OBTER_TEMPO(agora) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    agora = t.tv_sec + t.tv_usec / 1e6; \
}

// Função para trocar valores entre duas variáveis
void trocar(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Função que realiza o algoritmo Min-Max Sort em um segmento do array
// Cada thread vai ordenar seu próprio segmento utilizando a técnica de Min-Max Sort
void* minMaxSort(void *arg) {
    DadosDaThread *dados = (DadosDaThread*)arg;
    int *arr = dados->arr;
    int inicio = dados->inicio;
    int fim = dados->fim;

    while (inicio < fim) {
        int posMin = inicio, posMax = fim;

        // Procurar os menores e maiores elementos no segmento
        for (int i = inicio; i <= fim; i++) {
            if (arr[i] < arr[posMin]) {
                posMin = i;
            }
            if (arr[i] > arr[posMax]) {
                posMax = i;
            }
        }

        // Trocar o menor elemento com o primeiro do segmento
        if (posMin != inicio) {
            trocar(&arr[inicio], &arr[posMin]);
            if (posMax == inicio) {
                posMax = posMin;
            }
        }

        // Trocar o maior elemento com o último do segmento
        if (posMax != fim) {
            trocar(&arr[fim], &arr[posMax]);
        }

        // Ajustar os limites do segmento
        inicio++;
        fim--;
    }
    return NULL;
}

// Função que mescla os segmentos ordenados pelas threads em um único array ordenado
void mesclarSegmentosOrdenados(int *arr, int n, int numThreads, int tamanhoSegmento) {
    int *temp = (int*)malloc(n * sizeof(int));
    if (!temp) {
        printf("Erro: Falha na alocação de memória para mesclagem.\n");
        return;
    }

    int *indices = (int*)malloc(numThreads * sizeof(int));
    if (!indices) {
        printf("Erro: Falha na alocação de memória para os índices.\n");
        free(temp);
        return;
    }

    // Inicializar os índices para cada segmento
    for (int i = 0; i < numThreads; i++) {
        indices[i] = i * tamanhoSegmento;
    }

    for (int k = 0; k < n; k++) {
        int idxMin = -1;

        // Encontrar o menor elemento entre os segmentos
        for (int i = 0; i < numThreads; i++) {
            if (indices[i] < (i == numThreads - 1 ? n : (i + 1) * tamanhoSegmento)) {
                if (idxMin == -1 || arr[indices[i]] < arr[indices[idxMin]]) {
                    idxMin = i;
                }
            }
        }

        // Colocar o menor elemento encontrado no array temporário
        temp[k] = arr[indices[idxMin]];
        indices[idxMin]++;  // Avançar o índice do segmento
    }

    // Copiar os dados mesclados de volta para o array original
    for (int i = 0; i < n; i++) {
        arr[i] = temp[i];
    }

    free(temp);
    free(indices);
}

// Função para ler um array de inteiros de um arquivo binário
int* lerArquivoBinario(const char *nomeArquivo, int *n) {
    FILE *arquivo = fopen(nomeArquivo, "rb");
    if (!arquivo) {
        printf("Erro: Não foi possível abrir o arquivo de entrada.\n");
        return NULL;
    }

    // Ler o tamanho do array
    if (fread(n, sizeof(int), 1, arquivo) != 1) {
        printf("Erro: Falha ao ler o tamanho do array.\n");
        fclose(arquivo);
        return NULL;
    }

    // Alocar memória para o array
    int *arr = (int*)malloc(*n * sizeof(int));
    if (!arr) {
        printf("Erro: Falha na alocação de memória.\n");
        fclose(arquivo);
        return NULL;
    }

    // Ler os elementos do array
    if (fread(arr, sizeof(int), *n, arquivo) != *n) {
        printf("Erro: Falha ao ler os elementos do array.\n");
        free(arr);
        fclose(arquivo);
        return NULL;
    }

    fclose(arquivo);
    return arr;
}

// Função para gravar um array de inteiros em um arquivo binário
void gravarArquivoBinario(const char *nomeArquivo, int *arr, int n) {
    FILE *arquivo = fopen(nomeArquivo, "wb");
    if (!arquivo) {
        printf("Erro: Não foi possível abrir o arquivo de saída.\n");
        return;
    }

    // Gravar o tamanho do array
    fwrite(&n, sizeof(int), 1, arquivo);
    // Gravar os elementos do array
    fwrite(arr, sizeof(int), n, arquivo);

    fclose(arquivo);
}

int main(int argc, char *argv[]) {
    // Verificar se o número correto de parâmetros foi passado
    if (argc != 4) {
        printf("Uso: %s <arquivo_entrada> <arquivo_saida> <num_threads>\n", argv[0]);
        return 1;
    }

    const char *arquivoEntrada = argv[1];
    const char *arquivoSaida = argv[2];
    int numThreads = atoi(argv[3]);

    // Verificar se o número de threads é positivo
    if (numThreads <= 0) {
        printf("Erro: O número de threads deve ser positivo.\n");
        return 1;
    }

    // Garantir que o diretório Data e o arquivo de log existam
    garantirDiretorioEArquivo();

    // Ler o array do arquivo binário de entrada
    int n;
    int *arr = lerArquivoBinario(arquivoEntrada, &n);
    if (!arr) {
        return 1;
    }

    printf("Tamanho do array: %d\n", n);

    // Criar as threads e dividir o trabalho
    pthread_t threads[numThreads];
    DadosDaThread dadosThread[numThreads];

    int tamanhoSegmento = n / numThreads; // Tamanho de cada segmento
    int restante = n % numThreads;        // Elementos restantes

    double inicio, fim;
    OBTER_TEMPO(inicio);

    // Criar as threads para ordenar cada segmento
    for (int i = 0; i < numThreads; i++) {
        dadosThread[i].arr = arr;
        dadosThread[i].inicio = i * tamanhoSegmento;
        dadosThread[i].fim = (i + 1) * tamanhoSegmento - 1;

        // Atribuir os elementos restantes à última thread
        if (i == numThreads - 1) {
            dadosThread[i].fim += restante;
        }

        pthread_create(&threads[i], NULL, minMaxSort, &dadosThread[i]);
    }

    // Aguardar as threads terminarem
    for (int i = 0; i < numThreads; i++) {
        pthread_join(threads[i], NULL);
    }

    // Mesclar os segmentos ordenados
    mesclarSegmentosOrdenados(arr, n, numThreads, tamanhoSegmento);

    OBTER_TEMPO(fim);
    double tempoProcessamento = fim - inicio;

    printf("Tempo de processamento: %f segundos\n", tempoProcessamento);

    // Registrar o tempo e o número de threads no arquivo
    registrarTempoNoArquivo(tempoProcessamento, n, numThreads);

    // Salvar o array ordenado no arquivo binário
    gravarArquivoBinario(arquivoSaida, arr, n);

    printf("Array ordenado salvo em %s\n", arquivoSaida);

    // Liberar a memória alocada
    free(arr);
    return 0;
}
