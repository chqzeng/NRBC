%dip_label   Label objects in binary image.
%    [out,n] = dip_label(in, connectivity, flags, minSize, maxSize, boundary )
%
%    in
%       Image
%    connectivity
%       Integer number
%         number <= dimensions of in
%         pixels to consider connected at distance sqrt(number)
%    flags
%       One of or more of '' (normal operation),
%                         'threshold_on_size' (throw away objects that
%                              are smaller than minSize or larger than
%                              maxSize.
%                         'label_is_size' (The labeled objects will
%                              be assigned their size, rather than a label
%                              between 1 and the number of objects.
%    minSize
%       See flags for function. Ignored if set to zero.
%    maxSize
%       See flags for function. Ignored if set to zero.
%    boundary
%       Array with boundary conditions. The only recognised boundary condition
%       'periodic'. Any setting other than periodic is interpreted to mean:
%       "stop propagating labels at the image border". Examples:
%       ''   Normal behaviour
%       0    Normal behaviour
%       'periodic'   Periodic boundary conditions in every dimension
%       {'periodic','symmetric'}   Periodic boundary condition in the
%                                  X-dimension.
%
%    n
%       Number of objects in image (optional output parameter).
