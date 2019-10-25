#include<stdio.h>
#include<time.h>
#include<math.h>
#define N 16

using namespace std;


__global__ void FindSum(float input[])
{
	int tid = threadIdx.x;
	int step_count = 1;
	int no_of_threads = blockDim.x;
	
	while(no_of_threads>0)
	{
		
		if(tid < no_of_threads)
		{
			int fst = tid*step_count*2;
			int snd = fst + step_count;
			input[fst]+=input[snd];
		}
		
		step_count <<=1;
		no_of_threads >>=1;
	}
}

__global__ void FindDiff(float input[],float mean)
{
	int tid = threadIdx.x;

	while(tid<N)
	{
		input[tid] = input[tid] - mean;
	}		
}

int main()
{
	float *h_a;
	h_a = (float*)malloc(N*sizeof(float));
	
	for(int i=0;i<N;i++)
	{
		h_a[i] = ((float)rand()/RAND_MAX)*N;
	}
	
	for(int i=0;i<N;i++)
	{
		printf("%f\n",h_a[i]);
	}
	
	//Sum Calculations
	float *d_a;
	cudaMalloc(&d_a,N*sizeof(float));
	cudaMemcpy(d_a,h_a,N*sizeof(float),cudaMemcpyHostToDevice);
	
	FindSum <<<1,N/2>>>(d_a);
	cudaDeviceSynchronize();
	
	float *sum;
	sum = (float*)malloc(N*sizeof(float));
	cudaMemcpy(sum,d_a,sizeof(float),cudaMemcpyDeviceToHost);
	
	//mean
	float mean = (float)sum[0]/N;
	
	//Mean-Diff
	float *d_mean,*g;
	cudaMalloc(&d_mean,sizeof(float));
	cudaMalloc(&g,N*sizeof(float));
	
	cudaMemcpy(d_mean,mean,sizeof(float),cudaMemcpyHostToDevice);
	cudaMemcpy(g,h_a,N*sizeof(float),cudaMemcpyHostToDevice);
	
	
	FindDiff<<<1,N>>>(g,d_mean);
	cudaDeviceSynchronize();
	
	float *dArray;
	dArray = (float*)malloc(N*sizeof(float));
	cudaMemcpy(dArray,g,N*sizeof(float),cudaMemcpyDeviceToHost);
	
	//Sum of Difference Array
	float *sDiff,*d_sArray;
	cudaMalloc(&d_sArray,N*sizeof(float));
	sDiff = (float*)malloc(sizeof(float));
	
	FindSum <<<1,N/2>>>(d_sArray);
	cudaDeviceSynchronize();
	
	cudaMemcpy(sDiff,d_sArray,sizeof(float),cudaMemcpyHostToDevice);
	
	float *temp;
	temp = (float*)malloc(sizeof(float));
	
	temp = (float)sDiff[0]/N;
	
	//stdDev
	
	float stdDev = sqrt(temp);
	
	printf("Standard Deviation: %f",stdDev);
	
	cudaFree(d_a);
	cudaFree(d_mean);
	cudaFree(g);
	cudaFree(d_sArray);
	free(h_a);
	free(temp);
	free(dArray);
	
	return 0;
}
	
