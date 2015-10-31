function [r_list,c_list]=Search_centralline_Segment_by_seed(Mask_centralline,Mask_original_Patch_by_ID,seed_x, seed_y, rough_width)
% Search_centralline_Segment_by_seed - search the central line segment by seed
%
% Usage: [r_list,c_list]=Search_centralline_Segment_by_seed(Mask_centralline,Mask_original_Patch_by_ID,seed_x, seed_y, rough_width)
%
%
% Arguments:  Mask_original     - The Mask of original water body detection before pyramid 
%             Mask_original_Patch_by_ID  - The Mask of the central line for the mask only set the patch of current ID as 1, all others are 0
%             seed_x, seed_y  - the seed point to start the searching
%             rough_width     -       roughly width of the patch, calculated from its perimeter and Area 
%
% Returns:  r_list,c_list  - the out put seed point on a new patch
%
%
% Function Description:
% This function is similar to Search_neighour_patch_by_seed, the difference
% is this function is search inside a patch, while
% "Search_neighour_patch_by_seed" is search outside a patch
%
% See also:  Search_neighour_patch_by_seed
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

%check validation, should not be true
 if Mask_centralline(seed_x,seed_y)~=1
     disp('          Debug: Failed because The input seed point is not on the central line')
     return;
 end
 
 
%generate the central line for the connected mask after pyramid
%Mask_original_labelled = bwlabel(Mask_original, 8); % in 8-neighbourhood

 [ROWS, COLS]=size(Mask_centralline);
 
 roff = [-1  0  1  1  1  0 -1 -1];
 coff = [-1 -1 -1  0  1  1  1  0];
%Row and column coordinates of available
 r_list = [seed_x]; c_list = [seed_y];
 
%-------------Step 1: the first start pixel processing is different from the proceeding pixels
r = r_list(end)+roff;
c = c_list(end)+coff;
ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));
for i = ind
  if Mask_centralline(r(i),c(i)) == 1 && Mask_original_Patch_by_ID(r(i), c(i));
    r_list = [r_list; r(i)];
    c_list = [c_list; c(i)];
    break; %only consider the first appeared pixel in case of divergence
   end
end


if length(r_list)==1 %if there is no valid points 
%     endPT_x=r_list(end);
%     endPT_y=c_list(end);
    return;
end
     

%-------------Step 2:the proceeding pixels are processed in a consistent way
  for idx_length= 1: fix(rough_width)
      r = r_list(end)+roff;
      c = c_list(end)+coff;

     % Find indices of arrays of r and c that are within the image bounds
     ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));

     %if it reaches a fork with two or more divergence
     if trace(Mask_centralline(r(ind),c(ind)))>2  %if there is more than 2 neibghour are central_line pixels
         break;
     end
     
        % A pixel is available for linking if its value is 1 and it has not
        % reached a neighbour patch where the original mask will be 1
        for i = ind
            % If there is a loop and [c,r] is repeating one of the previous point in the list
            if  Mask_centralline(r(i),c(i)) == 1 && ... % on the central line
                length(r_list)>2 &&... %has more than 2 elements in the list    
                min(sum(abs([r_list(1:(end-2))-r(i), c_list(1:(end-2))-c(i)]),2))==0
                    return;

            elseif Mask_centralline(r(i),c(i)) == 1 && ... % on the central line
                    ~(r_list(end-1)==r(i) && c_list(end-1)==c(i));  % AND it is NOT the (end-1) pixel in the edge list
                
                if ~Mask_original_Patch_by_ID(r(i), c(i));  %if it reaches border of the patch
                    return;
                end
                    r_list = [r_list; r(i)];
                    c_list = [c_list; c(i)];

                break; %for divergence , only process the first satisfied pixel
            end
        end
  end 

end