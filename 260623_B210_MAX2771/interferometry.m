thres=-28;  % threshold (dB)
N=4;        % convolution by 2*N+1 square filter

load('Image_xy.mat');
image2=Image_xy/max(abs(Image_xy(:)));
load('../260530_compare_B210_MAX2771/B210/Image_xy.mat');
image1=Image_xy/max(abs(Image_xy(:)));
k=find(10*log10(abs(image1))<thres);image1(k)=NaN;
k=find(10*log10(abs(image2))<thres);image2(k)=NaN;
dimage=image1./image2;
whos dimage
dimage=conv2(dimage,ones(2*N,2*N)/N/N/4);
dimage=dimage(N:end-N,N:end-N);
whos dimage
h=imagesc(ym,xm,arg(dimage).');axis xy;
colormap(jet);
colorbar;
% set(h, 'AlphaData', 1-isnan(dimage))
