//<<<cuda vecadd config>>>
//<<<thread:1D>>>

//Tips Updating:
//1:(void**)&dev for cudaMalloc[no instance of overloaded function "cudaMalloc" matches the argument list]
//2:don't define variables in main
//3:main a,b,c,without malloc,its length must be determined before using them(better define n)
#include<stdio.h>
#include<iostream>
#include<stdlib.h>
#include<malloc.h>
#include<math.h>
#include<cuda_runtime.h>
double *dev_a,*dev_b,*dev_c;
__global__ void vecadd(double* a,double* b,double* c)
{
    while(tid<n)
    {
        c[tid]=a[tid]+b[tid];
        tid+=blockDim.x*threadIdx.y+threadIdx.x;
    }
}

__host__ int main()
{
    int n;
    scanf("%d",&n);
    double a[n],b[n],c[n];
    memset(a,0,sizeof(double)*n);
    memset(b,0,sizeof(double)*n);
    memset(c,0,sizeof(double)*n);
    for(int i=0;i<n;i++)
    {
        scanf("%lf%lf",&a[i],&b[i]);
    }
    cudaMalloc((void**)&dev_a,n*sizeof(double));
    cudaMalloc((void**)&dev_b,n*sizeof(double));
    cudaMalloc((void**)&dev_c,n*sizeof(double));
    cudaMemcpy(dev_a,a,n*sizeof(double),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,n*sizeof(double),cudaMemcpyHostToDevice);
    vecadd<<<(n+127)/128,128>>>(dev_a,dev_b,dev_c);
    cudaMemcpy(c,dev_c,n*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<n;i++)
    {
        printf("%lf\n",c[i]);
    }
    cudaFree(dev_a);cudaFree(dev_b);cudaFree(dev_c);
    return 0;
}