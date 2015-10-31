%NCONV   Normalized Convolution
% 
% SYNOPSYS:
%  image_array_out = nconv( image_in, certainty, applicability, { basis } );
%
% Higher order normalized convolution in 2D & 3D using multiple basis functions
% Returns the projection of f on the (sub)space span by the basis functions in 
% array b.
% 
% f is the nD signal, c is the certainty attributed to the samples of f. 
% a is the applicability function (spatial weigthing) and the array b holds the
% basis on which f is to be projected.
% 
% The output image_array_out is an array of images, one for each basis 
% function b
% 
% Note: the size of f and c must be equal. Also the size of a and each of 
% the basis functions in b must be equal.
% Note: The routine requires the storage of (n+1)*n copies of f, 
% where n is the number of basis functions.
% 
% EXAMPLES:
% 1)
% sx = 1; sy = 1;
% i=-3*sx:3*sx; j=-3*sy:3*sy; [I,J] = meshgrid(i,j);
% f = readim;                                  % 2D test image
% c = rand( size(f) )>0.5;                     % 50% of data removed/missing etc
% a = exp(-0.5*(I.*I/sx/sx+J.*J/sy/sy));       % Gaussian shaped applicability
% b1 = ones( size(a) );                        % Zero order basis function
% [b2, b3] = meshgrid(i,j);                    % First order basis functions
% b4=0.5*b2.*b2; b5=0.5*b3.*b3; b6=0.5*b2.*b3; % Second order basis functions
% out = nconv(f, c, a, {b1, b2, b3, b4, b5, b6} );
% nc = out{1}     % averaged value
% nc_dx = out{2}  % gradient in b2 direction, equal to dx(f)
% nc_dy = out{3}  % gradient in b3 direction, equal to dy(f)
% nc_dxx = out{4} % second order derivative in b4 direction 
%                 % (equal to dxx(f,1) if c is constant )
% 
% 
% LITERATURE:
% C.F. Westin, "A Tensor Framework for Multidimensional Signal Processing", 
% PhD Thesis, Linköping University, Linköping, Sweden, 1994
% Knutsson, H. and Westin, C.-F., "Normalized Convolution - A 
%   Technique for Filtering Incomplete and Uncertain Data",
%   "SCIA'93, Proceedings of the 8th Scandinavian Conference on 
%   Image Analysis", Vol 2, p, "997-1006".

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Kees van Wijk, Jan 2004.

% function out = nconv( f, c, a, b )
function image_out = nconv( varargin )

% Avoid being in menu
if ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
     image_out = struct('menu','none');
     return
end

if ( nargin<4 )
   error( 'Number of inputs must be 4. See "help nconv"' )
end

if ( nargout>1 )
   error( 'Number of outputs must be at most 1. See "help nconv"' )
end

f = varargin{1};
c = varargin{2};


if ( size(f) ~= size(c) )
   error('Size of first two inputs (signal and certainty) must be equal.')
end

dims = length(size(f)); %dimensionality of input

if (0) % sorry this does not work well yet
% Applicability
if ( length(varargin{3})==1 )
  sigma = varargin{3};
  sigmas = [];
  for (i=1:dims) sigmas = [sigmas sigma(1)]; end;
  if ( dims==2 )
    [I,J] = meshgrid(-3*sigmas(1):3*sigmas(1), -3*sigmas(2):3*sigmas(2));
    a = (1./sqrt(2*pi*(sigmas(1)*sigmas(1) ) ) ) * ...
     exp( -0.5 * ( I.*I/(sigmas(1)*sigmas(1)) + J.*J/(sigmas(2)*sigmas(2)) ) );
  elseif ( dims==3 )
    [I,J,K] = meshgrid(-3*sigmas(1):3*sigmas(1), -3*sigmas(2):3*sigmas(2), -3*sigmas(3):3*sigmas(3));
    a = (1./sqrt(2*pi*(sigmas(1)*sigmas(1)+sigmas(2)*sigmas(2)+sigmas(3)*sigmas(3) ) ) ) * ...
     exp( 0.5 * ( I.*I/(sigmas(1)^2) + J.*J/(sigmas(2)^2) + K.*K/(sigmas(3)^2) ) );
  else
    disp('Only 2D and 3D Data supported')
  end
else
  a = varargin{3};
  sigmas = [];
  for (i=1:dims) sigmas(i) = (size(a,i)-1)/6; end
end

if ( length(varargin{4})==1 ) % Meaning the polynomial order is given
  polyOrder = varargin{4}; % polynomial order
  if ( dims==2 )
    [I,J] = meshgrid(-3*sigmas(1):3*sigmas(1), -3*sigmas(2):3*sigmas(2));
    index = 1;
    for (j=0:polyOrder)
    for (i=0:polyOrder)
      if ( (i+j)<=polyOrder )
        b{index} = ((I.^i)/factorial(i)).*((J.^j)/factorial(j));
	% double(b{index})
        index = index + 1;
      end
    end
    end
  elseif ( dims==3 ) % 3D
    [I,J,K] = meshgrid(-3*sigmas(1):3*sigmas(1), -3*sigmas(2):3*sigmas(2), -3*sigmas(3):3*sigmas(3));
    index = 1;
    for (k=1:polyOrder)
    for (j=1:polyOrder)
    for (i=1:polyOrder)
      if ( (i+j+k)<=polyOrder )
        b{index} = ((I.^i)/factorial(i)).*((J.^j)/factorial(j)).*((K.^k)/factorial(k));
        index = index + 1;
      end
    end
    end
    end
  else
      disp('Only 2D and 3D Data supported')
  end
else
  % disp('Applicability and basis given explicitly')
  b = varargin{4};
end   
end % if (0) % sorry this does not work well yet

a = varargin{3};
b = varargin{4};

ts = length(b); % size of tensor image
for ( i=1:ts )
   if ( sum( size(b{i}) ~= size(a) ) ~= 0 )
      error('Each basis function must have same size as applicablity function.');
   end
end

%  Since we use the basis functions in convolutions (while we mean correlation!!) we have to flip the axes
% ( Remember: In convolution the kernel is first flipped and then swept over the image)
for ( i=1:ts )
   b{i}(:) = flipud( b{i}(:) );
end 

normator = newimar( ts,ts );
for (i=1:ts)
   for (j=i:ts) % normator is symmetric so less convolutions are needed
      normator{j,i} = dip_image( convolve(c, a.*b{j}.*b{i} ), 'sfloat' ); 
%plain matlab version for 2D data:       normator{j,i} = dip_image( conv2( double(c), double(a.*b{j}.*b{i}),'same' ), 'sfloat' ); 
   end
end
for (i=1:ts) % fill symmetric part of normator (Again eating memory!!!)
   for (j=1:i-1)
      normator{j,i} = normator{i,j};
   end
end
normator = dip_tensorimageinverse( normator ); % re-use normator

f_b_dual = newimar( ts );
for (i=1:ts)
   f_b_dual{i} = dip_image( convolve(f.*c, a.*b{i} ), 'sfloat' );
%   f_b_dual{i} = dip_image( conv2( double(f.*c), double(a.*b{i}),'same' ), 'sfloat' );
end

image_out = normator*f_b_dual; % matrix multiplication of tensor image and vector of images
% clear normator_dual


