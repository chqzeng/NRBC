%HIST2IMAGE   Backmaps a 2D histogram ROI to the images
%  The ROI can be specified by a coordinate array or
%  interactively selected from the histrogram
%
% SYNOPSIS:
%  [o1,o2,roi,histsel] = hist2image(in1,in2,coords,mask,bin1,bin2,range1,range2)
%
% PARAMETERS:
%  in1:     first input image
%  in2:     second input image
%  coords:  coordinate array [min1, max1; min2, max2],
%           if empty interactively selection
%  mask:    region where histogram should be evaluted
%  bin1:    number of bins for first image
%  bin2:    number of bins for second image
%  range1:  [min max] two values specifying the data range
%  range2:  [min max] two values specifying the data range
%
% DEFAULTS:
%  coords: []
%  bins1: 100
%  bins2: 100
%  range1: -1 %the minimum and maximum value of image 1 is taken
%  range2: -1 %the minimum and maximum value of image 2 is taken
%
%  SEE ALSO:
%   hist2d, dip_mdhistogram for higher dimensional histograms

% (C) Copyright 2007           Department of Molecular Biology
%     All rights reserved      Max-Planck-Institute for Biophysical Chemistry
%                              Am Fassberg 11, 37077 G"ottingen
%                              Germany
%
% Bernd Rieger, 2004.
% August 2004:       Added histogram selction for optional ouput Keith
% 19 September 2007: Input argument COORDS is now an actual array. HIST2D -> DIPHIST2D.
% 26 September 2007: Fixed out-of-range errors when COORDS is not empty.
% 23 april 2010:     Fixing scaling between histogram and contourplot. (AdV)

function [out1,out2,out3,out4] = hist2image(varargin)
d = struct('menu','Segmentation',...
   'display','Backmap 2D histogram to images',...
   'inparams',struct('name',       {'in1','in2','co','mask','bins1','bins2','range1','range2'},...
         'description',{'Channel 1','Channel 2','Coordinates','Mask', 'Bins 1','Bins 2','Range 1 [min max]','Range 2 [min max]'},...
         'type',       {'image','image','array','image','array','array','array','array'},...
         'dim_check',  {0,0,{[],[2,2]},0,0,0,[1,2],[1,2]},...
         'range_check',{[],[],[],[],'N+','N+','R','R'},...
         'required',   {1,1,0,0,0,0,0,0},...
         'default',    {'a','b',[],'[]',100,100,-1,-1}...
        ),...
   'outparams',struct('name',{'bc1','bc2','hroi','hs'},...
         'description',{'Backmap channel 1','Backmap channel 2','Histrogram ROI selction','Histogram Selection'},...
         'type',{'image','image','image','image'}...
         )...
  );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out1 = d;
      return
   end
end
try
   [in1,in2,co,mask,bins1,bins2,range1,range2] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
in1 = squeeze(in1);
in2 = squeeze(in2);
if ndims(in1) ~=2 | ndims(in2)~=2
   error(['Interactive backmapping only implemented for 2D images.'...
           'use low-level function "mdhistogrammap" otherwise.']);
end

if range1(1) == -1
   range1 = [min(in1),max(in1)];
end
min_1 = range1(1);
max_1 = range1(2);
if range2(1) == -1
   range2 = [min(in2),max(in2)];
end
min_2 = range2(1);
max_2 = range2(2);
scaling1=(max_1-min_1)/bins1;   % scale bins with contour plot (AdV)
scaling2=(max_2-min_2)/bins2;

if isempty(co)
   fprintf('Select a region in the histogram image, double click to end\n');
   % optimal more parameters can be given to the diphist function
   %[hist,cont_handle] = diphist2d(in1,in2,mask,range1,range2,bins1,bins2,'yes',logdisp,contf,contl,Nl);
   [hist,cont_handle] = diphist2d(in1,in2,mask,range1,range2,bins1,bins2,'yes');
   h=dipshow(hist);
   [histsel, v] = diproi(h,'polygon');
   dipshow(h,overlay(stretch(hist),histsel));%keep the histogram + selction
   figure(cont_handle);
   %h=line(v(:,1),v(:,2));  Bins don't scale correctly to contourplot (AdV)
   h=line(v(:,1)*scaling1,v(:,2)*scaling2);    
   set(h,'Color','red');
   set(h,'LineWidth',2);
   %use private MvG code here that is a little more general (more regions at once)
   m =  prv_mdhistogrammap(cat(3,in1,in2),dip_image(histsel,'sint32'),[0 0 1],mask,...
      {{'lower',min_1,'upper',max_1,'bins',bins1,'lower_abs','upper_abs'},...
       {'lower',min_2,'upper',max_2,'bins',bins2,'lower_abs','upper_abs'}});
   m = m>0;
else
   %if any(size(co) ~= [2,2])  % test no longer necessary (CL)
   %   error('Coordinate array must be of form 2x2 [min1, max1; min2, max2].');
   %end
   m1 = threshold(in1,'double',[co(1,:)]);
   m2 = threshold(in2,'double',[co(2,:)]);
   m = m1 & m2;
   co = round(co.*[repmat(bins1/diff(range1),1,2);repmat(bins2/diff(range2),1,2)])
   histsel = newim([bins1,bins2],'bin');
   histsel(co(1,1):co(1,2),co(2,1):co(2,2))=1;
end
out1 = overlay(stretch(in1),m);
out2 = overlay(stretch(in2),m);
out3 = m;
out4 = histsel;


