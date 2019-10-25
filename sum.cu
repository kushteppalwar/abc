#include<stdio.h>
#include<time.h>
#define N 2048

using namespace std;


__global__ void FindSum(double input[])
{
	int tid = threadIdx.x;
	int step_size = 1;
	int no_of_threads = blockDim.x;
	
	while(no_of_threads>0)
	{
		if(tid<no_of_threads)
		{
			int fst = tid*step_size*2;
			 int snd = fst + step_size;
			input[fst]+=input[snd];
		}
		step_size <<=1;
		no_of_threads >>=1;
	}
}

int main()
{
	double *h_a;
	h_a = (double*)malloc(N*sizeof(double));
	double time_taken;
	
	
	//generating array
	for(int i=0;i<N;i++)
	{
		//h_a[i] = rand()%N;
		h_a[i] = i;
	}
	
	//printing Array
	for(int i=0;i<N;i++)
	{
		printf("%lf\n",h_a[i]);
	}
	printf("\n");
	
	double *d_a;
	cudaMalloc(&d_a,N*sizeof(double));
	cudaMemcpy(d_a,h_a,N*sizeof(double),cudaMemcpyHostToDevice);
	
	clock_t t1 = clock();
	
	FindSum <<<1,N/2>>>(d_a);
	cudaDeviceSynchronize();
	
	clock_t t2 = clock()-t1;
	
	double *result;
	result = (double*)malloc(sizeof(double));
	
	cudaMemcpy(result,d_a,sizeof(double),cudaMemcpyDeviceToHost);
	
	printf("\nSum: \t%lf",result[0]);
	time_taken = ((double)t2)/CLOCKS_PER_SEC;
	printf("Time Taken:%lf",time_taken);
	
	printf("\nSerial processing:\n");
	float res=0;
	
	clock_t t3 = clock();
	for(int i=0;i<N;i++)
	{
		res +=h_a[i];
	}
	clock_t t4 = clock()-t3;
	printf("Seq Result: %f",res);
	time_taken = ((double)t4)/CLOCKS_PER_SEC;
	printf("Time Taken:%lf",time_taken);
	
	cudaFree(d_a);
	free(h_a);
	free(result);
	return 0;
	

}
