#include <stdint.h>

void clear_words(void* mem, unsigned int nwords)
{ // Clear 32-bit words from memory. "nwords" indicates the number of words to be zeroed.
  // This function uses the volatile type qualifier to inform the compiler not to optimize out the memory clearing.
    volatile uint32_t *v = mem; 

    for (unsigned int i = 0; i < nwords; i++) {
        v[i] = 0;
    }
}

void clear_words_u16(unsigned int nwords, uint16_t *mem)
{ 
  clear_words((void*)mem, nwords/2);
}

void clear_words_u8(unsigned int nwords, uint8_t *mem)
{ 
  clear_words((void*)mem, nwords/4);
}

