%HIST2D  generates a 2D histogram
%
% SYNOPSIS:
%  out = hist2d(in1,in2,mask,bin1,bin2,range1,range2,...
%         contourhist,logdisp,contourfill,contourlab,Nl)
%
% PARAMETERS:
%  in1:     first input image
%  in2:     second input image
%  mask:    region where histogram should be evaluted
%  bin1:    number of bins for first image
%  bin2:    number of bins for second image
%  range1:  [min max] two values specifying the data range
%  range2:  [min max] two values specifying the data range
%  contourhist: should a contour plot be made ('yes','no')
%  logdisp:     log plot for axes ('none','x-axis','y-axis','z-axis','xy-axes','xyz-axes')
%  contourfill: fill the contour plot? ('yes','no')
%  contourlab : label the contour lines?  ('yes','no')
%  Nl:      Number of contour lines
%
% DEFAULTS:
%  bins1: 100 % change to smaller (+-50) values if result is too sparse
%  bins2: 100
%  range1: [] % the minimum and maximum value of image 1 is taken
%  range2: [] % the minimum and maximum value of image 2 is taken
%  contourhist: 'No'
%  Nl: -1, automatic
%
% HINTS: use Mappings -> Custom -> 'jet' for a nice colormap
%        use axis xy, to flip the axis
%
% NOTE:
%   This function calls DIPHIST2D with the BIN and RANGE parameters
%   switched. It is better to call DIPHIST2 directly.
%
% SEE ALSO:
%  hist2image, dip_mdhistogram for higher dimensional histograms

% (C) Copyright 2004-2009      Department of Molecular Biology
%     All rights reserved      Max-Planck-Institute for Biophysical Chemistry
%                              Am Fassberg 11, 37077 G"ottingen
%                              Germany
%
% Bernd Rieger, 2004.
% 17 December 2009: Calling DIPHIST2D instead of replicating the code.

function out = hist2d(varargin)
% The input arguments were switched when the function name changed:
if length(varargin)>4
   % fill in some default values so we can do the switch
   if length(varargin)<5
      varargin{5} = 100;
   end
   if length(varargin)<6
      varargin{6} = [];
   end
   if length(varargin)<7
      varargin{7} = [];
   end
   % do the switch
   varargin(4:7) = varargin([6,7,4,5]);
end
out = diphist2d(varargin{:});
