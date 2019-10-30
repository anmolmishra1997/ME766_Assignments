#include <iostream>
using namespace std;

#define N 10000

__global__ void arrmul(float * d_A, float * d_B, float * d_C)
{
	long long int idx = blockIdx.x;
	long long int idy = blockIdx.y;
	long long int idz = threadIdx.x;
	long long int index = idz + (idy + idx*gridDim.y) *blockDim.x;
	long long int row = index/N;
	long long int col = index%N;
	// long long int idy = threadIdx.y;

	for(long long int k=0; k<N; k++)
		d_C[index] += d_A[row*N + k] * d_B[k*N + col];

}

void printArray(float* arr)
{
	for (long long int i=0; i<N; i++)
	{
		for (long long int j=0;j<N;j++)
			cout << arr[i*N+j] << " ";
		cout << endl;
	}
	cout << endl;
}

int main(int argc, char** argv)
{

	long long int array_bytes = N*N * sizeof(float);
	float *h_A, *h_B, *h_C;

	h_A = (float*) malloc(N*N * sizeof(float));
	h_B = (float*) malloc(N*N * sizeof(float));
	h_C = (float*) malloc(N*N * sizeof(float));

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	srand(time(NULL));

	for(long long int i=0; i<N*N; i++)
	{
		h_A[i] = (double)rand()/(double)RAND_MAX * 1;
		h_B[i] = (double)rand()/(double)RAND_MAX * 1;
		h_C[i] = 0;
	}

	float * d_A;
	float * d_B;
	float * d_C;

	cudaMalloc((void **) &d_A, array_bytes);
	cudaMalloc((void **) &d_B, array_bytes);
	cudaMalloc((void **) &d_C, array_bytes);

	cudaEventRecord(start);
	cudaMemcpy(d_A, h_A, array_bytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, array_bytes, cudaMemcpyHostToDevice);

	long long int blockx = N/10;
	long long int blocky = N/10;
	long long int threads = 100;

	dim3 block( blockx, blocky );

	arrmul<<<block, threads >>>(d_A, d_B, d_C);

	cudaMemcpy(h_C, d_C, array_bytes, cudaMemcpyDeviceToHost);
	cudaEventRecord(stop);

	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);

	cout << milliseconds << endl;

	// printArray(h_A);
	// printArray(h_B);
	// printArray(h_C);

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	return 0;
}