function [bConnected,Ref_Patch_Width, Neigh_Patch_Width] = Neighour_patch_Connection (Mask_original,Mask_origin_outline,Mask_centralline,water_Patches,ind_patch,cur_neirghour_patch,List_Central_line_pts,T_dir_theta,T_Len_r_gap,T_width_ratio)
% Neighour_patch_Connection - this function is used to determine the connection between two patches.r
%
% Usage: [bConnected,Ref_Patch_Width, Neigh_Patch_Width] = Neighour_patch_Connection (Mask_original,Mask_origin_outline,Mask_centralline,water_Patches,ind_patch,cur_neirghour_patch,List_Central_line_pts)
%
%
% Arguments:  Mask_original     - The Mask of original water body detection before pyramid 
%             Mask_origin_outline -The outline Mask of original water body detection before pyramid 
%             Mask_centralline  - The Mask of the central_line for the mask after pyramid connection of gaps 
%             water_Patches     - The structure object that record all the water patches to search for ARea,Peri,etc 
%             ind_patch         - The patch index of the current working patch, also call the "reference patch"
%             cur_neirghour_patch    - The patch index of the neighbour  patch
%             List_Central_line_pts  - The list of pixels that connect these two patches, from the central_line    
%             T_dir_theta,T_Len_r_gap,T_width_ratio  -optional thresholds
%
% Returns:  bConnected      - a logical value to indicate whether these two patches should be connected 
%           Ref_Patch_Width - The width of the estimated Ref patch, it is meaningless when bConnected=0 
%           Neigh_Patch_Width - The width of the estimated Neigh patch, it is meaningless when bConnected=0
%
%
% Function Description: This Function is the major summary Step 2: 
% determine the connection eligibility of two patches, that have been
% detected to be connected by central line in Step 1. It works as the major
% role to determine whether two patches should be connected and proceed the
% Step 3: to connect the two patches together.
%
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

 %initialize output variants
    bConnected=0;
    Ref_Patch_Width=0;
    Neigh_Patch_Width=0;

if ~exist('T_dir_theta','var')
    T_dir_theta=90;   %condition 1: the direction change should be less than a given angle
end
if ~exist('T_Len_r_gap','var')
    T_Len_r_gap=2;    %condition 2: The length of patch along central line direction should be longer than (T_Len_r_gap) times of gap
end
if ~exist('T_width_ratio','var')
    T_width_ratio=3;  %condition 3: the width of the patches should be: max(w1,w2)/min(w1,w2) < T_width_ratio
end


% if ind_patch==3 && cur_neirghour_patch==4
%     bConnected=1;
%     Ref_Patch_Width=150;
%     Neigh_Patch_Width=150;
%     return;
% elseif ind_patch==4 && cur_neirghour_patch==60
%     bConnected=1;
%     Ref_Patch_Width=180;
%     Neigh_Patch_Width=190;
%     return;
% end

%%---------------condition 1:  the direction should be consistent,largest direction-------------
    % change should be less than theta degree
    
    if length(List_Central_line_pts(:,1))>3 %for very short central line, it usually has no direction change, and make mistakes for polyline fitting
%         slope_cos_values=ones(length(List_Central_line_pts(:,1)));
%     else
        [Gap_xy_fit, slope_cos_values]=curve_fitting_with_bspline(List_Central_line_pts(:,1),List_Central_line_pts(:,2));
        if sum(sum(slope_cos_values<=cos(T_dir_theta*pi/180))) %if any of the cosine value between two central line points is less than cos(T_dir_theta)
            %disp(['          Debug: failed case: Direction cos difference (',num2str(min(slope_cos_values(:))), ')is smaller than threshold: cos(', num2str(T_dir_theta), ')']);
            disp(sprintf('          Debug: failed case: Direction difference (%6.2f)is larger than threshold: %d degree', acos(min(slope_cos_values(:)))*180/pi,T_dir_theta));
            return;
        end
    end

    
%%---------------condition 2:  the Length along central line direction should long enough-------------
    bLen_Ref=Estimate_Centraline_Dir_Len(List_Central_line_pts([2 1],1), List_Central_line_pts([2 1],2), Mask_centralline,Mask_original,T_Len_r_gap*length(List_Central_line_pts(:,1)));
    bLen_Neigh=Estimate_Centraline_Dir_Len(List_Central_line_pts([end-1 end],1), List_Central_line_pts([end-1 end],2), Mask_centralline,Mask_original,T_Len_r_gap*length(List_Central_line_pts(:,1)));
    if ~(bLen_Ref|| bLen_Neigh) %both side are shorter than threshold
        disp('          Debug: failed case: Length along central direction is shorter than expected');
        return;
    end
   
    
%%---------------condition 3:  the width of the two river need to be consistent-------------
    % max(width1,width2)/min(width1,width2) <2 , the width difference should not more than twice 
    RefPT_x=List_Central_line_pts(1,1);
    RefPT_y=List_Central_line_pts(1,2);
    NeighourPT_x=List_Central_line_pts(end,1);
    NeighourPT_y=List_Central_line_pts(end,2);

    %calculate the rough width based on the assumption that river patch is close to the shape of rectangle.
    Ref_Patch=water_Patches(ind_patch);
    Neighour_Patch=water_Patches(cur_neirghour_patch);
    Ref_Width=Ref_Patch.Perimeter/4 - sqrt(Ref_Patch.Perimeter.^2/4-4*Ref_Patch.Area)/2;
    Neighour_Width=Neighour_Patch.Perimeter/4 - sqrt(Neighour_Patch.Perimeter.^2/4-4*Neighour_Patch.Area)/2;

    %generate the central line for the connected mask after pyramid
    Mask_original_labelled = bwlabel(Mask_original, 8); % in 8-neighbourhood

    %trace the central_line to find the segment of central_line will be used here
    [Ref_r_list,Ref_c_list]=Search_centralline_Segment_by_seed(Mask_centralline,Mask_original_labelled==ind_patch,RefPT_x, RefPT_y, Ref_Width);
    [Neigh_r_list,Neigh_c_list]=Search_centralline_Segment_by_seed(Mask_centralline,Mask_original_labelled==cur_neirghour_patch,NeighourPT_x, NeighourPT_y, Neighour_Width);
    
    %make sure the list is long enough
