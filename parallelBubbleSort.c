#include<omp.h>
#include<stdio.h>
#include<stdlib.h>

void p_bubbleSort(int array[], int count)
{
  omp_set_num_threads(count/2);
  int swap_flag = 0;
  do{
    swap_flag = 0;
    for(int k=0; k< count-2; k++)
    {
      if(k%2 ==0)
      {
        #pragma omp paralel for
        for(int i=0; i<count/2; i++)
        {
          int temp;
          if(array[2*i] > array[2*i+1])
          {
            temp = array[2*i];
            array[2*i] = array[2*i+1];
            array[2*i+1] = temp;
            swap_flag = 1;
          }
        }
      }
      else
      {
        #pragma omp paralle for
        for(int j=0; j<(count-1)/2; j++)
        {
          int temp;
          if( array[2*j+1] > array[2*j+2])
          {
            //swap
            temp = array[2*j+1];
            array[2*j+1] = array[2*j+2];
            array[2*j+2] = temp;
            swap_flag=1;
          }
        }
      }
    }
  }while(swap_flag!=0);
}
int main(int argc, char* argv[])
{
  int size = 10;
   int array[] = {4,3,7,9,6,5,2,1,1000,8};
   printf("unsorted array: \\n");
   for(int i=0; i<10; i++)
    printf("%d\\t", array[i]);

  printf("\\n");

  p_bubbleSort(array, size);

  printf("sorted array is:\\n");
  for(int i=0; i<size; i++)
  {
    printf("%d\\t",array[i] );
  }
}
