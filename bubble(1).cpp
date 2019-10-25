# include <iostream>
# include <cstdio>
# include <time.h>
# include <omp.h>
# include "omp.h"
# include<chrono>

using namespace std;
using namespace std::chrono;

void getval(int a[],int b[],int n)
{
for(int i=0;i<n;i++)
{
a[i]=b[i]=n-i;
}
}

void serial(int a[],int n)
{
time_point<system_clock> start,end;
start=system_clock::now();

for(int i=0;i<n-1;i++)
{
for(int j=0;j<n-1;j++)
{
 if(a[j]>a[j+1])
 {
  int temp=a[j];
  a[j]=a[j+1];
  a[j+1]=temp;
 }
}
}

end=system_clock::now();
duration<double>time=end-start;
cout<<"The time is"<<time.count()*1000;

}

void parallel(int a[],int n)
{
time_point<system_clock> start,end;
start=system_clock::now();
omp_set_num_threads(2);
int first=0;
for(int i=0;i<n;i++)
{
first=i%2;
#pragma omp parallel for default(none),shared(a,first,n)
for(int j=first;j<n-1;j=j+2)
{
if(a[j]>a[j+1])
{

int temp=a[j];
  a[j]=a[j+1];
  a[j+1]=temp;
}
}
}
end=system_clock::now();
duration<double>time=end-start;
cout<<"The time is"<<time.count()*1000;
}

int main()
{
int n;
cout<<"Enter the value of n:";
cin>>n;

int a[n];
int b[n];

getval(a,b,n);
serial(a,n);
parallel(a,n);
}
