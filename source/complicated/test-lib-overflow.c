#include <stdlib.h>

void library(char *s);
int main(void) {
  char *s = malloc(1);
  library(s);
  free(s);

  return 0;
}