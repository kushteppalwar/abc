#include<iostream>
#include<stdio.h>
#include<time.h>
#define N 4

using namespace std;

__global__ void getMult(int *a,int *b,int *c,int n)
{
	int row = blockIdx.x*blockDim.x + threadIdx.x;
	int col = blockIdx.y*blockDim.y + threadIdx.y;
	int sum=0;
	
	if(col<n && row<n)
	{
		for(int i=0;i<n;i++)
		{
			sum += a[row*n+i]*b[i*n+col];
		}
		c[row*n+col] = sum;
	}
}

int main()
{
	int a[N][N];
	int b[N][N];
	int c[N][N];
	
	for(int i=0;i<N;i++)
	{
		for(int j=0;j<N;j++)
		{
			a[i][j] = rand()%N+1;
			b[i][j] = rand()%N+1;
			c[i][j] = 0;
		}
	}
	
	cout<<"Initial Status: "<<endl;
	for(int i=0;i<N;i++)
	{
		for(int j=0;j<N;j++)
		{
			cout<<a[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<endl;
	
	for(int i=0;i<N;i++)
	{
		for(int j=0;j<N;j++)
		{
			cout<<b[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<endl;
	
	for(int i=0;i<N;i++)
	{
		for(int j=0;j<N;j++)
		{
			cout<<c[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<endl;
	
	
	int *d_a,*d_b,*d_c,*d_N;
	
	//Memory allocation
	cudaMalloc(&d_a,N*N*sizeof(int));
	cudaMalloc(&d_b,N*N*sizeof(int));
	cudaMalloc(&d_c,N*N*sizeof(int));
	cudaMalloc(&d_N,sizeof(int));
	
	//Memory Copy to device
	cudaMemcpy(d_a,a,N*N*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,b,N*N*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemset(d_c,0,N*N*sizeof(int));
	//cudaMemcpy(d_N,N,sizeof(int),cudaMemcpyHostToDevice);
	
	dim3 dimGrid(1,1);
	dim3 dimBlock(16,16);
	
	getMult<<<dimGrid,dimBlock>>>(d_a,d_b,d_c,N);
	cudaDeviceSynchronize();
	
	cudaMemcpy(c,d_c,N*N*sizeof(int),cudaMemcpyDeviceToHost);
	for(int i=0;i<N;i++)
	{
		for(int j=0;j<N;j++)
		{
			cout<<c[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<endl;
	
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	cudaFree(d_N);
	
	return 0;
}



