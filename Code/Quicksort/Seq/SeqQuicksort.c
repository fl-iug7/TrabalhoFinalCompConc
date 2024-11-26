#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <unistd.h>

/*
 * Descrição:
 * Este programa implementa o algoritmo Quicksort para ordenar um vetor de inteiros 
 * armazenado em um arquivo binário. O programa lê um vetor de um arquivo de entrada,
 * ordena o vetor utilizando Quicksort, e grava o vetor ordenado em um arquivo de saída.
 * O tempo de execução da ordenação também é medido e exibido. 
 *
 * O programa usa recursão para implementar o Quicksort e particionamento para reorganizar
 * os elementos em torno de um pivô.
 * 
 * A validação da ordenação pode ser ativada com a macro `VALIDAR_ORDENACAO` para garantir que
 * o vetor está corretamente ordenado.
 */

// Macro para obter o tempo atual em segundos
#define OBTER_TEMPO(agora) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    agora = t.tv_sec + t.tv_usec / 1e6; \
}

// Função para trocar dois elementos
void trocar(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Função para particionar o vetor, selecionando um pivô e reorganizando os elementos
// O pivô é movido para a última posição, e os elementos menores que ele vão para a esquerda
// e os maiores vão para a direita.
int particionar(int A[], int lo, int hi) {
    int meio = lo + (hi - lo) / 2; // Seleciona o pivô como o elemento do meio
    int pivo = A[meio];

    // Mover o pivô para o final para simplificar a partição
    trocar(&A[meio], &A[hi]);

    int i = lo - 1;
    int j = hi;

    while (1) {
        // Move o índice 'i' até encontrar um elemento maior ou igual ao pivô
        do {
            i++;
        } while (A[i] < pivo);

        // Move o índice 'j' até encontrar um elemento menor ou igual ao pivô
        do {
            j--;
        } while (A[j] > pivo && j > lo);

        // Se os índices se cruzaram, o pivô pode ser colocado na posição correta
        if (i >= j) {
            trocar(&A[i], &A[hi]);
            return j;
        }

        // Se não, troca os elementos para garantir que a partição seja feita corretamente
        trocar(&A[i], &A[j]);
    }
}

// Algoritmo Quicksort: ordena o vetor recursivamente utilizando o particionamento
void quicksort(int A[], int lo, int hi) {
    if (lo < hi) {
        int p = particionar(A, lo, hi); // Encontra a posição do pivô
        quicksort(A, lo, p);             // Ordena a parte esquerda
        quicksort(A, p + 1, hi);         // Ordena a parte direita
    }
}

// Função para medir o tempo de ordenação
double medirTempoDeOrdenacao(int a[], int comprimentoA) {
    double inicio, fim;

    OBTER_TEMPO(inicio);  // Marca o tempo inicial
    quicksort(a, 0, comprimentoA - 1);  // Ordena o vetor
    OBTER_TEMPO(fim);     // Marca o tempo final

    return fim - inicio;  // Retorna o tempo de execução em segundos
}

// Função principal
int main(int argc, char *argv[]) {
    if (argc != 3) {
        // Verifica se o número correto de argumentos foi fornecido (entrada e saída de arquivos)
        fprintf(stderr, "Uso: %s <arquivo_entrada> <arquivo_saida>\n", argv[0]);
        return 1;
    }

    // Abrir o arquivo binário de entrada
    FILE *arquivoEntrada = fopen(argv[1], "rb");
    if (!arquivoEntrada) {
        perror("Erro ao abrir o arquivo de entrada");
        return 1;
    }

    // Ler o tamanho do vetor armazenado no arquivo
    int comprimentoA;
    fread(&comprimentoA, sizeof(int), 1, arquivoEntrada);

    // Alocar memória para armazenar o vetor
    int *a = malloc(comprimentoA * sizeof(int));
    if (!a) {
        perror("Falha na alocação de memória");
        fclose(arquivoEntrada);
        return 1;
    }

    // Ler o vetor de inteiros do arquivo
    fread(a, sizeof(int), comprimentoA, arquivoEntrada);
    fclose(arquivoEntrada);

    // Medir o tempo de ordenação
    double tempoGasto = medirTempoDeOrdenacao(a, comprimentoA);
    printf("Tempo gasto para ordenar: %f segundos\n", tempoGasto);

    // Etapa de validação (opcional)
    #ifdef VALIDAR_ORDENACAO
    if (estaOrdenado(a, comprimentoA)) {
        printf("O vetor está corretamente ordenado.\n");
    } else {
        printf("O vetor não está corretamente ordenado.\n");
    }
    #endif

    // Abrir o arquivo binário de saída para escrever o vetor ordenado
    FILE *arquivoSaida = fopen(argv[2], "wb");
    if (!arquivoSaida) {
        perror("Erro ao abrir o arquivo de saída");
        free(a);  // Libera a memória alocada antes de sair
        return 1;
    }

    // Escrever o tamanho do vetor e o vetor ordenado no arquivo de saída
    fwrite(&comprimentoA, sizeof(int), 1, arquivoSaida);  // Escrever o tamanho do vetor
    fwrite(a, sizeof(int), comprimentoA, arquivoSaida);  // Escrever o vetor ordenado
    fclose(arquivoSaida);

    // Criar o diretório Data caso não exista
    struct stat st = {0};
    if (stat("Data", &st) == -1) {
        mkdir("Data", 0700);  // Cria o diretório com permissão 0700
    }

    // Criar ou abrir o arquivo Data/seq_quicksort.txt para adicionar o log do tempo
    FILE *arquivoLog = fopen("Data/seq_quicksort.txt", "a");
    if (!arquivoLog) {
        perror("Erro ao abrir o arquivo de log");
        free(a);  // Libera a memória alocada antes de sair
        return 1;
    }

    // Adicionar a linha de log no arquivo Data/seq_quicksort.txt
    fprintf(arquivoLog, "Tempo: %f; Comprimento: %d\n", tempoGasto, comprimentoA);
    fclose(arquivoLog);

    // Liberar a memória alocada para o vetor
    free(a);

    return 0;
}
