% Curvature estimation based on a Parabolic Model
%
% SYNOPSIS:
%  [orientation_im, curvature_im, confidence_im] = curvature_parabolic(input_im, sigma_g, sigma_a)
%
% PARAMETERS:
%	sigma_g: size of the Gaussian standard deviation in computing the first-derivatives
%	sigma_a: size of the Gaussian standard deviation to define local neighborhood ( > sigma_g
%
% LITERATURE:
% J. van de Weijer, L.J. van Vliet, P.W. Verbeek, M. van Ginkel,
% Curvature estimation in orientation patterns using curvi-linear models applied to gradient vector fields,
% IEEE Transactions on Pattern Analysis and Machine Intelligence, PAMI, vol.23, no 9., sept 2001.
% 
% equation numbers below refer to the PAMI article
%


function [orientation_im, curvature_im, confidence_im] = curvature_parabolic(input_im, sigma_g, sigma_a)

%Initialize the filter
	break_of_sigma = 3.;
	filtersize = break_of_sigma*sigma_g;
      
	% compute the Gaussian and first Gaussian derivatives at scale sigma_g
	[y x] = ndgrid(-filtersize:filtersize,-filtersize:filtersize);
	Gg    = 1./(2 * pi * sigma_g^2)* exp((x.^2 + y.^2)./(-2 * sigma_g * sigma_g) );
	Gg_x  = 1./(sigma_g^2)* x .* Gg;
	Gg_y  = 1./(sigma_g^2)* y .* Gg;

	% Compute the (moment generating) filters at scale sigma_a
	filtersize = break_of_sigma*sigma_a;
	[y x] = ndgrid(-filtersize:filtersize,-filtersize:filtersize);
	Ga    = 1/(2 * pi * sigma_a^2) * exp((x.^2 + y.^2)/(-2 * sigma_a * sigma_a));
	Ga_x  = x .* Ga;
	Ga_y  = y .* Ga;
	Ga_xy = x .* Ga_y;
	Ga_xx = x .* Ga_x;
	Ga_yy = y .* Ga_y;

% orientation_imation Estimation

Fx  = filt2dim(Gg_x, input_im);
Fy  = filt2dim(Gg_y, input_im);
Fxx = Fx .* Fx;
Fxy = Fx .* Fy;
Fyy = Fy .* Fy;
orientation_im = 1/2 * atan2(2 * filt2dim(Ga,Fxy), filt2dim(Ga, (Fxx - Fyy)));

% curvature_imature Estimation

Cos2   = cos(orientation_im) .* cos(orientation_im);
Sin2   = sin(orientation_im) .* sin(orientation_im);
CosSin = cos(orientation_im) .* sin(orientation_im);

%see equation 29

w2fw2 = filt2dim(Ga_yy,Fyy) .* Cos2.*Cos2...
   - 2 * (filt2dim(Ga_xy,Fyy) + filt2dim(Ga_yy,Fxy)) .* Cos2.*CosSin...
   + (filt2dim(Ga_xx,Fyy) + 4*filt2dim(Ga_xy,Fxy) + filt2dim(Ga_yy,Fxx)) .* CosSin.*CosSin...
   + 2*(-filt2dim(Ga_xx,Fxy) - filt2dim(Ga_xy,Fxx)) .* CosSin.*Sin2...
   + filt2dim(Ga_xx,Fxx) .* Sin2.*Sin2;

w2fv2 = filt2dim(Ga_yy,Fxx) .* Cos2.*Cos2...
   - 2 * (filt2dim(Ga_xy,Fxx)-filt2dim(Ga_yy,Fxy)) .* Cos2.*CosSin...
   + (filt2dim(Ga_xx,Fxx) - 4*filt2dim(Ga_xy,Fxy) + filt2dim(Ga_yy,Fyy)) .* CosSin.*CosSin...
   + 2 * (filt2dim(Ga_xx,Fxy) - filt2dim(Ga_xy,Fyy)) .* CosSin.*Sin2...
   + filt2dim(Ga_xx,Fyy) .* Sin2.*Sin2;

wfvfw = cos(orientation_im) .* (filt2dim(Ga_y,Fxy).*Cos2...
   	+ (-filt2dim(Ga_x,Fxy)-filt2dim(Ga_y,(Fxx-Fyy)) ).*CosSin...
		+ (filt2dim(Ga_x,(Fxx-Fyy))-filt2dim(Ga_y,Fxy)).*Sin2)...
	+ filt2dim(Ga_x,Fxy).*Sin2.*sin(orientation_im);

fv2 = filt2dim(Ga,Fxx).*Cos2 + 2*filt2dim(Ga,Fxy).*CosSin + filt2dim(Ga,Fyy).*Sin2;
fw2 = filt2dim(Ga,Fyy).*Cos2 - 2*filt2dim(Ga,Fxy).*CosSin + filt2dim(Ga,Fxx).*Sin2;

w2 = ones(size(input_im))*sigma_a*sigma_a;

% Compute curvature (eq.17) and confidence (eq.18))

curvature_im  = (w2fv2 - w2.*fw2 - sqrt(4*w2 .* wfvfw .* wfvfw + power(-w2fv2 + w2.*fw2, 2)))...
   ./ (2*w2 .* wfvfw);
confidence_im = (curvature_im.*curvature_im .* (w2fw2 - w2fv2) - 4*curvature_im.*wfvfw + fv2 - fw2)...
   ./ (curvature_im.*curvature_im .* (w2fw2 + w2fv2) + fv2 + fw2);

orientation_im = dip_image(orientation_im);
curvature_im   = dip_image(curvature_im);
confidence_im  = dip_image(confidence_im);

