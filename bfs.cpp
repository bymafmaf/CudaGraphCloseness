#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
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

void call_me_maybe(char* ad, int* bd, const int csize, const int isize, char* a, int* b, int blocksize);


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
  char a[N] = "Hello ";
  int b[N] = {15, 10, 6, 0, -11, 1, 0};

  char *ad;
  int *bd;
  const int csize = N*sizeof(char);
  const int isize = N*sizeof(int);

  printf("%s", a);
  call_me_maybe(ad, bd, csize, isize, a, b, blocksize);

  printf("%s\n", a);
  
  free(row_ptr);
  free(col_ind);

  return 1;
}
