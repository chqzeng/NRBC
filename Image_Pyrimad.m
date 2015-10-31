function mask_density=Image_Pyrimad(Img_Input,scale)
%-------------------Copyright and citiation--------------------------------
%  This code is published under GNU GENERAL PUBLIC LICENSE v3, more details about this license please read: [here] ( https://github.com/chqzeng/NRBC/blob/master/LICENSE)
%
% Please cite this work as:  
% Zeng, C.; Bird, S.; Luce, J.J.; Wang, J. A Natural-Rule-Based-Connection (NRBC) Method for River Network Extraction from High-Resolution Imagery. Remote Sens. 2015, 7, 14055-14078.
% open accessed  of this paper: [Here] (http://www.mdpi.com/2072-4292/7/10/14055).
% 
% Contact:  Chuiqing Zeng:   chqzeng@gmail.com  
%------------------------------------------------------------------------------

    %scale=3;  %the image pyrimad scale
    
    %test_data=meshgrid(1:40,10:50);
    iteration=fix(size(Img_Input)/scale);  %water_mask_larger_Area_fill
    data_reshape=zeros(iteration(1),iteration(2),scale^2);  % a matrix M * N * (scale)^2
    new_size=iteration*scale;
    for idx=1:scale
        for idy=1:scale
        filter_x=idx:scale:new_size(1);
        filter_y=idy:scale:new_size(2);
        ind=scale*(idx-1)+idy;  %the index in the third dimension
        data_reshape(:,:,ind)=Img_Input(filter_x,filter_y);  %water_mask_larger_Area_fill
        end
    end
    mask_density=sum(data_reshape,3)/scale^2;  %calucalate the density of mask
end