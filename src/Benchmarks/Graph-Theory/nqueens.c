// INCLUDE HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define BOARD_SIZE 8

int count; // Number of solutions

// Function headers 
void solve(int n, int col, int *hist);

int main(int argc, char* argv[])
{
	int boardSize;
	if (argc == 1)
	{
		boardSize = BOARD_SIZE;
		#ifdef DEBUG
			printf("No size specified. Using default board size of %d x %d.\n", 
				BOARD_SIZE, BOARD_SIZE);
		#endif
	}
	else if (argc == 2)
	{
		boardSize = atoi(argv[1]);
		#ifdef DEBUG
			printf("Using board of size %d x %d.\n", boardSize, boardSize);
		#endif
	}
	else
	{
		#ifdef DEBUG
			printf("Usage: ./nqueens [Board size]");
		#endif
		exit(1);
	}

	// Solve n Queens
	int history[boardSize];
	clock_t tic = clock();
	solve(boardSize, 0, history);
	clock_t toc = clock();
	double elapsedTimeSeconds = (double) ((toc - tic) / CLOCKS_PER_SEC);
	printf("%d, %lf\n", boardSize, elapsedTimeSeconds);

	#ifdef DEBUG
		printf("Number of solutions: %d\n", count);
	#endif

	return 0;
}

void solve(int n, int col, int *hist)
{
	if (col == n) 
	{
		//printf("\nNo. %d\n-----\n", ++count);
		//for (int i = 0; i < n; i++, putchar('\n'))
		//	for (int j = 0; j < n; j++)
		//		putchar(j == hist[i] ? 'Q' : ((i + j) & 1) ? ' ' : '.');
                count++;
		return;
	}
 
	#define attack(i, j) (hist[j] == i || abs(hist[j] - i) == col - j)
	for (int i = 0, j = 0; i < n; i++) 
	{
		for (j = 0; j < col && !attack(i, j); j++);
			if (j < col) continue;
			hist[col] = i;
		solve(n, col + 1, hist);
	}
}
