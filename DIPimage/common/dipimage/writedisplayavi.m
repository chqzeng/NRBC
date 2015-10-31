%WRITEDISPLAYAVI   Writes displayed 3D image into an AVI file
%  Writes a 3D image into an avi movie file
%
% SYNOPSIS:
%  writedisplayavi(fig, filename, fps, comp)
%
% PARAMETERS:
%  fig:      figure window
%  filename: string with name of file, optionally with path and extension.
%  fps:      frames per second to write
%  comp:     compression (only under windows)
%
% DEFAULTS:
%  fps = 15
%  comp = 'Cinepak' under Windows, 'None' elsewhere
%
% SEE ALSO:
%  writeavi
%
% NOTES:
%  - is slow
%  - compression is only available under Windows 
%
% SEE ALSO:
%  writeavi

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, May 2001.
% April 2005, up to date again for color etc.

function out = writedisplayavi(varargin)

if isunix
   compressionopts={'None'};
   compdef = compressionopts{1};
else
   compressionopts={ 'None', 'Indeo3', 'Indeo5', 'Cinepak', 'MSVC', 'RLE' };
   compdef = compressionopts{4};
end
d = struct('menu','File I/O',...
    'display','Write AVI',...
    'inparams',struct('name',       {'fig','filename','fps','compression'},...
        'description',{'Figure window','Filename','Frames per second','Compression method'},...
        'type',       {'handle','outfile','array','option'},...
        'dim_check',  {0,0,0,0},...
        'range_check',{'3D','*.*','R+',compressionopts},...
        'required',   {1,1,0,0},...
        'default',    {[],'',15,compdef}...
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
   [fig,filename,fps,compression] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

aviobj = avifile(filename,'fps',fps,'compression',compression);
wn = get(fig);
sz = wn.UserData.imsize;

if ~findstr(wn.Tag,'Color')
   try %this can go wrong depending on the compression and image content
      aviobj.Colormap = gray(256);
   catch
      close(aviobj);
      error(lasterr);
   end
end

figure(fig)
for ii =0:sz(3)-1   
   dipmapping(fig,'slice',ii);
   frame = getframe(gca);
   aviobj = addframe(aviobj, frame);
end
aviobj = close(aviobj);
