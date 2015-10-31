%MEASURE   Do measurements on objects in an image
%
% SYNOPSIS:
%  msr = measure(object_in,gray_in,measurmentIDs,objectIDs,...
%                 connectivity,minSize,maxSize)
%
% PARAMETERS:
%  object_in: binary or labelled image holding the objects.
%  gray_in: (original) gray value image of object_in. It is needed for
%           several types of measurements. Otherwise you can use [].
%  measurementIDs: measurements to be performed, either a single string
%                  or a cell array with strings (e.g.: {'Size','Perimeter'} ).
%                  See MEASUREHELP for a full list of possible
%                  measurements.
%  objectIDs: labels of objects to be measured. Use [] to measure all
%             objects
%  connectivity: defines which pixels are considered neighbours: up to
%     'connectivity' coordinates can differ by maximally 1. Thus:
%     * A connectivity of 1 indicates 4-connected neighbours in a 2D image
%       and 6-connected in 3D.
%     * A connectivity of 2 indicates 8-connected neighbourhood in 2D, and
%       18 in 3D.
%     * A connectivity of 3 indicates a 26-connected neighbourhood in 3D.
%     Connectivity can never be larger than the image dimensionality.
%     Setting the connectivity to Inf (the default) makes it equal to the image
%     image dimensionality.
%  minSize, maxSize: minimum and maximum size of objects to be measured.
%
% DEFAULTS:
%  measurementIDs = 'size'
%  objectIDs = []
%  connectivity = inf
%  minSize = 0
%  maxSize = 0
%
% RETURNS:
%  msr: a dip_measurement object containing the results.
%
% EXAMPLE:
%  img = readim('cermet')
%  msr = measure(img<100, img, ({'size', 'perimeter','mean'}), [], ...
%                1, 1000, 0)
%
% NOTE:
%  The function MEASUREHELP provides help on the measurement
%  features available in this function.
%
% NOTE:
%  Several measures use the boundary chain code (i.e. 'Feret', 'Perimeter',
%  'CCBendingEnergy', 'P2A' and 'PodczeckShapes'). These measures will fail
%  if the object is not compact (one chain code must represent the whole
%  object). If the object is not compact under the connectivity chosen, only
%  one part of the object will be measured. Make sure the connectivity in
%  MEASURE matches that used in LABEL!

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2000.
% September 2000: Added 'optionarray' for measurementIDs.
% September 2000: Added MINSIZE and MAXSIZE parameters.
% December 2000:  Fixed bug when using MINSIZE or MAXSIZE with new dip_measurement.
% January 2002:   Returning empty structure if MINSIZE is larger than any object.
% February 2002:  Using the new function 'dip_getmeasurefeatures' - removed static lists.
% February 2004:  Improved help (KvW).
% February 2004:  Fixed bug involving min and max size. Default measurement is 'size'.
% 18 April 2005:  Exit gracefully in absence of any objects when a size
%                    restriction is imposed (MvG)
% 12 Feb 2007:    Better way of removing Mike's private measurement functions.
% February 2008:  Added strucutre for non-diplib measurements;
%                    now: extent of 2/3D cubes and elliposids. (BR)
% 6 March 2008:   Simplified removing of small objects from object ID list.
%                 Using new overloaded method RMFIELD.
% 20 Oct 2008:    Added 'MajorAxes' measurement (BR)
% 7 Dec 2009:     Added a note to the help about chain codes and connectivity.
% 14 Sep 2010:    Changed default connectivity to match label default (BR)
% 1 October 2010: Moved sub-function MAPALIASES to PRIVATE/DI_MAPALIASES.

function data = measure(varargin)

msmts = dip_getmeasurefeatures;

% Remove private elements from list - This is Michael's useless creation.
[tmp,I] = intersect({msmts.name},{'BendingEnergy','CCLongestRun','Orientation2D','Anisotropy2D'});
if ~isempty(I)
    msmts(I) = [];
