//Dawid Żywczak, 310111
#include "traceroute.h"

int traceroute(int sockfd, struct sockaddr_in *dest){
	time_t tt;
	int seed = time(&tt);
	int pid = getpid();
	srand(seed);
	for(int i = 1; i<=30; i++){
    		int magick_number = (int)(rand() / (RAND_MAX + 1.0) * 50000);
		struct in_addr ip_reply[3]; //Adresses which responded
		int responsetime = 0;
		int no_reply = 0; //number of replies
		struct timespec before;
		clock_gettime(CLOCK_MONOTONIC, &before); //we start measuring time here
		if(send_packets(sockfd, i, pid, *dest, magick_number) < 0) return -1;
		int end = get_responses(sockfd, pid, &no_reply, &responsetime, ip_reply, magick_number, &before);
		if(end < 0) return -1;
		print_ips(i, &no_reply, &responsetime, ip_reply);
		if(end) return 0;
	}
	return 0;
}

void print_ips(int ttl, int *no_reply, int *responsetime, struct in_addr *ip_reply){
	printf("%d.\t", ttl);
	char ip_1[30], ip_2[30], ip_3[30];
	inet_ntop(AF_INET, &(ip_reply[0]), ip_1, sizeof(ip_1));
	inet_ntop(AF_INET, &(ip_reply[1]), ip_2, sizeof(ip_2));
	inet_ntop(AF_INET, &(ip_reply[2]), ip_3, sizeof(ip_3));

	if(*no_reply == 0) printf("*");
	else{
		printf("%s", ip_1);
		if(strcmp(ip_1,ip_2)!=0 && *no_reply>1){
			printf(" %s", ip_2);
		}
		if(strcmp(ip_1,ip_3)!=0 && strcmp(ip_2,ip_3)!=0 && *no_reply>2) {
			printf(" %s", ip_3);
		}

		if(*responsetime < 0) printf("\t???");
		else printf("\t%dms", *responsetime);
	}
	printf("\n");
}
