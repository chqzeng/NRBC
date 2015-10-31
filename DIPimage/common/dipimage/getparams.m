%GETPARAMS   Automated parameter parsing for DIPimage functions
%   VARARGOUT = GETPARAMS(DEFS,VARARGIN)
%    Retrieves the parameters in VARARGIN according to the expected
%    values in DEFS. Puts a variable PARAMERROR into the caller's
%    workspace, which will contain a diagnostic string in case this
%    function willingly generates an error.
%
%    If varargin contains the string '?', an interactive parameter entry
%    is started. This feature is DEPRECATED, and will be removed in a
%    future version.
%
%   MSG = GETPARAMS('test',DEFS)
%    Tests the DEFS structure for correctness. Returns a string in MSG
%    if there is an error, otherwise MSG is empty.
%
% --DEFINITION OF THE DEFS STRUCTURE -----------------------------------------
%
% DEFS is a struct array. It contains the following fields:
%   menu           String with name of menu to place function in
%   display        String with display name of function in menu
%   inparams       Structure array with input parameters
%   outparams      Structure array with output parameters
%   output_select  Boolean value, adds an input argument that selects
%                  which of the output arguments to generate.
%
% defs.inparams contains the following fields for each parameter:
%   name           String containing the variable's name
%   description    String containing a description to show the user
%   type           String containing the data type
%   dim_check      Points to the argument that determines the dimensionality
%   range_check    Array with range limits
%   required       Boolean value
%   default        Default value used if none specified
%
% defs.outparams contains the following fields for each parameter:
%   name           String containing the variable's name
%   description    String containing a description to show the user
%   type           String containing the data type
%   suppress       (optional) Boolean value
%
% NAME:        Not used for now.
%
% DESCRIPTION: This is a clue for the user as to what to enter.
%
% TYPE:        One of: 'image','dataset','measurement','array','anytypearray','measureid',
%              'option','optionarray','infile','outfile','indir','handle','string',
%              'boolean','cellarray'. The difference between 'infile' and 'outfile' is
%              in the dialog box displayed (UIGETFILE or UIPUTFILE). 'indir' displayes
%              a dialog box to select a directory (UIGETDIR).
%
% DIM_CHECK:   - If TYPE is 'array', this specifies the dimensions of the array in
%              one of two ways: 1) it points to an image parameter whose dimensionality
%              dictates the length of this vector, or 2) it directly gives the expected
%              SIZE, with -1 values for the dimensions where there is no size
%              requirements. Furthermore, if DIM_CHECK is 0, a scalar is expected, if it
%              is -1, any length vector is allowed, including the empty array, and if it
%              is [], an empty array is expected. If various options are possible, put
%              them into a cell array: {[],[1,3],[3,3]}. The options are checked in turn,
%              the first fit is used. If no fit is found, the error for the last option
%              is returned.
%              - If TYPE is 'image', DIM_CHECK defines a range for the image dimensionality:
%              [MIN,MAX]. [] and 0 map to [0,Inf], and N maps to [N,N]. For example, to allow
%              only 2D images, specify either 2 or [2,2].
%              - If TYPE is 'measureid', it points to the measurement parameter from which
%              a measurement ID should be selected.
%              - If TYPE is 'optionarray', a value of 0 indicates an empty cell array is
%              allowed; a value of 1 indicates at least 1 option is expected.
%              - For other TYPEs, this value is meaningless.
%
% RANGE_CHECK: - If TYPE is 'array', [min,max] is the range for the parameter. An empty
%              array indicates "anything goes". Shortcut strings:
%                Integer types: 'N+' = [1 Inf]. 'N-' = [-Inf -1]. 'N' = [0 Inf], 'Z' = [].
%                Real types: 'R' = []. 'R+' = [0 Inf]. 'R-' = [-Inf 0].
%              - If TYPE is 'image', RANGE_CHECK is a string or a cell array with
%              strings that defines the allowed data types and whether the image is
%              expected to be scalar, color, etc. Valid is any combination of dip_image
%              data types plus these aliases: 'float', 'signed', 'sint', 'unsigned',
%              'uint', 'integer','int', 'real', 'noncomplex', 'complex', 'any'.
%              The parameter can specify at most one of these: 'scalar', 'tensor',
%              'vector', 'color' or 'array'. If none is specified, 'tensor' is assumed.
%              If this value is set to [], {'all','tensor'} is assumed.
%              - If TYPE is 'option' or 'optionarray', RANGE_CHECK is a cell array
%              with possible options: {0,1},{'rectangular','elliptic','parabolic'},
%              etc. OR it is a struct with possible options together with
%              a definition: s(1).name = 'name' ; s(1).description = 'description'.
%              - If TYPE is 'infile' or 'outfile', RANGE_CHECK is a string
%              containing the mask for the filename.
%              - If TYPE is 'handle', RANGE_CHECK is a cell array with strings that
%              specify the type of figure window required. See PRIVATE/HANDLELIST for
%              information on the format.
%
% REQUIRED:    If this value is non-zero (TRUE), then the parameter cannot be
%              missing from varargin. DEFAULT is then meaningless. 'option',
%              'optionarray' and 'measureid' should *always* have zero here.
%
% DEFAULT:     This is the value of the default taken. If TYPE is 'image',
%              'dataset' or 'measurement', it is the name of a variable in the
%              base workspace.
%              - If TYPE is 'measureid', the default is the first measurement id
%              in the dip_measurement variable; this value is not used.
%              - If TYPE is 'option', it is one of the options in the array.
%              - If TYPE is 'optionarray', it is either one of the options in the
%              array, or a cell array with some of the options in the array, or
%              an empty cell array.
%              - If TYPE is 'handle', GCF is the default; this value is not used.
%              - If TYPE is 'boolean', can be either 'yes', 'no', 1 or 0.
%
% SUPPRESS:    Set to 1 to avoid displaying the output when the command is executed
%              from the GUI. Most functions do not have this value in their DEFS
%              struct. It defaults to 0.
%
% ----------------------------------------------------------------------------
%
% For more information, read the DIPimage user guide.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April-June 2000.
% 9 August 2000:     Added support for DATASET in the toolbox.
% 2 September 2000:  Corrected bug that didn't allow default vector 'array'.
% 19 September 2000: Added support for MEASUREMENT in the toolbox.
% 5 May 2001:        Added the 'handle' data type.
% 8 August 2001:     'array' with DIM_CHECK == 0 wasn't checked in the second syntax.
% 15 August 2001:    Added the 'string' and 'boolean' data types.
% 26 August 2001:    'handle' parsing now done by GETFIGH.
% 30 September 2001: Added RANGE_CHECK for 'handle'.
% 18 December 2001:  Integer ARRAY can be Inf.
% 6 March 2002:      'option' and 'optionarray' now support a description list as well.
% 15 November 2002:  New style GETPARAMS. Not much of the actual code has changed.
%                    Merged TESTDEFS and TESTPARAM into this file. Minimized the
%                    number of dependent private functions. Changed the DEFS struct
%                    in TESTDEFS to avoid more parsing during other tasks.
% 12 September 2003: 'optionarray' now uses 'dim_check' to allow for empty cell arrays.
% 20 July 2004:      Added TYPE == 'measureid'.
% 12 Oct 2004:       Added TYPE == 'indir' (BR)
% 11 July 2005:      Added TYPE == 'cellarray' (BR & CL)
% 31 August 2007:    Removed the GETPARAMS('test',DEFS.INPARAMS(I),VALUE) syntax.
% 16 September 2007: Deprecated the '?' input argument to all DIPimage functions.
%                    Split out code from this function into PARAMTYPE and sub-functions.
% 18 September 2007: Removed the GETPARAMS('test') syntax with two output arguments.
% 24 July 2009:      Added optional DEFS.OUTPARAMS.SUPPRESS value.
% 30 July 2009:      Changed help to reflect changes in PARAMTYPE_IMAGE.

