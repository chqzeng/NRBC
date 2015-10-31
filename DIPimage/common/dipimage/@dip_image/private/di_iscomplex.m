%DI_ISCOMPLEX(A)
%    Returns true if A is flagged as one of the complex data types.
%    A is expected to be a scalar dip_image object.

% (C) Copyright 2011, Cris Luengo.
% Centre for Image Analysis, Uppsala, Sweden.

function t = di_iscomplex(a)
t = strcmp(a.dip_type(2:end),'complex');
