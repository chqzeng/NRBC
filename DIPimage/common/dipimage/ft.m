%FT   Fourier Transform (forward)
%
% SYNOPSIS:
%  image_out = ft(image_in)
%
% NOTE:
%  Setting the 'FFTtype' preference to 'fftw' (defaults to 'diplib')
%  will cause the built-in FFTN function to be used, which calls the
%  FFTW library. This library computes the Fourier transform much
%  faster than the DIPlib library. The output of FFTN is then normalized
%  and shifted to match the output of the DIPlib version of the Fourier
%  transform.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% March 2013, use fftw via matlab as option for faster computation (BR)

function image_out = ft(varargin)

if nargin==0
   if exist('private/Fourier.jpg','file')
      image_out = dip_image(imread('private/Fourier.jpg'));
      return
   end
end

d = struct('menu','Transforms',...
           'display','Fourier transform',...
           'inparams',struct('name',       {'image_in'},...
                             'description',{'Input image'},...
                             'type',       {'image'},...
                             'dim_check',  {0},...
                             'range_check',{[]},...
                             'required',   {1},...
                             'default',    {'a'}...
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
   [image_in] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

switch(lower(dipgetpref('FFTtype')))
case 'fftw'
	fftw('planner','measure');
	image_out = dip_image(fftshift(fftn(ifftshift(dip_array(image_in))))./sqrt(prod(size(image_in))));
case 'diplib'
	dimProcess = ones(1,ndims(image_in));
	image_out = dip_fouriertransform(image_in, 'forward', dimProcess);
otherwise
   error('Unkown ''FFTtype'' value in DIPSETPREF.'); 
end
image_out.pixelunits = di_convertphysDims(image_in.pixelunits,'invert');
image_out.pixelsize = [1./(image_in.pixelsize .* size(image_in))];
