%COUNTINGFRAME   Applies a counting frame to a labelled image
%
% A counting frame is a method to select objects to measure. It avoids bias
% in any per-object measurement, such as object count, size distributions,
% etc. Objects fully outside the counting frame are removed from the image,
% as are those that are partially inside the counting frame but touch the
% exclusion line. The counting frame should be small enough such that no
% objects that remain in the image are cut by the image boundary. This
% function will give a warning if any such objects are present.
%
% See any book on stereology for further information on the counting frame.
%
% SYNOPSIS:
%  image_out = countingframe(image_in,frame_size)
%
% PARAMETERS:
%  image_in, image_out: Labelled images, typically of a signed integer type.
%                       Only 2D images are supported for the time being.
%  frame_size:          Size of the counting frame. The frame will be centered
%                       in the image. This should have as many dimensions as
%                       the image; if fewer dimensions are given, other
%                       dimensions will be filled out by replication. If set
%                       to an empty array, an edge size of 80% of the image
%                       edge size will be used. 
%
% DEFAULTS:
%  frame_size = []  ( equivalent to 0.8*imsize(image_in) )
%
% EXAMPLE:
%  a = readim('cermet');
%  b = label(~threshold(a));
%  b = countingframe(b,200);
%  m = measure(b,a,'size');
%  diphist(m.size,20); % unbiased estimate of size distribution
%  d = size(m,1)/(200^2) % unbiased estimate of particle density (px^-2)

% (C) Copyright 2014, Cris Luengo.
% Centre for Image Analysis, Uppsala, Sweden.
% 25 April 2014.

function lab = countingframe(varargin)

d = struct('menu','Segmentation',...
           'display','Apply counting frame',...
           'inparams',struct('name',       {'image_in',   'frame_size'},...
                             'description',{'Input image','Frame size'},...
                             'type',       {'image',      'array'     },...
                             'dim_check',  {2,            {[],1}      },...
                             'range_check',{'',           'N+'        },...
                             'required',   {1,            0           },...
                             'default',    {'a',          []          }...
                              ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      lab = d;
      return
   end
end
try
   [lab,fsz] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% Default value for FSZ
isz = imsize(lab);
if isempty(fsz)
   fsz = round(isz*0.8);
end
if any(fsz>=isz)
   error('Counting frame does not fit in the image!');
end
topleft = floor((isz-fsz)/2);
botright = topleft + fsz - 1;

% Empty set of objects
LUT = dip_array(newim(max(lab),datatype(lab)));
   % Using NEWIM rather than ZEROS to be able to replicate the data type of LAB.

% Add objects partially inside counting frame...
q = dip_array(dip_crop(lab,topleft,fsz));
q = unique(q(:));
q(q==0) = [];
LUT(q) = q;

% Remove objects touching exclusion line...
q = newim(lab,'bin');
q(topleft(1),0:botright(2)) = 1;
q(topleft(1):botright(1),botright(2)) = 1;
q(botright(1),botright(2):end) = 1;
q = unique(dip_array(lab(q)));
q(q==0) = [];
LUT(q) = 0;

% Apply LUT
LUT = [0,LUT]; % This should maintain the data type of LUT.
lab = lut(lab,LUT);

% Test
if any(lab([0,end],:)) || any(lab(:,[0,end]))
   warning('Counting frame is not small enough, some objects touching the image border remain.');
end
