%COLORSPACE   Gets/sets/changes the color space.
%    IN = COLORSPACE(IN,COL), with IN a color image, changes the color
%    space of image IN to COL, converting the pixel values as
%    required. If COL is 'grey', a scalar image is returned with the
%    luminosity (Y).
%
%    IN = COLORSPACE(IN,COL), with IN a tensor image, sets the color
%    space of image IN to COL.
%
%    COL = COLORSPACE(IN) returns the name of the color space of the
%    image IN.
%
%    Converting to a color-space-less tensor image is done by
%    specifying the empty string as a color space. This action only
%    changes the color space information, and does not change any
%    pixel values. Thus, to change from one color space to another
%    without converting the pixel values themselves, change first to
%    a color-space-less tensor image, and then to the final color
%    space.
%
%    A color space is any string recognized by the system. It is
%    possible to specify any other string as color space, but no
%    conversion of pixel values can be made, since the system doesn't
%    know about that color space. Color space names are not case
%    sensitive. Recognized color spaces are:
%
%       art                       L*a*b* (or Lab, CIELAB)
%       CMY                       L*u*v* (or Luv, CIELUV)
%       CMYK                      R'G'B'
%       grey                      RGB
%       HCV                       XYZ
%       HSV                       Yxy
%       L*C*h* (or LCh)


% To add a color space:
%   - In the long list of calls to DEFINE and REGISTER, add a few
%     calls to these functions
%   - Optionally add aliases to COLOR_ALIAS.
% Say you want to add a color space 'MySpace', with 6 channels, and
% you have functions that convert from this color space to CMYK and
% back, called convert_to_myspace and convert_from_myspace. The calls
% to DEFINE and REGISTER would look like this:
%    define('MySpace',6);
%    register(@convert_to_myspace,'CMYK','MySpace');
%    register(@convert_from_myspace,'MySpace','CMYK');
% This function will then be able to convert from your color space
% to RGB, for example, by converting to CMYK, then to CMY, then to
% RGB. You don't need to do anything else to accomplish this.
% Note that colour space names are not case sensitive, meaning that
% 'myspace' is the same as 'MySpace'. Nevertheless, you should use
% the same case when calling DEFINE as that you use in the function
% @convert_to_myspace when you set the color space name in the image.


% (C) Copyright 2014, Cris Luengo
%     16 April 2014
%     Centre for Image Analysis, Uppsala, Sweden
% Based on original code by Cris Luengo, October 2000.
% (C) Copyright 1999-2011, Pattern Recognition Group,
%     Delft University of Technology, The Netherlands

% Revision log:
% 20 April 2001:     Known color spaces now always produce valid images
%                    (i.e. adding blank images or removing them).
% 27 June 2001:      Added color spaces: R'G'B' , L*u*v* .
%                    Added aliases: rgb==RGB, lab==LAB==Lab==L*a*b*, etc.
%                    Re-wrote function intelligence. We now don't need to
%                    go through XYZ if it isn't necessary.
% 27 August 2001:    Fixed stupid bug.
% 30 September 2001: Fixed another stupid bug.
% 8 March 2002:      Added 'gray' to the alias list.
% June 2002:         Added CMY and CMYK. (JD)
% 5 June 2002:       Added HCV and HSV. (JD)
% 12 June 2002:      Binary images are converted to 'uint8' before creating
%                    the color image.
% 15 November 2002:  Fixed binary images to work in MATLAB 6.5 (R13)
% 27 November 2003:  Fixed removing of colorspace information.
% 17 July 2007:      Added %#function pragma.
% 19 February 2008:  RGB2GREY was never used, the table said to do RGB2XYZ and
%                    then XYZ2GREY.
% 14 July 2008:      Added converion of grey-valued image to color.
% 1 August 2008:     When no conversion is necessary, we now check for correctness.
% 28 August 2008:    Added Piet's ART color space and L*C*H* color space.
% 16 April 2014:     Rewrote completely, no more big table. Logic!
% 17 April 2014:     More correct path search, more correct data structure.
% 29 April 2014:     Aliases are also registered. Some more refinement of code.

function out = colorspace(in,newcol_str)

persistent colspace;
   % colspace(i).name                    % color space name
   % colspace(i).nchannels               % number of channels
   % colspace(i).conversion(j)           % lists known color space convertion functions,
   %                                       converts from colspace[i] to colspace[j]
   % colspace(i).conversion(j).index     % destination color space, index j
   % colspace(i).conversion(j).function  % function handle
   % colspace(i).conversion(j).cost      % the cost for running the function (data loss and time costs)

