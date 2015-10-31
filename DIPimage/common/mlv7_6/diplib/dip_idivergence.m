%dip_idivergence  Idivergence.
%    out = dip_idivergence(in1, in2, mask)
%
%   in1
%      Image. (Data)
%   in2
%      Image. (Model)
%   mask
%      Image.
%
%  out = sum(in1* log(in1/in2)-(in1-in2))/#number of pixels
%  is the -loglikelihood with stirling approximation for ln n!
%  for a possion distriubtion.
%
%  For in1==0 the stirling approximation would fail, -in2 is returned.  

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2004.

