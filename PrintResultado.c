#include <stdio.h>
#include <stdlib.h>

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

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <binary file>\n", argv[0]);
        return 1;
    }

    const char *nomeArquivo = argv[1];
    int n;
    int *vetor = lerVetorBinario(nomeArquivo, &n);
    
    if (vetor == NULL) {
        return 1;
    }

    // Print the array
    printf("Array length: %d\n", n);
    printf("Array elements: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", vetor[i]);
    }
    printf("\n");

    // Free the allocated memory
    free(vetor);

    return 0;
}