persistent aliases;
   % aliases{i,2}                        % aliases{i,1} is an alias for aliases{i,2}

if isempty(colspace)
   % RGB
   define('grey',1);
   define_alias('gray','grey');
   define('RGB',3);
   register(@rgb2grey, 'RGB',      'grey');
   register(@grey2rgb, 'grey',     'RGB');
   %#function grey2rgb rgb2grey
   % XYZ and Yxy
   define('XYZ',3);
   define('Yxy',3);
   register(@rgb2xyz,  'RGB',      'XYZ');
   register(@xyz2rgb,  'XYZ',      'RGB');
   register(@xyz2yxy,  'XYZ',      'Yxy');
   register(@yxy2xyz,  'Yxy',      'XYZ');
   register(@xyz2grey, 'XYZ',      'grey');
   register(@yxy2grey, 'Yxy',      'grey');
   register(@grey2xyz, 'grey',     'XYZ');
   register(@grey2yxy, 'grey',     'Yxy');
   %#function rgb2xyz xyz2rgb xyz2yxy yxy2xyz xyz2grey yxy2grey grey2xyz grey2yxy
   % CMY and CMYK
   define('CMY',3);
   define('CMYK',4);
   register(@rgb2cmy,  'RGB',      'CMY');
   register(@cmy2rgb,  'CMY',      'RGB');
   register(@cmy2cmyk, 'CMY',      'CMYK');
   register(@cmyk2cmy, 'CMYK',     'CMY');
   %#function cmy2cmyk cmy2rgb cmyk2cmy rgb2cmy 
   % HSV and HCV
   define('HCV',3);
   define('HSV',3);
   register(@rgb2hcv,  'RGB',      'HCV');
   register(@hcv2rgb,  'HCV',      'RGB');
   register(@hsv2hcv,  'HSV',      'HCV');
   register(@hcv2hsv,  'HCV',      'HSV');
   %#function hcv2hsv hcv2rgb hsv2hcv rgb2hcv
   % L*a*b* and L*u*v*
   define('L*a*b*',3);
   define('L*u*v*',3);
   define('L*C*h*',3);
   define_alias('lab','L*a*b*');
   define_alias('cielab','L*a*b*');
   define_alias('luv','L*u*v*');
   define_alias('cieluv','L*u*v*');
   define_alias('lch','L*C*h*');
   register(@xyz2lab,  'XYZ',      'L*a*b*');
   register(@xyz2luv,  'XYZ',      'L*u*v*');
   register(@lab2xyz,  'L*a*b*',   'XYZ');
   register(@luv2xyz,  'L*u*v*',   'XYZ');
   register(@lab2lch,  'L*a*b*',   'L*C*h*');
   register(@lch2lab,  'L*C*h*',   'L*a*b*');
   register(@lab2grey, 'L*a*b*',   'grey');
   register(@lab2grey, 'L*u*v*',   'grey'); % lab2grey also works for L*u*v*
   register(@lab2grey, 'L*C*h*',   'grey'); % lab2grey also works for L*C*H*
   register(@grey2lab, 'grey',     'L*a*b*');
   register(@grey2luv, 'grey',     'L*u*v*');
   %#function lab2grey lab2xyz luv2xyz xyz2lab xyz2luv grey2lab grey2luv
   % R'G'B' (nonlinear RGB)
   define('R''G''B''',3);
   register(@rgb2rgbnl,'RGB',      'R''G''B''');
   register(@rgbnl2rgb,'R''G''B''','RGB');
   %#function  rgb2rgbnl  rgbnl2rgb
   % Piet's color space
   define('art',3);
   register(@lab2art,  'L*a*b*',   'art');
   register(@art2lab,  'art',      'L*a*b*');
   %#function art2lab lab2art lch2lab lab2lch
end

function define(space,nchannels)
   if ~isempty(colspace) && any(strcmpi(space,{colspace.name}))
      error('Color channel already known');
   end
   k = length(colspace)+1;
   colspace(k).name = space;
   colspace(k).nchannels = nchannels;
   colspace(k).conversion = [];
end

function define_alias(alias,space)
   if ~isempty(aliases) && any(strcmpi(space,aliases(:,1)))
      error('Color channel alias already known');
   end
   k = size(aliases,1)+1;
   aliases{k,1} = alias;
   aliases{k,2} = space;
end

