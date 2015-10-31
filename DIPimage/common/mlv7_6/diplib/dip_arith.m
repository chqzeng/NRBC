%dip_arith   Arithmetic operations between two images.
%    out = dip_arith(in1, in2, op, dt)
%
%   in1
%      Image.
%   in2
%      Image.
%   op
%      Operation, one of the following strings: 'add', 'sub',
%      'mul', 'div', or 'mul_conjugate'.
%   dt
%      Output data type, one of the following strings: 'uint8',
%      'uint16', 'uint32', 'sint8', 'sint16', 'sint32', 'sfloat',
%      'dfloat', 'scomplex', 'dcomplex', 'bin', 'minimum', 'flex',
%      'flexbin', 'dipimage'.
%
%   'minimum' is the smallest data type that can hold the result of
%   the operation. 'flex' is either 'sfloat' or 'dfloat', or one of
%   the complex types, as needed. 'flexbin' also allows for binary
%   output if both inputs are binary. 'dipimage' is the same as
%   'flexbin' and yields the behaviour expected in DIPimage.
%
%   The 'dt' input argument is optional, the default value is 'dipimage'.

% (C) Copyright 2013, Cris Luengo.
% Centre for Image Analysis, Uppsala, Sweden.
