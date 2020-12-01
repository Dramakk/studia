//Dawid Żywczak, 310111
#pragma once
#ifndef udp_client
#define udp_client

#include <cstdlib>
#include <cstring>

#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/time.h>
#include <netinet/ip_icmp.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <iostream>
#include <string>
#include <utility>
#include <vector>
#include <algorithm>
using namespace std;

int find_in_vec(const vector<pair<int, pair<short, bool>>> &packets, int x, short y);
vector<pair<int, pair<short, bool>>> prepare_fragments(int &bytes_to_get);
int send_requests(int sockfd, struct sockaddr_in server_addr, const vector<pair<int, pair<short, bool>>> &packets, 
const int &recieved_packets_total, const int &window_size);
int udp_client_recieve(int &sockfd, FILE *file, vector<pair<int, pair<short, bool>>> &packets, const struct sockaddr_in &server_addr);
#endif
