%MSR2OBJ   Label each object in the image with its measurement
%
% SYNOPSIS:
%  image_out = msr2obj(image_in,msr,measurementID, msrID_dim)
%
% PARAMETERS:
%  image_in:      labelled image containing the objects.
%  msr:           measurement structure.
%  measurementID: name of one of the measurements in msr.
%                 If empty, the first one is taken.
%  msrID_dim:     the component, for array measurements, default 1

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% February 2002:  Using the new function 'dip_getmeasurefeatures' - removed static lists.
% September 2002: Keep datatype of measurement for output images. (BR)
% July 2004:      Using new 'measureid' type as input parameter. (CL)
% January 2007:   Added option for Measurement ID dimsion for array measurement as Dimension (BR)
% 12 Feb 2007:    Removing Mike's private measurement functions as in MEASURE. (CL)
% March 2008:     Added mapaliases to the allowed list, same as for measure (BR)
% 1 October 2010: Moved sub-function MAPALIASES to PRIVATE/DI_MAPALIASES.

function image_out = label(varargin)

msmts = [struct('name','','description',''),dip_getmeasurefeatures];
% Remove private elements from list - This is Michael's useless creation.
[tmp,I] = intersect({msmts.name},{'BendingEnergy','CCLongestRun','Orientation2D','Anisotropy2D'});
if ~isempty(I)
   msmts(I) = [];
end

d = struct('menu','Analysis',...
           'display','Convert labels to measurements',...
           'inparams',struct('name',       {'image_in',   'msr',             'msrID',         'msrDim'},...
                             'description',{'Label image','Measurement Data','Measurement ID','Measurement ID dimension'},...
                             'type',       {'image',      'measurement',     'measureid',     'array'},...
                             'dim_check',  {0,            0,                 2,               0},...
                             'range_check',{[],           [],                [],              'N'},...
                             'required',   {1,            1,                 0,               0},...
                             'default',    {'a',          '',                '',              1}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
% Aliases for elements in the 'msmts' list (backwards compatability).
if nargin>=3
   varargin{3} = di_mapaliases(varargin{3});
end
try
   [image_in,msr,msrID,msrDim] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

type = class(dip_array(image_in));
if ~strncmp(type,'int',3) & ~strncmp(type,'uint',4)
   error('Integer input image expected.')
end
if isempty(msrID)
   msrID = fieldnames(msr);
   msrID = msrID{1};
end

try
   newlabs = subsref(msr,substruct('.',msrID));
catch
   error(lasterr);
end
table = zeros(max(image_in),1);
table(msr.id) = newlabs(msrDim,:);
table = feval(class(newlabs),[0;table]);
%keep datatype of the labels, save memory

image_out = lut(image_in,table);
