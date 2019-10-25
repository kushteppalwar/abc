#include<stdio.h>
#include<time.h>
#define N 2048

using namespace std;

__global__ void getMin(int input[])
{
	int tid = threadIdx.x;
	int step_count =1;
	int no_of_threads = blockDim.x;
	
	while(no_of_threads>0)
	{
		if(tid<no_of_threads)
		{
			int fst = tid*step_count*2;
			int snd = fst+step_count;
			
			if(input[fst]<input[snd])
				input[fst] = input[snd];
			else
				input[fst]=input[fst];
		}
		
		step_count <<=1;
		no_of_threads >>=1;
	}
	
}

int main()
{
	int *d_a;
	int *h_a;
	
	h_a = (int*)malloc(N*sizeof(int));
	cudaMalloc(&d_a,N*sizeof(int));
	
	for(int i=0;i<N;i++)
	{
		//h_a[i] = rand()%N;
		h_a[i] = N-i+1;
	}
	
	//printing the array
	/*for(int i=0;i<N;i++)
	{
		printf("%d  ",h_a[i]);
	}*/
	
	cudaMemcpy(d_a,h_a,N*sizeof(int),cudaMemcpyHostToDevice);
	
	clock_t t1 = clock();
	getMin <<<1,N/2>>>(d_a);	
	cudaDeviceSynchronize();
	clock_t t2 = clock()-t1;
	
	double time_taken;
	
	time_taken = ((double)t2)/CLOCKS_PER_SEC;
	
	int *result;
	result = (int*)malloc(sizeof(int));
	cudaMemcpy(result,d_a,sizeof(int),cudaMemcpyDeviceToHost);
	printf("Minimum number is: %d",result[0]);
	printf("Time taken is: %lf",time_taken);
	
	
	cudaFree(d_a);
	free(result);
	free(h_a);
	
	return 0;
}
