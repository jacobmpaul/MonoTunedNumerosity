%%%%%%%%%%%%%
%% Fig.S12 %%
%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Responses of Dakin and colleagues’ high spatial frequency filter response metric %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% S. C. Dakin, M. S. Tibber, J. A. Greenwood, F. A. A. Kingdom, M. J. Morgan, A common visual metric for approximate number and density. Proc. Natl. Acad. Sci. U. S. A. 108, 19552–19557 (2011)

load('StimulusImages.mat');

% Rescale stimulus images from 0 to 1, assuming dots are black (0, NOT white) and
% background is gray (128) and we want dots at 1 and background at 0.
ConstantTotalArea.images(ConstantTotalArea.images>128)=255-ConstantTotalArea.images(ConstantTotalArea.images>128);
ConstantTotalArea.images=((128-single(ConstantTotalArea.images))/128);
ConstantTotalArea.images=1-ConstantTotalArea.images;

ConstantItemSize.images(ConstantItemSize.images>128)=255-ConstantItemSize.images(ConstantItemSize.images>128);
ConstantItemSize.images=((128-single(ConstantItemSize.images))/128);
ConstantItemSize.images=1-ConstantItemSize.images;

ConstantTotalPerimeter.images(ConstantTotalPerimeter.images>128)=255-ConstantTotalPerimeter.images(ConstantTotalPerimeter.images>128);
ConstantTotalPerimeter.images=((128-single(ConstantTotalPerimeter.images))/128);
ConstantTotalPerimeter.images=1-ConstantTotalPerimeter.images;

HighDensity.images(HighDensity.images>128)=255-HighDensity.images(HighDensity.images>128);
HighDensity.images=((128-single(HighDensity.images))/128);
HighDensity.images=1-HighDensity.images;

maxFilterSF=100;
% This block takes time, so is limited to 12 examples of each numerosity and configuration
whichImages=[1:48 67:114];
response=zeros(max(whichImages), 4, maxFilterSF);
imageRadius=100; %It's much faster just to look in the part of the image where the dots area, and the total response is identical.
imageArea=(size(HighDensity.images, 1)./2-100):(size(HighDensity.images, 1)/2+99); %#ok<BDSCA>
for imNum=whichImages
    for filterSF=1:maxFilterSF
        [response(imNum, 1, filterSF)]=DakinFilter(ConstantTotalArea.images(imageArea,imageArea,imNum), filterSF);
    end
end
for imNum=whichImages
    for filterSF=1:maxFilterSF
        [response(imNum, 2, filterSF)]=DakinFilter(ConstantItemSize.images(imageArea,imageArea,imNum), filterSF);
    end
end
for imNum=whichImages
    for filterSF=1:maxFilterSF
        [response(imNum, 3, filterSF)]=DakinFilter(ConstantTotalPerimeter.images(imageArea,imageArea,imNum), filterSF);
    end
end
for imNum=whichImages
    for filterSF=1:maxFilterSF
        [response(imNum, 4, filterSF)]=DakinFilter(HighDensity.images(imageArea,imageArea,imNum), filterSF);
    end
end

% Numerosity of each image
ImageNumerosity=ConstantTotalArea.imageNumerosity(whichImages);
ImageNumerosity=repmat(ImageNumerosity, [1,4]); %#ok<NASGU>

% Define part of image to evaluate
% From 768*768 images
imSize=768;
halfSize=imSize/2;

% Define x, y and eccentricity
[x,y]=meshgrid(-halfSize:(halfSize-1), -halfSize:(halfSize-1));
[~,r]=cart2pol(x,y);
r=round(r);
mask=r>(halfSize-1);

% Determine scale to normalize power by to compensate for resolution
PowerNormalizer=imSize.^2*sqrt(2);

% Make dotOrder for all cycles (3 repeats per TR, 8 cycles of images recorded)
ImageNumerosity=repmat(ConstantTotalArea.imageNumerosity, [3,8]);
ImageNumerosity=ImageNumerosity(:);

