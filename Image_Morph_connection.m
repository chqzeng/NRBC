function [Img_filled Img_new_parts]=Image_Morph_connection(Img_Input_lower_level,Img_Input_upper_level,Img_Input_NDVI, scale,Pyr_level)
%using the morphological method to fill the gaps between patches in lower
%level of a pyramid with the guidance from the upper level of the pyramid
%(coarser image spatial resolution)
% Input:   binary images
%Img_Input_lower_level: lower level image in the pyramid, with higher
%                       spatial resolution
%Img_Input_upper_level: upper level image in the pyramid, with lower
%                       spatial resolution, smaller size (about 1/search_range)
%search_range:                 The search_range between images in the pyramid, e.g.,2,3
%Pyr_level:             The level of pyramid start as 1 from the top of the
%                       pyramid, and it is N at the original image level
%
%
%%output
%Img_filled:            The output binary image that is filled with
%                       connected pixels
%Img_new_parts:         Only the filled parts, but not include the pixels
%                       of the lower level
%
%Img_Input_NDVI:        the mask of NDVI to indicator where should not be
%                       filled. NDVI=1 means it is veg, otherwise is 0
%
%%------The idea to connect points . ------------------
% the test image should be an int8 image with values: 
% 0:         means background, no operation needed;
% 1:         means only have value in upper level image, points to be
% processed
% 2:         means have value for both upper and lower level images, used
% are reference to validate whether pixels with value 1 should be connected
% for a block of pixels with the following values:
%
%2  2   2   0   0   0
%2  2   1   0   0   0
%2  2   1   1   2   2
%2  1   1   1   2   2
%0  0   0   2   2   0
%
%points with value 1 will be searched and processed,
% the four directions : horizontal, vertical and the two diagonal will be
% processed separately, as soon as any of the four direction satisfied the
% rules, the pixel 1 will be filled (turn into 2)
%
% The rule is:  for each direction, start from the pixel toward left or
% right, it should find a pixel value 2 with in one search_range unit ("search_range" pixels)
% at the same time, there should be no background pixel on the search route
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

%check the input image and they should be the same resolution 
%or at least been overlapped together,  
temp_upper_resized= imresize(Img_Input_upper_level>0, scale,'nearest');
temp_upper_size=size(temp_upper_resized);
temp_lower_size=size(Img_Input_lower_level);  %the size of image for operation at lower level
if min(temp_upper_size<temp_lower_size)<0
    disp('wrong input image dimensions:')
    disp('The upper level image should be eqaul or less than 1/search_range of width and length, compared with the lower level image')
end

%initial the test image
Test_image=uint8(Img_Input_lower_level>0); %set the initial values
Test_image(1:temp_upper_size(1),1:temp_upper_size(2))=Test_image(1:temp_upper_size(1),1:temp_upper_size(2)) ...
    + uint8(temp_upper_resized); %update by adding the value from upper level image

% iterate each of the pixel with value 1
[list_x,list_y]= find(Test_image==1);  %list of all candidates

%initialize the output matrices
Img_filled =Img_Input_lower_level>0;
Img_new_parts=uint8(zeros(size(Img_filled)));

for idx_candidate=1:length(list_x)
    
%%--------------------step 1: search through the horizontal directi0n------
%     temp_left=Test_image(current_candidate);  %initial of the left size value
%     for idx_left=1:search_range %search toward the left direction
%         idx_x=list_x(idx_candidate)-idx_left; %the left size direction x
%         idx_y=list_y(idx_candidate); %y keep constant for horizontal case
%         if min([idx_x, idx_y, temp_lower_size(1)-idx_x+1,  temp_lower_size(2)-idx_y+1])<=0  %%pixel out of bound
%             break;
%         end
%         temp_left=temp_left*Test_image(idx_x,idx_y);  %multiple the value together
%         if temp_left ~= 1  % if there are not pixel value 1,but 0 or 2 show up
%             break
%         end
%     end
%     temp_right=Test_image(current_candidate);  %initial of the left size value
%     for idx_right=1:search_range %search toward the right direction
%         idx_x=list_x(idx_candidate) + idx_right; %the right size direction x
%         idx_y=list_y(idx_candidate); %y keep constant for horizontal case
%         if min([idx_x, idx_y, temp_lower_size(1)-idx_x+1,  temp_lower_size(2)-idx_y+1])<=0  %%pixel out of bound
%             break;
%         end
%         temp_right=temp_left*Test_image(idx_x,idx_y);  %multiple the value together
%         if temp_right ~= 1  % if there are not pixel value 1,but 0 or 2 show up
%             break
%         end
%     end


    current_candidate=[list_x(idx_candidate) list_y(idx_candidate)]; %the location of the current pixel
    search_range=scale^Pyr_level;  %the search range increases when it going down in the pyramid
    
