function [Pixel_list_filled, optimal_width]=Neighour_patch_filled(Mask_original,Mask_centralline,ind_patch,cur_neirghour_patch,List_Central_line_pts,Ref_Width, Neigh_Width)
% Neighour_patch_filled - Fill two neighbour patches that has been tested to be eligible to connect together
%
% Usage: [Pixel_list_filled, optimal_width]=Neighour_patch_filled(Mask_original,Mask_centralline,ind_patch,cur_neirghour_patch,List_Central_line_pts,Ref_Width, Neigh_Width)
%
%
% Arguments:  Mask_original     - The Mask of original water body detection before pyramid 
%             Mask_centralline  - The Mask of the central_line for the mask after pyramid connection of gaps 
%             ind_patch         - The patch index of the current working patch, also call the "reference patch"
%             cur_neirghour_patch    - The patch index of the neighbour  patch
%             List_Central_line_pts  - The list of pixels that connect these two patches, from the central_line  
%             Ref_Width,        - The width of the Reference patch  
%             Neigh_Width       - The width of the Neighbour patch  
%
% Returns:  Pixel_list_filled   - The pixel list that need to be filled in the gap, the same size as input mask images 
%           optimal_width       - the optimal width corresponding to the filled pixels   
%
%
% Function Description: This function is used to fill the gap between two
% patches that have approved to be eligible for connection. A general idea
% is that the optimal fill will happen at roughly the same width as the two
% patches themselves. The perimeter change is used as the function to monitor
% and find the optimal fill width .
% Practically, the central_line is first extent a certain length to both
% side, into the two patches, to avoid problems of irregular patch border.
% then, the central_line segment is growing wider and wider till it find the
% best width to fill the gap. The perimeter of the union object of (the
% Reference patch, the gap filled area, and the Neighbour patch) as a
% single object is decreasing at first, and then growing after it reach
% optimal width.
% The gap is growing vertically to the central_line direction using the
% morphology methods.
% Finally, the final filled gap area is only a single 8-neighbour connected
% area after subtract the pixels belong to the original two patches, while
% the rest of areas is removed due to mistakes at complicated patch
% shapes.
%
% See also:  
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

    %image bounds
    [ROWS, COLS]=size(Mask_centralline);
 
    %start and end points
    RefPT_x=List_Central_line_pts(1,1);
    RefPT_y=List_Central_line_pts(1,2);
    NeighourPT_x=List_Central_line_pts(end,1);
    NeighourPT_y=List_Central_line_pts(end,2);
  
    %initial the pixels list that need to be filled
    Pixel_list_filled=Mask_original> Inf;  %make a logical listof zeros
    
    % the conversion from 2D index[i,j] to single 1D index : (j-1) * d1 + i
    %temp=List_Central_line_pts(2:end-1,:) %remove the first and the las point
    centralline_list=(List_Central_line_pts(:,2)-1)*ROWS+List_Central_line_pts(:,1);
    Pixel_list_filled(centralline_list)=1;

%%----- fit the line to find the both direction toward Reference patch and Neighbour patch--------------
    [Ref_Mask_line_Seg,k,b]=Extend_Gap_CentralLine(List_Central_line_pts,ROWS,COLS, 0); % dir=0 means from Neighbour --> Ref
    [Niegh_Mask_line_Seg,k,b]=Extend_Gap_CentralLine(List_Central_line_pts,ROWS,COLS, 1); % dir=1 means from Ref --> Neighbour
    
    %set the extended pixels as seed as well, just like the pixels of central_line between the gap
    Ref_Mask_list=(Ref_Mask_line_Seg(:,2)-1)*ROWS+Ref_Mask_line_Seg(:,1);
    Pixel_list_filled(Ref_Mask_list)=1;
    %same process for the other side of the seg
    Neigh_Mask_list=(Niegh_Mask_line_Seg(:,2)-1)*ROWS+Niegh_Mask_line_Seg(:,1);
    Pixel_list_filled(Neigh_Mask_list)=1;
    
    %generate the unioned patch of three pieces 
    Mask_original_labelled = bwlabel(Mask_original, 8); % in 8-neighbourhood
    Mask_two_patches=Mask_original_labelled==ind_patch | Mask_original_labelled==cur_neirghour_patch; %| Pixel_list_filled;

