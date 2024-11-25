#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>

typedef struct {
    int *arr;
    int start;
    int end;
} ThreadData;

// Macro to get time in seconds
#define GET_TIME(now) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    now = t.tv_sec + t.tv_usec / 1e6; \
}

// Swap function
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Function to perform Min-Max Sort on a segment of the array
void* minMaxSort(void *arg) {
    ThreadData *data = (ThreadData*)arg;
    int *arr = data->arr;
    int start = data->start;
    int end = data->end;

    while (start < end) {
        int minPos = start, maxPos = end;

        for (int i = start; i <= end; i++) {
            if (arr[i] < arr[minPos]) {
                minPos = i;
            }
            if (arr[i] > arr[maxPos]) {
                maxPos = i;
            }
        }

        // Swap the smallest element with the start
        if (minPos != start) {
            swap(&arr[start], &arr[minPos]);
            if (maxPos == start) {
                maxPos = minPos;
            }
        }

        // Swap the largest element with the end
        if (maxPos != end) {
            swap(&arr[end], &arr[maxPos]);
        }

        start++;
        end--;
    }
    return NULL;
}

// Merge sorted segments into a single sorted array
void mergeSortedSegments(int *arr, int n, int numThreads, int segmentSize) {
    int *temp = (int*)malloc(n * sizeof(int));
    if (!temp) {
        printf("Error: Memory allocation failed for merging.\n");
        return;
    }

    int *indices = (int*)malloc(numThreads * sizeof(int));
    if (!indices) {
        printf("Error: Memory allocation failed for indices.\n");
        free(temp);
        return;
    }

    // Initialize indices for each segment
    for (int i = 0; i < numThreads; i++) {
        indices[i] = i * segmentSize;
    }

    for (int k = 0; k < n; k++) {
        int minIdx = -1;

        // Find the smallest element among the segments
        for (int i = 0; i < numThreads; i++) {
            if (indices[i] < (i == numThreads - 1 ? n : (i + 1) * segmentSize)) {
                if (minIdx == -1 || arr[indices[i]] < arr[indices[minIdx]]) {
                    minIdx = i;
                }
            }
        }

        temp[k] = arr[indices[minIdx]];
        indices[minIdx]++;
    }

    // Copy merged data back to original array
    for (int i = 0; i < n; i++) {
        arr[i] = temp[i];
    }

    free(temp);
    free(indices);
}

// Function to read array from binary file
int* readBinaryFile(const char *filename, int *n) {
    FILE *file = fopen(filename, "rb");
    if (!file) {
        printf("Error: Unable to open input file.\n");
        return NULL;
    }

    if (fread(n, sizeof(int), 1, file) != 1) {
        printf("Error: Failed to read array length.\n");
        fclose(file);
        return NULL;
    }

    int *arr = (int*)malloc(*n * sizeof(int));
    if (!arr) {
        printf("Error: Memory allocation failed.\n");
        fclose(file);
        return NULL;
    }

    if (fread(arr, sizeof(int), *n, file) != *n) {
        printf("Error: Failed to read array elements.\n");
        free(arr);
        fclose(file);
        return NULL;
    }

    fclose(file);
    return arr;
}

// Function to write array to binary file
void writeBinaryFile(const char *filename, int *arr, int n) {
    FILE *file = fopen(filename, "wb");
    if (!file) {
        printf("Error: Unable to open output file.\n");
        return;
    }

    fwrite(&n, sizeof(int), 1, file);
    fwrite(arr, sizeof(int), n, file);

    fclose(file);
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <input_file> <output_file> <num_threads>\n", argv[0]);
        return 1;
    }

    const char *inputFile = argv[1];
    const char *outputFile = argv[2];
    int numThreads = atoi(argv[3]);
    if (numThreads <= 0) {
        printf("Error: Number of threads must be positive.\n");
        return 1;
    }

    int n;
    int *arr = readBinaryFile(inputFile, &n);
    if (!arr) {
        return 1;
    }

    printf("Array length: %d\n", n);

    pthread_t threads[numThreads];
    ThreadData threadData[numThreads];

    int segmentSize = n / numThreads;
    int remaining = n % numThreads;

    double start, end;
    GET_TIME(start);

    // Divide work among threads
    for (int i = 0; i < numThreads; i++) {
        threadData[i].arr = arr;
        threadData[i].start = i * segmentSize;
        threadData[i].end = (i + 1) * segmentSize - 1;

        // Assign remaining elements to the last thread
        if (i == numThreads - 1) {
            threadData[i].end += remaining;
        }

        pthread_create(&threads[i], NULL, minMaxSort, &threadData[i]);
    }

    // Wait for threads to finish
    for (int i = 0; i < numThreads; i++) {
        pthread_join(threads[i], NULL);
    }

    // Merge sorted segments
    mergeSortedSegments(arr, n, numThreads, segmentSize);

    GET_TIME(end);
    double processingTime = end - start;

    printf("Processing time: %f seconds\n", processingTime);

    // Save sorted array to binary file
    writeBinaryFile(outputFile, arr, n);

    printf("Sorted array saved to %s\n", outputFile);

    free(arr);
    return 0;
}
