%SPECTRA2XYZ   Converts input spectra to XYZ values
%
% SYNOPSIS:
%  [image_out, xy_boundary] = spectra2xyz( spectra_in, Y_white, dlab, k)
%
% DEFAULTS:
%  Y_white = max(Y)
%  dlab    = 4
%  k       = 683 lm/W
%
% DESCRIPTION:
%  In this function the tristimulus values of the input spectra are
%  determined with respect to the luminance of white. There are three
%  possible ways to define Y_white. If Y_white is empty, the reference
%  white is the largest luminance Y of spectra_in. If Y_white = 1, the
%  reference luminance is also 1 (or no reference white is taken into
%  account). If Y_white is one or more spectra, the reference luminance
%  is the luminance of the (mean) spectra.
%
%  The tristimulus values are determined as follows:
%     X = k*sum( spectrum_in * x_bar) * dlab / Y_white
%     Y = k*sum( spectrum_in * y_bar) * dlab / Y_white
%     Z = k*sum( spectrum_in * z_bar) * dlab / Y_white
%  spectrum_in is the spectral radiance of irradiance
%  dlab is de stepsize in nm
%  k is a constant: 683 lm/W
%  x_bar, y_bar, z_bar are the color matching functions from CIE 1931
%     2 degree observer.
%
%  In the second output argument the boundaries of the xy system is
%  given.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, may 10 1999,
% imported in dipimage June 2002.

function [out, bound] = spectra2xyz( spectr, spectr_white, dlab, k);
% Avoid being in menu
if nargin == 1 & ischar(spectr) & strcmp(spectr,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if nargin < 1, error('An input spectrum is needed'); end;
if isempty( spectr ), error('The input spectrum should have a size'); end
if nargin < 3, dlab = 4; end
if nargin < 4, k = 683; end

[X, Y, Z, x_bound, y_bound] = spectrum2xyz( spectr, dlab, k);

if( nargin < 2 | isempty( spectr_white))
   Y_white = max(Y);
elseif( spectr_white == 1)
   Y_white = 1;
else
   [X_white, Y_white, Z_white] = spectrum2xyz( spectr_white, dlab, k);
end

Y_white = mean( Y_white );
X = X./Y_white;
Y = Y./Y_white;
Z = Z./Y_white;

out = joinchannels('XYZ', X, Y, Z);
bound = joinchannels('Yxy', x_bound*0+1, x_bound, y_bound);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ X, Y, Z, x_boundary, y_boundary ] = spectrum2xyz( spectr, dlab, k )

load('xyz_bar_1931');
s = size( spectr );
if( s(1) == 1)
   spectr = spectr';
   s = size( spectr );
end
if( dlab ~= 4)
   lambda = [380:dlab:780];
   lambda_old = [380:4:780];
   s_l = size(lambda);
   x_low = lambda_old(1);
   x_high = lambda_old(2);
   j = 1;
   x_bar2 = zeros(s_l(1), 1)
   y_bar2 = zeros(s_l(1), 1)
   z_bar2 = zeros(s_l(1), 1)
   for i=1:s_l
      io_high = find( lambda(i) <= lambda_old );
      io_low = find( lambda(i) >= lambda_old );
      if isempty(io_low)
         x_bar2(i) = x_bar(1);
         y_bar2(i) = y_bar(1);
         z_bar2(i) = z_bar(1);
      elseif isempty(io_high)
         x_bar2(i) = x_bar(end);
         y_bar2(i) = y_bar(end);
         z_bar2(i) = z_bar(end);
      else
         iol = io_low(end);
         ioh = io_high(1);
         x_bar2(i) = (x_bar(iol).*(lambda_old(ioh) - lambda(i)) + ...
            x_bar(ioh).*(lambda(i) - lambda_old(iol)))./ ...
               (lambda_old(ioh)-lambda_old(iol));
         y_bar2(i) = (y_bar(iol).*(lambda_old(ioh) - lambda(i)) + ...
            y_bar(ioh).*(lambda(i) - lambda_old(iol)))./ ...
               (lambda_old(ioh)-lambda_old(iol));
         z_bar2(i) = (z_bar(iol).*(lambda_old(ioh) - lambda(i)) + ...
            z_bar(ioh).*(lambda(i) - lambda_old(iol)))./ ...
               (lambda_old(ioh)-lambda_old(iol));
      end
   end
end

R_xbar = zeros(s(1), s(2));
R_ybar = zeros(s(1), s(2));
R_zbar = zeros(s(1), s(2));


for i=1:s(2)
   Rx_bar(:, i) = spectr(:, i).*x_bar;
   Ry_bar(:, i) = spectr(:, i).*y_bar;
   Rz_bar(:, i) = spectr(:, i).*z_bar;
end

X = k.*sum(Rx_bar).*dlab;
Y = k.*sum(Ry_bar).*dlab;
Z = k.*sum(Rz_bar).*dlab;

x_boundary = x_bar./(x_bar + y_bar + z_bar);
y_boundary = y_bar./(x_bar + y_bar + z_bar);

xy_boundary = [x_boundary y_boundary];
