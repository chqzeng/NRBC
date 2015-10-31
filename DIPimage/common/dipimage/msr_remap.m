%MSR_REMAP   Map a measurement structure corresponding to a particular label
%            image to a measurement structure corresponding to a re-mapped
%            version of that label image.
%
% SYNOPSIS:
%  [msr_new,map_array]=msr_remap(msr_org,t_lut,<msr_mapped>)
%
% PARAMETERS:
%  msr_org     the measurement structure as measured on the original label image
%  t_lut       the look-up table [from setlabels()] used to re-map the label
%              image. Remapping two different labels onto the same label is not
%              allowed.
%  msr_mapped  a measurement structure obtained on the new label image may
%              have a different ordering of the measurement ID's. If you
%              have performed a measurement on the new label image, provide
%              it as the third argument and the measurement ID's in msr_new
%              will be put in the same order. Optional.
%
% OUTPUT
%  map_array   is such that msr_new.size == msr_org.size(map_array).
%              Careful though : msr_new ~= msr_org(map_array)
%
% EXAMPLE
%   iml=label(gaussf(noise(newim([500,500])))>0.3);
%   msr_org=measure(iml,[],{'center','size'},[],2,0,0);
%   % select some objects that we want to remove
%   sel=(msr_org.center(1,:)>100)&(msr_org.center(1,:)<170)&...
%       (msr_org.center(2,:)>100)&(msr_org.center(2,:)<170);
%   remove_ids=msr_org.id(sel);
%   [iml_new,t_lut]=setlabels(iml,remove_ids,'clear');
%   msr_size=measure(iml_new,[],{'size'},[],2,0,0);
%   [msr_new,map1]=msr_remap(msr_org,t_lut);
%   any(msr_new.size~=msr_size.size)
%
%   any(msr_new.size~=msr_org.size(map1))
%
%   [msr_new,map2]=msr_remap(msr_org,t_lut,msr_size);
%   any(msr_new.size~=msr_size.size)
%   any(msr_new.size~=msr_org.size(map1))
%   any(msr_new.size~=msr_org.size(map2))
%

% (C) 2008-  Michael van Ginkel
% created 07 Aug 2008

function [msr_new,map_array]=msr_remap(varargin)
   % Avoid being in menu
   if nargin==1
      if ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
         msr_new=struct('menu','none');
         return
      end
   end

   if (nargin<2)|(nargin>3)
      error('msr_remap requires 2 or 3 arguments');
   end
   msr_org=varargin{1};
   t_lut=varargin{2};
   msr_ref=[];
   if nargin>2
      msr_ref=varargin{3};
   end

   map_array_org=find(t_lut>0);
   new_ids=t_lut(map_array_org);
   % test for skullduggery
   if length(new_ids)~=length(unique(new_ids))
      error('msr_remap can only deal with unique remappings or deletions');
   end
   msr_new=msr_org(map_array_org-1);
   % get the mapping for fields, i.e. msr.size
   map_array=zeros(max(msr_org.id),1);
   map_array(msr_org.id)=1:length(msr_org.id);
   map_array=map_array(msr_new.id);
   msr_new.Id=new_ids;
   if ~isempty(msr_ref)
      map_tmp=zeros(max(msr_new.id),1);
      map_tmp(msr_new.id)=1:length(msr_new.id);
      map_tmp=map_tmp(msr_ref.id);
      map_array=map_array(map_tmp);
      msr_new=msr_new(msr_ref.id);
   end
