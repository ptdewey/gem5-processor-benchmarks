// INCLUDE HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DEFAULT_LENGTH 100

// FUNCTION HEADERS
void mergeSort(int* array, int low, int high);
void merge(int* array, int low, int mid, int high);
void printArray(int array[], int length);

int main(int argc, char **argv) {
	int length;
	if (argc == 1)
	{
		length = DEFAULT_LENGTH;
		#ifdef DEBUG
			printf("No array length specified. Using default length of %d\n.", 
				DEFAULT_LENGTH);
		#endif
	}
	else if (argc == 2)
	{
		length = atoi(argv[1]);
		#ifdef DEBUG
			printf("Creating array of length %d.\n", length);
		#endif
	}
	else
	{
		#ifdef DEBUG
			printf("Usage: ./quicksort [Array Length]\n");
		#endif
		exit(1);
	}

	// Populate array
	int* array = (int*) malloc(length * sizeof(int));
	srand(time(NULL));
	for (int i = 0; i < length; i++)
	{
		array[i] = rand();
	}

	// Sort array
	#ifdef DEBUG
		printf("Unsorted array:\n");
		printArray(array, length);
	#endif

	clock_t tic = clock();
    mergeSort(array, 0, length - 1);
	clock_t toc = clock();
	double elapsedTimeSeconds = (double) ((toc - tic) / CLOCKS_PER_SEC);
	printf("%d, %g\n", length, elapsedTimeSeconds);

	#ifdef DEBUG
		printf("Sorted array:\n");
		printArray(array, length);
	#endif

    free(array);
	array = NULL;

    return 0;
}

void mergeSort(int* array, int low, int high) 
{
    if (low < high) 
	{
        int mid = low + (high - low) / 2;
        mergeSort(array, low, mid);
        mergeSort(array, mid + 1, high);
        merge(array, low, mid, high);
    }
}

void merge(int* array, int low, int mid, int high) {
    int leftLength = mid - low + 1;
    int rightLength = high - mid;

    int* leftArray = (int*) malloc(leftLength * sizeof(int));
    int* rightArray = (int*) malloc(rightLength * sizeof(int));

    for (int i = 0; i < leftLength; i++) 
	{
        leftArray[i] = array[low + i];
    }
    for (int j = 0; j < rightLength; j++) 
	{
        rightArray[j] = array[mid + 1 + j];
    }

    int i = 0, j = 0, k = low;

    while (i < leftLength && j < rightLength) 
	{
        if (leftArray[i] <= rightArray[j]) 
		{
            array[k] = leftArray[i];
            i++;
        } else 
		{
            array[k] = rightArray[j];
            j++;
        }
        k++;
    }

    while (i < leftLength) 
	{
        array[k] = leftArray[i];
        i++;
        k++;
    }

    while (j < rightLength) {
        array[k] = rightArray[j];
        j++;
        k++;
    }

    free(leftArray);
    free(rightArray);
}

void printArray(int array[], int length) 
{
    for (int i = 0; i < length; i++) 
	{
        printf("%d ", array[i]);
    }
    printf("\n");
}
