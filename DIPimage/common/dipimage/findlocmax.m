%FINDLOCMAX   Finds iteratively the local maximum in a LSIZE cube
%
% SYNOPSIS:
%   [postion,value] = findlocmax(in, cood, lsize, subpixel, subpixelcube, submeth)
%
% PARAMETERS:
%   in:    input image
%   cood:  starting coordinates
%   lsize: cube size = 2*floor(lsize./2)+1
%   subpixel: 'yes','no' returns subpixel max position
%             via the center of intensities;
%             for negative intensities parabolic fit
%   subpixelcube: cube size = 2*floor(subpixelcube./2)+1
%   submeth: 'CenterOfMass','Parabolic','Gaussian'
%
% DEFAULTS:
%   subpixel: 'no'
%   subpixelcube: 0 %same as lsize
%   submeth: 'CenterOfMass'
%
% EXAMPLES:
%   out = findlocmax(readim,[20 160],[15 15])

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, 2004
% July 2004, added max finding via center of mass of intensities
% September 2004, nD subpixel finding with own size
% October 2004, added support for negative values, where center of mass does not work
% April, 2005, return max value at maximum position
% April, 2005, added several subpixel methods
% July 2006, remove local background for CM, still the best way is to go with an object
%            mask + Gravity, the square box is not optimal, especially for skew intensity
% 27 September 2010: Rewritten to use SUBSREF instead of EVAL. (CL)
% 23 December 2010: Changed finding of new coordinate, before gave sometimes strange results (BR)
% 21 July 2011, Catch case when local max is on the boundary (BR)

function [out,out2] = findlocmax(varargin)


d = struct('menu','Analysis',...
    'display','Find local maximum',...
    'inparams',struct('name',{'in','cood','lsize','subp','subp_lsize','submeth'},...
    'description',{'Input image','Start coordinate','Size of the cube',...
    'Subpixel position','Size of the cube for subpixel','Subpixel method'},...
    'type',              {'image','array','array','boolean','array','option'},...
    'dim_check',  {0,1,1,0,1,0},...
    'range_check',{[],'R+','N',0,'N',{'CenterOfMass','Parabolic','Gaussian'}},...
    'required',  {1,1,1,0,0,0},...
    'default',   {'a',128,10,0,0,'CenterOfMass'}...
    ),...
    'outparams',struct('name',{'out','out2'},...
    'description',{'Position','Value'},...
    'type',{'image','array'}...
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
    [in,cood,lsize,subp,subp_lsize,submeth] = getparams(d,varargin{:});
catch
    if ~isempty(paramerror)
        error(paramerror)
    else
        error(firsterr)
    end
end
%give possibility to supply not int cood, but round it here
cood = round(cood);
in = squeeze(in);%just make sure
if any(cood > size(in))
    error('Coordinates not within the image.');
end


N = ndims(in);
s = floor(lsize./2);
%2s+1 neighborhood
co = zeros(N,2);%corner array
ss = substruct('()',cell(1,N));
ts = substruct('()',cell(1,N));

%fprintf('cood: %d %d, s: %d %d\n',cood,s);
done =0;
while ~done
    for ii=1:N
        co(ii,1) = max(min(cood(ii)-s(ii),size(in,ii)-1),0);
        co(ii,2) = max(min(cood(ii)+s(ii),size(in,ii)-1),0);
        ss.subs{ii} = co(ii,1):co(ii,2);
        ts.subs{ii} = cood(ii);
    end
    roi = subsref(in,ss);  % get roi
    [v,nc] = max(roi);          % get max value in roi (and the coordinate)
    v = double(v);
    
    %fprintf('max_n: %f, cood(1) %d, cood(2) %d\n',v,cood(1),cood(2))
    tmpv = double(subsref(in,ts)); % get value of prior max
    
    if v == tmpv
        out2 = v; %intensity
        out = cood; %coordinate position
        done = 1;
    else
        %nc = nc(1,:);%just in case we find more than one max
        cood = cood - s;
        cood(cood<0)=0;
        cood = cood + nc;
    end
end
if subp
    %check if the initial coordinates are on the edge of the image, we
    %cannot deal with that
    sz=size(in);
    if any(out >= sz-1)
        return;
    end
    if ~subp_lsize
        subp_lsize = s;
    else
        subp_lsize = floor(subp_lsize./2);
    end
    %fprintf(' out:%d %d\n',out)
    if strcmp(submeth,'CenterOfMass')
        mask = getcube(in,out,subp_lsize);
        if any(in(mask)<0)
            warning(['Negative values in the ROI of the image, center of mass estimation does not work ' ...
                'switching to parabolic subpixel fit.']);
            submeth = 'Parabolic';
        end
    end
    switch submeth
        case 'CenterOfMass'
            [tmp,v] = dip_isodatathreshold(in,mask,1);
            mask2 = dip_image(tmp*mask,'sint32'); %this may give a unconnected mask
            if sum(mask2)==0
                mask2 = mask;
            end
            msr = measure(mask2,in-min(in(mask2>0)),{'Gravity'},[],1,0,0);
            out = msr.Gravity;
        case 'Parabolic'
            out = dip_subpixellocation(in, out, 'parabolic', 'maximum');
        case 'Gaussian'
            out = dip_subpixellocation(in, out, 'gaussian', 'maximum');
    end
    if nargout ==2
        out2 = getcube_int(in,out,subp_lsize);
    end
end

% retrieves intensity image cube with boundary cutoff
function out = getcube_int(in,cood,s)
N = ndims(in);
co2 = cood;
cood = round(cood);
for ii=1:N
    co(ii,1) = max(min(cood(ii)-s(ii)-2,size(in,ii)-1),0);
    co(ii,2) = max(min(cood(ii)+s(ii)+2,size(in,ii)-1),0);
end
upleft = co(:,1);
sz = diff(co,1,2);
out = dip_crop(in, upleft, sz);
co2 = co2 - upleft;
if size(co2,1)>size(co2,2); co2=co2'; end
out = get_subpixel(out,co2,'cubic');


% retrieves binary image cube with boundary cutoff
function mask = getcube(in,cood,s)
mask = newim(in,'bin');
N = ndims(in);
ss = substruct('()',cell(1,N));
for ii=1:N
    co1 = max(min(cood(ii)-s(ii),size(in,ii)-1),0);
    co2 = max(min(cood(ii)+s(ii),size(in,ii)-1),0);
    ss.subs{ii} = co1:co2;
end
mask = subsasgn(mask,ss,1);
