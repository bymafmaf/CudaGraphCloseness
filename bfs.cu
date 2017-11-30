#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>

#include "graphio.h"
#include "graph.h"

const int N = 512;

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



__global__
void run(etype *row_ptr, vtype *col_ind, etype *results, int nov);


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
  if (nov > N) {
    nov = N;
  }
  etype *d_row_ptr;
  vtype *d_col_ind;

  etype *d_results;
  int row_size = nov * sizeof(etype);
  int col_size = row_ptr[nov-1] * sizeof(vtype);

  cudaMalloc((void **)&d_row_ptr, row_size);
  cudaMalloc((void **)&d_col_ind, col_size);
  cudaMalloc((void **)&d_results, row_size);

  cudaMemcpy(d_row_ptr, row_ptr, row_size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_col_ind, col_ind, col_size, cudaMemcpyHostToDevice);

  printf("%s %d\n", "nov is", nov);
  run<<<(nov + 511)/512, 512>>>(d_row_ptr, d_col_ind, d_results, nov);

  etype *results = (etype *) malloc(row_size);
  cudaMemcpy(results, d_results, row_size, cudaMemcpyDeviceToHost);


  unsigned int max = 0;
  int maxIndex = -1;

  unsigned int totalNonZero = 0;
  for (unsigned int i = 0; i < nov; i++) {
    if (results[i] == 0) {
      continue;
    }
    totalNonZero++;
    if(results[i] >= max){
      max = results[i];
      maxIndex = i;
    }
  }
  cout << "total non zeroes " << totalNonZero << endl;
  printf("%s %d %s%d\n", "Min closeness belongs to", maxIndex, "with score of 1/", max);

  cudaFree(d_row_ptr);
  cudaFree(d_col_ind);
  //cudaFree(dc);

  free(row_ptr);
  free(col_ind);

  return 1;
}
