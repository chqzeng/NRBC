%FMMATCH Fourier-Mellin transform 
%   tries to find the scaling, translation and rotation between two 2D images
%
% SYNOPSIS:
%  [zoom, trans, ang] = fmmatch(in1, in2)
% 
% OUPUT PARAMETERS:
%  zoom        = array containing a zoom
%  translation = array containing a shift
%  angle       = rotation angle [in rad]
%  
% SEE ALSO: rotation, rotate, resample, rotation3d, find_affine_trans

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2009 based on code by Dick de Ridder and Jeroen van Schie
% 23 July 2010: New findmaxima routine. (CL)

function [zoom, trans, ang] = fmmatch(varargin)

d = struct('menu','Analysis',...
           'display','Fourier-Mellin',...
           'inparams',struct('name',       {'im1', 'im2'},...
                             'description',{'Input image 1','Input image 2'},...
                             'type',       {'image','image'},...
                             'dim_check',  {0,0},...           
                             'range_check',{[],[]},...
                             'required',   {1, 1},...                            
                             'default',    {'a', 'b'}...
                              ),...
           'outparams',struct('name',{'zoom','trans','ang'},...
                              'description',{'Zoom factor','Translation','Rotation angle'},...
                              'type',{'array','array','array'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      zoom = d;
      return
   end
end

try
   [im1, im2 ] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
%This function determines the rotation, scale and translation between two
%images. This is done with a FMI-SPOMF algorithm.

    
interpolation_method = '4-cubic';

%Execute the FMI SPOMF core algorithm
fourierim1 = log(abs(ft(im1)));
fourierim2 = log(abs(ft(im2)));
lp1 = logpolar(fourierim1);
lp2 = logpolar(fourierim2);
out1 = ft(lp1);
out2 = ft(lp2);
Q = (conj(out1)*out2)/((abs(out1))*abs(out2));
qinv = ift(Q);

%Find the position of the maximum
qinv = abs(qinv);
[qposition,qvalue] = findmaxima(qinv);
[qval,qindex] = max(qvalue);
qmax2loc = qposition(qindex,:);
theta = qmax2loc(1);
lambda = qmax2loc(2);

%Compute the scale and rotation
sx = size(im1,1);
if (theta<=sx/2)
  theta = theta + sx/2;
end
ang = pi*(sx-theta)/(sx/2);
zoom = sx^(((sx/2)-lambda)/(sx));

%Re-scale the transformed image (im2) by sigma^-1 and duplicate
imageA = resample2(im2, 1/zoom, interpolation_method);
imageB = imageA;

%Re-rotate the two rescaled images by angle and angle+180'
%respectively
imageA = rotation(imageA, -ang, 3, interpolation_method, 'zero');
imageB = rotation(imageB, -ang-pi, 3, interpolation_method, 'zero');

%Crop the images to the size of the smallest.
newsize = min(min(size(im1)),min(min(size(imageA)),min(size(imageB))));
newsize = [newsize newsize];
imageA = cut2(imageA,newsize);
imageB = cut2(imageB,newsize);
imageR = cut2(im1,newsize);

%Calculate the SPOMFs between the reference image (im1) and the
%two rescaled and rerotated images respectively
fourierA = ft(imageA);
fourierB = ft(imageB);
fourierR = ft(imageR);
QA = (fourierA/abs(fourierA)) * (conj(fourierR)/abs(conj(fourierR)));
QB = (fourierB/abs(fourierB)) * (conj(fourierR)/abs(conj(fourierR)));
qinvA = ift(QA);
qinvB = ift(QB);
Amax=max(abs(qinvA));
Bmax=max(abs(qinvB));

%Determine which of the two copies yields the highest maximum
if(Amax>Bmax)
  imageS = imageA;
else
  ang = ang + pi;
  imageS = imageB;
end

%Crop to avoid black parts
locSmax = findshift(imageR,imageS);
maxshift = max(abs(locSmax));
imageS = cut2(imageS,ceil(size(imageS)/(sqrt(2)*abs(cos(pi/4-ang)))));
imageR = cut2(imageR,ceil(size(imageR)/(sqrt(2)*abs(cos(pi/4-ang)))));
imageS = cut2(imageS,ceil(size(imageS)./zoom));
imageR = cut2(imageR,ceil(size(imageR)./zoom));
if(maxshift<size(imageS,1)/4)
  imageS = cut2(imageS,ceil([size(imageS,1)-2*maxshift,size(imageS,2)-2*maxshift]));
  imageR = cut2(imageR,ceil([size(imageR,1)-2*maxshift,size(imageR,2)-2*maxshift]));
end

%Sharpen or blur to compensate for the interpolation blurring
%sb can be changed to get possible better results.
  sigma = 0.5;
  imageR = gaussf(imageR,sigma);
  imageS = gaussf(imageS,sigma);


%Determine the shift of the best reconstructed image
tXY = findshift(imageS, imageR, 'iter');
tX = tXY(1);
tY = tXY(2);

%Change the domain of the angle from 0:2*pi to -pi:pi
if(ang > pi)
  ang = ang - 2*pi;
end
%Reverse the scaling and rotating of the detected shift
%tX = tX * zoom;
%tY = tY * zoom;   
%translationX = tX * cos(ang) - tY * sin(ang);
%translationY = tX * sin(ang) + tY * cos(ang);
%trans = -1*[translationX translationY];

trans = -1.*[tX tY];

%----------Helper  functions--------------------------------
function out = logpolar (in)
%Performs a Cartesian to log-polar transform by bi-linear
%interpolation. 
N = size(in,1);
M = N;
K = N;

out = newim(in);

%Some abbreviations.
c1 = (N/2-1)/(M-1);
c2 = N/2-1;

%Min and max possible values.
mins = newim(M,K);
maxs = newim(M,K);
maxs = maxs+(N-1);

%Log-polar grid.
mm = xx(M,K)+N/2;
kk = yy(M,K)+N/2;

%Find Cartesian (U,V) for log-polar grid [mm,kk]. 
Mtemp = newim(M,K)+(M-1);
U = c1 .* Mtemp.^((mm-1)./(M-1)) .* cos(2.*pi.*(kk-1)./K) + c2;
U = dip_image((dip_array(U))');
V = c1 .* Mtemp.^((mm-1)./(M-1)) .* sin(2.*pi.*(kk-1)./K) + c2;
V = dip_image((dip_array(V))');

%For each position, find four neighbouring pixels. Clip at borders.
F_U = min(max(floor(U),mins),maxs);
F_V = min(max(floor(V),mins),maxs);
C_U = max(min(ceil(U), maxs),mins);
C_V = max(min(ceil(V), maxs),mins);

%Now use neighbour coordinates as indices in original 'in' image.
G1 = reshape(in(dip_array(F_U+N*F_V+1)),N,N);
G2 = reshape(in(dip_array(C_U+N*F_V+1)),N,N);
G3 = reshape(in(dip_array(F_U+N*C_V+1)),N,N);
G4 = reshape(in(dip_array(C_U+N*C_V+1)),N,N);

G1 = dip_image((dip_array(G1))');
G2 = dip_image((dip_array(G2))');
G3 = dip_image((dip_array(G3))');
G4 = dip_image((dip_array(G4))');

%Calculate distances from position to each neighbour.
D1 = 1-(U-F_U);
D2 = 1-(C_U-U);
D3 = 1-(V-F_V);
D4 = 1-(C_V-V); 

%To avoid jumps...
D1(U==F_U) = 0; D2(U==F_U) = 1;
D1(U==C_U) = 1; D2(U==C_U) = 0;
D3(V==F_V) = 0; D4(V==F_V) = 1;
D3(V==C_V) = 1; D4(V==C_V) = 0;

%Bi-linear interpolation.
out = D3.*(D1.*G1+D2.*G2)+D4.*(D1.*G3+D2.*G4);   



function im_out = cut2(im_in,newsize)
%Crops the image to a smaller size. Interpolates if sizes are not both even
%or both odd. 
if (size(im_in,1)==size(im_in,2))   %im_in is square
  s_in = size(im_in,1);
  s_out = newsize(1);
  if (mod(s_in,2)==0)    %s_in is even
      if (mod(s_out,2)==0)    %s_out is even
          im_out = cut(im_in,newsize);
      else    %s_out is odd
          im_out = resample2(im_in,4,'3-cubic');    %stretch x4
          im_out = cut(im_out,4.*newsize);               %cut out center
          im_out = resample2(im_out,0.25,'3-cubic'); %stretch x0.25
      end
  else    %s_in is odd
      if (mod(s_out,2)==0)    %s_out is even
          im_out = resample2(im_in,4,'3-cubic');    %stretch x4
          im_out = cut(im_out,4.*newsize);               %cut out center
          im_out = resample2(im_out,0.25,'3-cubic'); %stretch x0.25

      else    %s_out is odd
          im_out = cut(im_in,newsize);
      end
  end
else %im_in is not square
  im_out = resample2(im_in,4,'3-cubic');    %stretch x4
  im_out = cut(im_out,4.*newsize);               %cut out center
  im_out = resample2(im_out,0.25,'3-cubic'); %stretch x0.25
end


function image_out = resample2(image_in, zoom, interpolation_method)
%This function stretches a dipimage with respect to the origin, instead of
%the top left corner (like resample.m does). This function is not (yet)
%designed to handle translations as well. 

%Compute shift caused by cutting off bottom and right edges when resampling to a non-integer amount of pixels:
epsilon1 = (zoom*size(image_in,1)-floor(zoom*size(image_in,1)))/(2*zoom);

%Compute shift caused by resampling with respect to the top left corner instead of the center:
epsilon2 = (1-zoom)/(2*zoom);

%Determine total shift:
delta = epsilon1 + epsilon2;
delta = [delta delta];

%Resample taking the error in shifts in account:
image_out = resample(image_in, zoom, delta, interpolation_method);


