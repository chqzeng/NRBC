function [r_list,c_list]=Search_neighour_patch_by_seed(seed_x, seed_y, Mask_centralline,Mask_original,T_gap_width)
% Search_neighour_patch_by_seed - start from a seed point at the edge of one patch, find its neighbour patch 
%
% Usage: [r_list,c_list]=Search_neighour_patch_by_seed(seed_x, seed_y, Mask_centralline,Mask_original)
%
%
% Arguments:  Mask_original     - The Mask of original water body detection before pyramid 
%             Mask_centralline  - The Mask of the central line for the mask after pyramid connection of gaps 
%             seed_x, seed_y     - The start pixel for search.
%
% Returns:  r_list - the row index for the pixel that end the search
%           c_list - the column index for the pixel that end the search
%
%
% Function Description: This a one of the three major function to
% accomplish the water patch connection. It serves as the Step 1: to find
% connected river patches by seed pixels from one patch, and then trace
% that point along central_line till it reaches a new patch, or exit when it
% makes mistakes (reach a loop, end of a central_line, etc)
%
% The out put of this function is a row and column index for the pixel that
% end the current search, ideally it is in a new neighbour patch, and the ID
% for that patch can be retrieved through a labelled original image.
%
% This function is similar to Search_centralline_Segment_by_seed, the difference
% is this function is search outside a patch, while
% "Search_centralline_Segment_by_seed" is search inside a patch
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

%validation check, it should not happen
 if Mask_centralline(seed_x,seed_y)~=1
     disp('Failed: The input seed point is not on the central line')
     return;
 end
 
 %optional argument: T_gap_width
 if nargin < 5
  T_gap_width=100;
 end

 %image bounds
 [ROWS, COLS]=size(Mask_centralline);
 
 %define 8-neibhour by offset
 roff = [-1  0  1  1  1  0 -1 -1];
 coff = [-1 -1 -1  0  1  1  1  0];
 
%Row and column coordinates of available
 r_list = [seed_x]; 
 c_list = [seed_y];
 
%-------------Step 1.1: the first start pixel processing is different from the proceeding pixels
r = r_list(end)+roff;
c = c_list(end)+coff;
ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));
for i = ind
  if Mask_centralline(r(i),c(i)) == 1 && ~Mask_original(r(i), c(i));
    r_list = [r_list; r(i)];
    c_list = [c_list; c(i)];
    break; %only consider the first appeared pixel in case of divergence
   end
end

if length(r_list)==1 %if there is no valid points 
    return;
end
     
%-------------Step 1.2:the proceeding pixels are processed in a consistent way
  while 1
      r = r_list(end)+roff;
      c = c_list(end)+coff;

      %[r_list(end) c_list(end)]  %for test purpose
      % T_gap_width=100;
      if(length(r_list)>T_gap_width)  %for test purpose
          disp(['          Debug:   The central_line gap is larger than threshold: ', num2str(T_gap_width)]);
          disp(sprintf('          at start point (col, row): %d, %d', c_list(1),r_list(1)));
          return; 
      end
      
     % Find indices of arrays of r and c that are within the image bounds
     ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));

     num_centralline_pt_in_8_neigh=trace(Mask_centralline(r(ind),c(ind)));
    
     %case 1: less than 2 pixel in Neighbour are central_line pixels
     if num_centralline_pt_in_8_neigh<2 
         disp('    Debug: reach the end of central line') %this should not be happen
         return;
     
     %case 2: 2 pixel in Neighbour are central_line pixels: one in, one out
     elseif num_centralline_pt_in_8_neigh==2  
         for i = ind
            % If there is a loop and [c,r] is repeating one of the previous point in the list
            if  Mask_centralline(r(i),c(i)) == 1 && ... % on the central line
                length(r_list)>2 &&... %has more than 2 elements in the list    
                min(sum(abs([r_list(1:(end-2))-r(i), c_list(1:(end-2))-c(i)]),2))==0
                    return;

            elseif Mask_centralline(r(i),c(i)) == 1 && ... % on the central line
                    ~(r_list(end-1)==r(i) && c_list(end-1)==c(i));  % AND it is NOT the (end-1) pixel in the edge list
                   
                r_list = [r_list; r(i)];
                c_list = [c_list; c(i)];

                if Mask_original(r(i), c(i));  %if it reaches a new patch
                    return;
                end
                
                break; %for divergence , only process the first satisfied pixel
            end
         end
         
     %case 3: more than 2 pixel in Neighbour are central_line pixels: fork
     else  
         prev_2_cur_vector=[r_list(end),c_list(end)]-[r_list(end-1),c_list(end-1)];
         valid_neigh=find(diag(Mask_centralline(r(ind),c(ind))));
         cur_2_new_vector=zeros(length(valid_neigh),2);
         for i = 1:length(valid_neigh)  %find the (end-1) point on central_line
            % if ~(r_list(end-1)==r(i) && c_list(end-1)==c(i)) %not the previous end-1 th point
            if  length(r_list)>2 &&... %has more than 2 elements in the list    
                min(sum(abs([r_list(1:(end-2))-r(valid_neigh(i)), c_list(1:(end-2))-c(valid_neigh(i))]),2))==0
                disp('    Debug: detected loop, exit the current search')
                disp(sprintf('          at start point (col, row): %d, %d', c_list(1),r_list(1)));
                return;
            end
                cur_2_new_vector(i,:)=[r(valid_neigh(i)),c(valid_neigh(i))]-[r_list(end),c_list(end)];
            % end
         end
         vect_len=sqrt(cur_2_new_vector(:,1).^2+cur_2_new_vector(:,2).^2);
         direction_cos=(cur_2_new_vector./repmat(vect_len,1,2))*prev_2_cur_vector';
         [s,j]=max(direction_cos);
         r_list = [r_list; r(valid_neigh(j))];
         c_list = [c_list; c(valid_neigh(j))];
         if Mask_original(r(i), c(i));  %if it reaches a new patch
             return;
         end
     end
     
        % A pixel is available for linking if its value is 1 and it has not
        % reached a neighbour patch where the original mask will be 1

  end  %end of while
 
 
end %end of function