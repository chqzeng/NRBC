function Patch_Width=Estimate_Patch_width(Mask_origin_outline,Mask_original_labelled,ind_patch,Ref_xy_fit,RefPT_x,RefPT_y, bLeft)
% Estimate_Patch_width - estimate the width of patch, perpendicular direction of the central_line.
%
% Usage: Patch_Width=Estimate_Patch_width(Mask_origin_outline,Mask_original_labelled,ind_patch,Ref_xy_fit,RefPT_x,RefPT_y, bLeft)
%
%
% Arguments:  Mask_origin_outline     - The outline Mask of original water body detection before pyramid 
%             Mask_original_labelled  - The labelled Mask of original water body detection before pyramid 
%             ind_patch   - the index of the searching patch
%             Ref_xy_fit  - Point list along the central line, including pixels extending both patches. 
%             RefPT_x,RefPT_y         - The pixel index of the end point of Ref or Neigh patch, on the cental line   
%             bLeft       - logical value to indicate which direction it going toward
%                           1: the Reference patch's direction and calculate its width 
%                           0: the Neighbour patch's direction and calculate its width 
%
% Returns:  Patch_Width - the estimated width of the patch
%
%
% Function Description:
%check a few (e.g. 10) times to measure some sample width of the river patch
%use 10 sample points and check the width at these points by
%perpendicular direction, and intersection to the two opposite sides
%will given the distance as the width.
%
%iterate each sample point, to find its corresponding width, by find
%points at the two opposite sides of the central_line , AND intersect
%with the perpendicular line to the slope direction. such points will
%give the distance as the width of the patch
%
%illustration:
%   -------------1----------  border (- |)
%   |            .
%   +++++++++++++*++++++++++ central_line(++)
%   |            .    
%   |            . perpendicular line (.)
%   -------------2----------
%  given a sample point (*) on  the central line, its perpendicular to
%  central_line's slope at that point (*), will intersect with patch border
%  at point 1 and point 2 at opposite sides of the central_line, and the
%  distance between point 1 and 2 will give the width of the patch.
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

    %to calculate the slope for adjecant pixels
    diff_xy=(diff(Ref_xy_fit'))'; 
    Ref_slope_dir=diff_xy(2,:)./diff_xy(1,:);  %slope direction
    
    %since the slope vector is now (n-1) size, add repeat the last item to keep length consistence
    Ref_slope_dir=[Ref_slope_dir,Ref_slope_dir(end)]; 
    
    Ref_slope_dir(Ref_slope_dir>1e5)=1e5;  %this line is to tolerant some extreme cases. close to tan(pi/4)
    Ref_slope_dir(Ref_slope_dir<-1e5)=-1e5; 
    
    Ref_norm_dir=-1./Ref_slope_dir; % perpendicluar direction has slope k=-1/k
    
    %find the pixel that are on the outline of the searching patch
    [Ref_mask_outline_px_idx,Ref_mask_outline_px_idy]=find( (Mask_original_labelled==ind_patch) & Mask_origin_outline);
    
  
    %check a few (e.g. 10) times to measure some sample width of the river patch
    %use 10 sample points and check the width at these points by
    %perpendicular direction, and intersection to the two opposite sides
    %will given the distance as the width.
    num_width_samples=10;
    
    %diff_RefPT is the index of the point that closest to the given [RefPT_x,RefPT_y], which is the edge of the patch
    %thus, diff_RefPT is the approximate index of the [RefPT_x,RefPT_y] in the Ref_xy_fitlist
     [temp diff_RefPT]=min(sum(abs([Ref_xy_fit(1,:)-RefPT_x; Ref_xy_fit(2,:)-RefPT_y])));
    
     %define the start and end point
     %point order: (Seg_End)---L/2----(RefPT)========L========(NeighourPT)++++L/2++++(Seg_End)
     %if bLeft is true, then it will find "(Seg_End)---L/2----(RefPT)", and
     %sample 10 points with equal interval from this range.
     % If there is no enough points (10), then will give less sample points
     if bLeft  % direction into the Reference patch, calculate the width of Ref patch
         if diff_RefPT<num_width_samples
            num_width_samples=diff_RefPT;
            sample_PT_idx=1:diff_RefPT;
         else
            sample_PT_idx=1:fix(diff_RefPT/num_width_samples):diff_RefPT;
         end
    else %it is the right side
        if (length(Ref_xy_fit)-diff_RefPT)<num_width_samples
            num_width_samples=(length(Ref_xy_fit)-diff_RefPT);
            sample_PT_idx=length(Ref_xy_fit):-1:diff_RefPT;
         else
            sample_PT_idx=length(Ref_xy_fit):-1*fix((length(Ref_xy_fit)-diff_RefPT)/num_width_samples):diff_RefPT;
         end
     end
    
    %define the points, and their slope and perpendicular directions
    Patch_Width=zeros(num_width_samples,1);
    xc=Ref_xy_fit(1,sample_PT_idx);
    yc=Ref_xy_fit(2,sample_PT_idx);
    kc=Ref_norm_dir(sample_PT_idx);
    sc=Ref_slope_dir(sample_PT_idx);
    
% ----------distance from these points to a given line -----------------
    %dist_2_line=@(xc,yc,kc,x0,y0)abs(kc*x0-y0+yc-kc*xc)/sqrt(kc^2+1);
    dist_2_line=@(xc,yc,kc,x0,y0)abs(kc*x0-y0+yc-kc*xc)/sqrt(kc^2+1);  
    dist_2_centraline=@(xc,yc,kc,x0,y0)kc*x0-y0+yc-kc*xc; %remove abs to keep symbol as indicator for which side of the line it sits
    
    %iterate each sample point, to find its corresponding width, by find
    %points at the two opposite sides of the central_line , AND intersect
    %with the perpendicular line to the slope direction. such points will
    %give the distance as the width of the patch
    for idx_width=1:num_width_samples
        
        %only calculate the distance from outline of a patch toward its perpendicular line
        dist_list=dist_2_line(xc(idx_width),yc(idx_width),kc(idx_width),Ref_mask_outline_px_idx,Ref_mask_outline_px_idy);
        
        % ideally the distance should be zero which means it is on the line
        % practically, the distance should be with in one pixel,
        intersect_Pts_dix=(dist_list)<= sqrt(2)/2 ;
        
        %use the symbol to indicate intersected points are at opposite or same side of the central_line
        symbol=dist_2_centraline(xc(idx_width),yc(idx_width),sc(idx_width),Ref_mask_outline_px_idx(intersect_Pts_dix),Ref_mask_outline_px_idy(intersect_Pts_dix));
        %temp_dist=dist_list(intersect_Pts_dix);
        sym_two_sides=(symbol*symbol') <=0;  %make a matrix to show their symbols, pixel-pairs at two sides should have symbol -1
        
        %calculate the distance from intersect points themselves, and only
        %use the valid point combinations that are at opposite side of the
        %central line.
        d=dist(([Ref_mask_outline_px_idx(intersect_Pts_dix),Ref_mask_outline_px_idy(intersect_Pts_dix)])');
        d=d.*sym_two_sides;
        
        
        if isempty(d(d>sqrt(2)))  %in case there is no points under this rule
            Patch_Width(idx_width)=0;
        else
            Patch_Width(idx_width)=min(d(d>sqrt(2))); %the actual width should be the min width
        end
    end
    
    Patch_Width=Patch_Width(Patch_Width>0); %remove the width as 0
end