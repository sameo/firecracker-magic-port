#include <stdio.h>
#include <sys/io.h>
#include <unistd.h>

#define FC_MAGIC_IOPORT 0x03f0
#define FC_MAGIC_IOPORT_VALUE 123

int main(int argc, char *argv[]) {
	int err;

	err = iopl(3);
	if (err < 0) {
		perror("iopl failed");
	}
	
	err = ioperm(FC_MAGIC_IOPORT_VALUE, 16, 1);
	if (err < 0) {
		perror("ioperm failed");
	}

	outb(FC_MAGIC_IOPORT_VALUE, FC_MAGIC_IOPORT);

//	while(1) {
//		sleep(10);
//	}
//	return 0;
}
