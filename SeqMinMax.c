#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

// Macro to get the current time in seconds
#define GET_TIME(now) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    now = t.tv_sec + t.tv_usec / 1e6; \
}

// Function to check if the array is already sorted
int isSorted(int arr[], int n) {
    for (int i = 1; i < n; i++) {
        if (arr[i - 1] > arr[i]) {
            return 0; // Not sorted
        }
    }
    return 1; // Sorted
}

// Min-Max Sort algorithm
void minMaxSort(int arr[], int n) {
    int minIndex = 0, maxIndex = n - 1;

    while (minIndex < maxIndex) {
        int minPos = minIndex, maxPos = maxIndex;

        for (int i = minIndex; i <= maxIndex; i++) {
            if (arr[i] < arr[minPos]) {
                minPos = i;
            }
            if (arr[i] > arr[maxPos]) {
                maxPos = i;
            }
        }

        // Swap the smallest value with the start
        if (minPos != minIndex) {
            int temp = arr[minIndex];
            arr[minIndex] = arr[minPos];
            arr[minPos] = temp;

            if (maxPos == minIndex) {
                maxPos = minPos;
            }
        }

        // Swap the largest value with the end
        if (maxPos != maxIndex) {
            int temp = arr[maxIndex];
            arr[maxIndex] = arr[maxPos];
            arr[maxPos] = temp;
        }

        minIndex++;
        maxIndex--;
    }
}

// Function to read the array from a binary file
int* lerVetorBinario(const char *nomeArquivo, int *n) {
    FILE *arquivo = fopen(nomeArquivo, "rb");
    if (!arquivo) {
        printf("Error: Unable to open input file.\n");
        return NULL;
    }

    // Read the size of the array
    if (fread(n, sizeof(int), 1, arquivo) != 1) {
        printf("Error: Failed to read the array size.\n");
        fclose(arquivo);
        return NULL;
    }

    // Allocate memory for the array
    int *vetor = (int *)malloc(*n * sizeof(int));
    if (!vetor) {
        printf("Error: Memory allocation failed.\n");
        fclose(arquivo);
        return NULL;
    }

    // Read the values of the array
    if (fread(vetor, sizeof(int), *n, arquivo) != *n) {
        printf("Error: Failed to read array values.\n");
        free(vetor);
        fclose(arquivo);
        return NULL;
    }

    fclose(arquivo);
    return vetor;
}

// Function to save the array to a binary file
void salvarVetorBinario(const char *nomeArquivo, int *vetor, int n) {
    FILE *arquivo = fopen(nomeArquivo, "wb");
    if (!arquivo) {
        printf("Error: Unable to create output file.\n");
        return;
    }

    // Write the size of the array
    fwrite(&n, sizeof(int), 1, arquivo);

    // Write the array values
    fwrite(vetor, sizeof(int), n, arquivo);

    fclose(arquivo);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <input_file.bin> <output_file.bin>\n", argv[0]);
        return 1;
    }

    const char *arquivoEntrada = argv[1];
    const char *arquivoSaida = argv[2];
    int n;

    // Read the array from the binary file
    int *vetor = lerVetorBinario(arquivoEntrada, &n);
    if (!vetor) {
        return 1;
    }

    // Print the array before sorting
    printf("\nArray (before): [ ");
    for (int i = 0; i < (n < 10 ? n : 5); i++) {
        printf("%d ", vetor[i]);
    }
    if (n > 10) printf("... ");
    for (int i = (n > 10 ? n - 5 : 0); i < n; i++) {
        if (i >= 5) printf("%d ", vetor[i]);
    }
    printf("]\n");

    // Sort the array and measure time
    double start, end, execTime;

    GET_TIME(start);
    if (isSorted(vetor, n)) {
        printf("The array is already sorted.\n");
    } else {
        minMaxSort(vetor, n);
    }
    GET_TIME(end);

    execTime = end - start;
    printf("Execution time: %f seconds\n", execTime);

    // Save the sorted array to the binary file
    salvarVetorBinario(arquivoSaida, vetor, n);

    printf("Sorted array saved in: %s\n", arquivoSaida);

    // Free allocated memory
    free(vetor);

    return 0;
}
