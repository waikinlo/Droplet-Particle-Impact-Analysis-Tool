%% Condition without a needle
close all
clear all
Frame_Rate=1000;
pixcelsize=0.1;
Width_of_needle=100;
Radius_of_ball=[50 150];
Radius_of_Droplet=[200 250]
AD_line_num=50;
bool=0;
boolH=0;
break_i=0;
breakB1=0;
breakB2=0;
[fileD,pathD,indxD]=uigetfile('*.wmv','./','Please select the droplet video')
[fileR,pathR,indxR]=uigetfile('*.wmv',pathD,'Please select the scale bar video file')

vidx=VideoReader([pathR fileR])
pixcelsize=get_pixcelSize(vidx);
vid=VideoReader([pathD fileD])
N=vid.NumberOfFrames;
im = read(vid,1);
figure,imshow(im,[])
[centers, radii, metric] = imfindcircles(im(:,:,1),Radius_of_ball,'ObjectPolarity','dark','Sensitivity',0.96);
centers=centers(1,:);
radii=radii(1);
viscircles(centers, radii,'EdgeColor','b');
L=imsegkmeans(im(:,:,1),2);
figure,imshow(L,[])
figure,imshow(L==1)
imB=L==1;
imBf=imfill(imB,'holes');
figure,imshow(imBf)
% Get the droplet area/location
imBfo=imopen(imBf,strel('disk',Width_of_needle));
imBfo=findLargeBlock_2D(imBfo,4);
figure,imshow(imBfo)
S=regionprops(imBfo);
[centersd, radiid, metricd] = imfindcircles(imBfo,Radius_of_Droplet,'ObjectPolarity','bright','Sensitivity',0.96);
viscircles(centersd, radiid,'EdgeColor','b');
%Specify a mirror point；
limitY=round(centers(1,2)+radii(1));



for i=1:N
    im = read(vid,i);
    
    L=imsegkmeans(im(:,:,1),2);
    figure(99),imshow(L,[])
    
    L(limitY:end,:)=0;
    mean_G=[];
    for bi=1:2
        All_A(bi)=sum(sum(L==bi));
        All_G(bi)=sum(sum(double(im(:,:,1)).*(double(L==bi))));
        mean_G(bi)= All_G(bi)/ All_A(bi);
    end
    %Select the cluster with the lowest mean grayscale intensity
    [V,III]=sort(mean_G,'descend');
    imB=L==III(2);
    imBf=imfill(imB,'holes');
    imBfpartN=imopen(imBf,strel('disk',round(Width_of_needle/5)));
    imBfpartN=bwareaopen(imBfpartN,round(pi/2*radii(1)^2),4);
    [~,n]=bwlabel(imBfpartN,8);
    SX=regionprops(imBfpartN);
    % figure,imshow(imBfpartN)
    P_n(i)=size(SX,1);
    u=[];
    for j=1:P_n(i)
        u(j)=SX(j).BoundingBox(2)+SX(j).BoundingBox(4);
    end
    u=sort(u);
    P_maxY(i)=max(u);
%         P_maxY1(i)=u;
        P_NmaxY(i)=u(1);

%     if length(u)>1
%     else
%         P_NmaxY(i)=0;
%     end

    %  figure,imshow(imBfpartN)
    % Get the droplet area/location
    imBfo=imopen(imBf,strel('disk',Width_of_needle));
    if sum(sum(imBfo))>0
    imBfo=findLargeBlock_2D(imBfo,4);
    %         figure,imshow(imBfo)
    S=regionprops(imBfo);
    Pend(i)=S(1).BoundingBox(2)+S(1).BoundingBox(4);
    P_c(i)=S(1).Centroid(2);
    
    [centersd, radiid, metricd] = imfindcircles(imBfo,Radius_of_Droplet,'ObjectPolarity','bright','Method','TwoStage','Sensitivity',0.99);
    if ~isempty(centersd)
    Pcentersd(i,:)=centersd(2);
    viscircles(centersd(1,:), radiid(1),'EdgeColor','b');
    viscircles(centers, radii,'EdgeColor','c');
    end
