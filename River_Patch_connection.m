function [Mask_filled, Mask_new_parts,conn_Patches_indicateor]=River_Patch_connection(Mask_original,Mask_Pyrimad_connected,T_gap_width, T_dir_theta,T_Len_r_gap,T_width_ratio)
% River_Patch_connection - The overall summarized function to connect river patches
%
% Usage: [Mask_filled Mask_new_parts]=River_Patch_connection(Mask_original,Mask_Pyrimad_connected,T_gap_width, T_dir_theta,T_Len_r_gap,T_width_ratio)
%
%
% Arguments:  Mask_original           - The Mask of original water body detection before pyramid 
%             Mask_Pyrimad_connected  - The Mask of original water body detection after pyramid connected
%             T_gap_width,     -optional: Threshold for connect-able gap width ; default is 100 pixels       
%             T_dir_theta,     -optional: Threshold for direction change of two neighbour patches (in degree); default is 90           
%             T_Len_r_gap      -optional: Threshold for min length of patch along central line direction compared in ratio of central line gap; default is 2
%             T_width_ratio    -optional: Threshold for max(w1,w2)/min(w1,w2) < T_width_ratio; default is 3
%
% Returns:  Mask_filled   - the Mask, with same size as Mask_original, give the mask after connection
%           Mask_new_parts   -the mask that gives the pixels that merely filled during the connection, not include the original pixels.
%
% Example: [Mask_filled Mask_new_parts]=River_Patch_connection(Img,Img_connected);%with default optional parameters
%       or [Mask_filled Mask_new_parts]=River_Patch_connection(Img,Img_connected,[],90,[],3); %with some user defined optional parameters
%
% Function Description:  This the summary function that includes the
% overall process of the river patch connection. This function may also be
% used in other objects such as the road patches, or building patches,
% after automated detection from remote sensing imagery. It may also be
% used for other image processing purpose based on users' requirement
%
% This function consists of THREE major steps:
% 
% Step 1: detect the potential connection between patches with the
% guidance of the connected patched after pyramid, it provides the
% topological relations between patches. For example, two patches are about
% to be connected should be topologically connected in the pyramid
% processing; otherwise it won't be connected.
%
% Step 2: for potential connection patches, a series of criteria are
% tested and only patch pairs that satisfy ALL the rules will be eligible for
% further processing. These rules include: a) the gap width: too wide gap
% cannot be connected; b) the direction difference from one patch to the
% other: two patches should have similar direction; c) length along the
% connection direction: a patch should be a certain times longer than the
% gap itself along the central_line; d)Width along the connection direction:  
% The two patches should have consistent width at the connecting end.
%
% Step 3: connection. If two patches are eligible to connect, they will
% connected together by filling the gap between them. the perimeter of the
% union object from three objects (the two patches and the filled gap) is
% used as the rule for an optimal gap fill width: the ideal gap fill will
% make the final filled new patch has the minimum perimeter.
%
% See also:  Search_neighour_patch_by_seed,Neighour_patch_Connection,Neighour_patch_filled
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
% Version: February  2014 Dec - Original version
 

%check input image size consistence
if max(abs(size(Mask_original)-size(Mask_Pyrimad_connected)))>0
    disp('Please input two image with exactly same size')
    return;
end

%input optional parameters
if ~exist('T_gap_width','var')|| isempty(T_gap_width) %condition 0: the gap width should be less than a certain value
    T_gap_width=100;
end
if ~exist('T_dir_theta','var')|| isempty(T_dir_theta)
    T_dir_theta=90;   %condition 1: the direction change should be less than a given angle
end
if ~exist('T_Len_r_gap','var')|| isempty(T_Len_r_gap)
    T_Len_r_gap=2;    %condition 2: The length of patch along central line direction should be longer than (T_Len_r_gap) times of gap
end
if ~exist('T_width_ratio','var')|| isempty(T_width_ratio)
    T_width_ratio=3;  %condition 3: the width of the patches should be: max(w1,w2)/min(w1,w2) < T_width_ratio
