#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>
#include <sys/stat.h>

/*
 * Este programa realiza a ordenação de um vetor de inteiros usando o algoritmo Quicksort
 * de forma paralela com múltiplas threads. A quantidade máxima de threads simultâneas 
 * é controlada por uma variável global e um mutex, que são usados para evitar a 
 * criação excessiva de threads.
 * O programa lê o vetor de um arquivo binário de entrada, realiza a ordenação 
 * e escreve o vetor ordenado em um arquivo binário de saída.
 *
 * O código usa o modelo de threads POSIX (pthreads) para paralelizar a execução 
 * do Quicksort. Ele divide o vetor em duas partes e cria threads para ordenar 
 * essas partes paralelamente, mas respeita o número máximo de threads especificado 
 * pelo usuário.
 *
 * O tempo total de execução da ordenação é medido e impresso ao final.
 */

int maxThreads;              // Número máximo de threads global
int currentThreads = 0;      // Contagem global de threads ativas
pthread_mutex_t threadMutex; // Mutex para gerenciar a contagem de threads

// Macro para obter o tempo em segundos
#define OBTER_TEMPO(agora) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    agora = t.tv_sec + t.tv_usec / 1e6; \
}

// Definir uma estrutura para armazenar os parâmetros de cada thread
typedef struct {
    int *A;  // Ponteiro para o vetor
    int lo;  // Índice inferior
    int hi;  // Índice superior
} QuicksortArgs;

