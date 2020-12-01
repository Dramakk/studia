/*Dawid Żywczak, 310111*/
#include "udp_client.h"

using namespace std;

int udp_client_recieve(int &sockfd, FILE *file, vector<pair<int, pair<short, bool>>> &packets, const struct sockaddr_in &server_addr)
{
    int lfr, laf, shift, n, proggres = 0, window_size = 1500, recieved_packets_total = 0;
    int packets_size = packets.size();
    char buffer[window_size][1100];
    char data[1100];
    bool recv_done = false;
    unsigned int len;
    struct timeval check_begin, check_end;
    gettimeofday(&check_begin, 0);
    struct sockaddr_in recieved_addr;
    memset(&recieved_addr, 0, sizeof(recieved_addr));
    while (!recv_done)
    {
        //Starting new window
        memset(&buffer, 0, sizeof(buffer));
        window_size = packets_size - recieved_packets_total;
        if (window_size > 1500)
        {
            window_size = 1500;
        }
        lfr = recieved_packets_total - 1;
        laf = lfr + window_size;
        //Process all requests from current window
        if (recieved_packets_total >= packets_size - 1)
        {
            recv_done = true;
            break;
        }
        while (lfr < recieved_packets_total + window_size - 1)
        {
            //Print proggress and send requests
            printf("%.2f%% done\n", 100 * (double)proggres / (double)packets_size);
            if (send_requests(sockfd, server_addr, packets, recieved_packets_total, window_size) != 0)
            {
                cerr << "error while sending requests\n";
                return EXIT_FAILURE;
            }
            short ready = 1;
            fd_set descriptors;
            FD_ZERO(&descriptors);
            FD_SET(sockfd, &descriptors);
            struct timeval tv;
            tv.tv_sec = 0;
            tv.tv_usec = 25000;
            //Wait for incomming packets, using select to avoid active wait and 100% CPU usage
            while (ready > 0)
            {
                ready = select(sockfd + 1, &descriptors, NULL, NULL, &tv);
                if (ready < 0)
                    return ready;
                if (ready > 0)
                {
                    //Packets are here, proccess
                    for (short u = 0; u < ready; u++)
                    {
                        n = recvfrom(sockfd, (char *)data, sizeof(data),
                                     MSG_DONTWAIT, (struct sockaddr *)&recieved_addr,
                                     &len);
                        if (n < 0)
                        {
                            return EXIT_FAILURE;
                        }
                        if (n)
                        {
                            //Check if we have the datagram from the server, if not ignore it
                            if (inet_ntoa(recieved_addr.sin_addr) == inet_ntoa(server_addr.sin_addr) && server_addr.sin_port == recieved_addr.sin_port)
                            {
                                //Extract start and length of data recieved
                                char start[100];
                                char end[100];
                                sscanf(data, "%*s %s %s", start, end);
                                int index = find_in_vec(packets, (int)atoi(start), (short)atoi(end));
                                //We found that request in our list of requests
                                if (index != -1)
                                {
                                    int header_offset = 5 + strlen(start) + 2 + strlen(end);
                                    int data_size = sizeof(data) - header_offset;
                                    //If request is in current window
                                    if (index <= laf)
                                    {
                                        //If its first frame in the window
                                        if (index == lfr + 1)
                                        {
                                            memcpy(buffer[index - recieved_packets_total], data + header_offset, data_size);
                                            packets[index].second.second = true;
                                            proggres++;
                                            shift = lfr;
                                            for (int i = index; i < recieved_packets_total + window_size; i++)
                                            {
                                                if (packets[i].second.second == false)
                                                    break;
                                                shift++;
                                            }
                                            lfr = shift;
                                            laf = lfr + window_size;
                                        }
                                        //Frame in the window, not first
                                        else if (index > lfr + 1)
                                        {
                                            if (!packets[index].second.second)
                                            {
                                                proggres++;
                                                memcpy(buffer[index - recieved_packets_total], data + header_offset, data_size);
                                                packets[index].second.second = true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            gettimeofday(&check_end, 0);
            double seconds = (double)(check_end.tv_sec - check_begin.tv_sec) + (double)(check_end.tv_usec - check_begin.tv_usec)/10000000;
            //We didnt get any response for 5s, end program
            if(seconds >= 5 && lfr == -1){
                cerr << "no data recieved for 5s\n";
                return EXIT_FAILURE;
            }
        }
        if (lfr >= window_size - 1)
        {
            for (int i = recieved_packets_total; i < recieved_packets_total + window_size; i++)
            {
                if(fwrite(buffer[i - recieved_packets_total], 1, packets[i].second.first, file) == 0){
                    cerr << "error while writting to file\n";
                    return EXIT_FAILURE;
                }
            }
            recieved_packets_total += window_size;
        }
    }
    return 0;
}
