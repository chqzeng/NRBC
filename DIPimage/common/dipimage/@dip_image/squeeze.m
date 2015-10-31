%SQUEEZE   Remove singleton dimensions.
%   B = SQUEEZE(A) returns an image B with the same elements as
%   A but with all the singleton dimensions removed. A dimension
%   is singleton if size(A,dim)==1.
%
%   See also EXPANDDIM, SHIFTDIM, PERMUTE, RESHAPE

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, January 2001.
% 16 August 2001:   Extended to handle image arrays.
% 28 August 2001:   Bug: 1D images must have the data in a row.
% 5 March 2008:     Bug fix in pixel dimension addition. (CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function in = squeeze(in)
for ii = 1:prod(imarsize(in))
   siz = imsize(in(ii));
   if isempty(siz)
      ; % Don't do anything!
   elseif any(siz==0)
      % In case the image is empty
      in(ii).data = [];
      in(ii).dims = 0;
      in(ii).physDims.PixelSize = [];
      in(ii).physDims.PixelUnits = {};
   else
      if any(siz==1)
         mxsiz = max(siz);
         if mxsiz==prod(siz)                    % Meaning it is 0D/1D data!
            in(ii).data = reshape(in(ii).data,1,mxsiz);
            if mxsiz==1
               in(ii).dims = 0;
               in(ii).physDims.PixelSize = [];
               in(ii).physDims.PixelUnits = {};
            else
               in(ii).dims = 1;
               n = find(siz==mxsiz);
               if ~isempty(in(ii).physDims.PixelSize)
                  in(ii).physDims.PixelSize  = in(ii).physDims.PixelSize(n);
               end
               if ~isempty(in(ii).physDims.PixelUnits)
                  in(ii).physDims.PixelUnits = in(ii).physDims.PixelUnits(n);
               end
            end
         else
            % SIZ here always has 2 or more elements!
            swap = 0;                           % This is to preserve our altered ordering
            if siz(1)==1 | siz(2)==1
               swap = 1;
               if siz(1)~=1 | siz(2)~=1
                  in(ii).data = permute(in(ii).data,[2,1,3:length(siz)]);
               end
            end
            if length(siz) == length(in(ii).physDims.PixelSize)
               in(ii).physDims.PixelSize(siz==1) = [];
               in(ii).physDims.PixelUnits(siz==1) = [];
            end
            siz = siz([2,1,3:end]);
            siz(siz==1) = [];                   % Remove singleton dimensions
            in(ii).dims = length(siz);
            siz = [siz,ones(1,2-length(siz))];  % Make sure siz is at least 2-D
            in(ii).data = reshape(in(ii).data,siz);
            if swap
               in(ii).data = permute(in(ii).data,[2,1,3:length(siz)]);
            end
         end
      end
   end
end
