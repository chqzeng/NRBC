%dip_testobjectcreate   TestObject generation function.
%    out = dip_testobjectcreate(object, testObject, objectHeight, objectRadius,...
%          scale, scaleRadius, scaleAmplitude, objSigma, position)
%
%   object
%      Image.
%   testObject
%      Object shape. String containing one of the following values:
%      'ellipsoid', 'box', 'ellipsoidshell', 'boxshell', 'user_supplied'.
%   objectHeight
%      Real number.
%   objectRadius
%      Real number.
%   scale
%      Real array.
%   scaleRadius
%      Real number.
%   scaleAmplitude
%      Real number.
%   objSigma
%      Real number.
%   position
%      Boolean number (1 or 0).

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%Output: sfloat
%FUNCTION
%This function can generate an aliasing free object
%(ellips, box, ellipsoid shell, box shell) or uses an user-supplied object.
%The generated objects have their origin at the center in the image, but can
%be generated with a sub-pixel random shift around the center, to average out
%dicretization effects over several instances of the same generated object.
%Optinally the generated object can be convolved with an isotropic Gaussian
%with a width specified by objSigma. Elliptical objects are only supported
%for images with a dimsnionality equal or less than three. The position boolean
%variable specifies whether a subpixel random shift should be applied to
%the object. This can be used to average out digitisation error over a
%repetition of the generation of the same object.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image object     IMAGE *object     Output Object Image
%  dipf_TestObject testObject    int testObject    Type of Test Object
%  dip_float objectHeight     double objectHeight     Object Height
%  dip_float objectRadius     double objectRadius     Object Radius
%  dip_FloatArray scale    double sx, sy, sz    Relative Radii for each dimension
%  dip_float scaleRadius      double scaleRadius      ScaleRadius
%  dip_float scaleAmplitude      double scaleAmplitude      ScaleAmplitude
%  dip_float objSigma      double objSigma      Sigma of Gaussian Object Blur
%  dip_Boolean position    int position      Random Subpixel Position Shift
%  dip_Random *random            Pointer to a Random
%     structure
%
%SEE ALSO
% TestObjectModulate , TestObjectBlur , TestObjectAddNoise
