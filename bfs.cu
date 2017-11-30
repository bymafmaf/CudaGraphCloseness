#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>

#include "graphio.h"
#include "graph.h"

char gfile[2048];

using namespace::std;

void usage(){
  printf("./bfs <filename> <sourceIndex>\n");
  exit(0);
}
void random_ints(int* a, int N)
{
   int i;
   for (i = 0; i < N; ++i)
    a[i] = rand();
}
// CUDA STARTS

#define N (2048*2048)
#define M 512


__global__
void run(etype *row_ptr, vtype *col_ind, int nov);


/*
You can ignore the ewgths and vwghts. They are there as the read function expects those values
row_ptr and col_ind are the CRS entities. nov is the Number of Vertices
*/

int main(int argc, char *argv[]) {
  etype *row_ptr;
  vtype *col_ind;
  ewtype *ewghts;
  vwtype *vwghts;
  vtype nov;

  if(argc != 2)
  usage();

  const char* fname = argv[1];
  strcpy(gfile, fname);

  if(read_graph(gfile, &row_ptr, &col_ind, &ewghts, &vwghts, &nov, 0) == -1) {
    printf("error in graph read\n");
    exit(1);
  }
  /****** YOUR CODE GOES HERE *******/
  etype *d_row_ptr;
  vtype *d_col_ind;
  int size = nov * sizeof(int);

  cudaMalloc((void **)&d_row_ptr, size);
  cudaMalloc((void **)&d_col_ind, size);

  cudaMemcpy(d_row_ptr, row_ptr, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_col_ind, col_ind, size, cudaMemcpyHostToDevice);

  run<<<(N + M - 1)/M, M>>>(d_row_ptr, d_col_ind, nov);

  //cudaMemcpy(c, dc, size, cudaMemcpyDeviceToHost);

  // for (size_t i = 0; i < N; i++) {
  //   cout << c[i] << endl;
  // }
  cudaFree(d_row_ptr);
  cudaFree(d_col_ind);
  //cudaFree(dc);

  free(row_ptr);
  free(col_ind);

  return 1;
}