end

%iniitalize the output matrices
Mask_filled =Mask_original>0;
Mask_new_parts=zeros(size(Mask_filled))<0;  %logical matrix of zeros

% global Mask_origin_outline;
% global Mask_pyrimad_centralline;
% global Mask_origin;

%calculate the outline of the original mask after preprocessing (fill small holes )
Mask_origin_outline= bwmorph(Mask_original,'remove');
% %or using:
% Mask_origin_outline = bwperim(Mask_original, 8)% in 8-neighbourhood

%generate the central line for the connected mask after pyramid
Mask_original_labelled = bwlabel(Mask_original, 8); % in 8-neighbourhood


Mask_pyrimad_centralline= bwmorph(Mask_Pyrimad_connected,'thin',Inf);
%for test
%Mask_pyrimad_centralline(8065:8070,5145:5155)=0;Mask_pyrimad_centralline(8040:8050,5250:5260)=0;

%[Mask_pyrimad_central_list edgeim etypr] = edgelink(Mask_pyrimad_centralline);
%%nedgelist = cleanedgelist(edgelist, Max_River_width/2);

%---------------------pre-processing: find the intersection of central_line and  the outline of the original mask
Mask_centralline_edge_pixels=Mask_pyrimad_centralline & Mask_origin_outline; %points on both outline and central line
%some rare case, for example e is edge(outline) pixels, and c is central_line pixels:
% e c
% c e
% they are crossed but not have any overlapped pixels
% A way to solve this problem it detect the [1 1; 1 1] patterns in an image of their union(|, OR) image 

%detect the [1 1 ;1 1] pattern
lut = makelut('sum(x(:)) == 4',2);
test=Mask_pyrimad_centralline + Mask_origin_outline;  % a temporary image to search for [1 1; 1 1]blocks
test=applylut(test,lut); %the LUT will detect all the [1 1; 1 1]block and give the left-upper corner as value "1"
test(2:end,:)=test(2:end,:)+test(1:end-1,:);  %fill the entire [1 1 ; 1  1] block to vlaue "1"
test(:,2:end)=test(:,2:end)+test(:,1:end-1);
test=test & Mask_pyrimad_centralline & Mask_original; %the extra seed points are within the [1 1;1 1]blocks, on the central line; and inside patches.
Mask_centralline_edge_pixels=Mask_centralline_edge_pixels | test;


%build the structure of the original mask, for easily search their Area,Perimeter, and Bounds
Conn_comp= bwconncomp(Mask_original,8);
water_Patches = regionprops(Conn_comp, 'BoundingBox', 'Image','Perimeter','Area'); 
num_Patches=length(water_Patches);

% define a matrix to store/update the connected patch-pairs
conn_Patches_indicateor=zeros(num_Patches);  

for ind_patch=1:num_Patches  %process each patch separately, execute the three steps  
    
     disp(['Debug: current processing patch: ', num2str(ind_patch)]);
    
%%--------------------step 0: search for the intersection of central_line and the patch outline pixels, treat them as seeds---------------
    current_patch=water_Patches(ind_patch);
    
    if current_patch.Area < 50 %too small area
        continue;
    end
    
    temp_Extent=[current_patch.BoundingBox(1:2);current_patch.BoundingBox(1:2)+current_patch.BoundingBox(3:4)-[1 1]];
    temp_Extent=fix(temp_Extent+1); %because the offset image will start from (1,1) rather than (0,0)
    minY=temp_Extent(1);
    maxY=temp_Extent(2);
    minX=temp_Extent(3);
    maxX=temp_Extent(4);
    cur_Patch_image=current_patch.Image;
    
    %obtain the corresponding seed pixels: as the intersection of central_line and outline 
    [cur_patch_seed_x,cur_patch_seed_y]=find(Mask_centralline_edge_pixels(minX:maxX, minY:maxY)& cur_Patch_image);
    cur_patch_seed_x=cur_patch_seed_x+ (minX-1); %add the offset back to the image
    cur_patch_seed_y=cur_patch_seed_y+ (minY-1);
      
    
