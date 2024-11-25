#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>

int maxThreads;              // Global maximum number of threads
int currentThreads = 0;      // Global count of active threads
pthread_mutex_t threadMutex; // Mutex to manage thread count

// Macro to get time in seconds
#define GET_TIME(now) { \
    struct timeval t; \
    gettimeofday(&t, NULL); \
    now = t.tv_sec + t.tv_usec / 1e6; \
}

// Define a structure to store the parameters for each thread
typedef struct {
    int *A;  // Pointer to the array
    int lo;  // Low index
    int hi;  // High index
} QuicksortArgs;

// Function to swap two elements
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Partition function
int partition(int A[], int lo, int hi) {
    int mid = lo + (hi - lo) / 2;
    int pivot = A[mid];
    swap(&A[mid], &A[hi]); // Move pivot to the end

    int i = lo - 1;
    for (int j = lo; j < hi; j++) {
        if (A[j] < pivot) {
            i++;
            swap(&A[i], &A[j]);
        }
    }
    swap(&A[i + 1], &A[hi]); // Place pivot in correct position
    return i + 1;
}

// Threaded QuickSort function
void *quicksort_threaded(void *arg) {
    QuicksortArgs *args = (QuicksortArgs *)arg;
    int *A = args->A;
    int lo = args->lo;
    int hi = args->hi;

    if (lo < hi) {
        int p = partition(A, lo, hi);

        QuicksortArgs leftArgs = { A, lo, p - 1 };
        QuicksortArgs rightArgs = { A, p + 1, hi };

        pthread_t leftThread, rightThread;
        int leftThreadCreated = 0, rightThreadCreated = 0;

        // Lock mutex and check if a new thread can be created
        pthread_mutex_lock(&threadMutex);
        if (currentThreads < maxThreads) {
            currentThreads++;
            pthread_mutex_unlock(&threadMutex);

            pthread_create(&leftThread, NULL, quicksort_threaded, &leftArgs);
            leftThreadCreated = 1;
        } else {
            pthread_mutex_unlock(&threadMutex);
            quicksort_threaded(&leftArgs);
        }

        pthread_mutex_lock(&threadMutex);
        if (currentThreads < maxThreads) {
            currentThreads++;
            pthread_mutex_unlock(&threadMutex);

            pthread_create(&rightThread, NULL, quicksort_threaded, &rightArgs);
            rightThreadCreated = 1;
        } else {
            pthread_mutex_unlock(&threadMutex);
            quicksort_threaded(&rightArgs);
        }

        // Wait for threads to finish if they were created
        if (leftThreadCreated) {
            pthread_join(leftThread, NULL);
            pthread_mutex_lock(&threadMutex);
            currentThreads--;
            pthread_mutex_unlock(&threadMutex);
        }
        if (rightThreadCreated) {
            pthread_join(rightThread, NULL);
            pthread_mutex_lock(&threadMutex);
            currentThreads--;
            pthread_mutex_unlock(&threadMutex);
        }
    }

    return NULL;
}

// Function to measure the sorting time
double measureSortTime(int a[], int aLength) {
    double start, end;

    GET_TIME(start);

    QuicksortArgs args = { a, 0, aLength - 1 };
    quicksort_threaded(&args);

    GET_TIME(end);

    return end - start;
}

// Main function
int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <input_file> <output_file> <num_threads>\n", argv[0]);
        return 1;
    }

    maxThreads = atoi(argv[3]);
    if (maxThreads <= 0) {
        fprintf(stderr, "Number of threads must be positive.\n");
        return 1;
    }

    pthread_mutex_init(&threadMutex, NULL);

    // Open the input binary file
    FILE *inputFile = fopen(argv[1], "rb");
    if (!inputFile) {
        perror("Error opening input file");
        return 1;
    }

    // Read the size of the array
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

    // Measure the sorting time
    double timeTaken = measureSortTime(a, aLength);
    printf("Sorting time: %f seconds\n", timeTaken);

    // Open the output binary file
    FILE *outputFile = fopen(argv[2], "wb");
    if (!outputFile) {
        perror("Error opening output file");
        free(a);
        return 1;
    }

    // Write the sorted array to the output file
    fwrite(&aLength, sizeof(int), 1, outputFile);
    fwrite(a, sizeof(int), aLength, outputFile);
    fclose(outputFile);

    // Free allocated memory and destroy mutex
    free(a);
    pthread_mutex_destroy(&threadMutex);

    return 0;
}
