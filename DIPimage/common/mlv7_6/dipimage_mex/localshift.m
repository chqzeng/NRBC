%LOCALSHIFT   Shifts/warps an image by a shift vector per pixel/grid point
% 
% SYNOPSIS:
%  out = localshift(in, sv, osize, interp, coord)
%
% PARAMETERS:
%  in:     2D image
%  sv:     shift vector per pixel as a dip_image_array
%  osize:  output size 
%          'Recut':    new size = bounding bound around shifted image 
%          'FullSize': new size = old size + max(abs(shift vector))
%          'ConstFoV': new size = old size (with constant Field of View)
%  interp: Interplotation option
%          'zoh': zero order hold, shift via 2D histogram and normalized convolution
%          'bilinear': osize is ignored=ConstFoV, loop is done over output image
%          '3-cubic': osize is ignored=ConstFoV, loop is done over output image
%  coord:  optional coordinate grid image (2D) as meshgrid, if the shift vector is not
%          per pixel as the output from findlocalshift
%
% NOTE:
%  only implemented for 2D but could be nD
%
% SEE ALSO:
%  findlocalshift, orientation/vectorplot

% (C) Copyright 2005               FEI Electron Optics - Building AAEp 
%     All rights reserved          PO Box 80066
%                                  5600 KA Eindhoven 
%                                  The Netherlands
% Bernd Rieger, June 2005
% July 2005, added Input with same centers
% October 2006, added cubic interpolation

function out = localshift(varargin)

d = struct('menu','Manipulation',...
  'display','Local shift',...
  'inparams',struct('name',       {'in','sv','recut','inter','mc'},...
       'description',{'Input image','Shift vector','Output size','Interpolation','Coordinates'},...
       'type',       {'image','image','option','option','image'},...
       'dim_check',  {0,0,0,0,0},...
       'range_check',{'','',{'FullSize','Recut','ConstFoV'},{'zoh','bilinear','3-cubic'},''},...
       'required',   {1,1,0,0,0},...
       'default',    {'a','sv','FullSize','zoh','[]'}...
      ),...
  'outparams',struct('name',{'out'},...
                     'description',{'Output image'},...
                     'type',{'array'}...
                     )...
 );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end

try
   [in,sv,recut,inter,mc] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ndims(in)~=2
   error('Only implemented for 2D.');
end
if ~isa(sv,'dip_image_array')
   sv = im2array(sv);
end
if size(in) ~= size(sv{1}) 
   if isempty(mc)
      error('No coordinate grid given and sizes of image and shift image not identical');
   end
   %assume mc is a rectangular grid inside the image borders
   o1 = min(ex_slice(mc,0));
   o2 = max(ex_slice(mc,0));
   o3 = min(ex_slice(mc,1));
   o4 = max(ex_slice(mc,1));
   szt = [o2-o1+1 o4-o3+1];   
   ns = szt./size(sv{1});
   %first interpolate new shift values in the regular grid as from findlocalshift, then
   %do the borders
   sv{1} = resample(sv{1},ns,[0 0],'3-cubic');
   sv{2} = resample(sv{2},ns,[0 0],'3-cubic');
   
   % do borders, outside the grid generate new shift values by normalized
   % averaging
   tmp = newim(in,'bin');
   tmp(o1:o2,o3:o4)=1;
   sv1 = newim(in,'dfloat');sv2 = newim(in,'dfloat');
   sv1(tmp) = sv{1};sv2(tmp)=sv{2};
   sg = (o1/3 + (size(in,2)-o2)/3 )/2;
   sv{1} = normalized_averaging(sv1,tmp,sg);
   sv{2} = normalized_averaging(sv2,tmp,sg);
   clear tmp sv1 sv2
end

switch inter
   case 'zoh'
      pos = newimar(xx(in,'corner'),yy(in,'corner'));
      model = pos + sv;
      zo =1; %gobal zoom
      %in the following the model contains the ABSOLUTE positions on the new grid

      lefttop = floor( [min(model{1}) min(model{2})] * zo );
      rightbottom = ceil( [max(model{1}) max(model{2})] * zo );

      switch recut
         case 'Recut'
            offset = -lefttop';      % offset of 1st frame in the HR grid
            outsize = rightbottom - lefttop + 1;
         case {'FullSize'}
            offset = [0 0];
            outsize = rightbottom + 1;
         case 'ConstFoV'
            offset = [0 0];
            outsize = size(in);
         otherwise
            error('Should not happen.');
      end
      %fprintf('offset %d %d\n',offset);
      %fprintf('lefttop %d %d\n',lefttop);
      %fprintf('rightbottom %d %d\n',rightbottom);
      %fprintf('outsize %d %d\n',outsize);

      I = round(model{1}*zo + offset(1)) + round(model{2}*zo + offset(2))*outsize(1);
      param = {{'lower',0,'upper',prod(outsize),'bins',prod(outsize),...
                'lower_abs','upper_abs','no_correction'}};
      tot = reshape(mdhistogram(I,size(in)*0,in,param), outsize);
      cnt = reshape(mdhistogram(I,size(in)*0,~newim(in,'bin'),param), outsize);

      out = normalized_averaging(tot,cnt,1);
   case 'bilinear'
      out = dip_image(localshift_low(double(in),double(array2im(sv)))); %quick 2D c implementation without DIPlib
   case '3-cubic'
      out = dip_image(localshift_low_cubic(double(in),double(array2im(sv)))); %quick 2D c implementation without DIPlib
   otherwise
      error('Unknown interpolation option.');
end

function out = normalized_averaging(tot,cnt,s)
% Normalized the accumulated samples/weights, fill-in NaN if necessary
out = tot/(cnt+eps);    % add epsilon to avoid NaN (=0/0)
mask = cnt==0;          % fill-in empty pixels, if any
if sum(mask)>0          
   tot2 = gaussf(tot,s); 
   cnt2 = gaussf(cnt,s);
   out(mask) = tot2(mask)/(cnt2(mask)+eps);
end