%ROTATION3D   Rotate a 3D image
%
% There are 2 different methods avaiable to do the rotation
% by DIRECT mapping or by 9 SHEARS. Both have different advantages.
%
% SYNOPSIS:
%  image_out = rotation3d(image_in, method, RotationParameters, CenterOfRotation, interploation, bgval)
%
%  method
%      Computation method: 'direct', '9 shears'
%  RotationParameters:
%      DIRECT: 1x3 array containing the Euler angles [alpha beta gamma]
%              3x3 array containing the rotation matrix
%              4x4 array containing the transformation matrix
%                  in homogenous coordinates
%      9 SHEARS: 1x3 array containing the Euler angles [alpha beta gamma]
%  CenterOfRotation:
%      DIRECT: 1x3 array containing the rotation center
%              if CenterOfRotation==[] then CenterOfRotation=center of the image
%      9 SHEARS: no choice (center of the image)
%  interpolation
%      DIRECT: no choice (linear)
%      9 SHEARS: 'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh', 'nn',
%                'lanczos2', 'lanczos3', 'lanczos4', 'lanczos6', 'lanczos8'.
%                For binary images, use 'nn'.
%  bgval
%      DIRECT: no meaning
%      9 SHEARS: Value used to fill up the background. String containing
%      one of the following values: 'zero', 'min', 'max'.
%
% NOTES:
%  All angles are in radian.
%
%  Rotation in 3D by 3 Euler angles:
%     R = R_{3''}(\gamma) R_{2'}(\beta) R}_3(\alpha)
%  Note: There is another definition of the Euler angle. The second rotation
%  is then about the intermediate 1-axis. This convention is traditionally
%  used in the mechanics of the rigid body. The angles are called \psi, \theta,
%  \phi and their relation with the other angles is:
%     \phi=\gamma-\pi/2 mod 2\pi, \theta=\beta,
%     \psi=\alpha+\pi/2 mod 2\pi.
%
%  For interpolation methods that do not generate values outside the input
%  range ('linear', 'zoh' and 'nn'), the output data type is the same as
%  that of the input. For other interpolation methods, integer images are
%  cast to single-precision floating point before calling the underlying
%  library function DIP_ROTATION3D. If this behaviour is undesired, please
%  call that function directly.
%  The direct method always casts the image to a suitable floating-point type.
%
% LITERATURE:
%  D. Hearn and M.P. Baker, Computer Graphics, Prentice Hall
%  J. Foley and A. van Dam, Computer Graphics, Addison-Wesly
%  F. Scheck, Mechanics, Springer
%
% SEE ALSO: rotation, dip_image/rotate, resample.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2001
% 18-19 September 2007: Modified the "RotationParameters" input parameter, GETPARAMS
%                       now tests the sizes. "CenterOfRotation" now needs to be empty
%                       to use the default value. (CL)
% 17 October 2012:      Allow for complex data types to rotate. (BR)
% 7 March 2013:         Casting to float for most interpolation methods. (CL)

function out = rotation3d(varargin)

d = struct('menu','Manipulation',...
           'display','3D general rotation ',...
           'inparams',struct('name',       {'in',         'method','rotpara',                     'center',         'inter',               'bgval'},...
                             'description',{'Input image','Method','Euler Angles/Rotation Matrix','Rotation Center','Interpolation Method','Background Value'},...
                             'type',       {'image',      'option','array',                       'array',          'option',              'option'},...
                             'dim_check',  {0,            0,       {[1,3],[3,3],[4,4]},           {[],1},           0,                     0},...
                             'range_check',{[],           {'direct','9 shears'},...
                                                                   'R',                           'R+',             {'bspline','4-cubic','3-cubic','linear','zoh','nn','lanczos2','lanczos3','lanczos4','lanczos6','lanczos8'},...
                                                                                                                                           {'zero','min','max'}},...
                             'required',   {1,            1,       1,                             0,                0,                     0},...
                             'default',    {'a',          'direct',[0 0 0],                       [],               'lanczos3',            'zero'}...
                            ),...
           'outparams',struct('name',       {'out'},...
                              'description',{'Output image'},...
                              'type',       {'image'}...
                             )...
          );
if nargin == 1
    s = varargin{1};
    if ischar(s) & strcmp(s,'DIP_GetParamList')
        out = d;
        return
    end
end
if nargin >= 5 & isequal(varargin{5},'bilinear')
    varargin{5} = 'linear';
end
try
    [in,method, rotpara, center,inter, bgval ] = getparams(d,varargin{:});
catch
    if ~isempty(paramerror)
        error(paramerror)
    else
        error(firsterr)
    end
end

if ndims(in)~=3
    error('Input image not 3D.');
end
switch method
    case 'direct'
        %default for rotation center is round(size(in)/2)
        if isempty(center)
            center=round(size(in)/2);
        end
        if prod(size(rotpara))==3 %3 euler angles
            R=zeros(4,4);T=eye(4,4);
            R(4,4)=1;
            %Translate
            T(1,4)=-center(1);
            T(2,4)=-center(2);
            T(3,4)=-center(3);
            %Rotate, erster index zeile, zweiter spalte
            %Rotation Axes: 3, 2', 3''
            alpha=rotpara(1);
            beta=rotpara(2);
            gamma=rotpara(3);
            R(1,1)=cos(gamma)*cos(alpha)-cos(beta)*sin(alpha)*sin(gamma);
            R(2,1)=-sin(gamma)*cos(alpha)-cos(beta)*sin(alpha)*cos(gamma);
            R(3,1)=sin(beta)*sin(alpha);
            R(1,2)=cos(gamma)*sin(alpha)+cos(beta)*cos(alpha)*sin(gamma);
            R(2,2)=-sin(gamma)*sin(alpha)+cos(beta)*cos(alpha)*cos(gamma);
            R(3,2)=-sin(beta)*cos(alpha);
            R(1,3)=sin(beta)*sin(gamma);
            R(2,3)=sin(beta)*cos(gamma);
            R(3,3)=cos(beta);
            %combine step
            B=R*T;
            %Translate back
            T(1,4)=center(1);
            T(2,4)=center(2);
            T(3,4)=center(3);
            %combine step to overall Matrix and go
            R=T*B;
        elseif isequal(size(rotpara),[3,3]) %only rotation matrix
            R = rotpara;
            R(4,4)=1;
            T=eye(4,4);
            %Translate
            T(1,4)=-center(1);
            T(2,4)=-center(2);
            T(3,4)=-center(3);
            %combine step
            B=R*T;
            %Translate back
            T(1,4)=center(1);
            T(2,4)=center(2);
            T(3,4)=center(3);
            %combine step to overall Matrix and go
            R=T*B;
        elseif isequal(size(rotpara),[4,4]) %homogenous coordinates
            R = rotpara;
        else
            error('Rotation parameters invalid.');
        end
        %R
        %two low level routines for different data types too save memory
        if isempty(strfind(datatype(in),'complex'))
            if strcmp(datatype(in),'dfloat')
                out = mat2im(rot_euler_low(im2mat(in),R));
            else
                out = mat2im(rot_euler_low_sfloat(single(in),R));
            end
        else
            %fprintf('complex!!\n');
            if strcmp(datatype(in),'dcomplex')
                outR = mat2im(rot_euler_low(im2mat(real(in)),R));
                outI = mat2im(rot_euler_low(im2mat(imag(in)),R));
            else
                outR = mat2im(rot_euler_low_sfloat(single(real(in)),R));
                outI = mat2im(rot_euler_low_sfloat(single(imag(in)),R));
            end            
            out = complex(outR,outI);
        end
    case '9 shears'
        if ~any(strcmp(inter,{'linear','zoh','nn'}))
           for ii=1:prod(imarsize(in))
              if isinteger(in{ii}) | islogical(in{ii})
                 in{ii} = dip_image(in{ii},'sfloat');
              end
           end
        end
        l = zeros(imarsize(in));
        for ii=1:prod(imarsize(in))
           if islogical(in{ii})
              in{ii} = +in{ii};
              l(ii) = 1;
           end
        end
        out = dip_rotation3d(in,rotpara(1),rotpara(2),rotpara(3),inter,bgval);
        if any(l)
           for ii=1:prod(imarsize(in))
              if l(ii)
                 out{ii} = dip_image(out{ii},'bin');
              end
           end
        end
    otherwise
        error('Unkown rotation method.');
end
