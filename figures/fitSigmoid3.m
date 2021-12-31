function [data,fitParams,B2,B3] = fitSigmoid3(eccs, ves, minEcc, maxEcc, binsize, ii, doPlot)

voxelSize=1.77;



data.x    = (minEcc:binsize:maxEcc)';
data.y    = nan(size(data.x));
data.ysterr = nan(2,length(data.x));
data.ysdev    = nan(size(data.x));
data.z    = zeros(size(data.x));

bii=[];

% Determine data for bins
for b=minEcc:binsize:maxEcc,
    %Determine which voxels are in each bin
    bii = eccs >  b-binsize./2 & ...
        eccs <= b+binsize./2 & ii;
    if any(bii),
        
        %Fit which eccentricity bin this corresponds to
        ii2 = find(data.x==b);
        
        s = wstat(ves(bii), ones(size(ves(bii))), voxelSize^2);
        data.ysterr(:,ii2) = s.sterr;
        data.ysdev(ii2) = s.stdev;
        data.y(ii2)=s.mean;
        
    else
        fprintf(1,'[%s]:Warning:No data in eccentricities %.1f to %.1f.\n',...
            mfilename,b-binsize./2,b+binsize./2);
    end;
end;

data.xfit = nan;
data.yfit = nan;
ii = logical(ii);
if exist('bootstrp', 'file')
    %    [B] = bootstrp(1000,@(x) sigmoidFit(x,data.x(data.x>=minEcc & data.x<=maxEcc & ~isnan(data.y) & data.ysterr(1,:)'>0.01),data.y(data.x>=minEcc & data.x<=maxEcc & ~isnan(data.y) & data.ysterr(1,:)'>0.01), ones(size(1./data.ysterr(1,(data.x>=minEcc & data.x<=maxEcc & ~isnan(data.y) & data.ysterr(1,:)'>0.01))))'), [1:sum(data.x>=minEcc & data.x<=maxEcc & ~isnan(data.y) & data.ysterr(1,:)'>0.01)]');
    %    [tmp] = bootstrp(1000,@(x) prfFit(x,data.x2(data.x2>=x2fit(1) & data.x2<=x2fit(2) & ~isnan(data.y2) & data.y2sterr(1,:)'>0.01),data.y2(data.x2>=x2fit(1) & data.x2<=x2fit(2) & ~isnan(data.y2) & data.y2sterr(1,:)'>0.01),1./data.y2sterr(1,(data.x2>=x2fit(1) & data.x2<=x2fit(2) & ~isnan(data.y2) & data.y2sterr(1,:)'>0.01))'),[1:sum(data.x2>=x2fit(1) & data.x2<=x2fit(2) & ~isnan(data.y2) & data.y2sterr(1,:)'>0.01)]');
    ii = ii(1:length(eccs(eccs>=minEcc & eccs<=maxEcc)));
    [B] = bootstrp(1000,@(x) sigmoidFit(x,eccs(eccs>=minEcc & eccs<=maxEcc),ves(eccs>=minEcc & eccs<=maxEcc), ones(size(eccs(eccs>=minEcc & eccs<=maxEcc)))'), [1:length(eccs(eccs>=minEcc & eccs<=maxEcc))]');
    
    
    B2 = B';
    pct1 = 100*0.05/2;
    pct2 = 100-pct1;
    b_lower = prctile(B2',pct1);
    b_upper = prctile(B2',pct2);
    fitParams=prctile(B2', 50);
    
    
    keep1 = B2(1,:)>b_lower(1) &  B2(1,:)<b_upper(1);
    keep2 = B2(2,:)>b_lower(2) &  B2(2,:)<b_upper(2);
    keep = keep1 & keep2;
    xfit = linspace(min(data.x(~isnan(data.y))),max(data.x(~isnan(data.y))),1000)';
    yfit = fitParams(4)-normcdf2(xfit,fitParams(1),fitParams(2)).*(fitParams(4)-fitParams(3));
    xfitR2 = data.x;
    yfitR2 = fitParams(4)-normcdf2(xfitR2,fitParams(1),fitParams(2)).*(fitParams(4)-fitParams(3));
    
    %   [~,pcov] = normlike([fitParams(1),fitParams(2)], xfit);
    %[temp, blo, bup]=normcdf2(xfit,fitParams(1),fitParams(2), cov(data.x(data.x>=minEcc & data.x<=maxEcc & ~isnan(data.y) & data.ysterr(1,:)'>0.01),data.y(data.x>=minEcc & data.x<=maxEcc & ~isnan(data.y) & data.ysterr(1,:)'>0.01)), 0.05);
    
    %     [temp, blo, bup]=normcdf2(xfit,fitParams(1),fitParams(2), pcov, 0.05,'upper');
    %     b_lower=blo.*(fitParams(4)-fitParams(3));
    %     b_upper=bup.*(fitParams(4)-fitParams(3));
    
    keep=find(keep);
    for n=1:length(keep)
        fits(:,n)=B2(4,keep(n))-(normcdf2(xfit,B2(1,keep(n)),B2(2,keep(n))).*(B2(4,keep(n))-B2(3,keep(n))));
        B3(:,n)=B2(:,n);
    end
    
    b_upper = max(fits,[],2);
    b_lower = min(fits,[],2);
    data.b_upper=b_upper;
    data.b_lower=b_lower;
    data.xfit=xfit;
    data.yfit=yfit;
    data.xfitR2=xfitR2;
    data.yfitR2=yfitR2;
end

MarkerSize = 6;
if doPlot
    figure; plot(data.x, data.y, 'ro')
    hold on; errorbar(data.x,data.y,data.ysterr(1,:),data.ysterr(2,:),'ro',...
        'MarkerFaceColor','r',...
        'MarkerSize',MarkerSize);
    hold on; plot(data.xfit, data.yfit, 'r','LineWidth',2);
    hold on; plot(data.xfit, data.b_upper, 'k','LineWidth',1);
    hold on; plot(data.xfit, data.b_lower, 'k','LineWidth',1);
    axis square;
    axis([0 5.5 0 0.8])
end
end

function [B, e]=sigmoidFit(ii,x,y,ve)
x = x(ii); y = y(ii); ve = ve(ii);
options = optimset('MaxFunEvals',10000);
[B, e] = fminsearch(@(z) mysigmoidfit(z,x,y,ve),[1.0;0.2; min(y); max(y)],options);
return
end

function e=mysigmoidfit(z,x,y,ve)
e=sum((y-(z(4)-(normcdf2(x,z(1),z(2)).*(z(4)-z(3))))).^2);
return
end