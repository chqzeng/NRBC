%MAT2IM   Converts a matlab array to a dip_image.
%
% SYNOPSIS:
%  A = MAT2IM(B,DIMS)
%
% DEFAULT:
%  DIMS = [];
%
%  Converts the matrix B to a dip_image. DIMS is an array specifying the matrix
%  dimensions to use as tensor dimensions. If left out, a scalar image is produced.
%  If a string is given as DIMS, it is used as color space name, and the last
%  matrix dimension is considered the color dimension.
%
% EXAMPLES:
%  a = readim('flamingo');
%  b = im2mat(a);
%  c = mat2im(b,'rgb');   % c is identical to a.
%
%  a = readim('chromo3d');
%  a = gradientvector(a);
%  b = im2mat(a);
%  c = mat2im(b,4);       % c is identical to a.
%
% SEE ALSO:
%  IM2MAT, DIP_IMAGE, DIP_IMAGE/DIP_ARRAY

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger & Cris Luengo, August 2008

function out = mat2im(varargin)
switch nargin
    case 0
         error('Input array expected.');
    case 1
        if ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
            out = struct('menu','none');
            return
        end
        out = dip_image(varargin{1});
    case 2
        in = varargin{1};
        if ~isnumeric(in)
            error('Input must be numeric.');
        end
        I = varargin{2};
        sz = size(in);
        if isnumeric(I)
            if any(I> length(size(in))) | any(I) < 1
                error('Given array dimension do not match matrix dimesions.');
            end
            out = newimar(sz(I));
            switch numel(I)
                case 1
                    ind = cell(1,length(sz));
                    ind(:) = {':'};
                    ind = substruct('()',ind);
                    outsz = sz;
                    outsz(I) = [];
                    for ii=1:sz(I)
                        ind.subs{I} = ii;
                        tmp = subsref(in,ind);
                        tmp = reshape(tmp,outsz);
                        out{ii} = dip_image(tmp);
                    end
                case 2
                    ind = cell(1,length(sz));
                    ind(:) = {':'};
                    ind = substruct('()',ind);
                    outsz = sz;
                    outsz(I) = [];
                    for jj=1:sz(I(1))
                        ind.subs{I(1)} = jj;
                        for ii=1:sz(I(2))
                            ind.subs{I(2)} = ii;
                            tmp = subsref(in,ind);
                            tmp = reshape(tmp,outsz);
                            out{jj,ii} = dip_image(tmp);
                        end
                    end
                otherwise
                    error('Conversion to higher dimensional tensor not implemented.'); %TOO LAZY
            end
        elseif ischar(I)
            out = joinchannels(I,in);
        else
            error('Wrong input.');
        end
    otherwise
        error('Too many input arguments.');
end
