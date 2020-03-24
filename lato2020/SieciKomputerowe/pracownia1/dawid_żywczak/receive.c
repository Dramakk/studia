#include "traceroute.h"

//Dawid Żywczak, 310111

int recall(int sockfd, int ttl, int id, int *ireply, int *responsetime, struct in_addr *treply){
	int rec;
	int total_response_time=0;	
	struct timespec t,st;
	clock_gettime(CLOCK_MONOTONIC, &t);
	int resp = 0;
	fd_set descriptors;
	FD_ZERO (&descriptors);
	FD_SET (sockfd, &descriptors);
	int ready;
	struct timeval tv; tv.tv_sec = 1; tv.tv_usec = 0;
	while((tv.tv_sec != 0 || tv.tv_usec != 0) && *ireply < 3){
		ready = select (sockfd+1, &descriptors, NULL, NULL, &tv);
		if(ready < 0)
			return ready;		
		if(ready > 0){
			for(int i = 0; i<ready; i++){
				rec=recv_single(sockfd, ttl, id, treply+*ireply);
				if(rec<0) return -1;
				if(rec!=2) {
					(*ireply)++;	
					total_response_time+=resp;			
				}		
				clock_gettime(CLOCK_MONOTONIC, &st);	
				resp = (st.tv_sec - t.tv_sec)*1000 + (st.tv_nsec - t.tv_nsec)/1000000;
			}
		}	
	}
	if(*ireply<3) *responsetime = -1;	 
	else *responsetime=total_response_time/3;
	
	if(rec==1) return 1;

	return 0;
}


int recv_single(int sockfd, int ttl, int id, struct in_addr *addr){
	u_int8_t buffer[IP_MAXPACKET];
	struct sockaddr_in sender;
	socklen_t sender_len = sizeof(sender);
	if(recvfrom(sockfd, buffer, IP_MAXPACKET, MSG_DONTWAIT, (struct sockaddr*) &sender, &sender_len)<0){
		fprintf(stderr, "Recieving error: %s\n", strerror(errno));
		return -1;
	}

	struct ip *ip_header = (struct ip *)buffer;
	struct icmp *icmp_header = (struct icmp *)((uint8_t *)ip_header + (*ip_header).ip_hl * 4);;

	if(icmp_header->icmp_type == ICMP_TIME_EXCEEDED){
		struct ip *ip_recv = (struct ip *)((uint8_t *)icmp_header + 8);
		struct icmp *icmp_recv = (struct icmp *)((uint8_t *)ip_recv + (*ip_recv).ip_hl * 4);
		if(icmp_recv->icmp_seq==ttl && icmp_recv->icmp_id==id){
			*addr=ip_header->ip_src;
			return 0;
		}
	}
	else if(icmp_header->icmp_type == ICMP_ECHOREPLY && icmp_header->icmp_seq==ttl && icmp_header->icmp_id==id){
		*addr=ip_header->ip_src;
		return 1;
	}

	return 2;
}
