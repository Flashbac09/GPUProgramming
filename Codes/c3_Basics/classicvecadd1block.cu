#include<stdio.h>
#include<iostream>
#include<stdlib.h>
#include<math.h>
#include<cuda_runtime.h>
//vector add, given dimension n.
//1 block,n threads.
#define n 2
double a[n],b[n],c[n];
//KEY:address for memcpy,set pointers.//
double *dev_a,*dev_b,*dev_c;
__host__ int main()
{
    //step 0 data
    for(int i=0;i<n;i++)
    scanf("%lf%lf",&a[i],&b[i]);
    //step 1 malloc for device
    cudaMalloc((void**)&dev_a,n*sizeof(double));
    cudaMalloc((void**)&dev_b,n*sizeof(double));
    cudaMalloc((void**)&dev_c,n*sizeof(double));
    //step 2 data that device needs(H2D)
    cudaMemcpy(dev_a,a,N*sizeof(double),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,N*sizeof(double),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_c,c,N*sizeof(double),cudaMemcpyHostToDevice);
    //step 3 kernel function
    vecadd<<<1,n>>>(dev_a,dev_b,dev_c);
    //step 4 send result back to host(D2H)
    cudaMemcpy(c,dev_c,N*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<n;i++)
    {
        printf("%lf + %lf = %lf\n",a[i],b[i],c[i]);
    }
    //step end:CUDAFREE
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    return 0;
}

__global__ void vecadd(double *a,double *b,double *c)
{
    if(threadIdx.x<n)
    c[threadIdx.x]=a[threadIdx.x]+b[threadIdx.x];
}