%NEWCOLORIM   Creates a dip_image color image of the specified size and colorspace
%   NEWCOLORIM(N) is an 1D image with N pixels all set to zero.
%
%   NEWCOLORIM([N,M]) is an N-by-M image. NEWCOLORIM, by itself,
%   creates an image of 256 by 256 pixels of colorspace RGB.
%
%   NEWCOLORIM([N,M,P,...]) is an N-by-M-by-P-by-... image.
%
%   NEWCOLORIM(B) creates an image with zeros with the same properties as B.
%
%   NEWCOLORIM(B, COL) creates an empty image with the the colorspace COL.
%
%   NEWCOLORIM([N,M,..],COL,TYPE) sets the data type of the new image to TYPE.
%   TYPE can be any of the type parameters allowed by DIP_IMAGE. The
%   default data type is 'sfloat'.
%
%   Recognized color spaces are:
%        L*a*b* (or Lab, CIELAB)
%        L*u*v* (or Luv, CIELUV)
%        L*C*H* (or LCH)
%        RGB
%        R'G'B'
%        XYZ
%        Yxy
%        CMY
%        CMYK
%        HCV
%        HSV
%
%  SEE ALSO: newim, newimar

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger and Cris Luengo, April 2011

function out = newcolorim(varargin)
list_col = {'L*a*b*','L*u*v*','RGB','R''G''B''','XYZ','Yxy','CMY','CMYK','HCV','HSV','art','L*C*H*'};

d = struct('menu','Generation',...
             'display','New color image',...
             'inparams',struct('name',       {'sz', 'col',     'dip_type'},...
                               'description',{'Size', 'Color space',   'Data type'},...
                               'type',       {'array',  'option',  'option'},...
                               'dim_check',  {-1,       0,0},...
                               'range_check',{'N+',list_col,     {'bin','uint8','uint16','uint32','sint8','sint16','sint32','sfloat','dfloat','scomplex','dcomplex'}},...
                               'required',   {0,        0,0},...
                               'default',    {[256,256],'rgb','uint8'}...
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
   [sz,col,dip_type] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
b = double(col);
N = sum(b>64 & b<91) + sum(b>96 & b<123); %only check the letters
%N = length(col)
out = newimar(N);
out{:} = newim(sz,dip_type);
out = colorspace(out,col);
