#include<iostream>
#include<omp.h>
using namespace std;

int main()
{
	int a[8]={1,8,3,4,6,2,4,8};
	int n=8;
	float start,end;
	start=omp_get_wtime();
	int temp;
	int i,j;
	
	for(i=0;i<=(n-1);i++)
	{
		int first=i%2;
		#pragma omp parallel for default(none),shared(first,a,n,i)
		for(j=first;j<=(n-1);j=j+2)
		{
			if(a[j]>a[j+1])
			{
				int temp=a[j];
				a[j]=a[j+1];
				a[j+1]=temp;
			}
		}
	}
	
	end=omp_get_wtime();
	for(int i=0;i<n;i++)
	{
	
	cout<<a[i]<<" ";
	}
	
	
	
	
	
	
	
	cout<<"time required="<<end-start;
}
