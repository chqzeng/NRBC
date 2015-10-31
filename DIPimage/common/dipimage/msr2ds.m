%MSR2DS   Convert a measurement structure to a PRTOOLS dataset
%
% SYNOPSIS:
%  dataset = msr2ds(msr,labels)

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function data = msr2ds(varargin)

d = struct('menu','Analysis',...
           'display','Convert measurement to dataset',...
           'inparams',struct('name',       {'msr',             'labels'},...
                             'description',{'Measurement data','New labels'},...
                             'type',       {'measurement',     'array'},...
                             'dim_check',  {0,                 -1},...
                             'range_check',{[],                []},...
                             'required',   {1,                 0},...
                             'default',    {'',                []}...
                            ),...
           'outparams',struct('name',{'data'},...
                              'description',{'Output data set'},...
                              'type',{'dataset'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      data = d;
      return
   end
end
try
   [msr,labels] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isempty(labels)
   data = dataset(msr);
else
   data = dataset(msr,labels);
end