%     radiido=radiid;
%     radiio=radii;
%     centersdo=centersd;
%     centerso=centers;

    if i>1
        
        if P_n(i-1)-P_n(i)==1||bool
            bool=1;
            if P_n(i-1)-P_n(i)==1
            %% Analyze the particle size at the moment of contact
                figure(98),imshow(im(:,:,1),[])
                viscircles(centersd, radiid,'EdgeColor','b');
                viscircles(centers, radii,'EdgeColor','c');
                %Droplet size
                V1.Droplet_Area_T0=pi*(radiid(1)*pixcelsize)^2;
                V1.Droplet_Radii_T0=radiid*pixcelsize;
                V1.Ball_Area_T0=pi*(radii*pixcelsize)^2;
                V1.Ball_Radii_T0=radii*pixcelsize;            
                 %Eccentricity (offset distance)
                V1.eccentricD_T0=(centersd(1)-centers(1)*pixcelsize);
                %Instantaneous velocity
            %                 (Pcentersd(i-2)-Pcentersd(i-3))*pixcelsize*Frame_Rate
            V1.Droplet_V_T0=(P_NmaxY(i-2)-P_NmaxY(i-1))*pixcelsize*Frame_Rate;
            end
            
            P_maxYSum(i)=sum(P_maxY(i-5:i-1)-P_maxY(i));
            
            
            
            
            
            if(sum(P_maxY(i-5:i-1)-P_maxY(i))<-80)||boolH
                boolH=1;
                if (limitY-P_maxY(i))<3||sum(P_maxY(i-5:i-1)-P_maxY(i))>-20
                    break_i=break_i+1;
                    if break_i==3
                        Hend=i;
                        breakB1=1;
                    end
                    if sum(Pend(i-5:i-1)-Pend(i))<0&&breakB2==0
                                                breakB2=1;

                    end
                    if breakB1&&breakB2
                        break;
                    end
                end
            end
            
        end
        
    end
    
    end
end
%%The lowest-coordinate point of the droplet, or of the droplet–particle system
figure,plot(Pend)
%%The lowest-coordinate point of the fitted circle center for the droplet, or for the droplet–particle system

figure,plot(Pcentersd(:,1))
%%Number of segmented regions in the image
figure,plot(P_n)
%%Location of the lowest point in the image
figure,plot(P_maxY)
%%Starting point of the droplet
s1x=find(diff(P_n)>0);
s1=min(s1x);
s2=max(s1x);
if(isempty(s1))
    s1=1;
end
%%Point where the droplet contacts the particle
e1x=find(diff(P_n)<0)+1;
e1=min(e1x);
e2=max(e1x);

if P_n(1)==2
   s1=1;
   
    
end
%%Image of the droplet starting point
% figure,imshow(read(vid,s1+2))
%%Image of the droplet–particle contact point
% figure,imshow(read(vid,e1))
%% Highest-point location and its frame index
[maxd,dI]=min(P_maxY);

% figure,plot(diff(P_maxY));
%Time point when the particle is lifted
ADI=find(diff(P_maxY)<-2,1)+1;
%%Time at which the highest point is reached
V2.Tfly1=(dI-ADI)*1/Frame_Rate;
%% Compute the angle  A-D
im = read(vid,ADI);
L=imsegkmeans(im(:,:,1),2);
figure(99),imshow(L,[])

L(limitY:end,:)=0;
mean_G=[];
for bi=1:2
    All_A(bi)=sum(sum(L==bi));
    All_G(bi)=sum(sum(double(im(:,:,1)).*(double(L==bi))));
    mean_G(bi)= All_G(bi)/ All_A(bi);
end
%Select the cluster with the lowest mean grayscale intensity
[V,III]=sort(mean_G,'descend');
imB=L==III(2);
figure,imshow(imB)
imBf=imfill(imB,'holes');
figure,imshow(imBf);
imBfL=bwlabel(imBf);
BW=imBfL==imBfL(round(centers(2)),round(centers(1)));
figure,imshow(BW);
bwb=bwboundaries(BW);
%% Detect the droplet boundary and the particle boundary, and fit a circle to the particle
bwb=bwb{1};
%Predicted circle center
predicted_centers=centers+[P_maxY(ADI+1)-P_maxY(ADI) 0 ];
predicted_centers_b=bwb((sum((bwb-predicted_centers(2:-1:1)).^2,2).^0.5-radii)<5,:);

%  [a b c]=fit_circle(predicted_centers_b(:,2),predicted_centers_b(:,1));
%   [p, r] = RANSC_circfit(predicted_centers_b(:,2),predicted_centers_b(:,1))

%  [xc, yc, R] = circfit(predicted_centers_b(:,2),predicted_centers_b(:,1),radii)
Par = CircleFitByPratt(predicted_centers_b(:,2:-1:1))

Cerror=sum((predicted_centers_b-Par(2:-1:1)).^2,2).^0.5-Par(3);
[~,IE]=sort(abs(Cerror));
predicted_centers_b2=predicted_centers_b(IE(1:end-10),:);
Par = CircleFitByPratt(predicted_centers_b2(:,2:-1:1))
Droplet_b=bwb((sum((bwb-Par(2:-1:1)).^2,2).^0.5-Par(3))>=2,:);
Droplet_Idx=find((sum((bwb-Par(2:-1:1)).^2,2).^0.5-Par(3))>=2);
M = 30;
theta = linspace(0, 2 * pi, M)';
x0 = Par(1);
y0 = Par(2);
r0 = Par(3);
xfit1 = x0 + r0 * cos(theta);
yfit1 = y0 + r0 * sin(theta);
hold on
plot(xfit1, yfit1, '--', 'LineWidth', 1.5);

plot(Droplet_b(:,2),Droplet_b(:,1),'r.');

