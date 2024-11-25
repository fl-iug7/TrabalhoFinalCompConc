#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/time.h>

// Macro to get the current time in seconds
#define GET_TIME(now) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    now = t.tv_sec + t.tv_usec / 1e6; \
}

// Function to swap two elements
void trocar(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Function to partition the array, selecting a pivot and reorganizing elements
int particionar(int A[], int lo, int hi) {
    int meio = lo + (hi - lo) / 2;
    int pivo = A[meio];

    // Move the pivot to the end to simplify partitioning
    trocar(&A[meio], &A[hi]);

    int i = lo - 1;
    int j = hi;

    while (1) {
        do {
            i++;
        } while (A[i] < pivo);

        do {
            j--;
        } while (A[j] > pivo && j > lo);

        if (i >= j) {
            trocar(&A[i], &A[hi]);
            return j;
        }

        trocar(&A[i], &A[j]);
    }
}

// QuickSort algorithm
void quicksort(int A[], int lo, int hi) {
    if (lo < hi) {
        int p = particionar(A, lo, hi);
        quicksort(A, lo, p);
        quicksort(A, p + 1, hi);
    }
}

// Function to measure sorting time
double medirTempoDeOrdenacao(int a[], int aLength) {
    double inicio, fim;

    GET_TIME(inicio);  // Start time
    quicksort(a, 0, aLength - 1);
    GET_TIME(fim);     // End time

    return fim - inicio;
}

// Validate if array is sorted (optional)
#ifdef VALIDATE_SORT
bool estaOrdenado(int A[], int aLength) {
    for (int i = 1; i < aLength; i++) {
        if (A[i] < A[i - 1]) {
            return false;
        }
    }
    return true;
}
#endif

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    // Open input binary file
    FILE *arquivoEntrada = fopen(argv[1], "rb");
    if (!arquivoEntrada) {
        perror("Error opening input file");
        return 1;
    }

    // Read the size of the array
    int aLength;
    fread(&aLength, sizeof(int), 1, arquivoEntrada);

    // Allocate memory for the array
    int *a = malloc(aLength * sizeof(int));
    if (!a) {
        perror("Memory allocation failed");
        fclose(arquivoEntrada);
        return 1;
    }

    // Read the array from the file
    fread(a, sizeof(int), aLength, arquivoEntrada);
    fclose(arquivoEntrada);

    // Measure sorting time
    double tempoGasto = medirTempoDeOrdenacao(a, aLength);
    printf("Time taken to sort: %f seconds\n", tempoGasto);

    // Validation step
    #ifdef VALIDATE_SORT
    if (estaOrdenado(a, aLength)) {
        printf("The array is correctly sorted.\n");
    } else {
        printf("The array is not correctly sorted.\n");
    }
    #endif

    // Open output binary file
    FILE *arquivoSaida = fopen(argv[2], "wb");
    if (!arquivoSaida) {
        perror("Error opening output file");
        free(a);
        return 1;
    }

    // Write the sorted array to the output file
    fwrite(&aLength, sizeof(int), 1, arquivoSaida);  // Write array size
    fwrite(a, sizeof(int), aLength, arquivoSaida);  // Write sorted array
    fclose(arquivoSaida);

    // Free allocated memory
    free(a);

    return 0;
}
