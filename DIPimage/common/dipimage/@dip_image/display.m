%DISPLAY   Overloaded function for DISPLAY.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 15 August 2000: Tensor images also send to figure window as color images.
% 24 August 2000: Only 2D Tensor images are send to figure window.
% 8 October 2000: Added support for color to dip_image:
%                 only 2D color images are send to figure window.
% 9 October 2000: 4D and higher-D images not send to figure window anymore.
% 21 August 2001: DIPSHOW can now also display 1D and 3D color images.
%                 Made this function a bit simpler: removed sub-functions.
% 15 September 2001: Limiting the size of the images send to figure window.
% 4 April 2002:      Bug fix: color images weren't checked correctly for size.
% 30 November 2004:  Now automatically displaying 4D images with Bernd's work.
% 11 August 2014:    Fix for new graphics in MATLAB 8.4 (R2014b).

function display(in)
if dipgetpref('DisplayToFigure') & (isscalar(in) | iscolor(in))
   sz = size(squeeze(in(1)));
   dims = length(sz);
   if dims >= 1 & dims <= 4
      if all(sz<=dipgetpref('ImageSizeLimit'))
         h = dipshow(in,'name',inputname(1));
         if matlabver_ge([8,4])
            if ishandle(h)
               h = h.Number;
            end
         end
         disp(['Displayed in figure ',num2str(h)])
         return
      end
   end
end
if isequal(get(0,'FormatSpacing'),'compact')
   disp([inputname(1),' ='])
   disp(in)
else
   disp(' ')
   disp([inputname(1),' ='])
   disp(' ')
   disp(in)
   disp(' ')
end
