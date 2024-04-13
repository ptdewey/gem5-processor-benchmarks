// INCLUDE HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DEFAULT_DIMENSION 64 //matrix size

// Function headers
void gemm(int** A, int** B, int** C, int dimension);
void printMatrix(int** matrix, int dimension);

int main (int argc, char *argv[])
{
	int dimension; 
	if (argc == 1)
	{
		dimension = DEFAULT_DIMENSION;
		#ifdef DEBUG
			printf("No matrix dimension specified. Using default dimension of \
				%d\n.", DIMENSION);
		#endif
	}
	else if (argc == 2)
	{
		dimension = atoi(argv[1]);
		#ifdef DEBUG
			printf("Creating a matrix of size %d x %d.\n", dimension);
		#endif
	}
	else
	{
		#ifdef DEBUG
			printf("Usage: ./gemm [Matrix dimension]\n");
		#endif
		exit(1);
	}

	// Allocate and populate matrices
  	int** A = (int**) malloc(dimension * sizeof(int*)); 
  	int** B = (int**) malloc(dimension * sizeof(int*));
	int** C = (int**) malloc(dimension * sizeof(int*));
	for (int i = 0; i < dimension; i++)
	{
		A[i] = (int*) malloc(dimension * sizeof(int));
		B[i] = (int*) malloc(dimension * sizeof(int));
		C[i] = (int*) malloc(dimension * sizeof(int));
	}

	srand(time(NULL));
	for (int i = 0; i < dimension; i++)
	{
		for (int j = 0; j < dimension; j++)
		{
			A[i][j] = i - j;
			B[i][j] = j - i;
			C[i][j] = 0;
		}
	}

	// Multiply matrices
	clock_t tic = clock();
	gemm(A, B, C, dimension);
	clock_t toc = clock();
	double elapsedTimeSeconds = (double) ((toc - tic) / CLOCKS_PER_SEC);
	printf("%d, %lf\n", dimension, elapsedTimeSeconds);

	// Free matrices
	for (int i = 0; i < dimension; i++)
	{
		free(A[i]);
		free(B[i]);
		free(C[i]);
	}
	free(A);
	free(B);
	free(C);
	
  	return (0);
}

void gemm(int** A , int** B, int** C, int dimension)
{
	for (int i = 0; i < dimension; i++)
	{
        for (int j = 0; j < dimension; j++) 
		{
            for (int k = 0; k < dimension; k++)
			{
				C[i][j] += A[i][k] * B[k][j];
			}
		}
    }
}

void printMatrix(int** matrix, int dimension)
{
	for (int i = 0; i < dimension; i++)
	{
		for (int j = 0; j < dimension; j++)
		{
			printf("%d ", matrix[i][j]);
		}
		printf("\n");
	}
}



