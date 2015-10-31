%DISP   Display a dip_image object.
%   DISP(B) displays information about the image in B.
%
%   DISP(B,'extended') displays extended information about B.
%   Actually, any second parameter will do this, so DISP(B,1) does
%   the same.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February 2000.
% 8 October 2000:   Added support for color to dip_image.
%                   Changed the format of the output: tensor and color images
%                   don't need to display all their elements.
% 15 August 2005:   Fixed bug that happened when the input parameters were reversed.
% 5 March 2008:     Displaying pixel dimensions.
% 28 April 2008:    Displaying pixel dimensions more safely.
% 24 June 2011:     Added a note when the MATLAB matrix is complex.
% 22 November 2013: Allowing physDims to be empty.

function disp(in,mode)
if ~di_isdipimobj(in)
   error('Syntax error')
end
extended = 0;
if nargin == 2
   extended = 1;
end
s = imarsize(in);
n = prod(s);
if n ~= 1
   sz = num2str(s(1));
   for ii=2:length(s)
      sz = [sz,'x',num2str(s(ii))];
   end
   if iscolor(in)
      if extended
         disp ([sz,' color image (',in(1).color.space,') containing the following images:']);
      else
         disp ([sz,' color image (',in(1).color.space,'):']);
      end
   elseif istensor(in)
      if extended
         disp ([sz,' tensor image containing the following images:']);
      else
         disp ([sz,' tensor image:']);
      end
   else
      disp ([sz,' image array containing the following images:']);
      extended = 1;
   end
else
   disp ('Scalar (grey-value) image:');
end
if extended
   for (ii=1:n)
      display_data(in(ii))
   end
else
   if n==1
      display_data(in)
   else
      display_data(in,1)
   end
end

function display_data(in,array)
if nargin < 2
   array = 0;
   in1 = in;
else
   in1 = in(1);
end
disp(['    Image of type ',in1.dip_type]);
if isempty(in1.data)
   disp('        - empty -');
else
   if strcmp(dipgetpref('debugmode'),'on')
      if isreal(in1.data)
         disp(['        (MATLAB class = ',class(in1.data),')'])
      else
         disp(['        (MATLAB class = ',class(in1.data),', complex)'])
      end
      if islogical(in1.data)
         disp('        Error: data is logical!')
      end
   end
   disp(['        dimensionality ',num2str(in1.dims)]);
   if in1.dims~=0
      v = imsize(in1);
      sizes = num2str(v(1));
      for jj=2:length(v)
         sizes = [sizes,'x',num2str(v(jj))];
      end
      disp(['        size ',sizes]);
      if ~isempty(in1.physDims.PixelSize) & ~isempty(in1.physDims.PixelUnits)
         sizes = [num2str(in1.physDims.PixelSize(1)),in1.physDims.PixelUnits{1}];
         for jj=2:length(in1.physDims.PixelSize)
            sizes = [sizes,' x ',num2str(in1.physDims.PixelSize(jj)),in1.physDims.PixelUnits{jj}];
         end
         disp(['        pixel size ',sizes]);
      end
   else
      v = 1;
   end
   if prod(v) == 1
      if array
         disp(['        value [',num2str(double([in.data])),']']);
      else
         disp(['        value ',num2str(double(in1.data))]);
      end
   end
end
