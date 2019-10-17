/* Imię nazwisko: Dawid Żywczak
 * Numer indeksu: 310111
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Czemu procedura printf nie jest wielobieżna, a snprintf jest?
 * A: Ponieważ printf używa statycznego bufora, który może zostać zmodyfikowany
      w trakcie wykonania przez inne wywołanie printf.
      sprintf jest wielobieżny o ile nie przekazujemy mu jako parametru statycznego bufora.
*/

#define _GNU_SOURCE
#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ucontext.h>
#include <unistd.h>
#include <sys/mman.h>
#include <assert.h>

void handler(int sig, siginfo_t *info, void *ucontext)
{
  char buf[100];
  snprintf(buf, 100, "%s\n", strerror(sig));
  if(!write(STDERR_FILENO, buf, strlen(buf)))
    exit(EXIT_FAILURE);
  ucontext_t *context = (ucontext_t *)ucontext;
  snprintf(buf, 100, "Adres powodujacy blad: %p\n", info->si_addr);
  if(!write(STDERR_FILENO, buf, strlen(buf)))
    exit(EXIT_FAILURE);
  int code = info->si_code;
  switch (code)
  {
  case SEGV_MAPERR:
    snprintf(buf, 100, "Rodzaj bledu: MAPERR(Address not mapped to object.)\n");
    break;
  case SEGV_ACCERR:
    snprintf(buf, 100, "Rodzaj bledu: ACCERR(Invalid permissions for mapped object)\n");
    break;
  }
  if(!write(STDERR_FILENO, buf, strlen(buf)))
    exit(EXIT_FAILURE);
  snprintf(buf, 100, "Adres wierzcholka stosu: %p\n", (void *)context->uc_mcontext.gregs[REG_RSP]);
  if(!write(STDERR_FILENO, buf, strlen(buf)))
    exit(EXIT_FAILURE);
  snprintf(buf, 100, "Adres instrukcji powodujacej blad: %p\n", (void *)context->uc_mcontext.gregs[REG_RIP]);
  if(!write(STDERR_FILENO, buf, strlen(buf)))
    exit(EXIT_FAILURE);
  void *buf2[100];
  size_t size_of_buf2;
  size_of_buf2 = backtrace (buf2, 100);
  backtrace_symbols_fd(buf2, size_of_buf2, STDERR_FILENO);
  exit(EXIT_FAILURE);
}
int main(int argc, char *argv[]) {
  int *mem; //tutaj będziemy trzymać adres zmapowanej pamięci
  size_t size = 32;
  struct sigaction signalHandler;
  signalHandler.sa_handler = (__sighandler_t) handler;
  signalHandler.sa_flags = SA_SIGINFO;
  sigemptyset(&signalHandler.sa_mask);
  sigaction(SIGSEGV, &signalHandler, 0);
  if(argc == 2 && strcmp(argv[1], "--maperr") == 0){
    mem = (int*)mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    assert(mem != MAP_FAILED);
    int status = munmap(mem, size);
    assert(status != -1);
    int x = *mem;
    printf("%d", x); //nie wykona się, ale potrzebne żeby gcc nie zoptymalizował braku użycia zmiennej x
  }
  if(argc == 2 && strcmp(argv[1], "--accerr") == 0){
    mem = (int*)mmap(NULL, size, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    assert(mem != MAP_FAILED);
    *mem = 1;
  }
  return EXIT_SUCCESS; //program kończy się poprawnie bo nie dostaliśmy informacji co zepsuć
}
