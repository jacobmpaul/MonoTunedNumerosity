%%%%%%%%%%%
%% Fig.4 %%
%%%%%%%%%%%

%Set canvas size and determine position and eccentricity of each pixel
imageSize=768;
halfSize=imageSize/2;
[x,y]=meshgrid(-halfSize:(halfSize-1), -halfSize:(halfSize-1));
[~,r]=cart2pol(x,y);
r=round(r);
powerScale=imageSize^2*sqrt(2); %Allows calculation of a fixed power regardless of image size

dotColor=0; %Black dots
dotCols=[dotColor dotColor dotColor];
backgroundColor=128;
backgroundCols=[backgroundColor backgroundColor backgroundColor];

%Make a window to draw in, with gray background, on an external monitor
AssertOpenGL;
Screen('Preference','SkipSyncTests', 1);
[windowPtr, rect] = Screen('OpenWindow',1,[backgroundColor backgroundColor backgroundColor],[],[],2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For numerosity simulations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numerosities=1:175;
dotSize=16;
recheckDist=2.5; %For up to 175 dots
canvasSize=700;
%Initialize array for aggregate Fourier power in the first harmonic
power1=zeros(size(numerosities));
%And the second harmonic if needed
power2=zeros(size(numerosities));

for numCounter=1:length(numerosities)
    ndots=numerosities(numCounter);
    %Make a set of dot positions
    dotGroup=zeros(ndots,2);
    while length(unique(dotGroup(:,1)))~=ndots
        dotGroup=newDotPattern(ndots,canvasSize, dotSize, recheckDist);
        %It's possible that no good solution is found, so then try again
        if length(unique(dotGroup(:,1)))~=ndots
            disp('regenerating')
        end
    end

    %Make, draw, and retreive the dot pattern. Draw and retrieve in center
    %of display.
    Screen('DrawDots',windowPtr, double(dotGroup'), double(dotSize), double(dotCols), [round(rect(3)/2-canvasSize/2) round(rect(4)/2-canvasSize/2)],3);
    Screen('Flip',windowPtr);
    shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);

    %Re-scale image so background is zero and dots are one
    shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);

    %Get Fourier power in first Harmonic
    [power1(numCounter), power2(numCounter)]=Image2Power2D(shapesImage,r, 5, 0);
end
power1=power1./powerScale;
power2=power2./powerScale;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For item size simulations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dotSizes=1:255;
%Initialize array for aggregate Fourier power in the first harmonic
power1=zeros(size(dotSizes));
%And the second harmonic if needed
power2=zeros(size(dotSizes));
%All dots displayed in centre, always 1 dot
canvasSize=512;
dotGroup=[canvasSize/2, canvasSize/2];

for sizeCounter=1:length(dotSizes)
    dotSize=dotSizes(sizeCounter);
    %Make, draw, and retreive the dot pattern. Draw and retrieve in center
    %of display.
    Screen('DrawDots',windowPtr, double(dotGroup'), double(dotSize), double(dotCols), [round(rect(3)/2-canvasSize/2) round(rect(4)/2-canvasSize/2)],3);
    Screen('Flip',windowPtr);
    shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);

    %Re-scale image so background is zero and dots are one
    shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);

    %Get Fourier power in first Harmonic
    [power1(sizeCounter), power2(sizeCounter)]=Image2Power2D(shapesImage,r, 3,0);
end
power1=power1./powerScale;
power2=power2./powerScale;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For item spacing simulations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
canvasSizes=[50:5:500];
dotSize=16;
ndots=7;

%This relies on random placement more than other simulations, so repeat over several
%cycles to establish a mean and standard deviation
nCycles=18;

% %Initialize array for aggregate Fourier power in the first harmonic
power1=zeros(size(canvasSizes, nCycles));
%And the second harmonic if needed
power2=zeros(size(canvasSizes, nCycles));

for cycle=1:nCycles
    for spacingCounter=1:length(canvasSizes)
        canvasSize=canvasSizes(spacingCounter);
        recheckDist=4*(canvasSize-dotSize/2)/(195-dotSize/2);

        %Choose random dot positions
        dotGroup=zeros(6,2);
        while length(unique(dotGroup(:,1)))~=ndots
            dotGroup=newDotPattern(ndots,canvasSize, dotSize, recheckDist);
            %It's possible that no good solution is found, so then try again
            if length(unique(dotGroup(:,1)))~=ndots
                disp('regenerating')
            end
        end

        %Make, draw, and retreive the dot pattern. Draw and retrieve in center
        %of display.
        Screen('DrawDots',windowPtr, double(dotGroup'), double(dotSize), double(dotCols), [round(rect(3)/2-canvasSize/2) round(rect(4)/2-canvasSize/2)],3);
        Screen('Flip',windowPtr);
        shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);

        %Re-scale image so background is zero and dots are one
        shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);

        %Get Fourier power in first Harmonic
        [power1(spacingCounter, cycle), power2(spacingCounter, cycle)]=Image2Power2D(shapesImage,r, 5, 0);
    end
end
power1=power1./powerScale;
power2=power2./powerScale;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For item contrast and contrast range simulations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blackAndWhite=0;
normalizedByMeanContrast=1;
contrastRange=1; %Change contrast (0) or RANGE of contrasts (1)
canvasSize=256;
dotSize=16;
ndots=7;
if contrastRange
    contrasts=0:1/64:1;
else
    contrasts=[1/128:1/128:1];
end
nCycles=1;

power1=[];
power2=[];

for cycle=1:nCycles
    for contrastCounter=1:length(contrasts)
        recheckDist=4*(canvasSize-dotSize/2)/(195-dotSize/2); %176=1
        dotGroup=zeros(6,2);
        while length(unique(dotGroup(:,1)))~=ndots
            dotGroup=newDotPattern(ndots,canvasSize, dotSize, recheckDist);
            if length(unique(dotGroup(:,1)))~=ndots
                disp('regenerating')
            end
        end
        if contrastRange
            dotColsStart=0.5+(rand(size(dotGroup, 1), 1)*contrasts(contrastCounter)-contrasts(contrastCounter)/2);
        else
            dotColsStart=contrasts(contrastCounter);
        end
        if blackAndWhite==1
            dotSign=round(rand(size(dotGroup, 1), 1)).*2-1; %Random black and white mix
        else
            dotSign=0-ones(size(dotGroup, 1), 1); %Black only
        end
        dotCols=dotColsStart.*dotSign.*128+128;
        dotCols=repmat(dotCols, [1,3])';

        Screen('DrawDots',windowPtr, double(dotGroup'), double(dotSize), double(dotCols), [round(rect(3)/2-canvasSize/2) round(rect(4)/2-canvasSize/2)],3);
        Screen('Flip',windowPtr);
        shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);

        %Re-scale image so background is zero and full contrast dots are one
        shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);

        if normalizedByMeanContrast
            shapesImage=shapesImage./mean(dotColsStart);
        end

        %Get Fourier power in first Harmonic
%         [power1(contrastCounter, cycle)]=Image2Power2D(shapesImage,r, 5, 0);
    end
end
power1=power1./powerScale;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For item shapes. The procedure here is rather different because the shapes %
% are not circular symeterical, so power must be computer separaately in     %
% each orientation and the frequency of the first harmonic differs between   %
% orientations.                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stars=1; %1 for stars with nCorners points, 0 for polygons with nCorners sides
dist=30; % %Distance to corners in pixels
shapeCentre=[imageSize/2, imageSize/2]; %Centre position
power1=[];

for nCorners=3:10
    %When nCorners is 2, this is a circle
    
    %Corner (polygon) and point (star) angles around the centre point
    angles=linspace(0, 2*pi, nCorners+1);
    angles=angles(1:(end-1));
    if stars %Inner corner angles
        starAngles=linspace(angles(2)/2, 2*pi+angles(2)/2, nCorners+1);
        starAngles=starAngles(1:(end-1));
    end
    
    %Number of rotation steps: the edge of the image rotates by a pixel
    %in each step
    nSteps=round(halfSize*2*pi);
    stepAngles=linspace(0, 2*pi, nSteps+1);
    stepAngles=stepAngles(1:(end-1));
    
    fourierLinesAll=zeros(halfSize, size(stepAngles, 2));
    fourierMin=zeros(1, length(stepAngles));
    for step=1:length(stepAngles)
        %Here the shape is rotated, effectively rotating which orientation
        %is measured in the Fourier power distribution.
        %Calculate the positions of the corners of the rotated shape.
        rotAngles=angles+stepAngles(step);
        cornersX=dist*cos(rotAngles)+shapeCentre(1);
        cornersY=dist*sin(rotAngles)+shapeCentre(2);
        if stars %Also calculate the positions of the inner corners
            rotAngles=starAngles+stepAngles(step);
            cornersXstar=dist/3*cos(rotAngles)+shapeCentre(1);
            cornersYstar=dist/3*sin(rotAngles)+shapeCentre(2);
            cornersX=[cornersX; cornersXstar]; %Alternate inner corners and points
            cornersX=cornersX(:)';
            cornersY=[cornersY; cornersYstar];
            cornersY=cornersY(:)';
        end
        
        if nCorners==2
            %Draw a circle
            Screen('DrawDots',windowPtr, double(shapeCentre'), double(dist*2), double(dotCols), [round(rect(3)/2-imageSize/2) round(rect(4)/2-imageSize/2)],3);
        else
            Screen('FillPoly', windowPtr, double(dotCols), [cornersX+round(rect(3)/2-imageSize/2); cornersY+round(rect(4)/2-imageSize/2)]', 0);
        end
        Screen('Flip',windowPtr);
        
        shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);
        
        %Re-scale image so background is zero and full contrast dots are one
        shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);
        
        %Now we will make a mask of the edge of the first harmonic in
        %different orientations
        fourierImg     = abs(single(fftshift(fft2(shapesImage))));
        fourierLine=fourierImg(halfSize+1,(halfSize+2):end); %This is like the usual 'ring' (in Image2Power2D.m) but using a single orientation: horizontal
        
        
        [maxVal, maxPos]=max(fourierLine);
        
        %For shapes with odd number of corners, it is harder to find the
        %edge of the second harmonic. This is a change in the curvature of
        %the spectrum, rather than a local minimum, so is found in the second
        %derivative.
        deriv1=[diff(fourierLine)];
        deriv1(1:maxPos)=-1;
        whichMin1=find(deriv1>0, 1);
        
        deriv2=diff(diff((fourierLine)));
        deriv2(1:find(deriv2>0, 1))=0;
        whichMin2=find(deriv2<0, 1)+1;
        whichMin=min([whichMin1, whichMin2]);
        fourierLine((whichMin+1):end)=0;
        
        fourierMin(step)=whichMin;
    end
    
    
    %Then we we make a mask of which fft points fall inside
    %the harmonic at each angle. Start by making fourier
    %image at angle zero
    rotAngles=angles;
    cornersX=dist*cos(rotAngles)+shapeCentre(1);
    cornersY=dist*sin(rotAngles)+shapeCentre(2);
    if stars
        rotAngles=starAngles;
        cornersXstar=dist/3*cos(rotAngles)+shapeCentre(1);
        cornersYstar=dist/3*sin(rotAngles)+shapeCentre(2);
        cornersX=[cornersX; cornersXstar];
        cornersX=cornersX(:)';
        cornersY=[cornersY; cornersYstar];
        cornersY=cornersY(:)';
    end
    
    if nCorners==2
        %Draw a circle
        Screen('DrawDots',windowPtr, double(shapeCentre'), double(dist*2), double(dotCols), [round(rect(3)/2-canvasSize/2) round(rect(4)/2-canvasSize/2)],3);
    else
        Screen('FillPoly', windowPtr, double(dotCols), [cornersX+round(rect(3)/2-imageSize/2); cornersY+round(rect(4)/2-imageSize/2)]', 0);
    end
    Screen('Flip',windowPtr);
    
    shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);
    
    %Re-scale image so background is zero and shapes are one
    shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);
    
    %Now we will make a mask of the edge of the first harmonic in
    %different orientations
    fourierImg     = abs(single(fftshift(fft2(shapesImage))));
    
    mask=zeros(size(fourierImg));
    xborder=zeros(1,length(stepAngles)+1);
    yborder=xborder;
    for step=1:length(stepAngles)
        [xmask,ymask]=pol2cart(stepAngles(step), 1:(fourierMin(step)-1));
        xborder(step)=(xmask(end)+halfSize)+1;
        yborder(step)=(ymask(end)+halfSize)+1;
        xmask=round(xmask+halfSize)+1;
        ymask=round(ymask+halfSize)+1;
        mask(xmask, ymask)=1;
    end
    xborder(end)=xborder(1); %To close the loop
    yborder(end)=yborder(1);
    
    power1(nCorners)=sum(sum(fourierImg.*mask));
end
power1=power1./powerScale;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For connected pairs of dots %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dotSize=30;
lineWidth=4;
offsetAngle=0; %This can be done at any angle between dots, but 0 (horizontally offset) generalises to other angles.

for connected=1:6 %1 for unconnected dots, 2 for dots with separate bar rotated 90 degrees, 3 for dots connected with bar, 4 for dots connected with illusory contour, 5 for split rotated connector bar, 6 for split rotated illusory contour.
    for dist=dotSize:(dotSize+100) %Distance between dots, centre to centre. Start with dot edges touching
        dotGroup=[];
        dotGroupOrig=[imageSize/2-cosd(offsetAngle)*dist/2, imageSize/2-sind(offsetAngle)*dist/2; imageSize/2+cosd(offsetAngle)*dist/2, imageSize/2+sind(offsetAngle)*dist/2];
        shapeCentre=[round(rect(3)/2) round(rect(4)/2)];
        dotGroupCentered=dotGroupOrig-repmat([imageSize/2, imageSize/2], [size(dotGroupOrig,1),1]);
        
        dotGroup(:,1)=dotGroupCentered(:,1)+shapeCentre(1);
        dotGroup(:,2)=dotGroupCentered(:,2)+shapeCentre(2);
        Screen('DrawDots',windowPtr, dotGroup', dotSize, double(dotCols), [],3);
        
        if connected==2
            connectorCentered=[dotGroupCentered(1,:)+[dotSize/2 0];dotGroupCentered(1,:)+[dotSize/2 0];dotGroupCentered(2,:)-[dotSize/2 0];dotGroupCentered(2,:)-[dotSize/2 0]];
            connectorCentered=[connectorCentered(:,2) connectorCentered(:,1)];
            connectorCentered(:,1)=connectorCentered(:,1)+[lineWidth/2; -lineWidth/2;- lineWidth/2; lineWidth/2];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(dotCols), connector,1);
        elseif connected==3
            %connector coordinates
            connectorCentered=[dotGroupCentered(1,:);dotGroupCentered(1,:);dotGroupCentered(2,:);dotGroupCentered(2,:)];
            connectorCentered(:,2)=connectorCentered(:,2)+[lineWidth/2; -lineWidth/2;- lineWidth/2; lineWidth/2];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(dotCols), connector,1);
        elseif connected==4
            %connector coordinates
            dotGroupOrig=[imageSize/2-cosd(offsetAngle)*(dist/2-dotSize/6), imageSize/2-sind(offsetAngle)*(dist/2-dotSize/6); imageSize/2+cosd(offsetAngle)*(dist/2-dotSize/6), imageSize/2+sind(offsetAngle)*(dist/2-dotSize/6)];
            dotGroupCentered=dotGroupOrig-repmat([imageSize/2, imageSize/2], [size(dotGroupOrig,1),1]);
            connectorCentered=[dotGroupCentered(1,:);dotGroupCentered(1,:);dotGroupCentered(2,:);dotGroupCentered(2,:)];
            connectorCentered(:,2)=connectorCentered(:,2)+[lineWidth/2; -lineWidth/2;- lineWidth/2; lineWidth/2];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(backgroundCols), connector,1);
        elseif connected==5
            %connector coordinates at 90 deg
            connector1start=[imageSize/2-(dist/2)-lineWidth/2, imageSize/2+dotSize/6; imageSize/2-(dist/2)-lineWidth/2, imageSize/2+dist/2];
            dotGroupCentered=connector1start-repmat([imageSize/2, imageSize/2], [size(dotGroupOrig,1),1]);
            connectorCentered=[dotGroupCentered(1,:);dotGroupCentered(1,:);dotGroupCentered(2,:);dotGroupCentered(2,:)];
            connectorCentered(:,1)=connectorCentered(:,1)+[0; lineWidth; lineWidth; 0];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(dotCols), connector,1);
            connector1start=[imageSize/2+(dist/2)-lineWidth/2, imageSize/2-dotSize/6; imageSize/2+(dist/2)-lineWidth/2, imageSize/2-dist/2];
            dotGroupCentered=connector1start-repmat([imageSize/2, imageSize/2], [size(dotGroupOrig,1),1]);
            connectorCentered=[dotGroupCentered(1,:);dotGroupCentered(1,:);dotGroupCentered(2,:);dotGroupCentered(2,:)];
            connectorCentered(:,1)=connectorCentered(:,1)+[0; lineWidth; lineWidth; 0];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(dotCols), connector,1);
        elseif connected==6
            %connector coordinates at 90 deg
            connector1start=[imageSize/2-(dist/2)-lineWidth/2, imageSize/2+dotSize/6; imageSize/2-(dist/2)-lineWidth/2, imageSize/2+dist/2];
            dotGroupCentered=connector1start-repmat([imageSize/2, imageSize/2], [size(dotGroupOrig,1),1]);
            connectorCentered=[dotGroupCentered(1,:);dotGroupCentered(1,:);dotGroupCentered(2,:);dotGroupCentered(2,:)];
            connectorCentered(:,1)=connectorCentered(:,1)+[0; lineWidth; lineWidth; 0];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(backgroundCols), connector,1);
            connector1start=[imageSize/2+(dist/2)-lineWidth/2, imageSize/2-dotSize/6; imageSize/2+(dist/2)-lineWidth/2, imageSize/2-dist/2];
            dotGroupCentered=connector1start-repmat([imageSize/2, imageSize/2], [size(dotGroupOrig,1),1]);
            connectorCentered=[dotGroupCentered(1,:);dotGroupCentered(1,:);dotGroupCentered(2,:);dotGroupCentered(2,:)];
            connectorCentered(:,1)=connectorCentered(:,1)+[0; lineWidth; lineWidth; 0];
            connector(:,1)=connectorCentered(:,1)+shapeCentre(1);
            connector(:,2)=connectorCentered(:,2)+shapeCentre(2);
            Screen('FillPoly', windowPtr, double(backgroundCols), connector,1);
        end
        Screen('Flip',windowPtr);
        
        shapesImage=Screen('GetImage', windowPtr, [rect(3)/2-halfSize rect(4)/2-halfSize rect(3)/2+halfSize rect(4)/2+halfSize]);

        %Re-scale image so background is zero and dots are one
        shapesImage=(backgroundColor-single(shapesImage(:,:,1)))./(backgroundColor-dotColor);

        %Get Fourier power in first Harmonic
        [power1(connected, dist)]=Image2Power2D(shapesImage,r, 5, 1);
        
        %Get response of Dakin model. This is slow, and produces the data in
        %Figure S12e
        %DakinResponse(connected,dist)=DakinFilter(shapesImage, 2)/DakinFilter(shapesImage, 23);
    end
end

power1=power1./powerScale;
