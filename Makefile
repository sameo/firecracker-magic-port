all: fc-magic-port.c
	gcc -static -O2 -o fc-magic-port fc-magic-port.c
