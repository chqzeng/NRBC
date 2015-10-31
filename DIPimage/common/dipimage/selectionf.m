%SELECTIONF   Selection filter
%
% SYNOPSIS:
%  out = selectionf(in,selection,filterSize,filterShape)
%
% PARAMETERS:
%  in:          image from which values are selected
%  selection:   image in which the local minimum is found
%  filterShape: 'rectangular', 'elliptic', 'diamond'
%  threshold:   minimum difference in 'selection' to shift kernel
%
% DEFAULTS:
%  filterSize = 7
%  filterShape = 'elliptic'
%  threshold = 0
%
% NOTE:
%  selectionf(unif(in),varif(in)) is the same as kuwahara(in)

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.

function out = selectionf(varargin)

d = struct('menu','Adaptive Filters',...
           'display','Selection filter',...
           'inparams',struct('name',       {'in',         'selection',      'filterSize',    'filterShape',    'threshold'},...
                             'description',{'Input image','Selection image','Size of filter','Shape of filter','Threshold'},...
                             'type',       {'image',      'image',          'array',         'option',         'array'},...
                             'dim_check',  {0,            0,                1,               0,                [1,1]},...
                             'range_check',{[],           [],               'R+',            {'rectangular','elliptic','diamond'},'R+'},...
                             'required',   {1,            1,                0,               0,                0},...
                             'default',    {'a',          'b',              7,               'elliptic',       0}...
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
   [in,selection,filterSize,filterShape,threshold] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ~isequal(size(in),size(selection))
   error('Images IN and SELECTION should be the same size.')
end

out = dip_generalisedkuwaharaimproved(in,selection,[],filterSize,filterShape,threshold,1);
