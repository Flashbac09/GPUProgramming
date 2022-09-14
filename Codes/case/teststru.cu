#include <cuda_runtime.h>
#include <stdio.h>
//json defs
int main(int argc, char **argv) { 
    // define total data elements 
    int nElem = 1024;
    
    // define grid and block structure
    dim3 block (1024,2,5);
    dim3 grid ((nElem+block.x-1)/block.x); 
    printf("grid.x %d block.x %d \n",grid.x, block.x);

    // reset block
    block.x = 512;
    grid.x = (nElem+block.x-1)/block.x; 
    printf("grid.x %d block.x %d \n",grid.x, block.x);

    // reset block
    block.x = 256;
    grid.x = (nElem+block.x-1)/block.x; 
    printf("grid.x %d block.x %d \n",grid.x, block.x);

    // reset block
    block.x = 128;
    grid.x = (nElem+block.x-1)/block.x; 
    printf("grid.x %d block.x %d \n",grid.x, block.x);
    printf("%d %d %d %d",grid.y,grid.z,block.y,block.z);
    // reset device before you leave cudaDeviceReset();
    return(0);
}