end

% Add non-diplib measurements
add_msmts = di_derivedmeasurements;
n = length(msmts);
for ii=1:size(add_msmts,1)
    msmts(n+ii).name = add_msmts{ii,1};
    msmts(n+ii).description = add_msmts{ii,2};
end

d = struct('menu','Analysis',...
           'display','Measure',...
           'inparams',struct('name',       {'object_in',   'gray_in',         'measurementID','objectIDs', 'connectivity','minSize',            'maxSize'},...
                             'description',{'Object image','Grey-value image','Measurement',  'Object IDs','Connectivity','Minumum object size','Maximum object size'},...
                             'type',       {'image',       'image',           'optionarray',  'array',     'array',       'array',              'array'},...
                             'dim_check',  {0,             0,                 1,              -1,          0,             0,                    0},...
                             'range_check',{[],            [],                msmts,          'N+',        'N+',          'N',                  'N'},...
                             'required',   {1,             0,                 0,              0,           0,             0,                    0},...
                             'default',    {'a',           '[]',              'size',         [],          inf,             0,                    0}...
                            ),...
           'outparams',struct('name',{'msr'},...
                              'description',{'Output measurement data'},...
                              'type',{'measurement'}...
                             )...
           );
if nargin == 1
    s = varargin{1};
    if ischar(s) & strcmp(s,'DIP_GetParamList')
        data = d;
        return
    end
end
% Aliases for elements in the 'msmts' list (backwards compatability).
if nargin>=3
    if ischar(varargin{3})
        varargin{3} = {varargin{3}};
    end
    if iscellstr(varargin{3})
        for ii=1:prod(size(varargin{3}))
            varargin{3}{ii} = di_mapaliases(varargin{3}{ii});
        end
    end
end

try
    [object_in,gray_in,measurementID,objectIDs,connectivity,minSize,maxSize] = getparams(d,varargin{:});
catch
    if ~isempty(paramerror)
        error(paramerror)
    else
        error(firsterr)
    end
end
if isinf(connectivity)
   connectivity = ndims(object_in);
end

% Check for non-diplib measurements
if ~iscell(measurementID)
    measurementID = {measurementID};
end
orgmeasurementID = measurementID;
added_msrID = {};
for ii=1:size(add_msmts,1)
    jj = find(strcmpi(measurementID,add_msmts{ii,1}));
    if jj
        measurementID{jj} = add_msmts{ii,3};
        added_msrID{end+1} = add_msmts{ii,1};
    end
end
measurementID = unique(lower(measurementID));

if islogical(object_in)
    % meaning it is a binary image...
    object_in = dip_label(object_in,connectivity,'threshold_on_size',...
        minSize,maxSize,'');
    if max(object_in) < 1
        data = dip_measurement;
        return
    end
elseif minSize ~= 0 | maxSize ~= 0
    % measure object size and select objects in range
    % We don't need to do this if we just labelled the image
    if minSize ~= 0 & maxSize ~= 0 & minSize > maxSize
        error('maxSize must be larger than minSize.')
    end
    m = dip_measure(object_in,gray_in,'size',objectIDs,connectivity);
    % 18-04-2005 - MvG - Exit gracefully in absence of any objects
    if isempty( m )
        data = dip_measurement;
        return
    end
    sz = m.size;
    I = sz==sz;   % same as true(size(sz)), but works on older MATLABs.
    if minSize ~= 0
        I(sz<minSize) = 0;
    end
    if maxSize ~= 0
        I(sz>maxSize) = 0;
    end
    objectIDs = m.id(I);
    if length(objectIDs) < 1
        data = dip_measurement;
        return
    end
elseif max(object_in) < 1
    data = dip_measurement;
    return
end
data = dip_measure(object_in,gray_in,measurementID,objectIDs,connectivity);