% Determine power in first and second harmonics, for each stimulus configuration
for patternCounter=1:size(ConstantTotalArea.images, 3)
    
    % Examples of this variable 'fourierImg' are shown in Figure 3a
    fourierImg = abs(single(fftshift(fft2(ConstantTotalArea.images(:,:,patternCounter)))));
    
    ring=zeros(1, halfSize-1);
    for ecc=1:halfSize-1
        ring(ecc)=sum(fourierImg(r==ecc));
    end
    % Examples of this variable 'ring' are shown in Figure 3b

    [maxVal, maxPos]=max(ring);
    interp=(ring+[ring(end-1:end) ring(1:end-2)]+[ring(end) ring(1:end-1)]+[ring(2:end) ring(1)]+[ring(3:end) ring(1:2)])/5;
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin=tmp(find(tmp>maxPos, 1));
    ConstantTotalArea.fftSumToMin(patternCounter)=sum(ring(1:whichMin));
    
    % 2nd harmonic
    ring(1:whichMin-1)=0;
    [maxVal, maxPos]=max(ring);
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin2=tmp(find(tmp>maxPos, 1));
    try
        ConstantTotalArea.fftSumToMin2(patternCounter)=sum(ring(whichMin+1:whichMin2));
    catch
        ConstantTotalArea.fftSumToMin2(patternCounter)=nan;
    end
end

for patternCounter=1:size(ConstantItemSize.images, 3)
    
    % Examples of this variable 'fourierImg' are shown in Figure 3a
    fourierImg = abs(single(fftshift(fft2(ConstantItemSize.images(:,:,patternCounter)))));%./im2deg^2;
    
    ring=zeros(1, halfSize-1);
    for ecc=1:halfSize-1
        ring(ecc)=sum(fourierImg(r==ecc));
    end
    % Examples of this variable 'ring' are shown in Figure 3b
    
    [maxVal, maxPos]=max(ring);
    interp=(ring+[ring(end-1:end) ring(1:end-2)]+[ring(end) ring(1:end-1)]+[ring(2:end) ring(1)]+[ring(3:end) ring(1:2)])/5;
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin=tmp(find(tmp>maxPos, 1));
    ConstantItemSize.fftSumToMin(patternCounter)=sum(ring(1:whichMin));
    %2nd harmonic
    ring(1:whichMin-1)=0;
    [maxVal, maxPos]=max(ring);
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin2=tmp(find(tmp>maxPos, 1));
    try
        ConstantItemSize.fftSumToMin2(patternCounter)=sum(ring(whichMin+1:whichMin2));
    catch
        ConstantItemSize.fftSumToMin2(patternCounter)=nan;
    end
end

for patternCounter=1:size(ConstantTotalPerimeter.images, 3)
    
    % Examples of this variable 'fourierImg' are shown in Figure 3a
    fourierImg = abs(single(fftshift(fft2(ConstantTotalPerimeter.images(:,:,patternCounter)))));%./im2deg^2;
    
    ring=zeros(1, halfSize-1);
    for ecc=1:halfSize-1
        ring(ecc)=sum(fourierImg(r==ecc));
    end
    % Examples of this variable 'ring' are shown in Figure 3b
    
    [maxVal, maxPos]=max(ring);
    interp=(ring+[ring(end-1:end) ring(1:end-2)]+[ring(end) ring(1:end-1)]+[ring(2:end) ring(1)]+[ring(3:end) ring(1:2)])/5;
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin=tmp(find(tmp>maxPos, 1));
    ConstantTotalPerimeter.fftSumToMin(patternCounter)=sum(ring(1:whichMin));
    
    %2nd harmonic
    ring(1:whichMin-1)=0;
    [maxVal, maxPos]=max(ring);
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin2=tmp(find(tmp>maxPos, 1));
    try
        ConstantTotalPerimeter.fftSumToMin2(patternCounter)=sum(ring(whichMin+1:whichMin2));
    catch
        ConstantTotalPerimeter.fftSumToMin2(patternCounter)=nan;
    end
end

