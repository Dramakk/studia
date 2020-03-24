#include "traceroute.h"

//Dawid Żywczak, 310111

int send_sockets(int sockfd, int ttl, int pid, struct sockaddr_in addr){
	for(int i=0; i<3; i++){
		if(send_socket(sockfd, ttl, pid, addr)<0) return -1;
	}
	return 0;
}

/* Funkcja ze slajdów, wysyłamy jeden pakiet z ustalonym TTL, wykorzystujemy PID w celu identyfikacji
naszych pakietów */
int send_socket(int sockfd, int ttl, int pid, struct sockaddr_in addr){
	struct icmp packet;
	packet.icmp_type = ICMP_ECHO;
	packet.icmp_code = 0;
	packet.icmp_id = pid;
	packet.icmp_seq = ttl;
	packet.icmp_cksum = 0;
	packet.icmp_cksum = compute_icmp_checksum((u_int16_t*)&packet, sizeof(packet));

	setsockopt(sockfd, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));

	if (sendto(sockfd, &packet, sizeof(packet), 0, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
		fprintf(stderr, "Error sending packet: %s\n", strerror(errno));
		return -1;
	}
	return 0;
}
//Funkcja obliczająca checksum z wykładu
u_int16_t compute_icmp_checksum (const void *buff, int length){

	u_int32_t sum;
	const u_int16_t *ptr = buff;
	assert(length % 2 == 0);
	for (sum = 0; length > 0; length -= 2)
		sum += *ptr++;

	sum = (sum >> 16) + (sum & 0xffff);
	return (u_int16_t)(~(sum + (sum >> 16)));
}
