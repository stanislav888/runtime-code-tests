#include <stdlib.h>

int main() {
  char *p = static_cast<char*>(malloc(16));
  p[24] = 1; // выход за пределы буфера, в p всего 16 байт
  free(p);
  return 0;
}