#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <omp.h>

#define PI 3.1415926535
 
int main(int argc, char** argv)
{
	if (argc != 3)
	{
		printf("Must provide two arguments - n and t\n");
		exit(1);
	}
	
	int n = atoi(argv[1]);
	int t = atoi(argv[2]);

	unsigned int seed = time(NULL);
	int count = 0;
	double rx, ry;

	omp_set_num_threads(t);
	double start = omp_get_wtime();
	#pragma omp parallel for private(rx, ry) reduction(+:count)
	for(int i=0; i<n; i++)
	{
		rx = (double)rand_r(&seed)/(double)RAND_MAX * PI;
		ry = (double)rand_r(&seed)/(double)RAND_MAX;
		if( ry <= sin(rx))
			count++;
	}

	double end = omp_get_wtime();
	double time = end - start;

	double res = PI*count/n;
	printf("%f\n", res);
	printf("%f\n", time);
}