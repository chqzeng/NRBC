%DIPHIST2D   Generates a 2D histogram
%
% SYNOPSIS:
%  [out,h] = diphist2d(in1,in2,mask,range1,range2,bin1,bin2,...
%         contourhist,logdisp,contourfill,contourlab,Nl)
%
% PARAMETERS:
%  in1:     first input image
%  in2:     second input image
%  mask:    region where histogram should be evaluted
%  range1:  [min max] two values specifying the data range
%  range2:  [min max] two values specifying the data range
%  bin1:    number of bins for first image
%  bin2:    number of bins for second image
%  contourhist: should a contour plot be made ('yes','no')
%  logdisp:     log plot for axes ('none','x-axis','y-axis','z-axis','xy-axes','xyz-axes')
%  contourfill: fill the contour plot? ('yes','no')
%  contourlab : label the contour lines?  ('yes','no')
%  Nl:      number of contour lines
%
% DEFAULTS:
%  range1: [] % the minimum and maximum value of image 1 is taken
%  range2: [] % the minimum and maximum value of image 2 is taken
%  bins1: 100 % change to smaller (+-50) values if result is too sparse
%  bins2: 100
%  contourhist: 'No'
%  Nl: -1, automatic
%
% OUTPUT:
%  out:  overlay image of the backmap with the original
%  h:    handle to the contour plot (if requested) 
%
% HINTS: use Mappings -> Custom -> 'jet' for a nice colormap
%        use axis xy, to flip the axis
%
% SEE ALSO:
%  hist2image, mdhistogram for higher dimensional histograms

% (C) Copyright 2004-2009      Department of Molecular Biology
%     All rights reserved      Max-Planck-Institute for Biophysical Chemistry
%                              Am Fassberg 11, 37077 G"ottingen
%                              Germany
%
% Bernd Rieger, 2004.
% August 2004:  Added log-log stuff
% October 2004: Changes due to R13->14 in [c,h]=contour
% October 2006: Changed name hist2d -> diphist2d, flipped in range/bin input
% Arpil 2007:   Changed way axis strings are written -- no more eval.
% 19 September 2007: Fixed RANGE1 and RANGE2 input definition.
% 17 December 2009:  Using MATLABVER_GE instead of VERSION. Also using UNIQUE. (CL)
% 18 April 2013:     Fixed bug where 2nd output argument was not assigned. (CL)

function [out,hf] = diphist2d(varargin)

d = struct('menu','Statistics',...
    'display','2D histogram',...
'inparams',struct('name',{'ch1','ch2','mask','range1','range2','bins1','bins2','cont','logdisp','contf','contl','Nl'},...
      'description',{'Channel 1','Channel 2','Mask', ' Range 1 [min max]','Range 2 [min max]','Bins 1','Bins 2','Contour plot',' Log plot',' Filled contours',' Labeled contours','Number of contours'},...
      'type',{'image','image','image','array','array','array','array','boolean','option','boolean','boolean','array'},...
      'dim_check',  {0,0,0,{[],[1,2]},{[],[1,2]},0,0,0,0,0,0,0},...
      'range_check',{[],[],[],'R','R','N+','N+',[],{'none','x-axis','y-axis','z-axis','xy-axes','xyz-axes'},[],[],'Z'},...
      'required',   {1,1,0,0,0,0,0,0,0,0,0,0},...
      'default',    {'a','b','[]',[],[],100,100,0,'none',0,0,-1}...
    ),...
    'outparams',struct('name',{'out','handle'},...
      'description',{'Histogram image','Contour plot figure handle'},...
        'type',{'image','array'}...
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
   [ch1,ch2,mask,range1,range2,bins1,bins2,cont,logdisp,contf,contl,Nl] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isempty(range1) | range1(1) == -1
   min_1 = min(ch1);
   max_1 = max(ch1);
else
   min_1 = range1(1);
   max_1 = range1(2);
end

if isempty(range2) | range2(1) == -1
   min_2 = min(ch2);
   max_2 = max(ch2);
else
   min_2 = range2(1);
   max_2 = range2(2);
end

if ~isempty(mask)
   if ~islogical(mask)
      error('mask must be binary.');
   end
end

out = mdhistogram(cat(3,ch1,ch2),[0 0 1],mask,...
      {{'lower',min_1,'upper',max_1,'bins',bins1,'lower_abs','upper_abs'},...
       {'lower',min_2,'upper',max_2,'bins',bins2,'lower_abs','upper_abs'}});

hf = [];

if cont
   hf = figure;
   x = [0:bins1-1]./(bins1-1)*(max_1-min_1)+min_1;
   y = [0:bins2-1]./(bins2-1)*(max_2-min_2)+min_2;
   if strcmp(logdisp,'xyz-axes') | strcmp(logdisp,'z-axis')
      o2 = log10(double(out));
   else
      o2 = double(out);
   end
   if contf
      if Nl < 0
         [c,h] = contourf(x,y,o2);
      else
         [c,h] = contourf(x,y,o2,Nl);
      end
   else
      if Nl < 0
         [c,h] = contour(x,y,o2);
      else
         [c,h] = contour(x,y,o2,Nl);
      end
   end
   if contl
      clabel(c,h);
   end
   axis ij
   ha=gca;
   switch logdisp
      case {'xy-axes','xyz-axes'}
         set(ha,'XScale','log');
         set(ha,'YScale','log');
      case 'x-axis'
         set(ha,'XScale','log');
      case 'y-axis'
         set(ha,'YScale','log');
   end

   hc = colorbar;
   set(hc,'TickLength',[-.01 .025]);%tick on the outside

   n = length(h);
   %get height lines and mark them on the colorbar with ticks
   %change R13->14 in [c,h]=contour what the handles to contours is, arg
   he = zeros(1,n);
   if matlabver_ge([7,0])
      tmp = get(h);
      he = tmp.LevelList;
   else
      for ii=1:n
         tmp = get(h(ii));
         he(ii) = tmp.UserData;
      end
      he = unique(he);
   end
   set(hc,'YTick',he);
   if strcmp(logdisp,'xyz-axes') | strcmp(logdisp,'z-axis')
      he = round(10.^he);
      s = cell(length(he),1);
      for ii=1:length(he)
         s{ii} = num2str(he(ii));
      end
      set(hc,'YTickLabel',s);
   end

end
