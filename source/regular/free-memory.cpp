#include <cstdlib>
#include <cstdio>

int main(void) {
    int *a = static_cast<int*>(calloc(100, sizeof(int)));
    free(a);
    printf("%d\n", a[5]);

    return 0;
}
