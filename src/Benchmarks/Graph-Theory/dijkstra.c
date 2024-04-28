#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <time.h>

#define NUM_VERTICES 5000
#define MAX_WEIGHT 10
#define MIN_CONNECTIONS 3
#define INF INT_MAX

void dijkstra(int** graph, int startVertex);
int minDistance(int* dist, int* sptSet, int size);
void generateRandomGraph(int** graph, int startVertex);

int main(int argc, char* argv[]) {
    int startVertex;
    if (argc == 1) {
        startVertex = 0;
        #ifdef DEBUG
            printf("No starting vertex specified. Using default vertex %d.\n", startVertex);
        #endif
    } else if (argc == 2) {
        startVertex = atoi(argv[1]);
        #ifdef DEBUG
            printf("Starting from vertex %d.\n", startVertex);
        #endif
    } else {
        #ifdef DEBUG
            printf("Usage: ./dijkstra [Start vertex]\n");
        #endif
        exit(1);
    }

    int** graph = (int**) malloc(NUM_VERTICES * sizeof(int*));
    for (int i = 0; i < NUM_VERTICES; i++) {
        graph[i] = (int*) malloc(NUM_VERTICES * sizeof(int));
        if (graph[i] == NULL) {
            fprintf(stderr, "Memory allocation failed for graph[%d]\n", i);
            exit(EXIT_FAILURE);
        }
    }

    srand(42);
    generateRandomGraph(graph, startVertex);

    clock_t tic = clock();
    dijkstra(graph, startVertex);
    clock_t toc = clock();
    double elapsedTimeSeconds = (double)((toc - tic) / CLOCKS_PER_SEC);
    printf("Elapsed time: %lf seconds\n", elapsedTimeSeconds);

    for (int i = 0; i < NUM_VERTICES; i++) {
        free(graph[i]);
    }
    free(graph);

    return 0;
}

void generateRandomGraph(int** graph, int startVertex) {
    for (int i = 0; i < NUM_VERTICES; i++) {
        for (int j = 0; j < NUM_VERTICES; j++) {
            graph[i][j] = (i == j) ? 0 : INF;
        }
    }

    for (int i = 0; i < NUM_VERTICES; i++) {
        for (int j = 0; j < MIN_CONNECTIONS; j++) {
            int connectTo = rand() % NUM_VERTICES;
            if (connectTo != i && graph[i][connectTo] == INF) {
                int weight = rand() % MAX_WEIGHT + 1;
                graph[i][connectTo] = weight;
                graph[connectTo][i] = weight;
            } else {
                j--;
            }
        }
    }

    for (int j = 0; j < NUM_VERTICES/10; j++) {
        int connectTo = rand() % NUM_VERTICES;
        if (connectTo != startVertex && graph[startVertex][connectTo] == INF) {
            int weight = rand() % MAX_WEIGHT + 1;
            graph[startVertex][connectTo] = weight;
            graph[connectTo][startVertex] = weight;
        }
    }
}

void dijkstra(int** graph, int startVertex) {
    int* dist = (int*) malloc(NUM_VERTICES * sizeof(int));
    int* sptSet = (int*) malloc(NUM_VERTICES * sizeof(int));

    for (int i = 0; i < NUM_VERTICES; i++)
        dist[i] = INF, sptSet[i] = 0;

    dist[startVertex] = 0;

    for (int count = 0; count < NUM_VERTICES - 1; count++) {
        int u = minDistance(dist, sptSet, NUM_VERTICES);
        sptSet[u] = 1;

        for (int v = 0; v < NUM_VERTICES; v++) {
            if (!sptSet[v] && graph[u][v] != INF && dist[u] != INF && dist[u] + graph[u][v] < dist[v]) {
                dist[v] = dist[u] + graph[u][v];
            }
        }
    }

    // printf("Vertex \t\t Distance from Source\n");
    int max_dist = 0;
    for (int i = 0; i < NUM_VERTICES; i++) {
        // NOTE: uncommment to show distances
        // printf("%d \t\t %d\n", i, dist[i]);
        if (dist[i] > max_dist) {
            max_dist = dist[i];
        }
    }
    printf("Maximum distance: %d \t", max_dist);

    free(dist);
    free(sptSet);
}

int minDistance(int* dist, int* sptSet, int size) {
    int min = INF, min_index = -1;

    for (int v = 0; v < size; v++) {
        if (!sptSet[v] && dist[v] <= min) {
            min = dist[v], min_index = v;
        }
    }

    return min_index;
}
