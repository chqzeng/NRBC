% Curvature estimation based on a Circular Model
%
% SYNOPSIS:
%  [orientation_im, curvature_im, confidence_im] = curvature_circular(input_im, sigma_g, sigma_a)
%
% PARAMETERS:
%	sigma_g: size of the Gaussian standard deviation in computing the first-derivatives
%	sigma_a: size of the Gaussian standard deviation to define local neighborhood ( > sigma_g)
%
% LITERATURE:
% J. van de Weijer, L.J. van Vliet, P.W. Verbeek, M. van Ginkel,
% Curvature estimation in orientation patterns using curvi-linear models applied to gradient vector fields,
% IEEE Transactions on Pattern Analysis and Machine Intelligence, PAMI, vol.23, no 9., sept 2001.
% 
% equation numbers below refer to the PAMI article
%

function [orientation_im, curvature_im, confidence_im] = curvature_cirular(input_im, sigma_g, sigma_a)

%Initialize the filter
	break_of_sigma = 3.;
	filtersize = break_of_sigma*sigma_g;

	% compute the Gaussian and first Gaussian derivatives at scale sigma_g
	[y x] = ndgrid(-filtersize:filtersize,-filtersize:filtersize);
	Gg    = 1./(2 * pi * sigma_g.^2)* exp((x.^2 + y.^2)./(-2 * sigma_g * sigma_g) );
	Gg_x  = 1./(sigma_g.^2)* x .* Gg;
	Gg_y  = 1./(sigma_g.^2)* y .* Gg;

	% Compute the (moment generating) filters at scale sigma_a
	filtersize = break_of_sigma*sigma_a;
	[y x] = ndgrid(-filtersize:filtersize,-filtersize:filtersize);
	Ga    = 1/(2 * pi * sigma_a^2) * exp((x.^2 + y.^2)/(-2 * sigma_a * sigma_a));
	Ga_x  = x .* Ga;
	Ga_y  = y .* Ga;
	Ga_xy = x .* Ga_y;
	Ga_xx = x .* Ga_x;
	Ga_yy = y .* Ga_y;


% Orientation Estimation

Fx  = filt2dim(Gg_x,input_im);
Fy  = filt2dim(Gg_y,input_im);
Fxx = Fx .* Fx;
Fxy = Fx .* Fy;
Fyy = Fy .* Fy;
orientation_im=atan2(2*filt2dim(Ga,Fxy),filt2dim(Ga,(Fxx-Fyy) )) /2;

% Curvature Estimation
CosPhi = cos(orientation_im);
SinPhi = sin(orientation_im);

%see equation 27
A = filt2dim(Ga_xx,Fxx) + 2*filt2dim(Ga_xy,Fxy) + filt2dim(Ga_yy,Fyy);
B = -(filt2dim(Ga_x,Fxx) + filt2dim(Ga_y,Fxy)).*CosPhi - (filt2dim(Ga_x,Fxy) + filt2dim(Ga_y,Fyy)).*SinPhi;
C = filt2dim(Ga,Fxx).*CosPhi.*CosPhi + 2*filt2dim(Ga,Fxy).*CosPhi.*SinPhi + filt2dim(Ga,Fyy).*SinPhi.*SinPhi;
D = ones(size(C))*2*sigma_a*sigma_a;
E = filt2dim(Ga_xx,Fyy) - 2*filt2dim(Ga_xy,Fxy) + filt2dim(Ga_yy,Fxx);
F = (filt2dim(Ga_y,Fxy) - filt2dim(Ga_x,Fyy)).*CosPhi + (filt2dim(Ga_x,Fxy) - filt2dim(Ga_y,Fxx)).*SinPhi;
G = filt2dim(Ga,Fyy).*CosPhi.*CosPhi - 2*filt2dim(Ga,Fxy).*CosPhi.*SinPhi + filt2dim(Ga,Fxx).*SinPhi.*SinPhi;

% Compute Curvature (eq.25) and Confidence (eq.28))

curvature_im  = (E - G.*D - sqrt(4 * F.*F.*D + power(-E + G.*D, 2)))...
   ./(2*F.*D);
confidence_im = (curvature_im.*curvature_im .* (A-E) + 2*curvature_im .* (B-F) + (C-G))...
   ./(curvature_im.*curvature_im .* (A+E) + 2*curvature_im .* (B+F) + (C+G));

orientation_im = dip_image(orientation_im);
curvature_im   = dip_image(curvature_im);
confidence_im  = dip_image(confidence_im);
