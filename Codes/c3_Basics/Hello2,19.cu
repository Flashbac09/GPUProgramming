#include<iostream>
#include<cuda_runtime.h>
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>

__global__ void kernel()
{
    printf("Hello, CUDA!\n");
}

int main()
{
    kernel<<<2,19>>>();
    return 0;
}