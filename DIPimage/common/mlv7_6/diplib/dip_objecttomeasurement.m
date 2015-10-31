%dip_objecttomeasurement   Convert object label value to measurement value.
%    out = dip_objecttomeasurement(object, intensity, connectivity, objectID, ...
%          measurementID, measurementDim)
%
%   object
%      Image.
%   intensity
%      Image.
%   connectivity
%      Integer number.
%         number <= dimensions of in
%         pixels to consider connected at distance sqrt(number)
%   objectID
%      Integer array. [] implies all objects.
%   measurementID
%      String representing name of measurement. The list can be obtained
%      by calling DIP_GETMEASUREFEATURES.
%   measurementDim
%      Integer number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-July 1999.

%   DATATYPES:
%objectIm: integer
%
%intensityIm: integer, float
%FUNCTION
%This function produces an output image which pixel intensities are equal to
%the measurement value that the measurementID measurement function measured
%on the object who label is defined by the pixel intensity of the corresponding
%pixel in object. This function is therefore useful to select (i.e. threshold)
%objects on basis of a measurement perfomed on the object. intensity provides
%pixel intensity information for measurements that require pixel intensity
%information of the objects, whose shape is defined by object.
%
%
%The list of object IDs on which the measurements have to be performed is specified by objectID. If it is zero, ObjectToMeasurement will call
%ObjectLabelsGet to obtain a list of all non-zero values in objectIm.
%
%
%If the measurementID measurement function produces an array of measurement
%values, measurementDim will be used to select the desired array element.
%
%
%The SCIL-Image interface does not provide the
%possibility to specify an array of object IDs, it sets objectID to zero.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image object     IMAGE *object     Object label image
%  dip_Image intensity     IMAGE *intensity     Object intensity image
%  dip_Image out     IMAGE *out     Output image
%  dip_int connectivity    int connectivity     Connectivity of object's contour pixels
%  dip_IntegerArray objectID           Array of Object IDs
%  dip_int measurementID      int measurementID    Measurement function ID
%  dip_int measurementDim     int measurementDim      Measurement results array index
%
%SEE ALSO
% Measure
