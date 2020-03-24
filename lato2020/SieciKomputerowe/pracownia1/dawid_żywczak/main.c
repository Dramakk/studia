#include "traceroute.h"

//Dawid Żywczak, 310111

int main(int argc, char *argv[]){
	if(argc!=2){
		printf("Nieprawidłowe argumenty, podaj adres IP\n");
		return 0;
	}

	int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);

	if(sockfd < 0){
		fprintf(stderr, "Error creating socket: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}

	struct sockaddr_in addr;
	bzero (&addr, sizeof(addr));
	addr.sin_family = AF_INET;
	if(inet_pton(AF_INET, argv[1], &addr.sin_addr)==0){
		printf("Zły adres IP.\n");
		return EXIT_FAILURE;
	}

	if(traceroute(sockfd, &addr) < 0) return EXIT_FAILURE;

	return 0;
}

