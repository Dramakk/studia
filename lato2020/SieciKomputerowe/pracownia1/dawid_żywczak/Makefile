CFLAGS = -std=gnu99 -Wall -W

all :  traceroute

traceroute : traceroute.o receive.o send.o main.o

main.o: main.c traceroute.h

traceroute.o : traceroute.c traceroute.h

send.o : send.c traceroute.h

receive.o : receive.c traceroute.h

clean :
	rm -f traceroute.o receive.o send.o main.o
distclean :
	rm -f traceroute receive send main traceroute.o receive.o send.o main.o

