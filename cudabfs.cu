#include <stdio.h>
#include "graph.h"
#include <queue>

//etype unsigned int

__device__
void recur(etype vertice, etype level, etype *visited, etype *row_ptr, vtype *col_ind, etype *results, int nov){
  if (vertice == nov-1) {
    return;
  }
  for (size_t i = row_ptr[vertice]; i < row_ptr[vertice+1]; i++) {
    etype n_ind = col_ind[i];
    if (visited[n_ind] == 0) {
      visited[n_ind] = level;
    }
  }
  for (size_t i = row_ptr[vertice]; i < row_ptr[vertice+1]; i++) {
    etype n_ind = col_ind[i];
    if (visited[n_ind] == level) {
      recur(n_ind, level+1, visited, row_ptr, col_ind, results, nov);
    }
  }
}

__global__
void run(etype *row_ptr, vtype *col_ind, etype *results, int nov) {
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  if (index < nov) {
    etype *visited = new etype[nov];
    for (size_t i = 0; i < nov; i++) {
      visited[i] = 0;
    }

    recur(index, 1, visited, row_ptr, col_ind, results, nov);

    etype distanceSum = 0;
    for (size_t i = 0; i < nov; i++) {
      distanceSum += visited[i];
    }
    results[index] = distanceSum;
    //printf("vertice %d has closeness of %d\n", index, distanceSum);
  }
}
