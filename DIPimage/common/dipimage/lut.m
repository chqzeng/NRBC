%LUT   Look-up Table (with interpolation)
%
% SYNOPSIS:
%  image_out = lut(image_in,table)
%
% PARAMETERS:
%  table: an array with 1 or 3 columns (respectively produce a grey-value
%         image and an RGB image). MATLAB has many commands to create
%         colormaps (see 'help graph3d'). These should be used in this
%         way: lut(image,jet(256)*255)
%
% NOTES:
%  Indexing into the table starts at zero: pixel values should be
%  between 0 and LENGTH(TABLE)-1.
%
%  For integer images, the pixel values are table indices. For floating-
%  point images, the table-lookup is done with interpolation.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% June 2001:         Fixed bug: integer and floating-point images produced
%                    different results.
% December 2001:     Added 2D LUTs. The 'table' input must be an image now!
% December 2002:     Due to the above change, 3-by-1 tables were converted into 1-by-3.
% 19 September 2007: The 'table' argument is an array again.
% 22 September 2007: This functions needs to accept 1xN arrays as well as Nx1.
% 26 September 2007: Undid last change: this is now handled by PARAMTYPE_ARRAY.
% 2 July 2010:       For ease of use, we allow also a dip_image as a table, as this
%                    was the norm between Dec 2001 and Sept 2007.
% 16 April 2014:     Singleton dimensions were not kept.
% 25 April 2014:     Output data type is again the same as that of 'table'.

function image_out = lut(varargin)

d = struct('menu','Point',...
           'display','Look-up table',...
           'inparams',struct('name',       {'image_in',   'table'},...
                             'description',{'Input image','Table'},...
                             'type',       {'image',      'anytypearray'},...
                             'dim_check',  {0,            {[-1,1],[-1,3]}},...
                             'range_check',{[],           []},...
                             'required',   {1,            1},...
                             'default',    {'a',          []}...
                              ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   if nargin>1 & isa(varargin{2},'dip_image')
      varargin{2} = dip_array(varargin{2});
   end
   [image_in,table] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ~isreal(image_in) | ~isreal(table)
   error('Cannot work on complex data.');
end

out_type = class(table);
[N,w] = size(table);
if any(image_in>=N) | any(image_in<0)
   error('Image contains values outside of table.');
end

image_out = newimar(w,1);
sz = imsize(image_in);
for ii=1:w
   switch(class(dip_array(image_in)))
      case {'double','single'}
         t = double(table(:,ii));
         image_out{ii} = dip_image(interp1(0:N-1,t,double(image_in),'*linear'),out_type);
      otherwise
         try
            t = table(:,ii);
            image_out{ii} = dip_image(t(double(image_in)+1),out_type);
         catch
            error(lasterr);
         end
   end
   image_out{ii} = reshape(image_out{ii},sz); % we need to keep the original image's shape
end
if w==3
   image_out = colorspace(image_out,'RGB');
end
