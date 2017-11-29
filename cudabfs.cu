#include <stdio.h>

__global__
void add(int *da, int *db, int *dc) {

  *dc = *da + *db;

}
