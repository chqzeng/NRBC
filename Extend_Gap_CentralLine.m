function [Mask_line_Seg,k,b]=Extend_Gap_CentralLine(List_Central_line_pts,ROWS,COLS, dir)
% Extend_Gap_CentralLine - use the central line to extend it toward both sides with length to (gap_Len/2)
%
% Usage: [Mask_line_Seg,k,b]=Extend_Gap_CentralLine(List_Central_line_pts,ROWS,COLS, dir)
%
%
% Arguments:  List_Central_line_pts  - the point list that connect the two patches, comes from the central_line
%                          
%             ROWS,COLS  - the bounds of the entire image, to limit search extent 
%             dir        - The search direction, given as binary value: 
%                          1 means from Reference-->Neighbour direction;
%                          0 means from Neighbour --> Reference direction;  
%
% Returns:  Mask_line_Seg - a cell array of edge lists in row,column coords in
%           k,b           - define the regression line for the central_line in the gap as equation: y=kx+b 
%
%
% Function Description: This function is to extent a certain length to
% both sides before starting to fill the gap. the extended length can avoid
% the irregular shape of the patch border that may leads to holes after
% filling; thus a extended central_line aims to avoid such holes.
% the shape of the central_line direction is: 
%(Seg_End)---L/2----(RefPT)========L========(NeighourPT)++++L/2++++(Seg_End)
% This function is very similar to Closest_pt_in_8_Neigh, but that function
% is to find points toward a given line direction, while this function only
% trace the central line.
%
% See also:  Closest_pt_in_8_Neigh
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

    if dir % one direction start at the RefPt
        startPT_x=List_Central_line_pts(1,1);
        startPT_y=List_Central_line_pts(1,2);
        endPT_x=List_Central_line_pts(end,1);
        endPT_y=List_Central_line_pts(end,2);
        Mask_line_Seg=List_Central_line_pts([end-1 end],:);
    else % the other direction start at the NeighbourPT
        startPT_x=List_Central_line_pts(end,1);
        startPT_y=List_Central_line_pts(end,2);
        endPT_x=List_Central_line_pts(1,1);
        endPT_y=List_Central_line_pts(1,2);
        Mask_line_Seg=List_Central_line_pts([2 1],:);
    end

     %[ROWS, COLS]=size(Mask_centralline);
     gap_Len=length(List_Central_line_pts);
      
      %to find the end of the fitted line segment's end: [x,y]=[x0 +/- (w/2)/sqrt(k^2+1), y]  
      if size(unique(List_Central_line_pts(:,1)))==1  %the vertical line with only one x value
          %centraline_coeff= polyfit(List_Central_line_pts(:,1),List_Central_line_pts(:,2),1);%
          %Line_eq=@(x,y) y-List_Central_line_pts(1)=0
          k=1e5;  %use 1e5 as approximate for Inf = tan(pi/4)
      else
          centraline_coeff= polyfit(List_Central_line_pts(:,1),List_Central_line_pts(:,2),1);%fit a linear line
          k=centraline_coeff(1); %the slope is the first coeff after 1st order fitting
      end
      b=(endPT_y-0.5)-(endPT_x-0.5)*k; %use the centroid
         
    for ind_pt=1:round(gap_Len/2)  %extend length is half of the gap
        seed_r=Mask_line_Seg(end,1);
        seed_c=Mask_line_Seg(end,2);
        prev_r=Mask_line_Seg(end-1,1);
        prev_c=Mask_line_Seg(end-1,2);
        [new_r,new_c]=Closest_pt_in_8_Neigh(seed_r,seed_c,prev_r,prev_c,k,b,ROWS,COLS);
        if (new_r>0 && new_c>0)
            Mask_line_Seg=[Mask_line_Seg;[new_r,new_c]];
        else
            break;
        end
    end
     Mask_line_Seg=Mask_line_Seg(3:end,:); %remove the first two points since they already in the list
     
% --------------the previous method to extent a line toward one end-----------    
%     Seg_End_Pt_x=[endPT_x-(gap_Len/2)/sqrt(k^2+1) endPT_x+(gap_Len/2)/sqrt(k^2+1)];
%     Seg_End_Pt_y=(Seg_End_Pt_x-endPT_x).* k + endPT_y;
%     
%     %need to determine which side: opposite side of the gap
%     Gap_Dir_Vector=[startPT_x startPT_y]-[endPT_x endPT_y];
%     Extent_Dir_Vector=repmat([endPT_x endPT_y],2,1)-[Seg_End_Pt_x; Seg_End_Pt_y]';
%     [I, J]=max(Extent_Dir_Vector*Gap_Dir_Vector'); %only want the direction the same as the start-2-end vector
%     
%     %export the point which is the right direction
%     Seg_end_PT=[Seg_End_Pt_x(J) Seg_End_Pt_y(J)];
%     
%     x=linspace(endPT_x,Seg_end_PT(1),1000);  %set pts on this segment
%     y=(x-endPT_x).*k+ endPT_y;  %give corresponding y to the x on the line with its slope k
%     
%     nc=ceil(abs(Seg_end_PT(1)-endPT_x)); %the corresponding raster mask image size
%     nr=ceil(abs(Seg_end_PT(2)-endPT_y));
%     
%     Mask_line_Seg=Rasterize_line_2_mask(x,y,nc,nr);  %give the mask based on the line points
%     Mask_offset=[min(Seg_end_PT(1),endPT_x) min(Seg_end_PT(2),endPT_y)]-[1 1]; %give the offset of the mask

   
end

%--------discarded function------------
function Mask_line=Rasterize_line_2_mask(x,y,nc,nr)
%convert a vectorized line into a rasterized image
%Input:     for a [x,y] list represent the line
%Input:     the output image size is [nr,nc]
     xx=round(linspace(min(x),max(x),nc));
     yy=linspace(min(y),max(y),nr);
     [nx,nx]=histc(x,xx);
     [ny,ny]=histc(y,yy);
     %Mask_line=accumarray([ny.',nx.'],1,[nr,nc])~=0;
     Mask_line=accumarray([ny(nx>0).',nx(nx>0).'],1,[nr,nc])~=0;
end