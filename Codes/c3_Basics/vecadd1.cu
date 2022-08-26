#include <iostream>
#include <math.h>
#include<stdio.h>
#include<cuda_runtime.h>
__global__
void vecadd(int n, float *x, float *y)
{
  int index = threadIdx.x;
  int stride = blockDim.x;
  for (int i = index; i < n; i += stride)
      y[i] = x[i] + y[i];
}
 
int main(void)
{
  int N = 1<<20;
  float *x, *y;
  cudaMallocManaged(&x, N*sizeof(float));
  cudaMallocManaged(&y, N*sizeof(float));
  int Ndef;
  scanf("%d",&Ndef);
  for (int i = 0; i < Ndef; i++) 
  {
    scanf("%f%f",&x[i],&y[i]);
  }
 
  vecadd<<<1, 256>>>(Ndef, x, y);
  cudaDeviceSynchronize();
   for (int i = 0; i < Ndef; i++) 
  {
    printf("%f ",y[i]);
  }
  cudaFree(x);
  cudaFree(y);
  
  return 0;
}
