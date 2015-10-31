%SPLITANDMERGE   Split and merge clustering algorithm
%
% SYNOPSIS:
%  [image_out,display] = splitandmerge(image_in,initlevel,strategy,maxseeds,
%             useseeds,predicate,srelim,nvoxels,update,hmgvar,critprob,meandif)
%
% PARAMETERS:
%  image_in:  Input image
%  initlevel: Initialisation level
%  strategy:  Grouping strategy ('sequential' or 'parallel')
%  maxseeds:  Maximum number of seeds
%  useseeds:  Use all seeds ('yes or no')
%  predicate: Homogeneity criterion ('maxmin', 'mmm', 'sigma', 'var' or 'pseudo')
%  srelim:    Small region elimination ('absolute' or 'relative')
%  nvoxels:   Number or percentage of voxels considered a small region
%  update:    Statistical update of grouped regions ('yes or no')
%  hmgvar:    Variance within homogeneous regions
%  critprob:  Right critical probability ('10%', '25%' or '50%')
%  meandif:   Maximal difference between region means
%
% DEFAULTS:
%  initlevel = 3
%  strategy  = 'parallel'
%  maxseeds  = 5
%  useseeds  = 'yes'
%  predicate = 'var'
%  srelim    = 'relative'
%  nvoxels   = 0
%  update    = 'yes'
%  hmgvar    = 10
%  critprob  = '25%'
%  meandif   = 20

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, July 2003.

function [image_out,display] = splitandmerge(varargin)

arguments={...
   'image_in', 'Input image','image',0,[],1,'a';...
   'initlevel','Initialisation level','array',0,'N',0,3;...
   'strategy', 'Grouping strategy','option',0,{'sequential','parallel'},0,'parallel';...
   'maxseeds' ,'Maximum number of seeds','array',0,'N',0,5;...
   'useseeds', 'Use all seeds','option',0,{'yes','no'},0,'yes';...
   'predicate','Homogeneity criterion','option',0,{'maxmin','mmm','sigma','var','pseudo'},0,'var';...
   'srelim',   'Small region elimination','option',0,{'absolute','relative'},0,'relative';...
   'nvoxels',  'Number(a) or Percentage(r) of voxels','array',0,'R',0,0;...
   'update',   'Statistical update of grouped regions','option',0,{'yes','no'},0,'yes';...
   'hmgvar',   'Variance within homogeneous regions','array',0,'R+',0,10;...
   'critprob', 'Right critical probability','option',0,{'10%','25%','50%'},0,'25%';...
   'meandif',  'Maximal difference between region means','array',0,'R+',0,20};

d = struct('menu','Segmentation',...
           'display','Split and merge',...
           'inparams',struct('name',       arguments(:,1),...
                             'description',arguments(:,2),...
                             'type',       arguments(:,3),...
                             'dim_check',  arguments(:,4),...
                             'range_check',arguments(:,5),...
                             'required',   arguments(:,6),...
                             'default',    arguments(:,7)...
                              ),...
           'outparams',struct('name',{'image_out','display'},...
                       'description',{'Output image','Display image'},...
                       'type',{'image','image'}...
                             )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,initlevel,strategy,maxseeds,useseeds,predicate,srelim,nvoxels,...
    update,hmgvar,critprob,meandif] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% check sx==sy, all sizes power of 2
if imsize(image_in,1)~=imsize(image_in,2)
   error('Input image must be square')
end
if imsize(image_in,1)>256
   error('Sorry, there''s a bug in the code, this function only works with images of 256x256 pixels.')
end
powx=log(imsize(image_in,1))/log(2);
if mod(powx,1)
   error('Input image must have a size power of 2')
end
powz=log(imsize(image_in,3))/log(2);
if mod(powz,1)
   error('Input image must have a size power of 2')
end
maxlevel=max(powx,powz);
limitlevel=maxlevel-powz;
if strcmp(strategy,'sequential')
   grouping=0;
elseif strcmp(strategy,'parallel')
   grouping=1;
else
   error('Erroneous strategy parameter');
end
if strcmp(useseeds,'yes')
   useseeds=1;
elseif strcmp(useseeds,'no')
   useseeds=0;
else
   error('Erroneous maximum number of seeds parameter');
end
switch predicate
   case 'maxmin'
      predicate=1;
   case 'mmm'
      predicate=2;
   case 'sigma'
      predicate=3;
   case 'var'
      predicate=4;
   case 'pseudo'
      predicate=5;
   otherwise
      error('Erroneous homogeneity parameter');
end
if strcmp(srelim,'absolute')
   smallsize=nvoxels;
elseif strcmp(srelim,'relative')
   smallsize=prod(size(image_in))*nvoxels/100;
else
   error('Erroneous absolute/relative parameter');
end
if strcmp(update,'yes')
   update=1;
elseif strcmp(update,'no')
   update=0;
else
   error('Erroneous statistical update parameter');
end
switch critprob
   case '10%'
      critprob=0;
   case '25%'
      critprob=1;
   case '50%'
      critprob=2;
   otherwise
      error('Erroneous Right critical probability parameter');
end


tmpin=int32(image_in)';
[tmpout1,tmpout2]=splitandmerge_low(...
           tmpin,maxlevel,limitlevel,initlevel,grouping,maxseeds,useseeds,...
           predicate,meandif,0.,hmgvar,critprob,0.,smallsize,update,0,0,0 );
tmpout1=tmpout1';
image_out=dip_image(tmpout1);
mypermute=1:length(size(tmpout2));
mypermute(1)=2;
mypermute(2)=1;
tmpout2=permute(tmpout2,mypermute);
display=dip_image(tmpout2);
