/*Dawid Żywczak, 310111*/
#include "udp_client.h"
/* List of functions here:
- find_in_vec
- prepare_fragments
- send_request
*/
using namespace std;

int find_in_vec(const vector<pair<int, pair<short, bool>>> &packets, int x, short y)
{
    int packets_size = packets.size();
    for (int i = 0; i < packets_size; i++)
    {
        if (packets[i].first == x && packets[i].second.first == y && packets[i].second.second == false)
        {
            return i;
        }
    }
    return -1;
}

vector<pair<int, pair<short, bool>>> prepare_fragments(int &bytes_to_get)
{
    //Portion requested data into packets of size at max 1000B
    int sum = 0;
    vector<pair<int, pair<short, bool>>> packets;
    while (bytes_to_get > 1000)
    {
        pair<int, pair<short, bool>> packet;
        packet.first = sum;
        packet.second.first = 1000;
        packet.second.second = false;
        sum += 1000;
        bytes_to_get -= 1000;
        packets.push_back(packet);
    }
    pair<int, pair<short, bool>> packet;
    packet.first = sum;
    packet.second.first = bytes_to_get;
    packet.second.second = false;
    sum += bytes_to_get;
    bytes_to_get -= bytes_to_get;
    packets.push_back(packet);
    return packets;
}

int send_requests(int sockfd, struct sockaddr_in server_addr, const vector<pair<int, pair<short, bool>>> &packets, 
const int &recieved_packets_total, const int &window_size)
{
    string message = "";
    int packets_size = packets.size();
    for (int j = recieved_packets_total; j < recieved_packets_total + window_size && j < packets_size; j++)
    {
        if (packets[j].second.second == 0)
        {
            message = "GET " + to_string(packets[j].first) + " " + to_string(packets[j].second.first) + "\n";
            const char *request = message.c_str();
            if (sendto(sockfd, (const char *)request, strlen(request),
                       MSG_CONFIRM, (const struct sockaddr *)&server_addr,
                       sizeof(server_addr)) <= 0)
            {
                return EXIT_FAILURE;
            }
        }
    }
    return 0;
}
