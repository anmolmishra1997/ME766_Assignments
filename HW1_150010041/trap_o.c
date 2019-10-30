#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>

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
	double width = PI/n;
	double cf = width/2;

	double res = 0;


	omp_set_num_threads(t);
	double start = omp_get_wtime();
	#pragma omp parallel for reduction(+:res)
	for(int i=0; i<n; i++)
		res += sin(i*width) + sin((i+1)*width);

	double end = omp_get_wtime();
	double time = end - start;

	printf("%f\n", cf*res);
	printf("%f\n", time);

}