% viscircles(centers+[P_maxY(ADI+1)-P_maxY(ADI) 0 ], radii,'EdgeColor','c');
%% Identify the segmentation point between the droplet boundary and the particle boundary

break_PIc=find(diff(Droplet_Idx)~=1);
break_PI=[];
break_PI(1)=min(break_PIc);
break_PI(2)=max(break_PIc);

tho1B=Droplet_b(break_PI(1)-AD_line_num:break_PI(1),:);
tho2B=Droplet_b(break_PI(2)+1:break_PI(2)+AD_line_num,:);
thoK1=polyfit(tho1B(:,1),tho1B(:,2),1);
thoK2=polyfit(tho2B(:,1),tho2B(:,2),1);
tho1=atan(thoK1(1)).*180/pi
tho2=atan(thoK2(1)).*180/pi
break_Point1=bwb(Droplet_Idx(break_PI(1))+1,:);
break_Point2=bwb(Droplet_Idx(break_PI(2)+1)-1,:);
hold on
plot([break_Point1(2) x0],[break_Point1(1) y0],'r-')
plot([break_Point2(2) x0],[break_Point2(1) y0],'r-')

Thobreak_Point1=180-atan2(break_Point1(2)-x0,break_Point1(1)-y0).*180/pi;
Thobreak_Point2=180+atan2(break_Point2(2)-x0,break_Point2(1)-y0).*180/pi;

Thobreak_Droplet_ball_Point1=180-Thobreak_Point1-90-tho1;

Thobreak_Droplet_ball_Point2=-180+Thobreak_Point2+90-tho2;

V2.thoC=Thobreak_Droplet_ball_Point2;
V2.thoA=Thobreak_Droplet_ball_Point1;
V2.thoD=Thobreak_Point2;
V2.thoB=Thobreak_Point1;
V2.thoA1=tho1;
V2.thoC1=tho2;

V2.disA=(break_Point1-[y0 x0]).*pixcelsize   ;
V2.disC=(break_Point2-[y0 x0]).*pixcelsize   ;
% figure,plot(needle_Idx)
%% Droplet velocity
if e1<s1
   s1=1; 
end
t=s1:e1-1;
tx1=(t-(e1-1))*1/Frame_Rate;
vx1=diff(P_NmaxY(s1:e1-1))*pixcelsize*Frame_Rate;
vx1(1)=nan;
vx1=[nan vx1];
figure,
% plot(P_NmaxY)%(s1-1:e1)
hold on

plot(tx1(1:end),vx1)
title(['Droplet velocity  t=0,v=' num2str((vx1(e1-s1)))])
figure, plot(tx1(2:end),P_NmaxY(s1+1:e1-1)*pixcelsize*Frame_Rate)
title(['Droplet position'])

% figure,

t=ADI-1:dI;
tx2=(t-(e1-1))*1/Frame_Rate;
hx2=(P_maxY(ADI-1)-P_maxY(ADI-1:dI))*pixcelsize;
vx2=diff(hx2);
vx2=[nan vx2];
figure,plot(tx2,hx2)
title(['Change in particle rebound height  FlyTime=' num2str(V2.Tfly1)])



t=dI:Hend;
tx2d=(t-(e1-1))*1/Frame_Rate;
hx2d=(P_maxY(ADI-1)-P_maxY(dI:Hend))*pixcelsize;
vx2d=diff(hx2d);
vx2d=[nan vx2d];
figure,plot(tx2d,hx2d)
title(['Change in particle falling height '])


figure,plot(tx2,vx2)
title(['Change in particle rebound velocity  FlyTime=' num2str(V2.Tfly1)])
figure,plot(tx2d,vx2d)
title(['Change in particle falling velocity  '])
Data.tx2=tx2;
Data.hx2=hx2;
Data.vx2=vx2;
Data.tx2d=tx2d;
Data.hx2d=hx2d;
Data.vx2d=vx2d;

if s1~=s2
t=ADI-1:size(P_maxY,2);
tx2dD=(t-(e1-1))*1/Frame_Rate;
hx2dD=(P_maxY(ADI-1)-P_maxY(ADI-1:end))*pixcelsize;
hx2dDx=(P_maxY(ADI-1)-P_NmaxY(ADI-1:end))*pixcelsize;

vx2dDx=diff(hx2dDx);
vx2dDx=[nan vx2dDx];
figure,plot(tx2dD,hx2dD)
hold on
plot(tx2dD,hx2dDx)

title(['Change in droplet height, with the highest point defined as:' num2str(max(hx2dDx)) ])
% figure,plot(P_maxY)
% hold on
% plot(P_NmaxY)
Data.tx2dD=tx2dD;
Data.hx2dD=hx2dD;
Data.hx2dDx=hx2dDx;
Data.vx2dDx=vx2dDx;
   Data.Str='Droplet–particle separation' 

else
   Data.Str='No droplet–particle separation observed' 
end
Data.V1=V1;
Data.V2=V2;