%%%Identify the largest connected component (by area) and return the corresponding mask

function [C] =findLargeBlock_2D(A,con)
%Keep only the largest connected component
A0=bwconncomp(A,con);
Size_A0=zeros(1,A0.NumObjects);
for Ai=1:A0.NumObjects  
Size_A0(Ai)=size(cell2mat(A0.PixelIdxList(Ai)),1);
end
[Y,I] = sort(Size_A0,2,'descend');
C= false(A0.ImageSize);
C(cell2mat(A0.PixelIdxList(I(1))))=1;

%Identify the largest component (A1)