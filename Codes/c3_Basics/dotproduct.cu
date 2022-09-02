#include<stdio.h>
#include<iostream>
#include<stdlib.h>
#include<math.h>
#include<cuda_runtime.h>
#include<malloc.h>
#include<cuda.h>
//doc prodcut,ultilizing shared memory
#define imin(a,b) (a<b?a:b)
const int N=3;
const int threadsPerBlock=256;
const int blocksPerGrid=imin(32,(N+threadsPerBlock-1)/threadsPerBlock);

__global__ void dot(double* a,double* b,double* c)
{
    __shared__ double cache[threadsPerBlock];
    int tindex=threadIdx.x+blockDim.x*blockIdx.x;
    int cacheindex=threadIdx.x;
    double temp=0;
    while(tindex<N)
    {
        temp+=a[tindex]+b[tindex];
        tindex+=blockDim.x*gridDim.x;
    }
    cache[cacheindex]=temp;//for sum
    __syncthreads();//threads sync
    //Reduction
    int i=blockDim.x/2;
    while(i!=0)
    {
        if(cacheindex<i)
        {
            cache[cacheindex]+=cache[cacheindex+i];
        }
        __syncthreads();
        i=i/2;
    }
    if(cacheindex==0)
        c[blockIdx.x]=cache[0];//to each block
}

__host__ int main()
{
    //1:list
    double *a,*b,c,*pc;
    double *dev_a,*dev_b,*dev_c,*dev_pc;
    //2.1:malloc CPU
    a=(double*)malloc(N*sizeof(double));
    b=(double*)malloc(N*sizeof(double));
    pc=(double*)malloc(blocksPerGrid*sizeof(double));
    //2.2:malloc GPU
    cudaMalloc((void**)&dev_a,N*sizeof(double));
    cudaMalloc((void**)&dev_b,N*sizeof(double));
    cudaMalloc((void**)&dev_pc,blocksPerGrid*sizeof(double));
    for(int i=0;i<N;i++)
    {
        a[i]=i;b[i]=i*i;
    }
    //3.Memcpy forward
    cudaMemcpy(dev_a,a,N*sizeof(double),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,N*sizeof(double),cudaMemcpyHostToDevice);
    //4.Kernel Function
    dot<<<blocksPerGrid,threadsPerBlock>>>(dev_a,dev_b,dev_pc);
    //5.Memcpy back
    cudaMemcpy(pc,dev_pc,blocksPerGrid*sizeof(double),cudaMemcpyDeviceToHost);
    c=0;
    for(int i=0;i<N;i++)
    {
        c+=pc[i];
    }
    printf("%lf",c);
    //6.1:cudafree
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_pc);
    //6.2:free
    free(a);free(b);free(pc);
    return 0;
}
