/* Imię nazwisko: Dawid Żywczak
 * Numer indeksu: 310111
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Zdefiniuj proces "sierotę".
 * A: Proces "sierota" to taki, którego rodzic zakończył działanie, a sam proces jeszcze działa
 *
 * Q: Co się stanie, jeśli główny proces nie podejmie się roli żniwiarza?
 * A: Gdy nie ma innych żniwiarzy w "przodkach" procesu "sieroty", to zostaje on zakończony
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>

int main(void) {
  prctl(PR_SET_CHILD_SUBREAPER, 1);
  int pid = fork();
  int response;
  if (pid > 0){
        printf("Id procesu głównego: ");
        printf("%d\n", getpid());
	printf("ID syna: %d\n", pid);
        while( wait(&response) > 0); //czekamy na wszystkie procesy zanim zakończymy główny
    }
    else if (pid == 0) //syn
    {
        pid = fork();
        if (pid > 0){
	    wait(&response);
        }
        else if (pid == 0){ //wnuk
	  printf("ID wnuka: %d\n", getpid());
          kill(getppid(), SIGKILL); //zabijamy czekającego syna
          char *cmd[5] = { "ps", "-p", 0, "-l", NULL};
          char str[12];
          sprintf(str, "%d", getpid());
          cmd[2] = str;
          pid = fork();
          if(pid == 0){
              execv("/bin/ps", cmd);
          }
          else{
              waitpid(pid, &response, 0);
          }
        }
    }
    return EXIT_SUCCESS;
}