%%--------------step 0: check the NDVI of the pixel, if it is vegetation, then pass------------    
    if Img_Input_NDVI(list_x(idx_candidate), list_y(idx_candidate))
        continue;
    end
%%--------------step 1: search through the horizontal directi0n------------
       
       [temp_left idx_left]=check_direction(Test_image, current_candidate, search_range,-1,0);
       [temp_right idx_right]=check_direction(Test_image, current_candidate, search_range,1,0);
    
    %check the validation of this pixel at the current direction
    if temp_left * temp_right >=4 && (idx_left+idx_right)<2*search_range % only when BOTH left side and right are 2
        %update the output values
        Img_filled(current_candidate(1),current_candidate(2))=1;  
        %%%pixel in image with 0 (background) 1 (only upper image) 2 (both lower and upper)
        Img_new_parts(current_candidate(1),current_candidate(2))=1;  %binary image with 1 to show a new pixel
        continue;
    end
    
    %%----step 2: search through the vertical directi0n-----
       [temp_left idx_left]=check_direction(Test_image, current_candidate, search_range,0,-1);
       [temp_right idx_right]=check_direction(Test_image, current_candidate, search_range,0,1);
    
    %check the validation of this pixel at the current direction
    if temp_left * temp_right >=4 && (idx_left+idx_right)<2*search_range % only when BOTH left side and right are 2
        %update the output values
        Img_filled(current_candidate(1),current_candidate(2))=1;  
        %%% pixel in image with 0 (background) 1 (only upper image) 2 (both lower and upper)
        Img_new_parts(current_candidate(1),current_candidate(2))=1;  %binary image with 1 to show a new pixel
        continue;
    end
    
    %%----step 3: search through the vertical 1 (45 degree) directi0n-----
       [temp_left idx_left]=check_direction(Test_image, current_candidate, search_range,1,1);
       [temp_right idx_right]=check_direction(Test_image, current_candidate, search_range,-1,-1);
    
    %check the validation of this pixel at the current direction
    if temp_left * temp_right >=4 && (idx_left+idx_right)<2*search_range % only when BOTH left side and right are 2
        %update the output values
        Img_filled(current_candidate(1),current_candidate(2))=1;  
        %%% pixel in image with 0 (background) 1 (only upper image) 2 (both lower and upper)
        Img_new_parts(current_candidate(1),current_candidate(2))=1;  %binary image with 1 to show a new pixel
        continue;
    end
    
    %%-----------step 4: search through the vertical 2 (135 degree)directi0n-----------
       [temp_left idx_left]=check_direction(Test_image, current_candidate, search_range,-1,1);
       [temp_right idx_right]=check_direction(Test_image, current_candidate, search_range,1,-1);
    
    %check the validation of this pixel at the current direction
    if temp_left * temp_right >=4 && (idx_left+idx_right)<2*search_range % only when BOTH left side and right are 2
        %update the output values
        Img_filled(current_candidate(1),current_candidate(2))=1;  
        %%% pixel in image with 0 (background) 1 (only upper image) 2 (both lower and upper)
        Img_new_parts(current_candidate(1),current_candidate(2))=1;  %binary image with 1 to show a new pixel
        continue;
    end
 
end


end

%internal function
function [temp_value temp_index]=check_direction(Test_image, current_candidate,search_range,sign_x,sign_y)
%%the sign_x and sign_y used to control the pixel movement toward left,
%%right or diagnoal, their values can be -1,0, or 1

temp_value=Test_image(current_candidate(1),current_candidate(2));  %inital of the left size value
temp_lower_size=size(Test_image);
    for temp_index=1:search_range %search toward the left direction
        idx_x=current_candidate(1)+sign_x*temp_index; % increase the x direction
        idx_y=current_candidate(2)+sign_y*temp_index; % increase the y direction
        if min([idx_x, idx_y, temp_lower_size(1)-idx_x+1,  temp_lower_size(2)-idx_y+1])<=0  %%pixel out of bound
            break;
        end
        temp_value=temp_value*Test_image(idx_x,idx_y);  %multiple the value together
        if temp_value ~= 1  % if there are not pixel value 1,but 0 or 2 show up
            break
        end
    end
end