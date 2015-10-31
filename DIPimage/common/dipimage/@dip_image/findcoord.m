%FINDCOORD   Find coordinates of nonzero elements.
%   C = FINDCOORD(B) returns the coordinates of the image B that
%   are non-zero. C(N,:) is a vector with coordinates for non-zero
%   pixel number N. 
%
%   [C,V] = FINDCOORD(B) returns also a 1-D image containing the 
%   values of the non-zero pixels in B.
%   FINDCOORD is similar to FIND, in that it returns the same
%   list of pixels, but in a different form.
%
%   FINDCOORD(B,K) finds at most the first K nonzero pixels.
%   FINDCOORD(B,K,'first') is the same. FINDCOORD(B,K,'last') finds
%   at most the K last pixels. This syntax is only valid on
%   versions of MATLAB in which the built-in FIND supports these
%   options.
%
%   Note that the output of FINDCOORD cannot be directly used to
%   index an image. Each of the coordinates should be used separately,
%   i.e., B(C(N,1),C(N,2)), or by computing the pixel indices,
%   B(SUB2IND(B,C)).
%   SUB2IND(B,C) is the same as what is returned by the function FIND.
%
%   See also DIP_IMAGE/FIND, COORD2IMAGE, DIP_IMAGE/SUB2IND, DIP_IMAGE/IND2SUB.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2000.
% 22 June 2001:      Fixed bug caused by FIND on 1D data.
%                    Also, 1D images produced two coordinates.
% 27 August 2001:    Fixed important bug: coordinates returned were bogus
%                    if x and y sizes were not the same.
%                    Fixed bug in documentation.
% 11 September 2001: Fixed previous bug correctly. :{
% 19 November 2008:  Added return of pixel values (BR)
% 28 Septermber 2010: Extended to allow the parameters K and 'first'/'last';
%                     Using only calls to FIND and IND2SUB.

function [C,V] = findcoord(in,varargin)
if ~isa(in,'dip_image'), error('First argument must be a scalar image.'); end
if nargout==2
   [I,V] = find(in,varargin{:});
else
   I = find(in,varargin{:});
end
C = ind2sub(in,I);
