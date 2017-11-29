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

// CUDA STARTS

const int N = 7;
const int blocksize = 7;

__global__
void add(int *da, int *db, int *dc);


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
  int a, b, c;
  int *da, *db, *dc;
  int size = sizeof(int);

  cudaMalloc((void **)&da, size);
  cudaMalloc((void **)&db, size);
  cudaMalloc((void **)&dc, size);

  a = 5;
  b = 10;
  cudaMemcpy(da, &a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(db, &b, size, cudaMemcpyHostToDevice);

  add<<<1,1>>>(da, db, dc);

  cudaMemcpy(&c, dc, size, cudaMemcpyDeviceToHost);

  printf("%d\n", c);
  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  free(row_ptr);
  free(col_ind);

  return 1;
}