%%------------search the optimal width_filled_gap-----------------------
    
    %define the subset window size for operation
    Search_Range=fix(max([Ref_Width, Neigh_Width]));
    %roughly window size: Explore_window_sz --> [2*Search_Range+List_Central_line_pts, 2*Search_Range];
    Explore_window_minX=max([min(RefPT_x-Search_Range,NeighourPT_x-Search_Range),1]); 
    Explore_window_maxX=min([max(RefPT_x+Search_Range,NeighourPT_x+Search_Range),ROWS]);
    Explore_window_minY=max([min(RefPT_y-Search_Range,NeighourPT_y-Search_Range),1]);
    Explore_window_maxY=min([max(RefPT_y+Search_Range,NeighourPT_y+Search_Range),ROWS]);
    Explore_window_original=Mask_two_patches(Explore_window_minX:Explore_window_maxX,Explore_window_minY:Explore_window_maxY);
    Explore_window_seed=Pixel_list_filled(Explore_window_minX:Explore_window_maxX,Explore_window_minY:Explore_window_maxY);

    %initialize the array to record the perimeter change
    Width_gap_Peri=zeros(Search_Range,1); %the perimeter corresponding to a given buffer width of the seed pixels.
    
    %gradually increase the width to find the optimal width which has the smallest perimeter of the patch
    for ind_width_gap=min(2,Search_Range): Search_Range
        
        %SE = strel('line', LEN, DEG) ;
        SE_sq = strel('square',3);
        SE_line = strel('line', 2*(ind_width_gap-1), atan(k)*180/pi) ; %a linear profile with length and direction

        %need to square it first , other wise it could generate patches with holes
       Mask_filled=imdilate(Explore_window_seed,SE_sq);
       Mask_filled=imdilate(Mask_filled,SE_line);
       
       %drapped on the original window: make the union from 2 pieces (Ref patch + Neigh Patch) to 3 pieces (Central gap filled)
        Mask_filled = Explore_window_original | Mask_filled;
        Mask_filled_labelled = bwlabel(Mask_filled, 8);
        tempID=Mask_filled_labelled(RefPT_x-(Explore_window_minX-1),RefPT_y-(Explore_window_minY-1));
        
%         if mod(ind_width_gap,5)==0  
%             figure;imshow(Mask_filled)
%             title (sprintf('Filled gap width: %d',ind_width_gap))
%         end
        
        %calculate and record the perimeter of the current width
        STATS = regionprops(Mask_filled,'Perimeter');
        Width_gap_Peri(ind_width_gap)=STATS(tempID).Perimeter;
    end
     Width_gap_Peri(1)= Width_gap_Peri(2); %the 1st item has not set value yet, 
    
	%find the optimal fill width, to be more stable, 
    %it is better to use line fitting than simple "min" function
    if length(Width_gap_Peri)<3  %tolerant problematic case, with few pixels and cause problem in polyfit
        p= polyfit(1:Search_Range,Width_gap_Peri',2);%fit a quad line
    else
        p= polyfit(1:Search_Range,Width_gap_Peri',3);%fit a cubic line
    end
    fitted_peri = polyval(p,1: Search_Range);
    
    %the optimal case is the width with minimum fitted perimeter
    [val, optimal_width]=min(fitted_peri);
    
    %for test purpose and view the perimeter change
    %figure;plot(Width_gap_Peri); hold on; plot(fitted_peri); hold off;
    
    %use the optimal width, redo the previous steps in the iteration and generate the final filling gap areas
    SE_sq = strel('square',3);
    SE_line = strel('line', 2*(max(1,optimal_width-2)), atan(k)*180/pi) ; 
     Mask_filled=imdilate(Explore_window_seed,SE_sq);
     Mask_filled=imdilate(Mask_filled,SE_line);
     Mask_filled = Explore_window_original | Mask_filled;
       
    Mask_filled_labelled = bwlabel(Mask_filled, 8);
    tempID=Mask_filled_labelled(RefPT_x-(Explore_window_minX-1),RefPT_y-(Explore_window_minY-1));
    temp_filled=(Mask_filled_labelled==tempID) & (~Explore_window_original);  %the filled area is the region pixels that are outside original patches
    
    %in complicated shapes, there may be more than one parts are filled,only pick the part that directly in the gap, and cover the central_line
    temp_filled_labelled = bwlabel(temp_filled, 8);
    tempID=temp_filled_labelled(List_Central_line_pts(2,1)-(Explore_window_minX-1),List_Central_line_pts(2,2)-(Explore_window_minY-1));
    if tempID>0
        temp_filled= (temp_filled_labelled==tempID);  %only need the patch that is in the gap, there may be more than one candidates.
    else
        temp_filled= zeros(size(temp_filled));  %for case the temp ID is background, it should not happen.
    end
    
    %the final out put area is updated with the filled gap
    Pixel_list_filled(Explore_window_minX:Explore_window_maxX,Explore_window_minY:Explore_window_maxY)=temp_filled;
end