% Was a non-diplib measurements requested??
% if yes, add it to the dip_measurement object
if ~isempty(added_msrID)
    for ii=1:length(added_msrID)
        switch added_msrID{ii}
            case 'DimensionsEllipsoid'
                out = feat_dimensionsellipsoid(data);
            case 'GreyDimensionsEllipsoid'
                out = feat_dimensionsellipsoid_grey(data);
            case 'DimensionsCube'
                out = feat_dimensionscube(data);
            case 'GreyDimensionsCube'
                out = feat_dimensionscube_grey(data);
            case 'GreyMajorAxes'
                out = feat_majoraxes_grey(data);
            case 'MajorAxes'
                out = feat_majoraxes(data);
            otherwise
                error('Should not happen.');
        end
        data = subsasgn(data,substruct('.',added_msrID{ii}),out);
    end
    % remove added measures from list if neccessary
    tmp = setdiff(lower(measurementID),lower(orgmeasurementID));
    for ii=1:length(tmp)
        data = rmfield(data,tmp{ii});
    end
end
return;


%%%
function out = feat_dimensionsellipsoid(data)
J = flipud(data.Inertia);
switch size(J,1)
    case 2
        m = [0 16; 16 0];
    case 3
        m = 10.*[-1 1 1; 1 -1 1; 1 1 -1];
    otherwise
        error('Not implemented for higher dimensions than 3.');
end
out = sqrt(m*J);


function out = feat_dimensionsellipsoid_grey(data)
J = flipud(data.GreyInertia);
switch size(J,1)
    case 2
        m = [0 16; 16 0];
    case 3
        m = 10.*[-1 1 1; 1 -1 1; 1 1 -1];
    otherwise
        error('Not implemented for higher dimensions than 3.');
end
out = sqrt(m*J);


function out = feat_dimensionscube(data)
J = flipud(data.Inertia);
switch size(J,1)
    case 2
        m = [0 12; 12 0];
    case 3
        m = 6.*[-1 1 1; 1 -1 1; 1 1 -1];
    otherwise
        error('Not implemented for higher dimensions than 3.');
end
out = sqrt(m*J);


function out = feat_dimensionscube_grey(data)
J = flipud(data.GreyInertia);
switch size(J,1)
    case 2
        m = [0 12; 12 0];
    case 3
        m = 6.*[-1 1 1; 1 -1 1; 1 1 -1];
    otherwise
        error('Not implemented for higher dimensions than 3.');
end
out = sqrt(m*J);

function out=feat_majoraxes_grey(data)
J = data.GreyMu;
switch size(J,1)
    case 3 %2D
        N = 2;
    case 6 %3D
        N = 3;
    otherwise
        error('should not happen.')
end
out = zeros(N,N,size(J,2));
for objectnumber = 1:size(J,2)
    j = zeros(N,N);
    l=0;
    for ii = 1:N
        for jj=ii:N
            l=l+1;
            j(ii,jj) = J(l, objectnumber);
            j(jj,ii) = J(l, objectnumber);
        end
    end
    %if any(isnan(j)) || any(isinf(j)); continue;end
    [tmp,bla] = eig(j);
    out(:,:,objectnumber) = tmp;
end
out = reshape(out,N*N,objectnumber);

function out=feat_majoraxes(data)
J = data.Mu;
switch size(J,1)
    case 3 %2D
        N = 2;
    case 6 %3D
        N = 3;
    otherwise
        error('should not happen.')
end
out = zeros(N,N,size(J,2));
for objectnumber = 1:size(J,2)
    j = zeros(N,N);
    l=0;
    for ii = 1:N
        for jj=ii:N
            l=l+1;
            j(ii,jj) = J(l, objectnumber);
            j(jj,ii) = J(l, objectnumber);
        end
    end
    %if any(isnan(j)) || any(isinf(j)); continue;end
    [tmp,bla] = eig(j);
    out(:,:,objectnumber) = tmp;
end
out = reshape(out,N*N,objectnumber);
