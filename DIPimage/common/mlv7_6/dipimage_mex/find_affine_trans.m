%FIND_AFFINE_TRANS   Find the homogeneous matrix that rotates, translates and scales two 2D images
%
% SYNOPSIS:
%  [out,R] = find_affine_trans(in1, in2, [zoom, translation, angle])
% 
% PARAMETERS:
%  in1:    First input image
%  in2:    Second input image
%  guess:  [zoom (x,y), translation (x,y), angle]
%
%  out  : [zoom, translation, angle]
%
% SEE ALSO: affine_trans, fmmatch, transform
%
% NOTE: only works if the guess for the parameters is reasonable

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2009

function [out,H] = find_affine_trans(varargin)

d = struct('menu','Manipulation',...
           'display','Find 2D affine transformation',...
           'inparams',struct('name',       {'in1', 'in2', 'guess'},...
                             'description',{'Input image 1','Input image 2','Parameter guess'},...
                             'type',       {'image','image','array'},...
                             'dim_check',  {0,0,-1},...           
                             'range_check',{[],[],'R'},...
                             'required',   {1,1,0},...                            
                             'default',    {'a', 'b',[1 1 0 0 0]}...
                              ),...
           'outparams',struct('name',{'out','H'},...
                              'description',{'Transformation parameters','Transformation matrix'},...
                              'type',{'array','array'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end

try
   [in1, in2, guess ] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ndims(in1)~=ndims(in2) | ndims(in1)~=2
   error('Images must be 2D.');
end
if length(guess)~=5
   error('The inital guess must contain 5 parameters.');
end
in1 = double(in1);
in2 = double(in2);

% angle and x,y scaling
options=optimset([]);
options.TolX=1e-6;
options.TolFun=1e-12;
options.MaxIter=1e4;
options.MaxFunEvals=1e4;
options.Display='off';

lb = [-pi/2 ];
ub = [pi/2 ];

[out] = lsqcurvefit(@rotmat,guess,in1,in2 ,lb,ub,options);

N=3;
sx = 1/out(1);
sy = 1/out(2);
alp = out(5);
sh = out(3:4);
center = size(in1)./2;
R = zeros(N,N);
T = eye(N,N);
R(N,N) = 1;

%Translate
T(1:2,N) = -center;

%Rotate
R(1,1) = cos(alp)*sx;
R(1,2) = sin(alp)*sx;
R(2,1) = -1*sin(alp)*sy;
R(2,2) = cos(alp)*sy;

%combine step
B = R*T;
%Translate back
T(1:2,N) = center + sh;

%combine step to overall Matrix and go
H = T*B;


function out = rotmat(p,in)
out = double(affine_trans(in, p(1:2), p(3:4), p(5)));