for patternCounter=1:size(HighDensity.images, 3)

    % Examples of this variable 'fourierImg' are shown in Figure 3a
    fourierImg = abs(single(fftshift(fft2(HighDensity.images(:,:,patternCounter)))));%./im2deg^2;
    
    ring=zeros(1, halfSize-1);
    for ecc=1:halfSize-1
        ring(ecc)=sum(fourierImg(r==ecc));
    end
    % Examples of this variable 'fourierImg' are shown in Figure 3a
    
    [maxVal, maxPos]=max(ring);
    interp=(ring+[ring(end-1:end) ring(1:end-2)]+[ring(end) ring(1:end-1)]+[ring(2:end) ring(1)]+[ring(3:end) ring(1:2)])/5;
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin=tmp(find(tmp>maxPos, 1));
    HighDensity.fftSumToMin(patternCounter)=sum(ring(1:whichMin));
    
    %2nd harmonic
    ring(1:whichMin-1)=0;
    [maxVal, maxPos]=max(ring);
    tmp=find((diff([interp 0])>0 & ring<maxVal/5));
    whichMin2=tmp(find(tmp>maxPos, 1));
    try
        HighDensity.fftSumToMin2(patternCounter)=sum(ring(whichMin+1:whichMin2));
    catch
        HighDensity.fftSumToMin2(patternCounter)=nan;
    end
end

