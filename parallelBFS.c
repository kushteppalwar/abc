#include<stdio.h>
#include "omp.h"
int q[1000];
int visited[7];
int local_q;

void bfs(int adj_matrix[7][7], int first, int last, int q[], int n_nodes)
{
		if(first==last)
			return;

		//pop first element
		int cur_node = q[first++];
		
		printf("%d, ", cur_node);
		omp_set_num_threads(3);
		#pragma omp parallel for shared(visited)
		for(int i=0; i<n_nodes; i++)
		{
			if(adj_matrix[cur_node][i]==1 && visited[i]==0)
			{
				q[last++] = i;
				visited[i]=1;
			}
		}
	bfs(adj_matrix, first, last, q, n_nodes);
}

int main()
{
	int first = -1;	//index of first element
	int last = 0;	//index of next insertion
	int n_nodes = 7;
	for(int i=0; i<n_nodes; i++)
	{
		visited[i] = 0;
	}
	//shows graph connections
	int adj_matrix[7][7] = {
													{0,  1  ,1  ,0  ,0  ,0  ,0},
													{1	,0	,1	,1	,0	,0	,0},
													{1	,1	,0	,0	,1	,0	,0},
													{0	,1	,0	,0	,1	,0	,0},
													{0	,0	,1	,1	,0	,1	,0},
													{0	,0	,0	,0	,1	,0	,1},
													{0	,0	,0	,0	,0	,1	,0}
													};

	int start_node = 3;	//set start node as 1
	q[last++] = start_node;
	first++;
	visited[start_node] = 1;
	
	int cur_node;
	bfs(adj_matrix, first, last, q, n_nodes);
	/*
	while(first != last)
	{
		//pop first element
		cur_node = q[first++];
		
		printf("%d, ", cur_node);
		for(int i=0; i<n_nodes; i++)
		{
			if(adj_matrix[cur_node][i]==1 && visited[i]==0)
			{
				q[last++] = i;
				visited[i]=1;
			}
		}

	}	
	*/
	return 0;
}
