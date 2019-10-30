#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define PI 3.1415926535
 
int main(int argc, char** argv)
{
	if (argc != 2)
	{
		printf("Must provide one argument - n\n");
		exit(1);
	}
	int n = atoi(argv[1]);

	srand(time(NULL));
	int count = 0;
	double rx, ry;

	for(int i=0; i<n; i++)
	{
		rx = (double)rand()/(double)RAND_MAX * PI;
		ry = (double)rand()/(double)RAND_MAX;
		if( ry <= sin(rx))
			count++;
	}

	double res = PI*count/n;
	printf("%f\n", res);
}