%DIPSHOW   Shows a dip_image object as an image
%   DIPSHOW(B) displays the image in B. To which figure window and in what
%   mode depends on the current default settings, which can be specified
%   through DIPSETPREF and DIPFIG. DIPSHOW works for 1, 2 and 3 dimensional
%   grey-value images, as well as 2D color images.
%
%   DIPSHOW(B,[MIN MAX]) displays the image in B as a grey-value image in
%   the range [MIN MAX]. MIN is shown black, MAX is shown white. For color
%   images, each channel is stretched in the same way.
%
%   DIPSHOW(B,RANGESTR), with RANGESTR a string, provides shortcuts for the
%   range selection. The following list shows the posibilities:
%      'unit'              [0 1]
%      'normal' or '8bit'  [0 255]
%      '12bit'             [0 4095]
%      '16bit'             [0 65535]
%      's8bit'             [-128 127]
%      's12bit'            [-2048 2047]
%      's16bit'            [-32768 32767]
%      'lin' or 'all'      [MIN(B) MAX(B)]
%      'percentile'        [PERCENTILE(B,5) PERCENTILE(B,95)]
%      'base'              [MIN([MIN(B),-MAX(B)]) MAX([-MIN(B),MAX(B)])]
%      'angle'             [-PI PI]
%      'orientation'       [-PI/2 PI/2]
%   These modes additionally set the colormap to 'grey', except for the
%   'angle' and 'orientation' modes, which set the colormap to 'periodic',
%   and the 'base' mode, which sets the colormap to 'zerobased' (see below).
%
%   DIPSHOW(B,'log') displays the image in B using logarithmic stretching.
%   The colormap is set to 'grey'.
%
%   DIPSHOW(...,COLMAP) set the colormap to a custom colormap COLMAP. See the
%   function COLORMAP for more information on colormaps. Additionally, these
%   strings choose one of the default color maps:
%      'grey'         grey-value colormap
%      'periodic'     periodic colormap for angle display
%      'saturation'   grey-value colormap with saturated pixels in red and
%                     underexposed pixels in blue.
%      'zerobased'    The 50% value is shown in grey, with lower values
%                     increasingly saturated and lighter blue, and higher
%                     values increasingly saturated and lighter yellow.
%   When combining a COLMAP and a RANGESTR parameter, the COLMAP overrules
%   the default color map belonging to RANGESTR.
%
%   DIPSHOW(B,'labels') displays the image in B as a labeled image. This
%   mode cannot be combined with a RANGESTR or a COLMAP parameter.
%
%   DIPSHOW(...,TSMODE) can be used to overrule the default 'TrueSize'
%   setting. If TSMODE is 'truesize', TRUESIZE will be called after
%   displaying the image. IF TSMODE is 'notruesize', TRUESIZE will not be
%   called.
%
%   DIPSHOW(H,B,...) displays the image in B to the figure window with
%   handle H, overruling any settings made for variable B. H must be a valid
%   figure handle, or an integer value that will be used to create a new
%   window. If H is 0, a new window will be created.
%
%   H = DIPSHOW(...) returns the handle to the figure window used.
%
%   For more info on the figure windows created, see the DIPimage User Guide.
%
%   See also DIPSETPREF, DIPFIG, DIPTRUESIZE, DIPMAPPING, DIPZOOM, DIPTEST,
%   DIPORIEN, DIPLINK, DIPSTEP.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July-August 2000.
% 2 September 2000:  Enhanced "TrueSize" menu option.
%                    TRUESIZE is now DIPTRUESIZE, a stand-alone function.
% 19 September 2000: Some cosmetic changes.
% 9 October 2000:    Added support for ISCOLOR and color spaces.
% 26 October 2000:   Added TRUESIZE parameter to overrule default.
% 3 November 2000:   Rewrote some internal functions to increase flexibility.
%                    Angle display now in color.
%                    Added percentile stretching.
% 9 November 2000:   Improved title bar display.
%                    We now display the zoom factor in the titlebar.
% 23 November 2000:  Improved colormap used by ANGLE display.
% 30 March 2001
%   through 1 Apr:   For color images:
%                       Removed: DIPSHOW(A,'color')
%                       Added 'range' parameter usage for color images.
%                       The color space information is now retained.
%                       DIPTEST now can access the original color space data.
%                    Added slicing modes: XY, XZ, YZ.
%                    Added complex to real mappings.
%                    Changed menu structure.
%                    Improved handling of parameters and settings throughout.
%                    Compacted code.
% 5 April 2001:      Changed undocumented behaviour for integration with DIPFIG.
% 8 June 2001:       Changed 'angle' into 'orientation'. 'angle' is now full 2pi.
% 21 June 2001:      Improved 1D image display.
% 26 June 2001:      Added zoom factors to the 'Display' menu.
% 19 July 2001:      Added Link Display for 3D grey-value images to Actions menu (Bernd)
% 15 August 2001:    1D image now is displayed from 0 to size-1.
% 16 August 2001:
%   through 26 Aug:  Changed whole organization of DIPSHOW again.
%                    Added 1D/3D color display. Changed most of UserData specs.
%                    DIPZOOM callbacks are in here now. Spawned new function DIPSTEP.
%                    Added undocumented behaviour for use by DIPMAPPING.
%                    Added keyboard callback for zooming and panning.
%                    Keyboard callbacks are optional now, and are disabled with Esc.
% 28 August 2001:    Just a tiny bit tidier yet. Fixed 2 small bugs. Added arrow keys to
%                    callback.
% 29 August 2001:    1D images look a lot cooler now. It takes more memory, though. Not
%                    so good for large 1D images!
% 14 September 2001: Fixed small bug.
% 15 September 2001: Preventing callbacks from adding or changing variables in the base
%                    workspace (where they appear to be executed!).
% 19 September 2001: Allowing variable name as figure window handle argument.
% 22 September 2001: Small bug fixes. Changed specs of 1D image display.
%                    New global stretch mode for 3D. Storing computed ranges for image.
%                    Added 'ch_global' and 'ch_slice' methods.
%                    Avoiding creating a colormap every time we change the range or the
%                    slice. Now the user can use the COLORMAP function more confortably.
%                    New Mappings menu item: 'Manual...'.
% 30 September 2001: Small bug fix. Reading new default values for mapping modes.
%                    Global stretching now possible for RGB images; not for other color
%                    images. Renamed ch_xxx strings.
% 1 October 2001:    Renamed some of the UserData elements: mappingmode, complexmapping,
%                    currange. Storing computed ranges for image, also for different
%                    complexmapping modes.
% 14 December 2001:  Trying out a different LOG-stretch. Doesn't work as needed yet.
% 17 December 2001:  Fixed a small bug I introduced last week...
% 18 December 2001:  Added virtual sliders to DIPSTEP.
%                    DIPMAPPING('SLICE',N) now also updates linked displays.
% 14 March 2002:     Added DIPPAN. ResizeFcn now changes the axes position and limits
%                    (code taken over from DIPTRUESIZE).
% 21 March 2002:     Fixed another bug in LOG stretch.
% 22 March 2002:     Made the 'TrueSize' setting work a bit better.
% 23 May 2002:       Improved zooming.
% 27 June 2002:      DIPLINK only invokes DIPTRUESIZE if the slicing direction changes.
% 25 November 2003:  Added colormap commands.
% 28 November 2003:  Added global stretch warning for non-RGB 3D images.
% 3 March 2004:      Changing the slicing string also updates linked windows.
% 14 April 2004:     Added looking glass in Action menu (BR)
% 26 May 2004:       Added 'saturation' color map. (CL)
% 16 July 2004:      Added sum/max projection for 3D displays (BR)
% 5 November 2004:   Added keyboard shortcuts to the more common menu items.
% 7 February 2005:   Added mapping modes for unsigned, 12- and 16-bit data.
%                    Added some more keyboard shortcuts. Enhanced DIPSTEP functions.
%                    Enabled global stretch for 4D images. (CL)
% 10 February 2005:  Small bug fix for 4D images (BR)
% 20 February 2005:  Added color images for sum/max projection (BR)
% 9 August 2005:     Moved bunch of repeated code into MAPCOMPLEXDATA. (CL)
% 30 September 2005: Check for javachk which checks for java crap (MvG)
% 19 January 2006:   Zero values allowed in 1D log stretch. (CL)
% 7 February 2007:   Added Gamma correction for colour and grey images by preference (BR)
% 21 August 2007:    Fixed bug for global stretching on 4D images (CL)
% 10 October 2007:   Fixed bug for global stretching on color images (CL)
% 9 April 2008:      Added 'zerobased' colormap. (CL)
% 14 October 2008:   Fixed bug where new windows were not positioned properly. (CL)
% 14 November 2008:  Removed invalid option 'isosurface plot' for 3D colorimages (BR)
% 2 December 2008:   'labels' mode is a color map AND a range parameter. (CL)
% 10 March 2009:     Small change in the callback for DIPTEST: 3px moved = 1 slice. (CL)
% 26 March 2009:     Using new 'CurrentImageSaveDir' property. (CL)
% 31 March 2009:     Improved 'zerobased' colormap. (CL)
% 6 April 2009:      Finally fixed up the logarithmic display. (CL)
% 8 May 2009:        Not annoyingly reverting to 'grey' color map all the time.
%                    There's now a check mark by the "Manual..." menu option. (CL)
% 19 May 2009:       Double-clicking with DIPZOOM on now sets zoom to 100%. (CL)
% 24 July 2009:      Figure window now saved as TIFF, PNG, JPEG or EPS. (CL)
% 18 May 2011:       Now callilng DIPTRUESIZE with the 'INITIAL' mode. Changing the
%                    slicing direction doesn't change the truesize setting. (CL)
% 14 July 2011:      Using new 'BinaryDisplayColor' preference for binary image color. (CL)
% 2 September 2011:  Added 'unit' stretch mode. (CL)
% 17 October 2011:   Extended linking of displays to 2D and also the zoom/pan (not via
%                    DIPPAN). (BR)
% 19 October 2011:   Added mapping mode 'updatelinked' to be able to call this function
%                    from outside (BR)
% 17 November 2011:  Added 0D image display, only if dipshow is called explicitly. (BR)
% 16 May 2012:       Fixed bug in DIPZOOM for 1D displays. Made axis same color as
%                    background. (CL)
% 12 June 2014:      dipshow(N,img) didn't respect N if N didn't exist. (CL)
% 11 August 2014:    Fixes for new graphics in MATLAB 8.4 (R2014b).
% 19 September 2014: PNG is now the default file format for the "Save As..." menu option.

