#include<iostream>
#include<cuda_runtime.h>
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>
//device info code
/*
__global__ void Devcount()
{
    cudaGetDeviceCount(&count);
}
*/
/*a numinfo for total available GPU
  use cudaGetDeviceProperties to control props,which is a struct*/
__host__ int main()
{
    int count;
    cudaDeviceProp p;
    cudaGetDeviceCount(&count);
    printf("Devices Available:  %d\n",count);
    for(int i=0;i<count;i++)
    {
        cudaGetDeviceProperties(&p,i);
    }
    //some examples,not full list of cudaGetDeviceProperties struct.
    printf("DeviceName:  %s\n",p.name);
    printf("compute capability(major-minor): %d to %d\n",p.major,p.minor);
    printf("clockRate:  %d\n",p.clockRate);
    return 0;
}