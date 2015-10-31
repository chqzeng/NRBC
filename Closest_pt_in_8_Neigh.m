function [new_r,new_c]=Closest_pt_in_8_Neigh(seed_r,seed_c,prev_r,prev_c,k,b,ROWS,COLS)
% Closest_pt_in_8_Neigh - Given a line equation: y=kx+b, find the closet point to the line in a seed point's 8 neighbour
%
% Usage: [new_r,new_c]=Closest_pt_in_8_Neigh(seed_r,seed_c,prev_r,prev_c,k,b,ROWS,COLS)
%
%
% Arguments:  seed_r       -the row index of the seed in the image
%             seed_c       -the column index of the seed in the image
%             prev_r       -similar to "seed_r",but indicate the previous point,which used to determine the line's direction
%             prev_c       -similar to "seed_c",but indicate the previous point,which used to determine the line's direction
%             k,b          -determine the line equation: y=kx+b 
%             ROWS,COLS    -the size of the image,
%
% Returns:  new_r           - the new row index that give the correct direction of the line in 8-Neigh 
%           new_c           - the new column index that give the correct direction of the line in 8-Neigh            
%
%
% Function Description:  this function is used to determine the direction
% of Neighbours at the certain line direction. The idea is: calculate the
% distance of each of the 8-Neighbour pixels, where the pixel has the
% shortest distance to the given line is the best to represent the direction
%
%
%-------------------Copyright and citiation--------------------------------
%  This code is published under GNU GENERAL PUBLIC LICENSE v3, more details about this license please read: [here] ( https://github.com/chqzeng/NRBC/blob/master/LICENSE)
%
% Please cite this work as:  
% Zeng, C.; Bird, S.; Luce, J.J.; Wang, J. A Natural-Rule-Based-Connection (NRBC) Method for River Network Extraction from High-Resolution Imagery. Remote Sens. 2015, 7, 14055-14078.
% open accessed  of this paper: [Here] (http://www.mdpi.com/2072-4292/7/10/14055).
% 
% Contact:  Chuiqing Zeng:   chqzeng@gmail.com  
%------------------------------------------------------------------------------
%
% Version: February  2014 Dec - Original version

%Initial the output point row and col as invalid value.
    new_r=-1;
    new_c=-1;

    %define the 8-nieghbour by a offset of row and column index combination
     roff = [-1  0  1  1  1  0 -1 -1];
     coff = [-1 -1 -1  0  1  1  1  0];
  
     %construct the 8-neigh coords
    r = seed_r+roff;
    c = seed_c+coff;
    
    %ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));
    
    %the default distance is Inf, since we are looking for the min dist
    neig_dist=ones(length(roff),1)*Inf;  %intial distance is Inf
    
    %iterate trhough the 8-neigh to calculate distance
    for i = 1:length(roff)
        if (r(i)>=1 && r(i)<=ROWS) &&  (c(i)>=1 && c(i)<=COLS) && ...  %inside the image boundary
           ~(prev_r==r(i) &&  prev_c==c(i)) %not the previous point
       
       %dist_2_line=@(xc,yc,kc,x0,y0)abs(kc*x0-y0+yc-kc*xc)/sqrt(kc^2+1);
       
       %central point for a pixel
        x0=r(i);%-0.5; %the centroid
        y0=c(i);%-0.5;
       
       %calculat the distance
       neig_dist(i)= abs(k*x0+b-y0)/sqrt(k^2+1);
       end
    end
    
    %not only shortest distance, but also consitent direction
    dir_vec=[roff; coff]'*([seed_r,seed_c]-[prev_r,prev_c])';
    idx=find(dir_vec>=0);
    [i j]=min(neig_dist(idx));
    ind=idx(j);

    %export the shortest distance
    %[d,ind]=min(neig_dist);
    new_r=r(ind);
    new_c=c(ind);
end