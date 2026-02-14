% imd=imread('0.jpg');
% figure,imshow(imd,[])
function pixcelsize=get_pixcelSize(vidx)
imd = read(vidx,1);
figure,imshow(imd,[])
BW=imd(:,:,1)>150;
BW=imclose(BW,strel('disk',5));
figure,imshow(BW,[])
figure,plot(sum(BW,2))
figure,plot(diff(sum(BW,2)))
[~,idx]=min(diff(sum(BW,2)))

figure,plot((sum(BW(idx-100:idx,:),1)))
figure,plot(diff(sum(BW(idx-100:idx,:),1)))

S=regionprops(diff(sum(BW(idx-100:idx,:),1))>30)
pixcelsize=1/abs((S(1).Centroid(1)-S(end).Centroid(1))/(size(S,1)-1));