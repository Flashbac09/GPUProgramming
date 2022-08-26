#include<iostream>
#include<cuda_runtime.h>
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>

__global__ void kernel()
{
    
}

int main()
{
    kernel<<<1,1>>>();
    printf("Hello, CUDA!\n");
    return 0;
}