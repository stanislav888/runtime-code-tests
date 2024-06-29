#include <stdlib.h>

int main() {
  void *p = malloc(10);
  int x = p == nullptr;
  ++x;
  return 0;
}