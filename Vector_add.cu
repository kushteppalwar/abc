#include <stdio.h>
#include <iostream>
#include "cuda_runtime.h"
#define SIZE 50
using namespace std;

__global__ void add(int a[],int b[],int c[],int n)
{
	//int i = blockIdx.x * blockDim.x + threadIdx.x;
	int i = threadIdx.x;
	//if(i<n)
		c[i] = a[i]+b[i];
	
}

int main()
{
	int *a,*b,*c;
	int *d_a,*d_b,*d_c;
	
	a = (int*)malloc(SIZE * sizeof(int));
	b = (int*)malloc(SIZE * sizeof(int));
	c = (int*)malloc(SIZE * sizeof(int));
	
	//Vector Generation
	for(int i=0;i<SIZE;i++)
	{
		a[i] = i + 1;
		b[i] = i;
	}

	cudaMalloc(&d_a,SIZE * sizeof(int));
	cudaMalloc(&d_b,SIZE * sizeof(int));
	cudaMalloc(&d_c,SIZE * sizeof(int));
	
	cudaMemcpy(d_a, a, SIZE*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, SIZE*sizeof(int), cudaMemcpyHostToDevice);
	
	
	add<<<1,SIZE>>> (d_a,d_b,d_c,SIZE); 
	
	cudaDeviceSynchronize(); //wait untill all the codes finish execution
	
	cudaMemcpy(c,d_c,SIZE*sizeof(int),cudaMemcpyDeviceToHost);
	
	cout<<"\nVector A:\n";
	for(int i=0;i<SIZE;i++)
	{
		cout<<a[i]<<" ";
	}
	
	cout<<"\nVector B:\n";
	for(int i=0;i<SIZE;i++)
	{
		cout<<b[i]<<" ";
	}
	cout<<"\nVector SUM:\n";
	
	for(int i=0;i<SIZE;i++)
	{
		cout<<c[i]<<" ";
	}
	
	cudaFree(a);
	cudaFree(b);
	cudaFree(c);
	return 0;
}


