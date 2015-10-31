function [xy_fit, slope_cos_values]=curve_fitting_with_bspline(input_x,input_y,scale)
% curve_fitting_with_bspline - give a list of x, and y , fit them with baspline 
%
% Usage: [xy_fit, slope_cos_values]=curve_fitting_with_bspline(input_x,input_y)
%
%
% Arguments:  input_x         - the input x list, 
%             input_y         - the input y list,
%                              input_x and input_y should give a meaning point list rather than random points 
%              scale          -the times of points will be interpolated
% 
% Returns:  xy_fit                  - a group of points of the (scale*n by scale*n ) size as input, but after fitted spline
%           slope_cos_values        - the (n-1)by(n-1) matrices of cosine values for any two pixel of the adjacent input x y list
%
%
% Function Description: This function is similar to MATLAB default polyfit
% but more advanced, since this function is able to fit splines with
% non-increasing x or y, or both, which means x and y can be repeated in
% the input data list. It happens for rivers where the coords can be
% repeated for either x or y direction.
%
%
% Dependences:  PLEASE NOTE THAT THIS FUNCTION IS RELIED ON function
% "splinefit", which was written by 
% Jonas Lundgren <splinefit@gmail.com> 2010  
% this function and its relied function can be found in Matlab Central
% File Exchange library: http://www.mathworks.com/matlabcentral/fileexchange/13812-splinefit
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

if nargin < 3  %optinal input
    scale=2;
end
    %calculate the length of the input list.
    ds = sqrt(diff(input_x').^2 + diff(input_y').^2);
    Path_s = [0, cumsum(ds)];
    %pp1 = splinefit(Path_s,sortedd_data,8,0.25);
    
%     if length(input_x)<=2 %in case the central line gap is very narrow: 1 or 2 pixel wide
%     end
    
    % use the min function to tolerate cases when there are only a few
    % points in the incoming x and y list
    pp1 = splinefit(Path_s,[input_x';input_y'],min(length(input_x),3),min(length(input_x-1),2)); % Piecewise quadratic
    
    %interpolate the curve with (2*pixel number) sects
    n_seg=length(input_x)*scale;
    ss = linspace(0,Path_s(end),n_seg);
    xy_fit = ppval(pp1,ss);
    %xy_break = ppval(pp1,pp1.breaks);
    
    %draw the line 
    if 0  %or 0: to close the draw function
        hold on;
        plot(input_y',input_x','.')
        plot(xy_fit(2,:),xy_fit(1,:),'r',xy_break(2,:),xy_break(1,:),'*r');
        hold off;
    end
    
    diff_xy=(diff(xy_fit'))';  %define the slope by slope=atan((y2-y1)/(x2-x1))
    
    %calculate the direction differnce separately, by dot product of vectors
    ds = sqrt(diff_xy(1,:).^2 + diff_xy(2,:).^2);
    norm_diff_xy=diff_xy./repmat(ds,2,1);
    slope_cos_values=norm_diff_xy'*norm_diff_xy;  %please note it is (n-1)by(n-1)
    
end