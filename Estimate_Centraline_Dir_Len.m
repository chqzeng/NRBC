function bLargerThanThreshold=Estimate_Centraline_Dir_Len(seed_x, seed_y, Mask_centralline,Mask_original,T_max_length)
% Estimate_Centraline_Dir_Len - estimate the length of the patch along the direction of the central line, 
%                               please note the length along central_line is different from its true length                        
%
% Usage: bLargerThanThreshold=Estimate_Centraline_Dir_Len(seed_x, seed_y, Mask_centralline,Mask_original,T_max_length)
%
%
% Arguments:  seed_x       -the row (x) index of the seed in the image
%             seed_y       -the column(y) index of the seed in the image
%             Mask_centralline  - The Mask of the central_line for the mask after pyramid connection of gaps 
%             Mask_original     - The Mask of original water body detection before pyramid  
%             T_max_length       - the maximum length to detect, if the patch has length larger than this value, it will return as "success" 
%
% Returns:  bLargerThanThreshold - If the extended length >= T_max_length, then it is true; otherwise it is false          
%
%
% Function Description: this function is used to determine whether the
% patch is longer enough along the central_line direction; as one of the
% eligibility for connect two patches. it uses the central_line to trace
% toward the opposite direction of gap. If it can trace (T_max_length)
% number of pixels, then it will return a "true" value
% 
%
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

%initial the return value as false
bLargerThanThreshold=0;

%if the input point is not on the central line; it should not happen
 if Mask_centralline(seed_x,seed_y)~=1
     disp('Failed: The input seed point is not on the central line')
     return;
 end
 
 % define the image bounds
 [ROWS, COLS]=size(Mask_centralline);
 
 % row and column offsets for the eight neighbours of a point
 roff = [-1  0  1  1  1  0 -1 -1];
 coff = [-1 -1 -1  0  1  1  1  0];
 
%Row and column coordinates of available
 r_list = [seed_x]; c_list = [seed_y];
      
%-------------the proceeding pixels are processed in a consistent way
  while 1
      r = r_list(end)+roff;
      c = c_list(end)+coff;

      %the exit condition: where length has reach (T_max_length)
      if(length(r_list)>=T_max_length)  
          bLargerThanThreshold=1;
          return; 
      end
      
     % Find indices of arrays of r and c that are within the image bounds
     ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));

     num_centralline_pt_in_8_neigh=trace(Mask_centralline(r(ind),c(ind)));
     
     if num_centralline_pt_in_8_neigh<2   %less than two neighbour pixels are central line
         %disp('    Debug: reach the end of central line') 
         if (length(r_list)>=T_max_length); bLargerThanThreshold=1; end;
         return;
     else  %num_centralline_pt_in_8_neigh>=2 indicator more than 2 central line pts in 8-neigh
        
         %find the 8-neigh that are on the central_line
         prev_2_cur_vector=[r_list(end),c_list(end)]-[r_list(end-1),c_list(end-1)];
         valid_neigh=find(diag(Mask_centralline(r(ind),c(ind))));
         cur_2_new_vector=zeros(length(valid_neigh),2);
         
         %for those 8-neigh pixels on the central line 
         for i = 1:length(valid_neigh)  %find the (end-1) point on central_line
            % if ~(r_list(end-1)==r(i) && c_list(end-1)==c(i)) %not the previous end-1 th point
            if  min(sum(abs([r_list(1:(end-2))-r(valid_neigh(i)), c_list(1:(end-2))-c(valid_neigh(i))]),2))==0  %NOT repeat a previous pixel in the list   
                %disp('    Debug: detected loop, exit the current search')
                %disp(sprintf('          at start point (col, row): %d, %d', c_list(1),r_list(1)));
                if (length(r_list)>=T_max_length); bLargerThanThreshold=1; end;
                return;
            end
            %update the direction vector: from central pixel --> neighbour pixel 
            cur_2_new_vector(i,:)=[r(valid_neigh(i)),c(valid_neigh(i))]-[r_list(end),c_list(end)];
         end
         
         %normaliz(unitilize) the direction vectors since some vectors has length sqrt(2) 
         vect_len=sqrt(cur_2_new_vector(:,1).^2+cur_2_new_vector(:,2).^2);
         
         % the dot product of:  cose(thea)=[(n)pixel --> (n-1) pixel].[(n+1)pixel --> (n) pixel] , tells the direction of this two vector 
         direction_cos=(cur_2_new_vector./repmat(vect_len,1,2))*prev_2_cur_vector';
         
         %The ideal extending direction should consistent with previous direction:
         %from (n-1) pixel --> (n) pixel , with cos(theta) clsoe to 1
         [s,j]=max(direction_cos);
         
         %update the extending list
         r_list = [r_list; r(valid_neigh(j))];
         c_list = [c_list; c(valid_neigh(j))];
         
         %if the current extending pixel is about to out of the patch
         %boundary, then exit 
         if ~Mask_original(r(valid_neigh(j)), c(valid_neigh(j)));  %if it reaches a edge of the patch
             if (length(r_list)>=T_max_length); bLargerThanThreshold=1; end;
             return;
         end
     end
  end
 
 
end