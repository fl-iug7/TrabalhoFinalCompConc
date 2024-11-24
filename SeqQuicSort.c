#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>

// Function to swap two elements
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int partition(int A[], int lo, int hi) {
    // Choose the pivot as the middle element (or the element closest to the middle if the size is even)
    int mid = lo + (hi - lo) / 2;
    int pivot = A[mid];

    // Move pivot to the end for simplicity in partitioning
    swap(&A[mid], &A[hi]);
    
    int i = lo - 1;    // Left index
    int j = hi;        // Right index

    while (1) {
        // Move the left index to the right
        do {
            i++;
        } while (A[i] < pivot);

        // Move the right index to the left
        do {
            j--;
        } while (A[j] > pivot && j > lo);

        // If the indices crossed, return
        if (i >= j) {
            swap(&A[i], &A[hi]); // Move pivot to its correct position
            return j;
        }

        // Swap the elements at the left and right indices
        swap(&A[i], &A[j]);
    }
}

void quicksort(int A[], int lo, int hi) {
    if (lo < hi) { // Ensure that lo is less than hi
        int p = partition(A, lo, hi);
        quicksort(A, lo, p);      // Sort the left part
        quicksort(A, p + 1, hi);  // Sort the right part
    }
}

double measureSortTime(int a[], int aLength) {
    clock_t start = clock();
    quicksort(a, 0, aLength - 1); // Correct function call
    clock_t end = clock();
    return (double)(end - start) / CLOCKS_PER_SEC; // Return time in seconds
}

#ifdef VALIDATE_SORT
bool isSorted(int A[], int aLength) {
    for (int i = 1; i < aLength; i++) {
        if (A[i] < A[i - 1]) {
            return false; // Found an out-of-order element
        }
    }
    return true; // Array is sorted
}
#endif

// Main function to read from a binary file, sort the array, and write to a new binary file
int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    // Open the input binary file
    FILE *inputFile = fopen(argv[1], "rb");
    if (!inputFile) {
        perror("Error opening input file");
        return 1;
    }

    // Read the array size
    int aLength;
    fread(&aLength, sizeof(int), 1, inputFile);

    // Allocate memory for the array
    int *a = malloc(aLength * sizeof(int));
    if (!a) {
        perror("Memory allocation failed");
        fclose(inputFile);
        return 1;
    }

    // Read the array from the file
    fread(a, sizeof(int), aLength, inputFile);
    fclose(inputFile);

    // Measure the sort time
    double timeTaken = measureSortTime(a, aLength);
    printf("Time taken to sort: %f seconds\n", timeTaken); // Print sort time

    // Validation step
    #ifdef VALIDATE_SORT
    if (isSorted(a, aLength)) {
        printf("The array is sorted correctly.\n");
    } else {
        printf("The array is not sorted correctly.\n");
    }
    #endif

    // Open the output binary file
    FILE *outputFile = fopen(argv[2], "wb");
    if (!outputFile) {
        perror("Error opening output file");
        free(a);
        return 1;
    }

    // Write the sorted array to the output file
    fwrite(&aLength, sizeof(int), 1, outputFile); // Write the array size
    fwrite(a, sizeof(int), aLength, outputFile); // Write the sorted array
    fclose(outputFile);

    // Free allocated memory
    free(a);

    return 0;
}