%Undocumented:
%   DIPSHOW(...,'name',NAME) causes the figure window's title to be set
%   to NAME instead of INPUTNAME(IN). This is used by DIP_IMAGE/DISPLAY.
%
%   DIPSHOW(...,'position',POS) causes the figure's 'Position' property
%   to be set to POS. POS must be a 1x4 array with [X Y H W] or a 1x2 array
%   with [W H]. In the last case, the X and Y position is not changed.
%   This disables the truesize setting.
%
%   If IN is [], the image is made black, and the zoom factor is not shown.
%   This is used by DIPFIG, together with the 'position' option, to create
%   a figure window.
%
%   DIPSHOW(H,'ch_mappingmode',RANGE), DIPSHOW(H,'ch_mappingmode',MAPPINGMODE),
%   DIPSHOW(H,'ch_colormap', COLORMAP), DIPSHOW(H,'ch_globalstretch',BOOLEAN),
%   DIPSHOW(H,'ch_complexmapping',COMPLEXMAP), DIPSHOW(H,'ch_slicing',SLICING),
%   DIPSHOW(H,'ch_slice',SLICE), DIPSHOW(H,'ch_time',SLICE).
%   RANGE or MAPPINGMODE are as defined above for regular DIPSHOW syntax.
%   COLORMAP is 'grey', 'periodic', 'saturation', 'labels' or a colormap.
%   BOOLEAN is 'yes', 'no', 'on', 'off', 1 or 0.
%   COMPLEXMAP is one of: 'abs', 'real', 'imag', 'phase'.
%   SLICING is one of: 'xy', 'xz', 'yz', 'xt', 'yt', 'zt'.
%   SLICE is a slice number.
%   H is a handle to a figure window, and is optional. (although sometimes...)
%   These cause the image to be re-displayed using the requested mode, and
%   are used as callback for the 'Mappings' menu items. They can be joined
%   in a single command:
%      DIPSHOW('ch_mappingmode','lin','ch_complexmapping','abs').

