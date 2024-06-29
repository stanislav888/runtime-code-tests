int a[100];
int main(int argc, char **argv) {
  auto x = a[argc + 100];
  ++x;
  return 0;
}