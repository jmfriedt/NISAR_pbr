#include <stdio.h>
#include <fcntl.h>  // open, close
#include <unistd.h> // read
#include <stdlib.h> // malloc

#define N 100000

int main(int argc,char **argv)
{int fi,fo1i,fo1q,fo0i,fo0q,n,k;
 char *i0,*i1,*q0,*q1;
 char c[4]={1,3,-1,-3};
 unsigned char *d;
 i0=(char*)malloc(N);
 q0=(char*)malloc(N);
 i1=(char*)malloc(N);
 q1=(char*)malloc(N);
 d=(char*)malloc(N);
 if (argc==1) fi=open("12.bin",O_RDONLY);
 else fi=open(argv[1],O_RDONLY);
 if (fi>0)
   {fo0i=open("out0i.bin",O_WRONLY|O_CREAT,S_IRWXU|S_IRWXG|S_IRWXO);
    fo1i=open("out1i.bin",O_WRONLY|O_CREAT,S_IRWXU|S_IRWXG|S_IRWXO);
    fo0q=open("out0q.bin",O_WRONLY|O_CREAT,S_IRWXU|S_IRWXG|S_IRWXO);
    fo1q=open("out1q.bin",O_WRONLY|O_CREAT,S_IRWXU|S_IRWXG|S_IRWXO);
    do 
      {n=read(fi,d,N);
       if (n==N)
         {for (k=0;k<N;k++)
           {i0[k]=c[d[k]&3];
            q0[k]=c[(d[k]>>2)&3];
            i1[k]=c[(d[k]>>4)&3];
            q1[k]=c[(d[k]>>6)&3];
           }
          write(fo0i,i0,N);
          write(fo1i,i1,N);
          write(fo0q,q0,N);
          write(fo1q,q1,N);
         }
      } while (n==N);
   }
 else printf("No input file\n");
}