%%------low efficiency code, need to removed in future version----
%This IF SECTION is to avoid cases when the extended segment is not long enough for further River patch width detection
%Then the fake extent the segment line by extent it according the central line direction  
 if 1
    [ROWS, COLS]=size(Mask_centralline);
    %slope_cos_values(1,:)=[];   
      if length(Ref_r_list) <(Ref_Width/2)  %not enough points found
            disp(['          Debug: extend central_line not long enough-->Ref']);
            temp_list=[List_Central_line_pts(end:-1:2,:);[Ref_r_list,Ref_c_list]];
            [Ref_r_list, Ref_c_list]=Vitural_Extent_Segment(temp_list,Ref_Width/2,ROWS,COLS);
      end
      %make sure the list is long enough
      if length(Neigh_r_list) < (Neighour_Width/2)  %not enough points found
            disp(['          Debug: extend central_line not long enough-->Neigh']);
            temp_list=[List_Central_line_pts(1:(end-1),:);[Neigh_r_list,Neigh_c_list]];
            [Neigh_r_list,Neigh_c_list]=Vitural_Extent_Segment(temp_list,Ref_Width/2,ROWS,COLS);
      end
end
%%------low efficiency code, need to removed in future version----
    
    %the final central line segment is the combination of the 3 segments,
    %left: from one patch; middle: in the gap; right: from another patch
    Ref_Central_Seg_x= [Ref_r_list(end:-1:2); List_Central_line_pts(:,1); Neigh_r_list(2:end)];
    Ref_Central_Seg_y= [Ref_c_list(end:-1:2); List_Central_line_pts(:,2); Neigh_c_list(2:end)];
    
    
    %fit a 2nd-order curve for the central line without constrain:
    %mono-increasing since rivers can come back and forth.
    [Ref_xy_fit, slope_cos_values]=curve_fitting_with_bspline(Ref_Central_Seg_x,Ref_Central_Seg_y);

    %------------core part to determine whether patches needed to be connected------------
    % estimate the width of the river patch
    Neigh_Patch_Width=Estimate_Patch_width(Mask_origin_outline,Mask_original_labelled,cur_neirghour_patch,Ref_xy_fit,NeighourPT_x,NeighourPT_y,0);
    Ref_Patch_Width=Estimate_Patch_width(Mask_origin_outline,Mask_original_labelled,ind_patch,Ref_xy_fit,RefPT_x,RefPT_y,1);
    %if the width estimation failed
    if isempty(Neigh_Patch_Width) || isempty(Ref_Patch_Width)
        disp(['          Debug: failed case: cannot calculate patch width']);
        return;
    end
    %calculate the statistic variants based on the vector list of width
    std_ref_width=std(Ref_Patch_Width);
    std_neigh_width=std(Neigh_Patch_Width);
    %if the width of the two patch is consistent (no more than twice between each other)
    Ref_Patch_Width=max(Ref_Patch_Width);
    Neigh_Patch_Width=max(Neigh_Patch_Width);
    
    %the condition test
    if max([Ref_Patch_Width Neigh_Patch_Width])/min([Ref_Patch_Width Neigh_Patch_Width]) < T_width_ratio ...  %width differnce less than 3 times
            && max([std_ref_width std_neigh_width]) <20 %width variety is abnormal 
        bConnected=1;
    else
        disp(['          Debug: failed case: Width difference/STD too large: ']);
        %disp(['          Width info: Mean_Ref Mean_Neigh Std_Ref Std_Neigh:',num2str(Ref_Patch_Width),num2str(Neigh_Patch_Width),num2str(std_ref_width), num2str(std_neigh_width)]);
        disp(sprintf('          Width info: Mean_Ref: %6.2f, Mean_Neigh: %6.2f, Std_Ref: %6.2f, Std_Neigh: %6.2f',Ref_Patch_Width ,Neigh_Patch_Width,std_ref_width,std_neigh_width ));
    end

    return;
end

%-------------inner function---------------------
function [Ref_r_list, Ref_c_list]=Vitural_Extent_Segment(temp_list, nLen,ROWS,COLS)
% to extent the central_line segment into a patch in case it is not long enough 

    % temp_list=[List_Central_line_pts(end:-1:2,:);[Ref_r_list,Ref_c_list]];
    
    %the linear extending direction is given by a fitted line
            k=polyfit(temp_list(:,1),temp_list(:,2),1); %fit a linear line
%             k=k(1);
%             b=temp_list(end,1)-k*temp_list(end,2);
            for ind_pt=1:fix(nLen)  %extend length is half of the rough width
                seed_r=temp_list(end,1);
                seed_c=temp_list(end,2);
                prev_r=temp_list(end-1,1);
                prev_c=temp_list(end-1,2);
                 [new_r,new_c]=Closest_pt_in_8_Neigh(seed_r,seed_c,prev_r,prev_c,k(1),k(2),ROWS,COLS);
                if (new_r>0 && new_c>0)
                    temp_list=[temp_list;[new_r,new_c]];
                else
                    break;
                end
            end
            
            %fetch the last Ref_Width/2 elements as the new list 
            Ref_r_list=temp_list((end-fix(nLen)):end,1);  
            Ref_c_list=temp_list((end-fix(nLen)):end,2);
end


