#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

#define PI 3.1415926535

__global__ void mont(float* d_xData, float* d_yData, int* d_count)
{
	int idx = blockIdx.x;
	float rx = d_xData[idx];
	float ry = d_yData[idx];
	if (ry <= sinpi(rx))
		atomicAdd(d_count, 1);

	// float rx = sin(idx*width) + sin((idx+1)*width);
	// atomicAdd(res, c);
}

 
int main(int argc, char** argv)
{
	if (argc != 2)
	{
		printf("Must provide one argument - n\n");
		exit(1);
	}
	int n = atoi(argv[1]);

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

    curandGenerator_t gen;
    float *d_xData, *d_yData;
    // float h_xData[n], h_yData[n];


    cudaMalloc((void **)&d_xData, n*sizeof(float));
    cudaMalloc((void **)&d_yData, n*sizeof(float));

    int count;

	int* h_count = &count;
	*h_count = 0;

	int* d_count;
	cudaMalloc((void **) &d_count, sizeof(int));


    curandCreateGenerator(&gen, 
                CURAND_RNG_PSEUDO_DEFAULT);
    

    curandSetPseudoRandomGeneratorSeed(gen, time(NULL));

	cudaEventRecord(start);
    curandGenerateUniform(gen, d_xData, n);
    curandGenerateUniform(gen, d_yData, n);


    // cudaMemcpy(h_xData, d_xData, n * sizeof(float),
    //     cudaMemcpyDeviceToHost);
    // cudaMemcpy(h_yData, d_yData, n * sizeof(float),
    //     cudaMemcpyDeviceToHost);

	cudaMemcpy(d_count, h_count, sizeof(int), cudaMemcpyHostToDevice);

	mont<<<n, 1 >>>(d_xData, d_yData, d_count);


	cudaMemcpy(h_count, d_count, sizeof(int), cudaMemcpyDeviceToHost);
	cudaEventRecord(stop);
	
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);

	float res = PI* (*h_count)/n;

	printf("%f %f \n", res, milliseconds);
}