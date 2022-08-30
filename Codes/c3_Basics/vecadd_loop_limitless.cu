#include<stdio.h>
#include<iostream>
#include<stdlib.h>
#include<math.h>
#include<cuda_runtime.h>
//vector add, given dimension n.
//#1dim block,1dim thread(int for <<<>>>)
//#set maxdimlimit
//#not once for all(means limitless vecdim)
//loop in threads
//SIZE:  2(1 for call once),2^31-1,512
#define n 2
double a[n],b[n],c[n];
//KEY:address for memcpy,set pointers.//
double *dev_a,*dev_b,*dev_c;


__global__ void vecadd(double *a,double *b,double *c)
{
    int index=blockDim.x*blockIdx.x+threadIdx.x;
    while(index<n)
    {
        c[index]=a[index]+b[index];
        index+=gridDim.x*blockDim.x;
    }
    
}


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
    cudaMemcpy(dev_a,a,n*sizeof(double),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,n*sizeof(double),cudaMemcpyHostToDevice);
    //Which is Unnecessary:  cudaMemcpy(dev_c,c,n*sizeof(double),cudaMemcpyHostToDevice);
    //step 3 kernel function
    vecadd<<<128,128>>>(dev_a,dev_b,dev_c);
    //step 4 send result back to host(D2H)
    cudaMemcpy(c,dev_c,n*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<n;i++)
    {
        printf("%lf + %lf = %lf\n",a[i],b[i],c[i]);
    }
    //step 5:CUDAFREE
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    return 0;
}
