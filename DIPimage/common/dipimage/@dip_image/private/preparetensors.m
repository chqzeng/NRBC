%[TENSOROP,IN1,IN2] = PREPARETENSORS(IN1,IN2)
%    If either IN1 or IN2 is scalar, TENSOROP is zero.
%    Otherwise, IN1 and IN2 are converted to tensor dip_image
%    objects making sure that the image sizes match. Note that the
%    tensor sizes are not checked.
%    If TENSOROP is zero, IN1 and IN2 are returned without change.

% (C) Copyright 1999-2011, Cris Luengo.
% Centre for Image Analysis, Uppsala, Sweden.
%
% Cris Luengo, June 2011, based on the original DOARRAYINPUTS.

function [tensorop,in1,in2] = preparetensors(in1,in2)
if nargin ~= 2, error('Erroneus input.'); end
if nargout ~= 3, error('Erroneus output.'); end

% Examine first input
in1tensor = 0; in1array = 0;
if di_isdipimobj(in1)
   if ~isscalar(in1) & istensor(in1)
      in1tensor = 1;
   end
elseif isnumeric(in1) & prod(size(in1))~=1
   in1array = 1;
end

% Examine second input
in2tensor = 0; in2array = 0;
if di_isdipimobj(in2)
   if ~isscalar(in2) & istensor(in2)
      in2tensor = 1;
   end
elseif isnumeric(in2) & prod(size(in2))~=1
   in2array = 1;
end

if in1array & in2tensor
   % First input is an array: we'll take it if it's not too big (i.e. image-sized).
   if prod(size(in1))>100
      in1array = 0;
   end
elseif in2array & in1tensor
   % Second input is an array: idem as above.
   if prod(size(in2))>100
      in2array = 0;
   end
end

% If both inputs are either a tensor image or an array with matching size, we're a tensor operation.
tensorop = (in1tensor|in1array) & (in2tensor|in2array);
if tensorop

   % Convert arrays
   if in1array
      in1 = create_tensor(in1);
   elseif in2array
      in2 = create_tensor(in2);
   end

   % Check image sizes.
   sz1 = size(in1(1).data);
   sz2 = size(in2(1).data);
   if prod(sz1)~=1 & prod(sz2)~=1 & ~isequal(sz1,sz2)
      error('Image sizes do not match.');
   end

end

%
% Sub-function to convert a MATLAB array to a dip_image_array object.
%
function out = create_tensor(in)
out = dip_image('array',size(in));
for ii=1:prod(size(in))
   out(ii) = dip_image(in(ii));
end
