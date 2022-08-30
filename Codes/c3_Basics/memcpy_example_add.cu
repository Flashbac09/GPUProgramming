#include<iostream>
#include<cuda_runtime.h>
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>
//memcpy example
__global__ void simpleadd(int a, int b, int *c)
{
    *c=a+b;
    printf("dev:%d\n",*c);
}

int main()
{
    //step 0
    int c;
    int *c4dev;
    //step 1 malloc
    cudaMalloc((void**)&c4dev,sizeof(int));
    //step 2 kernel function
    simpleadd<<<2,19>>>(8,6,c4dev);
    //step 3 memcpy(d2h)
    cudaMemcpy(&c,c4dev,sizeof(int),cudaMemcpyDeviceToHost);
    printf("Host:%d\n",c);
    cudaFree(c4dev);
    return 0;
}