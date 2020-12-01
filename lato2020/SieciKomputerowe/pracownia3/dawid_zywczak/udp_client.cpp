/*Dawid Żywczak, 310111*/
#include "udp_client.h"
using namespace std;

int main(int argc, char *argv[])
{
	//Initialize all variables
	FILE *file;
	char *fname;
	char *ip;
	struct sockaddr_in server_addr;
	vector<pair<int, pair<short, bool>>> packets;
	int sockfd, port, bytes_to_get;
	//Get arguments from terminal
	if (argc == 5)
	{
		fname = argv[3];
		bytes_to_get = (int)atoi(argv[4]);
		port = atoi(argv[2]);
		ip = argv[1];
	}
	else
	{
		cerr << "usage: ./client <ip_addres> <port> <filename> <how_many_bytes>" << endl;
		return EXIT_FAILURE;
	}
	if (inet_pton(AF_INET, ip, &server_addr.sin_addr) == 0)
	{
		cerr << "Wrong IP address" << endl;
		return EXIT_FAILURE;
	}
	if (port < 0 || port > 65535)
	{
		cerr << "Wrong port number" << endl;
		return EXIT_FAILURE;
	}
	memset(&server_addr, 0, sizeof(server_addr));

	//Fill server addres data
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port);
	server_addr.sin_addr.s_addr = inet_addr(ip);

	//Create socket
	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
	{
		cerr << "socket creation failed" << endl;
		return EXIT_FAILURE;
	}
	//Check connection
	file = fopen(fname, "wb");
	if (!file)
	{
		cerr << "file opening failed\n"
			 << endl;
		return EXIT_FAILURE;
	}
	packets = prepare_fragments(bytes_to_get);
	if (udp_client_recieve(sockfd, file, packets, server_addr) != 0)
	{
		cerr << "something went wrong\n";
		return EXIT_FAILURE;
	}
	fclose(file);
	close(sockfd);
	return 0;
}
