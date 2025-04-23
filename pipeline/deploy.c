#include <stdio.h>
#include <lzma.h>

int main() {
    printf("XZ lib version: %s\n", lzma_version_string());
    return 0;
}