%%---------------------step 1: use the intersected seed pixels to find potential connected neighour patches----------------------
   neibghour_Patch_list=[];
   List_gap_Central_line_pts=[];
   
    num_seeds=length(cur_patch_seed_x);
    for ind_seed=1:num_seeds  %process each seed pixel
       
        % the core function of Step 1: to search for the neighbour by given seed points 
        [r_list,c_list]=Search_neighour_patch_by_seed(cur_patch_seed_x(ind_seed),cur_patch_seed_y(ind_seed),Mask_pyrimad_centralline,Mask_original,T_gap_width);
        endPT_x=r_list(end);
        endPT_y=c_list(end);
        neirghour_Patch_ID=Mask_original_labelled(endPT_x,endPT_y);
        
        %if the neighour patch is not the patch itself, add to the list
        if (neirghour_Patch_ID>0 && neirghour_Patch_ID~=ind_patch)
           
            %if this patch id is already in the list, then compare the
            %distance of the connected edge, if the new one is short than
            %the old one, replace the old connection with the new one.
            exist_patch_index=find(neibghour_Patch_list==neirghour_Patch_ID);
            
            if isempty(exist_patch_index)
                neibghour_Patch_list=[neibghour_Patch_list; neirghour_Patch_ID]; 
                List_gap_Central_line_pts{length(List_gap_Central_line_pts)+1}=[r_list,c_list];
            else
                dist_old=norm(List_gap_Central_line_pts{exist_patch_index(1)}(1,:)-List_gap_Central_line_pts{exist_patch_index(1)}(end,:));
                dist_new=norm([cur_patch_seed_x(ind_seed),cur_patch_seed_y(ind_seed)]-[endPT_x,endPT_y]);

                if dist_new < dist_old   %short distance, then update
                    List_gap_Central_line_pts{exist_patch_index(1)}=[r_list,c_list];
                end
            end
        end
    end

%%---------------------step 2:  to determine the connection between two  patches-------------------
    for ind_neighour=1:length(neibghour_Patch_list)
        cur_neirghour_patch_id=neibghour_Patch_list(ind_neighour);
        
        if conn_Patches_indicateor(ind_patch,cur_neirghour_patch_id) %if these two have already been connected
            continue;
        end
        disp(['     Debug: process potential connected neighbour patch:', num2str(cur_neirghour_patch_id)]);
        
         % the core function of Step 2: to determine whether the two patches are eligible for connection
        [bConnected, Ref_Width , Neigh_Width] = Neighour_patch_Connection (Mask_original,Mask_origin_outline,Mask_pyrimad_centralline,water_Patches,...
            ind_patch,cur_neirghour_patch_id,List_gap_Central_line_pts{ind_neighour}, T_dir_theta,T_Len_r_gap,T_width_ratio);
         
%%---------------------step 3:  if connected, filled the gap between two  patches-------------------      
        if bConnected  %if two patches are connected 
             % the core function of Step 3: to connect the two patches by filling their gap 
            Pixel_list_filled=Neighour_patch_filled(Mask_original,Mask_pyrimad_centralline,...
                ind_patch,cur_neirghour_patch_id,List_gap_Central_line_pts{ind_neighour},Ref_Width, Neigh_Width);
            
            Mask_filled(Pixel_list_filled)=1;  %filled area are update as 1 now
            Mask_new_parts(Pixel_list_filled)=1;

            %update the indicator matrix
            conn_Patches_indicateor(ind_patch,cur_neirghour_patch_id) = 1; %indicate these two patches are now connected and now need to process anymore
            conn_Patches_indicateor(cur_neirghour_patch_id,ind_patch) = 1;
            
            disp(['          Debug: successful case; fill this neighbour patch']);
        end
    end  %end of iteration for each potential connected Neighbour patch
    
end  %end of iteration for each patch

%   clear global Mask_origin;
%   clear global Mask_pyrimad_centralline;
%   clear global Mask_origin_outline;

end  %end of function





