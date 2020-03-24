#include "traceroute.h"

//Dawid Żywczak, 310111

int traceroute(int sockfd, struct sockaddr_in *addr){
	int pid = getpid();
	for(int i = 1; i<=30; i++){
		struct in_addr treply[3]; //Adresses which responded
		int responsetime = 0;
		int no_reply = 0; //number of replies
		if(send_sockets(sockfd, i, pid, *addr) < 0) return -1;
		int end = recall(sockfd, i, pid, &no_reply, &responsetime, treply);
		if(end < 0) return -1;
		print_ips(i, &no_reply, &responsetime, treply);
		if(end) return 0;
	}
	return 0;
}

void print_ips(int ttl, int *no_reply, int *responsetime, struct in_addr *treply){
	printf("%d.\t", ttl);
	char ip_1[30], ip_2[30], ip_3[30];
	inet_ntop(AF_INET, &(treply[0]), ip_1, sizeof(ip_1));
	inet_ntop(AF_INET, &(treply[1]), ip_2, sizeof(ip_2));
	inet_ntop(AF_INET, &(treply[2]), ip_3, sizeof(ip_3));

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
