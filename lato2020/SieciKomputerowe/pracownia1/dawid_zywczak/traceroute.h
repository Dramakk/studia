//Dawid Żywczak, 310111
#ifndef traceroute_h
#define traceroute_h

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include <stdbool.h>
#include <time.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

#include <netinet/ip_icmp.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <assert.h>

int traceroute(int sockfd, struct sockaddr_in *dest);

int send_packets(int sockfd, int ttl, int pid, struct sockaddr_in dest, int magic_number);
int send_packet(int sockfd, int ttl, int pid, struct sockaddr_in dest, int magic_number);

int recv_single(int sockfd, int id, struct in_addr *addr, int magick_number);
int get_responses(int sockfd, int id, int *no_reply, int *responsetime, struct in_addr *ip_reply, int magick_number, struct timespec *before);

u_int16_t compute_icmp_checksum(const void *buff, int length);
void print_ips(int ttl, int *no_reply, int *responsetime, struct in_addr *ip_reply);
#endif
