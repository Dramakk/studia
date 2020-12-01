//Dawid Żywczak, 310111
#include "traceroute.h"

int get_responses(int sockfd, int id, int *no_reply, int *responsetime, struct in_addr *ip_reply, int magick_number, struct timespec *before){
	int recv;
	int total_response_time=0;	
	struct timespec after;
	int resp = 0;
	fd_set descriptors;
	FD_ZERO(&descriptors);
	FD_SET(sockfd, &descriptors);
	int ready = 1;
	struct timeval tv; tv.tv_sec = 1; tv.tv_usec = 0;
	while(ready > 0 && *no_reply < 3){
		ready = select(sockfd+1, &descriptors, NULL, NULL, &tv);
		if(ready < 0)
			return ready;		
		if(ready > 0){
			for(int i = 0; i<ready; i++){
				recv=recv_single(sockfd, id, ip_reply+*no_reply, magick_number);
				if(recv<0) return -1;
				if(recv!=2) {
					(*no_reply)++;	
					total_response_time+=resp;			
				}		
				clock_gettime(CLOCK_MONOTONIC, &after); //we recieved packet here
				resp = (after.tv_sec - before->tv_sec)*1000 + (after.tv_nsec - before->tv_nsec)/1000000;
			}
		}	
	}
	if(*no_reply<3) *responsetime = -1;	 
	else *responsetime=total_response_time/3;
	
	if(recv==1) return 1;

	return 0;
}


int recv_single(int sockfd, int id, struct in_addr *addr, int magick_number){
	u_int8_t buffer[IP_MAXPACKET];
	struct sockaddr_in sender;
	socklen_t sender_len = sizeof(sender);
	if(recvfrom(sockfd, buffer, IP_MAXPACKET, MSG_DONTWAIT, (struct sockaddr*) &sender, &sender_len)<0){ //We don't have to check for blocking errors because we are using select
		fprintf(stderr, "Recieving error: %s\n", strerror(errno));
		return -1;
	}

	struct ip *ip_header = (struct ip *)buffer;
	struct icmp *icmp_header = (struct icmp *)((uint8_t *)ip_header + (*ip_header).ip_hl * 4);;

	if(icmp_header->icmp_type == ICMP_TIME_EXCEEDED){
		struct ip *ip_recv = (struct ip *)((uint8_t *)icmp_header + 8);
		struct icmp *icmp_recv = (struct icmp *)((uint8_t *)ip_recv + (*ip_recv).ip_hl * 4);
		if((icmp_recv->icmp_seq==magick_number || icmp_recv->icmp_seq==magick_number+1 || icmp_recv->icmp_seq==magick_number+2) && icmp_recv->icmp_id==id){
			*addr=ip_header->ip_src;
			return 0;
		}
	}
	else if(icmp_header->icmp_type == ICMP_ECHOREPLY && (icmp_header->icmp_seq==magick_number || icmp_header->icmp_seq==magick_number+1 || icmp_header->icmp_seq==magick_number+2) && icmp_header->icmp_id==id){
		*addr=ip_header->ip_src;
		return 1;
	}

	return 2;
}
