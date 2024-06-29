#include "asan-options.cpp"

int *f() {
  int i = 42;
  int *p = &i;
  return p;
}
int g(int *p) {
  return *p;
}
int main() {
   auto x = g(f());
   ++x;
  return 0;
}