// Função para trocar dois elementos
void trocar(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Função de partição
int particao(int A[], int lo, int hi) {
    int meio = lo + (hi - lo) / 2;
    int pivô = A[meio];
    trocar(&A[meio], &A[hi]); // Mover o pivô para o final

    int i = lo - 1;
    for (int j = lo; j < hi; j++) {
        if (A[j] < pivô) {
            i++;
            trocar(&A[i], &A[j]);
        }
    }
    trocar(&A[i + 1], &A[hi]); // Colocar o pivô na posição correta
    return i + 1;
}

// Função de Quicksort com threads
void *quicksort_threaded(void *arg) {
    QuicksortArgs *args = (QuicksortArgs *)arg;
    int *A = args->A;
    int lo = args->lo;
    int hi = args->hi;

    if (lo < hi) {
        int p = particao(A, lo, hi);

        QuicksortArgs argsEsquerda = { A, lo, p - 1 };
        QuicksortArgs argsDireita = { A, p + 1, hi };

        pthread_t threadEsquerda, threadDireita;
        int threadEsquerdaCriada = 0, threadDireitaCriada = 0;

        // Bloquear mutex e verificar se uma nova thread pode ser criada
        pthread_mutex_lock(&threadMutex);
        if (currentThreads < maxThreads) {
            currentThreads++;
            pthread_mutex_unlock(&threadMutex);

            pthread_create(&threadEsquerda, NULL, quicksort_threaded, &argsEsquerda);
            threadEsquerdaCriada = 1;
        } else {
            pthread_mutex_unlock(&threadMutex);
            quicksort_threaded(&argsEsquerda); // Ordenar sem criar nova thread
        }

        pthread_mutex_lock(&threadMutex);
        if (currentThreads < maxThreads) {
            currentThreads++;
            pthread_mutex_unlock(&threadMutex);

            pthread_create(&threadDireita, NULL, quicksort_threaded, &argsDireita);
            threadDireitaCriada = 1;
        } else {
            pthread_mutex_unlock(&threadMutex);
            quicksort_threaded(&argsDireita); // Ordenar sem criar nova thread
        }

        // Aguardar as threads terminarem, caso tenham sido criadas
        if (threadEsquerdaCriada) {
            pthread_join(threadEsquerda, NULL);
            pthread_mutex_lock(&threadMutex);
            currentThreads--;
            pthread_mutex_unlock(&threadMutex);
        }
        if (threadDireitaCriada) {
            pthread_join(threadDireita, NULL);
            pthread_mutex_lock(&threadMutex);
            currentThreads--;
            pthread_mutex_unlock(&threadMutex);
        }
    }

    return NULL;
}

// Função para medir o tempo de ordenação
double medirTempoOrdenacao(int a[], int comprimentoA) {
    double inicio, fim;

    OBTER_TEMPO(inicio);

    QuicksortArgs args = { a, 0, comprimentoA - 1 };
    quicksort_threaded(&args);

    OBTER_TEMPO(fim);

    return fim - inicio;
}

// Função para garantir que o diretório "Data" e o arquivo "conc_quicksort.txt" existam
void garantirDiretorioEArquivo() {
    struct stat st = {0};
    
    // Criar o diretório Data, se não existir
    if (stat("Data", &st) == -1) {
        mkdir("Data", 0700);  // Cria o diretório com permissão 0700
    }

    // Criar ou abrir o arquivo Data/conc_quicksort.txt para adicionar o log do tempo
    FILE *arquivoLog = fopen("Data/conc_quicksort.txt", "a");
    if (!arquivoLog) {
        perror("Erro ao abrir o arquivo de log");
        exit(1);
    }
    fclose(arquivoLog); // Apenas fechar para garantir que o arquivo foi criado
}

// Função para registrar o tempo e o número de threads no arquivo
void registrarTempoNoArquivo(double tempoGasto, int comprimentoA, int numThreads) {
    FILE *arquivoLog = fopen("Data/conc_quicksort.txt", "a");
    if (!arquivoLog) {
        perror("Erro ao abrir o arquivo de log");
        exit(1);
    }

    // Adicionar a linha de log no arquivo Data/conc_quicksort.txt
    fprintf(arquivoLog, "Tempo: %f; Comprimento: %d; Threads: %d\n", tempoGasto, comprimentoA, numThreads);
    fclose(arquivoLog);
}

// Função principal
int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Uso: %s <arquivo_entrada> <arquivo_saida> <num_threads>\n", argv[0]);
        return 1;
    }

    // Definir o número máximo de threads a partir do argumento do usuário
    maxThreads = atoi(argv[3]);
    if (maxThreads <= 0) {
        fprintf(stderr, "O número de threads deve ser positivo.\n");
        return 1;
    }

    // Inicializar o mutex para controle das threads
    pthread_mutex_init(&threadMutex, NULL);

    // Garantir que o diretório e o arquivo de log existam
    garantirDiretorioEArquivo();

    // Abrir o arquivo binário de entrada
    FILE *arquivoEntrada = fopen(argv[1], "rb");
    if (!arquivoEntrada) {
        perror("Erro ao abrir o arquivo de entrada");
        return 1;
    }

    // Ler o tamanho do vetor
    int comprimentoA;
    fread(&comprimentoA, sizeof(int), 1, arquivoEntrada);

    // Alocar memória para o vetor
    int *a = malloc(comprimentoA * sizeof(int));
    if (!a) {
        perror("Falha na alocação de memória");
        fclose(arquivoEntrada);
        return 1;
    }

    // Ler o vetor do arquivo
    fread(a, sizeof(int), comprimentoA, arquivoEntrada);
    fclose(arquivoEntrada);

    // Medir o tempo de ordenação
    double tempoDecorrido = medirTempoOrdenacao(a, comprimentoA);
    printf("Tempo de ordenação: %f segundos\n", tempoDecorrido);

    // Registrar o tempo e o número de threads no arquivo
    registrarTempoNoArquivo(tempoDecorrido, comprimentoA, maxThreads);

    // Abrir o arquivo binário de saída
    FILE *arquivoSaida = fopen(argv[2], "wb");
    if (!arquivoSaida) {
        perror("Erro ao abrir o arquivo de saída");
        free(a);
        return 1;
    }

    // Escrever o vetor ordenado no arquivo de saída
    fwrite(&comprimentoA, sizeof(int), 1, arquivoSaida);
    fwrite(a, sizeof(int), comprimentoA, arquivoSaida);
    fclose(arquivoSaida);

    // Liberar memória alocada e destruir o mutex
    free(a);
    pthread_mutex_destroy(&threadMutex);

    return 0;
}