function register(func_handle,fromspace,tospace,cost)
   if strcmpi(fromspace,tospace)
      error('Cannot convert to same color space');
   end
   if nargin<4
      cost = 0;
   end
   if cost<=0
      if strcmpi(tospace,'grey')
         cost = 1e9;
      else
         cost = 1;
      end
   end
   fromspace = find(strcmpi(fromspace,{colspace.name}));
   tospace = find(strcmpi(tospace,{colspace.name}));
   if isempty(fromspace) || isempty(tospace)
      error('Unknown color space');
   end
   if ~isempty(colspace(fromspace).conversion) && any([colspace(fromspace).conversion.index]==tospace)
      error('Trying to redefine a conversion function.');
   end
   k = length(colspace(fromspace).conversion)+1;
   colspace(fromspace).conversion(k).index = tospace;
   colspace(fromspace).conversion(k).function = func_handle;
   colspace(fromspace).conversion(k).cost = cost;
end

function space = find_color_alias(space)
   % Look up SPACE in the ALIASES table
   ii = find(strcmpi(space,aliases(:,1)));
   if ~isempty(ii)
      space = aliases{ii,2};
   end
   % Correct capitalization
   space = find_color(space);
end

function space = find_color(space)
   % Get the index for SPACE
   space = find(strcmpi(space,{colspace.name}));
   if isempty(space)
      space = 0;
   end
end

function p = findpath(fromspace,tospace)
   p = {};
   if fromspace == tospace
      return
   end
   cost = Inf(size(colspace));
   cost(fromspace) = 0;
   prev = zeros(size(colspace));
   stack = fromspace;
   while ~isempty(stack)
      [dummy,n] = min(cost(stack));    % find element on stack with minimum cost
      k = stack(n); stack(n) = []; % extract and remove that item
      next = [colspace(k).conversion.index];
      if ~isempty(next)
         c = cost(k)+[colspace(k).conversion.cost];
         I = cost(next)>c;
         if any(I)
            next(~I) = []; % remove entries that are not updated
            cost(next) = c(I);
            prev(next) = k;
            if any(next == tospace)
               break; % we don't wait until k==tospace, we are not going to find a cheaper path!
            end
            stack = unique([stack,next]); % add next to stack
         end
      end
   end
   if ~isfinite(cost(tospace))
      return;
   end
   k = tospace;
   p = {};
   while k~=fromspace
      n = k;
      k = prev(n);
      p = [{ colspace(k).conversion(find([colspace(k).conversion.index]==n)).function },p];
   end
end

if nargin < 1, error('Need an input argument.'); end
if nargin == 2
% Set/change color space
   if ~ischar(newcol_str), error('Color space name must be a string.'); end
      % (this assures IN is a dip_image)
   if ~istensor(in), error('Images in array are not of same size.'); end
   newcol = find_color_alias(newcol_str);
   if ~isempty(in(1).color)
      oldcol = find_color(in(1).color.space);
      if oldcol==0
         warning('Image has unknown color space. No conversion done.')
      end
   else
      if isscalar(in)
         oldcol = find_color('grey');
      else
         oldcol = 0;
      end
   end
   % Set or convert channels
   if newcol==0
      out = in;
      if isempty(newcol_str)
         [out.color] = deal([]);
      else
         out = di_setcolspace(out,out(1).color,newcol_str);
      end
   elseif oldcol==0 || oldcol==newcol
      % Make sure the image satisfies the requirements for the output type
      for ii=1:prod(imarsize(in))
         if strcmp(in(ii).dip_type,'bin')
            in(ii).dip_type = 'uint8';
         end
      end
      N = colspace(newcol).nchannels;
      if N == 0
         out = in;
      else
         out = dip_image('array',[N,1]);
         M = min(N,prod(imarsize(in)));
         out(1:M) = in(1:M);
         out(M+1:N) = dip_image('zeros',size(in(1)));
      end
      out = di_setcolspace(out,out(1).color,colspace(newcol).name);
   else
      % Convert colors from old to new color space following optimal path
      path = findpath(oldcol,newcol);
      out = in;
      if isempty(path)
         error('No conversion possible to requested destination color space.');
      else
         for ii=1:length(path)
            out = path{ii}(out);
         end
         % Note that the color conversion functions set the color space of the
         % output. We could remove this requirement, might add some efficiency
         % and some transparancy.
      end
   end
else
% Get color space
   if ~iscolor(in)
      out = '';
   else
      out = in(1).color.space;
   end
end

end % function
