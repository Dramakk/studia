CPPFLAGS = -std=c++14 -Wall -Wextra
CC = g++
LDFLAGS = -static
all :  udp_client

udp_client : udp_client_recieve.o helpers.o udp_client.o

udp_client.o: udp_client.cpp udp_client.h

helpers.o : helpers.cpp udp_client.h

udp_client_recieve.o : udp_client_recieve.cpp udp_client.h

clean :
	rm -f helpers.o udp_client.o udp_client_recieve.o
distclean :
	rm -f udp_client_recieve helpers udp_client helpers.o udp_client.o udp_client_recieve.o

