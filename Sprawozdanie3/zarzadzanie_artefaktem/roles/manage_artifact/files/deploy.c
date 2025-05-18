#include <stdio.h>
#include <lzma.h>

int main() {
    lzma_stream strm = LZMA_STREAM_INIT;
    lzma_end(&strm);
    printf("liblzma test OK\n");
    return 0;
}
