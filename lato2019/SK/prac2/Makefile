CC = gcc -ggdb 
CFLAGS = -Og -std=gnu11 -Wall -Wextra -Wno-unused-parameter -Wno-unused-function

all: zad1 zad2 zad3

zad1: zad1.o
zad2: zad2.o
zad3: zad3.o
	$(CC) $(CFLAGS) -o $@ $^ -ldl -Wl,-rpath,`pwd`

clean:
	rm -f zad1 zad2 zad3
	rm -f *.o
	rm -f *~


