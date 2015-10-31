%SETLABELS   Remap or remove labels
%
% SYNOPSIS:
%  [imo,t_lut]=setlabels(imi,labels,newval)
%
% PARAMETERS:
%  imi       input image
%  labels    the labels affected
%  newval    if scalar: the affected labels are set to <newval>
%            if array:  must be of the same length as labels, each label
%                       in <labels> is set to the corresponding value in <newval>
%            'clear':   the affected labels are set to zero. The remaining
%                       labels are renumbered consecutively.
%
% OUTPUT
%  t_lut is the look-up table used to remap the label image
%

% (C) 2008-  Michael van Ginkel
% created 07 Aug 2008
% 13 July 2009: Modified so the lookup table is of the output data type. (CL)

function [imo,t_lut]=setlabels(imi,labels,value)

% Avoid being in menu
if nargin==1
   if ischar(imi) & strcmp(imi,'DIP_GetParamList')
      imo=struct('menu','none');
      return
   end
end

t_lut=0:max(imi);
if ischar(value) && strcmp(value,'clear')
   t_lut(labels+1)=0;
   t_lut(t_lut>0)=1:sum(t_lut>0);
else
   t_lut(labels+1)=value;
end
dt = class(dip_array(imi));
t_lut = feval(dt,t_lut);
imo = lut(imi,t_lut);
imo = dip_image(imo,datatype(imi)); % in case it's binary!?
