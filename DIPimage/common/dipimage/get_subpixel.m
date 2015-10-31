%GET_SUBPIXEL   Retrieves subpixel values in an image
%
% USAGE:
%  out = get_subpixel(in, coord, method)
%
% PARAMETERS:
%  coord: image coordinates of interest;
%      can be a list of coordinates:
%      coord = [x' y'], x=[11.2 2.2 10.2],y=[0.1 2.3 3.7]
%  method: 'linear', 'spline', 'cubic', 'nearest'
%  out = array containing the interpolated values
%
% DEFAULTS:
%  method = 'linear'
%
% NOTE:
%  The image is converted to singles or doubles in this function,
%  so it might not be recommended for large images. On MATLAB
%  versions prior to 7.0, the image is always converted to doubles.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Sep 2001
% Nov, 2002:     Added nD support (BR)
% 9 April 2007:  Removed use of EVAL. (CL)
% 11 April 2007: Fixed bug, INTERPN needs x and y coordinates exchanged.
% 12 April 2007: Fixed bug, test for negative coordinates was not correct.
% 13 March 2009: Fixed bug, for 1D images
% 18 September 2009: Using the MATLABv7 ability to interpolate singles.
% 17 December 2009:  Using new function MATLABVER_GE. Converting output to DOUBLE.
% 10 May 2010:       Fixed bug for 1D images. (CL)
% 21 July 2010:      Simplified using NUM2CELL. (CL)

function out = get_subpixel(varargin)

d = struct('menu','Point',...
           'display','Subpixel value extraction',...
           'inparams',struct('name',       {'in',         'po',       'method'},...
                             'description',{'Input image','Points',   'method'},...
                             'type',       {'image',      'array',    'option'},...
                             'dim_check',  {0,            [-1,-1],    0},...
                             'range_check',{[],'R',{'linear','spline','cubic','nearest'}},...
                             'required',   {1,            1,           0},...
                             'default',    {'a',          0,           'linear'}...
                             ),...
            'outparams',struct('name',{'out'},...
                               'description',{'Output image'},...
                               'type',{'image'}...
                               )...
            );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end
try
   [in, po, method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

sz = imsize(in);
nd = length(sz);

if size(po,2)~=nd
   error('Image and point dimensions do not match.');
end
if any(any(po<0))
   error('Some coordinates are negative.');
end

if any(any(po>repmat(sz,size(po,1),1)))
   error('Coordinates out of image bounds.');
end

in = dip_array(in);
if ~strcmp(class(in),'double')
   if matlabver_ge([7,0])
      in = single(in);
   else
      in = double(in);
   end
end

po=po+1; % we use matlab
if nd==1
   out = interp1(in,po,method);
else
   s = num2cell(po,1);
   s = s([2,1,3:end]); % Switching coordinates, INTERPN uses y-x-z indexing.
   out = interpn(in,s{:},method);
end

out = double(out); % in case we used singles to interpolate.
