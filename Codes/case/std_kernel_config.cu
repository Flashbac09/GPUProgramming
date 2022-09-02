//std global index -done
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<string.h>
#include<malloc.h>
#include<cuda.h>
#include<cuda_runtime.h>
#include<map>

using namespace std;

//1:
int n;
double *a,*b,*c;
double *dev_a,*dev_b,*dev_c;
dim3 Dg(3,2,2);
dim3 Db(4,5,6);
__global__ void kernel(int n,double* a,double* b,double* c)
{
    int tid=0,bid=0,bdm=0,idx=0;
    printf("%d %d %d %d\n",blockDim.x,blockDim.y,gridDim.x,gridDim.y);
    tid=threadIdx.x+threadIdx.y*blockDim.x+threadIdx.z*blockDim.x*blockDim.y;
    bid=blockIdx.x+blockIdx.y*gridDim.x+blockIdx.z*gridDim.x*gridDim.y;
    bdm=blockDim.x*blockDim.y*blockDim.z;
    idx=tid+bid*bdm;
    if(idx<n)
    c[idx]=a[idx]+b[idx];
}

__host__ int main()
{
    scanf("%d",&n);

    //2:
    a=(double*)malloc(sizeof(double)*n);
    b=(double*)malloc(sizeof(double)*n);
    c=(double*)malloc(sizeof(double)*n);
    for(int i=0;i<n;i++)
    {
        a[i]=i+1;
        b[i]=(i*2.6)/(i+2);
    }
    cudaMalloc((void**)&dev_a,sizeof(double)*n);
    cudaMalloc((void**)&dev_b,sizeof(double)*n);
    cudaMalloc((void**)&dev_c,sizeof(double)*n);

    //3:
    cudaMemcpy(dev_a,a,sizeof(double)*n,cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,sizeof(double)*n,cudaMemcpyHostToDevice);

    //4:
    //Dg.x=3;Dg.y=2;Dg.z=2;
    //Db.x=2;Db.y=1;Db.z=1;
    kernel<<<Dg,Db>>>(n,dev_a,dev_b,dev_c);

    //5:
    cudaMemcpy(c,dev_c,sizeof(double)*n,cudaMemcpyDeviceToHost);


    for(int i=0;i<n;i++)
    {
        printf("%lf ",c[i]);
    }

    //6:
    cudaFree(dev_a);cudaFree(dev_b);cudaFree(dev_c);
    free(a);free(b);free(c);
    return 0;
}