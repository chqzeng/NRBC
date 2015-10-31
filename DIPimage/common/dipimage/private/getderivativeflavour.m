%GETDERIVATIVEFLAVOUR   All the logic for the derivative flavour parameters.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 9-11 October 2007.
% Added automatic IIR implementation for 'best' method if sigma>=10. (BR)
% August 2011: Added explanation to list of available methods. (CL)

function [method,ms] = getderivativeflavour(option,method,sigma,order)

if nargin==0
   option = 'deriv';
end

switch option

case 'choose'
   % Select a method based on METHOD, SIGMA and ORDER
   
   if nargin<3
      error('Not enough input arguments in call to GETDERIVATIVEFLAVOUR')
   elseif nargin<4
      order = zeros(size(sigma));
   end

   if any(order>3) | any(order>0 & sigma==0)
      % Use Fourier method in these cases, instead of FIR or IIR
      if any(strcmp(method,{'best','gaussfir','gaussiir'}));
         method = 'gaussft';
      end
   end
   sigma = sigma(sigma>0);
   if strcmp(method,'best')
      if any(sigma<0.8)
         method = 'gaussft';
      elseif any(sigma>=10)
         method = 'gaussiir';
      else
         method = 'gaussfir';
      end
   end

case 'alias'
   % Translate random method names into our select list of valid names

   if nargin<2
      error('Not enough input arguments in call to GETDERIVATIVEFLAVOUR')
   end

   method = lower(method);
   switch method
      case {'fir','firgauss','spatial'}
         method = 'gaussfir';
      case {'iir','iirgauss'}
         method = 'gaussiir';
      case {'fourier','ft'}
         method = 'gaussft';
      case 'fd'
         method = 'finitediff';
      case 'default'
         method = 'best';
   end

case 'gauss'
   % Return the default method and a list of available GAUSS-SPECIFIC methods.

   method = dipgetpref('DerivativeFlavour');
   method = getderivativeflavour('alias',method);
   
   % Force values to known list
   ms = struct('name',{'best','fir','iir','ft'},...
               'description',{'best choice for given sigma',...
                              'finite impulse response implementation',...
                              'infinite impulse response implementation',...
                              'Fourier transform implementation'});
   switch method
      case 'gaussfir'
         method = 'fir';
      case 'gaussiir'
         method = 'iir';
      case 'gaussft'
         method = 'ft';
      otherwise
         method = ms(1).name; % default value
   end

otherwise
   % Return the default method and a list of available methods.

   method = dipgetpref('DerivativeFlavour');
   method = getderivativeflavour('alias',method);

   % Force values to known list
   list = {'best','gaussfir','gaussiir','gaussft','finitediff'};
     % This is the list of values for the dip_DerivativeFlavour enum.
   ms = struct('name',list,...
               'description',{'best choice for given sigma',...
                              'Gaussian (finite impulse response implementation)',...
                              'Gaussian (infinite impulse response implementation)',...
                              'Gaussian (Fourier transform implementation)',...
                              'finite differences method'});
   if ~any(strcmp(method,list))
      method = list{1}; % default value
   end

end
