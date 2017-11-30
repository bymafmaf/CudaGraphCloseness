#include <stdio.h>
#include "graph.h"
__global__
void run(etype *row_ptr, vtype *col_ind, int nov) {
  int index = threadIdx.x + blockIdx.x * blockDim.x;
}
