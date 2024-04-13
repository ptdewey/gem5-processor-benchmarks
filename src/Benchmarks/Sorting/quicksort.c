// INCLUDE HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DEFAULT_LENGTH 100

// FUNCTION HEADERS
void quicksort(int *array, int low, int high);
int partition(int array[], int low, int high);
void swap(int* a, int* b);
void printArray(int array[], int length);

int main(int argc, char* argv[]) {
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
    quicksort(array, 0, length - 1);
	clock_t toc = clock();
	double elapsedTimeSeconds = (double) ((toc - tic) / CLOCKS_PER_SEC);
	printf("%d, %g\n", length, tic);

	#ifdef DEBUG
		printf("Sorted array:\n");
		printArray(array, length);
	#endif

	free(array);
	array = NULL;

    return 0;
}

void quicksort(int *array, int low, int high) 
{
    if (low < high) 
	{
        int pi = partition(array, low, high);
        quicksort(array, low, pi - 1);
        quicksort(array, pi + 1, high);
    }
}

int partition(int *array, int low, int high) 
{
    int pivot = array[high];
    int i = (low - 1);

    for (int j = low; j <= high - 1; j++) 
	{
        if (array[j] < pivot) 
		{
            i++;
            swap(&array[i], &array[j]);
        }
    }
    swap(&array[i + 1], &array[high]);
    return (i + 1);
}

void swap(int* a, int* b) 
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

void printArray(int array[], int length)
{
    for (int i = 0; i < length; i++) 
	{
        printf("%d ", array[i]);
    }
    printf("\n");
}
