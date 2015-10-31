%TOPHAT   Top-hat
%
% SYNOPSIS:
%  out = tophat(in, filterSize, filterShape, edgeType, polarity)
%
% PARAMETERS:
%  filterSize : Size of the filter.
%  filterShape: 'rectangular', 'elliptic', 'diamond', 'parabolic'
%  edgeType   : Select the features to filter. One of: 'texture',
%               'object' or 'both'. 'texture' is the common top-hat.
%               'both' is the sum of 'texture' and 'object'.
%  polarity   : Select features to filter. One of: 'black', 'white'
%               ('black' is for "bottom-hat").
%
% DEFAULTS:
%  filterSize = 7
%  filterShape = 'elliptic'
%  edgeType = 'texture'  (regular top-hat)
%  polarity = 'white'
%
% EXPLANATION:
%  'texture','white' = in - opening(in)
%  'texture','black' = closing(in) - in
%  'object' ,'white' = opening(in)  - erosion(in)
%  'object' ,'black' = dilation(in) - closing(in)
%  'both'   ,'white' = in - erosion(in)
%  'both'   ,'black' = dilation(in) - in

 
% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2004.

function out = tophat(varargin)

d = struct('menu','Morphology',...
   'display','Top-hat',...
   'inparams',struct('name',{'in','fsz','fsh','egd','pol'},...
       'description',{'Input image','Size of filter','Shape of filter',...
                      'Edge Type','Polarity'},...
       'type',       {'image','array','option','option','option'},...
       'dim_check',  {0,1,0,0,0},...
       'range_check',{[],'R+',{'rectangular','elliptic','diamond','parabolic'},...
                      {'texture', 'object', 'both'},{'black', 'white'}},...
       'required',   {1,0,0,0,0},...
       'default',    {'a',7,'elliptic','texture','white'}...
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
   [in,fsz,fsh,egd,pol] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = dip_tophat(in,[],fsz,fsh,egd,pol);
