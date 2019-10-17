/* Imię nazwisko: Dawid Żywczak
 * Numer indeksu: 310111
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Zdefiniuj proces "zombie".
 * A: Proces "zombie" to proces, który zakończył swoje wykonywanie, ale
    jego zamknięcie nie zostało obłużone przez proces rodzica tzn. nie zostały odczytany exit status
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    struct sigaction signalIgnore;
    signalIgnore.sa_handler = SIG_IGN;
    sigemptyset(&signalIgnore.sa_mask);
    signalIgnore.sa_flags = 0;
    int response;
    if(argc == 2 && strcmp(argv[1], "--burry") == 0){
        sigaction(SIGCHLD, &signalIgnore, 0); //ignorujemy sygnał SIGCHLD
    }
    int pid = fork();
    if(pid == 0){
        exit(EXIT_SUCCESS);
    }
    else if(pid > 0){
        char *cmd[5] = { "ps", "-p", 0, "-v", NULL};
        char str[20];
        sprintf(str, "%d", pid);
        cmd[2] = str;
        pid = fork();
        if(pid == 0){
            execv("/bin/ps", cmd);
        }
        else{
            waitpid(pid, &response, 0);
        }
    }
    return EXIT_SUCCESS;
}
