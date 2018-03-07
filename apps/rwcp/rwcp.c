#include <am.h>
#include <klib.h>

volatile int *cpbase = (int *)0x900;

void print_cp_statistics() {
  int proc_dsid_bits = 3;
  int ncol = 9;

  // waymask，access，miss，usage, sizes，freqs，incs，read，write
  printf("control plane statistics: ");
  for (int i = 0; i < ncol; i++)
    printf("%x ", cpbase[i * (1 << proc_dsid_bits)]);
  printf("\n");
}

int main() {
  print_cp_statistics();
  return 0;
}