%Calculate mean and standard deviation of power for each numerosity in each stimulus configuration
ndots=[1 2 3 4 5 6 7 20];
for n=1:length(ndots)
    ConstantTotalArea.meanSumToMin(n)=mean(ConstantTotalArea.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    ConstantTotalArea.sdSumToMin(n)=std(ConstantTotalArea.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    ConstantTotalArea.meanSumToMin2(n)=mean(ConstantTotalArea.fftSumToMin2(ImageNumerosity==ndots(n) & ConstantTotalArea.fftSumToMin2'>0))./PowerNormalizer;
    ConstantTotalArea.sdSumToMin2(n)=std(ConstantTotalArea.fftSumToMin2(ImageNumerosity==ndots(n) & ConstantTotalArea.fftSumToMin2'>0))./PowerNormalizer;
end

for n=1:length(ndots)
    ConstantItemSize.meanSumToMin(n)=mean(ConstantItemSize.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    ConstantItemSize.sdSumToMin(n)=std(ConstantItemSize.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    ConstantItemSize.meanSumToMin2(n)=mean(ConstantItemSize.fftSumToMin2(ImageNumerosity==ndots(n) & ConstantItemSize.fftSumToMin2'>0))/PowerNormalizer;
    ConstantItemSize.sdSumToMin2(n)=std(ConstantItemSize.fftSumToMin2(ImageNumerosity==ndots(n) & ConstantItemSize.fftSumToMin2'>0))/PowerNormalizer;
end

for n=1:length(ndots)
    ConstantTotalPerimeter.meanSumToMin(n)=mean(ConstantTotalPerimeter.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    ConstantTotalPerimeter.sdSumToMin(n)=std(ConstantTotalPerimeter.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    ConstantTotalPerimeter.meanSumToMin2(n)=mean(ConstantTotalPerimeter.fftSumToMin2(ImageNumerosity==ndots(n) & ConstantTotalPerimeter.fftSumToMin2'>0))/PowerNormalizer;
    ConstantTotalPerimeter.sdSumToMin2(n)=std(ConstantTotalPerimeter.fftSumToMin2(ImageNumerosity==ndots(n) & ConstantTotalPerimeter.fftSumToMin2'>0))/PowerNormalizer;
end

for n=1:length(ndots)
    HighDensity.meanSumToMin(n)=mean(HighDensity.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    HighDensity.sdSumToMin(n)=std(HighDensity.fftSumToMin(ImageNumerosity==ndots(n)))/PowerNormalizer;
    HighDensity.meanSumToMin2(n)=mean(HighDensity.fftSumToMin2(ImageNumerosity==ndots(n) & HighDensity.fftSumToMin2'>0))/PowerNormalizer;
    HighDensity.sdSumToMin2(n)=std(HighDensity.fftSumToMin2(ImageNumerosity==ndots(n) & HighDensity.fftSumToMin2'>0))/PowerNormalizer;
end

% Plot the result, FIGURE 3C
ndots8=[1 2 3 4 5 6 7 8];
figure; 
hold on; plot(ndots8(1:7), ConstantTotalArea.meanSumToMin(1:7), 'r');
hold on; plot(ndots8(1:7), ConstantItemSize.meanSumToMin(1:7), 'g');
hold on; plot(ndots8(1:7), ConstantTotalPerimeter.meanSumToMin(1:7), 'b');
hold on; plot(ndots8(1:7), HighDensity.meanSumToMin(1:7), 'm');
hold on; errorbar(ndots8, ConstantTotalArea.meanSumToMin,ConstantTotalArea.sdSumToMin, 'ro');
hold on; errorbar(ndots8, ConstantItemSize.meanSumToMin,ConstantItemSize.sdSumToMin, 'go');
hold on; errorbar(ndots8, ConstantTotalPerimeter.meanSumToMin,ConstantTotalPerimeter.sdSumToMin, 'bo');
hold on; errorbar(ndots8, HighDensity.meanSumToMin,HighDensity.sdSumToMin, 'mo');
hold on; plot(ndots8(1:7), ConstantTotalArea.meanSumToMin2(1:7), 'r');
hold on; plot(ndots8(1:7), ConstantItemSize.meanSumToMin2(1:7), 'g');
hold on; plot(ndots8(1:7), ConstantTotalPerimeter.meanSumToMin2(1:7), 'b');
hold on; plot(ndots8(1:7), HighDensity.meanSumToMin2(1:7), 'm');
hold on; errorbar(ndots8, ConstantTotalArea.meanSumToMin2,ConstantTotalArea.sdSumToMin2, 'ro');
hold on; errorbar(ndots8, ConstantItemSize.meanSumToMin2,ConstantItemSize.sdSumToMin2, 'go');
hold on; errorbar(ndots8, ConstantTotalPerimeter.meanSumToMin2,ConstantTotalPerimeter.sdSumToMin2, 'bo');
hold on; errorbar(ndots8, HighDensity.meanSumToMin2,HighDensity.sdSumToMin2, 'mo');

axis([0.5 8.5 0 4])
axis square
xlabel('Numerosity')
ylabel('Fourier power')
set(gca, 'XTick', [1:8])
set(gca, 'XTickLabel', [1:7 20])

% Save mean power for monotonic and tuned models

% Linear response model
load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=ConstantTotalArea.meanSumToMin(n);
end
save('params_PowerArea.mat', 'params')

load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=ConstantItemSize.meanSumToMin(n);
end
save('params_PowerSize.mat', 'params')

load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=ConstantTotalPerimeter.meanSumToMin(n);
end
save('params_PowerCirc.mat', 'params')

load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=HighDensity.meanSumToMin(n);
end
save('params_PowerDense.mat', 'params')

% For log response models, add 1 to result to avoid crossing zero
load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=log(ConstantTotalArea.meanSumToMin(n))+1;
end
save('params_LogPowerArea.mat', 'params')

load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=log(ConstantItemSize.meanSumToMin(n))+1;
end
save('params_LogPowerSize.mat', 'params')

load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=log(ConstantTotalPerimeter.meanSumToMin(n))+1;
end
save('params_LogPowerCirc.mat', 'params')

load('params_NumbersArea.mat')
for n=1:length(ndots)
    params.dotOrder(params.dotOrder==ndots(n))=log(HighDensity.meanSumToMin(n))+1;
end
save('params_LogPowerDense.mat', 'params')



function [responseLow] = DakinFilter(imageIn,filterSF, normalVol)
%ImageIn needs zeros in the background, ones on the item
%NormalizeVolume normalizes the filter's amplitude by the volume under the 
%filter's curve. This only matters if comparing the outputs of different filters, 
%otherwise if is just a constant scaling factor.

if ~exist('normalVol', 'var')
    normalVol=1;
end

filterSize=filterSF*5;
x=-filterSize:1:filterSize;
y=-filterSize:1:filterSize;
filterImg=zeros([length(x), length(y)]);

for xind=1:length(x)
    for yind=1:length(y)
        filterImg(xind, yind)=(1-(x(xind)^2+y(yind)^2)/(2*filterSF^2))*exp(-(x(xind)^2+y(yind)^2)/(2*filterSF^2));
    end
end

if normalVol==1
    filterImg=filterImg.*(1/(pi*filterSF^4));
end

filteredImg=conv2(imageIn, filterImg);
responseLow=sum(filteredImg(:));

end