% ORGANIZATION
%
% The figure window created contains:
% - A Tag, composed of the string 'DIP_Image' and one of each of these:
%       - '_1D', '_2D' or '_3D'.
%       - '_Binary', '_Grey', '_Color'.
% - A group of Uimenu objects, defined in CREATE_MENUS.
% - An Axes object with:
%   - An Image object.
% - A UserData object with:
%   - For all images:
%      - udata.mappingmode    -> String representing mapping mode: 'normal', 'lin', 'log', etc.
%                                Equal to '' means that udata.currange is to be used as-is.
%      - udata.currange       -> 2 values with the current display range.
%      - udata.complexmapping -> String representing complex to real mapping: 'abs', 'real',
%                                'imag', 'phase'.
%      - udata.computed       -> The values computed for the different mapping modes, if they
%                                have been computed (it might not exist!). It is a structure
%                                with a field for each of the mappingmode strings. Only the
%                                elements that have been computed exist.
%      - udata.computed_XXX   -> For complex images, these contain a copy of udata.computed
%                                computed for each of the complexmapping strings (XXX). Only
%                                those that have been used exists.
%      - udata.slicing        -> String representing 3D to 2D mapping: '' (for 1D/2D images),
%                                'xy', 'xz', 'yz', 'xt', 'yt', 'zt'.
%      - udata.colmap         -> String representing the colormap: 'grey', 'periodic', 'saturation',
%                                'zerobased', 'labels', 'custom'.
%      - udata.imagedata      -> Original dip_image object (or slice out of the 3D volume),
%                                converted to RGB colorspace in case of color image.
%                                A color image has the color along the 3rd. dimension.
%      - udata.imsize         -> image size: [x,y,z] for 3D, [x,y] for 2D, [x] for 1D.
%                                The x and y components are the slice dimensions, thus this
%                                array is re-arranged when changing the udata.slicing.
%      - udata.colspace       -> Name of color space: '' (for grey), 'RGB', 'Lab', 'XYZ', etc.
%      - udata.zoom           -> Pixel size or [] if aspect ratio is not 1:1. If 0, don't show zoom!
%      - udata.state          -> Action state: 'none', 'dipstep', 'diptest', 'dipzoom', etc.
%      - udata.imname         -> Name to be displayed in title bar.
%   - For 3D images:
%      - udata.maxslice       -> Highest slice available (udata.imsize(3)-1).
%      - udata.curslice       -> Slice currently displayed.
%      - udata.slices         -> Originial dip_image object, in case of color image it's
%                                in the original color space.
%      - udata.linkdisplay    -> If linked, list of figure handles, else [].
%      - udata.globalstretch  -> 0 or 1, indicating if stretching is computed on one slice or
%                                the whole thing.
%      - udata.globalcomputed -> Copy of udata.computed computed on global stuff. Or, with complex
%                                images, copies of udata.computed_XXX.
%   - For 4D images the same stuff as in 3D, but also:
%      - udata.maxtime        -> Highest slice available (udata.imsize(4)-1).
%      - udata.curtime        -> Slice currently displayed.
%   - For color images
%      - udata.colordata      -> dip_image object in original colorspace. In case of
%                                3D image, it is a slice out of udata.slices.
%      - udata.channels       -> Number of channels (== length(udata.colordata)).
%   - In function KeyPressFcn:
%      - udata.nextslice      -> String being typed by user containing a number.
%      - udata.lastkeypress   -> String containing last keypress
%   - If DIPSTEP has been enabled:
%      - udata.prevclick      -> Previous direction (1,0,-1). When double clicking, first
%                                a single click is detected, then the double click. However,
%                                we don't know with which button was double-clicked. Using
%                                this variable, the second click repeats the first one.
%   - If DIPORIEN has been enabled:
%      - udata.orientationim  -> dip_image object with orientation image.

% COMMON PHRASES
%
% Tests using the UserData property:
%  Dimensionality :       length(udata.imsize)
%  Is color:              ~isempty(udata.colspace)
%  Is binary:             islogical(udata.imagedata)
% Tests using the Tag property:
%  Is created by DIPSHOW: strncmp(tag,'DIP_Image',9)
%  Is grey:               length(tag)==17 & tag(14:17)=='Grey')
%  Is color:              length(tag)==18 & tag(14:18)=='Color')
%  Is binary:             length(tag)==19 & tag(14:19)=='Binary')
%  Dimensionality:        str2num(tag(11))                        ONLY if created by dipshow.
%  Is a 3D image:         strncmp(tag,'DIP_Image_3D',12)
%  etc.

