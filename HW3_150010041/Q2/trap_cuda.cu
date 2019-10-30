#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define PI 3.1415926535

__global__ void trap(float width, float* res)
{
	int idx = blockIdx.x;
	float c = sin(idx*width) + sin((idx+1)*width);
	atomicAdd(res, c);
}

int main(int argc, char** argv)
{
	if (argc != 2)
	{
		printf("Must provide one argument - n\n");
		exit(1);
	}

	int n = atoi(argv[1]);
	float width = PI/n;
	float cf = width/2;
	float res;

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	float* h_res = &res;
	*h_res = 0;

	float* d_res;
	cudaMalloc((void **) &d_res, sizeof(float));

	cudaEventRecord(start);
	cudaMemcpy(d_res, h_res, sizeof(float), cudaMemcpyHostToDevice);

	trap<<<n, 1 >>>(width, d_res);

	cudaMemcpy(h_res, d_res, sizeof(float), cudaMemcpyDeviceToHost);
	cudaEventRecord(stop);

	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);

	res = *h_res * cf;

	printf("%f %f\n", res, milliseconds);

	cudaFree(d_res);
}