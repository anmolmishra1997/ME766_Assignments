#include <stdio.h>
#include <stdlib.h>
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
	double width = PI/n;
	double cf = width/2;

	double res = 0;

	for(int i=0; i<n; i++)
		res += sin(i*width) + sin((i+1)*width);

	printf("%f\n", cf*res);

}