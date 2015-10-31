%BACKGROUNDOFFSET   Remove  background offset
%  Background is estimated from dark uniform region.
%
% SYNOPSIS:
%  [out, bg, bg_im]=backgroundoffset(in, clip, fs_var, bg_perc, bg_ob_dist)
%
% OUTPUT:
%  bg:    estimated background value
%  bg_im: region used for background estimation
%
% PARAMETERS:
%  in   : 2D,3D image
%  clip : clip values below zero 'yes','no'
%  fs_var    : filter size of the variance filter to find uniform regions
%  bg_prec   : [0:100] max depth of percentile in the variance to merge
%  bg_ob_dist: min distance of object from the background
%
% DEFAULT:
%  clip      : 'no'
%  fs_var    : 15
%  bg_prec   : 20
%  bg_ob_dist: 15

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2004
% Aug 2004, changed default clipping to no

function [varargout] = backgroundoffset(varargin)

d = struct('menu','Restoration',...
   'display','Background offset correction',...
   'inparams',struct('name',{'in','clip','fs_vari','waters_perc','niter'},...
              'description',{'Input image','Clip values below zero?',...
           'Variance filter size','Max depth percentile to merge in variance','Distance from object'},...
              'type',       {'image','boolean','array','array','array'},...
              'dim_check',  {0,0,1,0,0},...
              'range_check',{[],[],'R+','R+','N'},...
              'required',   {1,0,0,0,0},...
              'default',    {'a',0,15,20,15}...
                    ),...
   'outparams',struct('name',{'out','out2','out3'},...
                      'description',{'Output image','Background value','Selected background region'},...
                      'type',{'image'}...
                      )...
  );

if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      varargout{1} = d;
      return
   end
end
try
   [in,clip,fs_vari,waters_perc,niter] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

in = squeeze(in);%just in case
if ndims(in) >3
   error('Only supported up to 3D.');
end

%fs_vari = 15;
%waters_perc =20;
%niter=15; %distance of background to object

v = varif(in,fs_vari);
maxdepth = percentile(v,waters_perc)-min(v);
maxsize = prod(size(in))*.75; %background max 3/4 the size of images
w = watershed(v,2,maxdepth,round(maxsize));
l = label(~w,1,round(prod(size(in))*.05));%background minium of 5%
l = erosion(l,3);
m1 = measure(l,v,{'Mean','Size'});
m2 = measure(l,in,{'Mean'});


if ~size(m1,1)
   warning('No background found.');
   varargout{1}=in;
   varargout{2}=0;
   varargout{3}=0;
   return;
end
%overlay(stretch(in),w)
m = zeros(size(m1));
for ii=1:size(m1,1)
   m(ii,1) =m1(ii).Mean * m2(ii).Mean /m1(ii).Size;
end
[mm,mi] = sort(m(:,1));  %sort
%[ms,mis] = sort(m(:,2)) %sort  Std
%take mi(1) for the background, but erode it  for boundary
l = bdilation(l==mi(1),2);%connect to border
l = berosion(l,niter);
varargout{2} = mean(in,l); %bg level
varargout{1} = in - varargout{2};
if clip
   varargout{1}(varargout{1}<0)=0;
end

%return chosen background region
if nargout == 3
   varargout{3} = l;
end
