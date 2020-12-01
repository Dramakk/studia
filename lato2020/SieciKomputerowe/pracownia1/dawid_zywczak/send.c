//Dawid Żywczak, 310111
#include "traceroute.h"

int send_packets(int sockfd, int ttl, int pid, struct sockaddr_in dest, int magick_number){
	for(int i=0; i<3; i++){
		if(send_packet(sockfd, ttl, pid, dest, magick_number+i)<0) return -1;
	}
	return 0;
}

/* Funkcja ze slajdów, wysyłamy jeden pakiet z ustalonym TTL, wykorzystujemy PID w celu identyfikacji
naszych pakietów */
int send_packet(int sockfd, int ttl, int pid, struct sockaddr_in dest, int magick_number){
	struct icmp header;
	header.icmp_type = ICMP_ECHO;
	header.icmp_code = 0;
	header.icmp_id = pid;
	header.icmp_seq = magick_number;
	header.icmp_cksum = 0;
	header.icmp_cksum = compute_icmp_checksum((u_int16_t*)&header, sizeof(header));

	setsockopt(sockfd, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));

	if (sendto(sockfd, &header, sizeof(header), 0, (struct sockaddr*)&dest, sizeof(dest)) < 0) {
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
