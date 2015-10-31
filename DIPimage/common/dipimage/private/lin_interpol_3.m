function [out1, out2, out3] = lin_interpol_3(in1, in2, in3, matrix_in)

if( nargin < 1)
  p = [5.5, 7.8, 3.4]./10;
  in1 = p(1);
  in2 = p(2);
  in3 = p(3);
end
if( nargin < 4)
   x = [0:0.1:1]';
   for i=1:11
      y((i-1)*11+1:i*11, 3) = x;   
      y((i-1)*11+1:i*11, 2) = x(i);
   end
   for i=1:11
      y((i-1)*11.^2+1:i*11.^2, 2:3) = y(1:11.^2, 2:3);   
      y((i-1)*11.^2+1:i*11.^2, 1) = x(i);
   end
   vals = y(:, 1) + 2.*y(:, 2) + y(:, 3);
   vals(:, 2) = 2.*y(:, 1) + y(:, 3).^2;
   vals(:, 3) = 3.*y(:, 1)-y(:, 3)./2;
else
   y = matrix_in(:, 1:3);
   vals = matrix_in(:, 4:6);
end

size_in = size(in1);
in1 = in1(:);
in2 = in2(:);
in3 = in3(:);

out1 = zeros( size_in(1), size_in(2));
out2 = zeros( size_in(1), size_in(2));
out3 = zeros( size_in(1), size_in(2));

num_steps = size(vals, 1).^(1./3);

size_out = size(out1);

m3 = min(y(:, 3));
m2 = min(y(:, 2));
m1 = min(y(:, 1));

step3 = (max(y(:, 3))-min(y(:, 3)))./(num_steps-1);
step2 = (max(y(:, 2))-min(y(:, 2)))./(num_steps-1);
step1 = (max(y(:, 1))-min(y(:, 1)))./(num_steps-1);
off3 = floor((in3-m3)./step3);
off2 = floor((in2-m2)./step2).*num_steps;
off1 = floor((in1-m1)./step1).*num_steps.^2;
offset(:, 1) = off1 + off2 + off3 + 1;
offset(:, 2) = off1 + off2 + off3 + 2;
offset(:, 3:4) = offset(:, 1:2) + num_steps;
offset(:, 5:8) = offset(:, 1:4) + num_steps.^2;

dx = in1-step1.*floor((in1-m1)./step1);
dy = in2-step2.*floor((in2-m2)./step2);
dz = in3-step3.*floor((in3-m3)./step3);

offset = ceil(offset);
io = find( offset(:, 2) > size(vals, 1));
offset(io, 2) = offset(io, 2) -1;
io = find( offset(:, 3) > size(vals, 1));
offset(io, 3:4) = offset(io, 1:2);
io = find( offset(:, 5) > size(vals, 1));
offset(io, 5:8) = offset(io, 1:4);

p000 = vals(offset(:, 1), 1);
p001 = vals(offset(:, 2), 1);
p010 = vals(offset(:, 3), 1);
p011 = vals(offset(:, 4), 1);
p100 = vals(offset(:, 5), 1);
p101 = vals(offset(:, 6), 1);
p110 = vals(offset(:, 7), 1);
p111 = vals(offset(:, 8), 1);

c0 = p000;
c1 = (p100-p000)./step1;
c2 = (p010-p000)./step2;
c3 = (p001-p000)./step3;
c4 = (p110 - p010 - p100 + p000)./(step1.*step2);
c5 = (p101 - p001 - p100 + p000)./(step1.*step3);
c6 = (p011 - p010 - p001 + p000)./(step2.*step3);
c7 = (p111 - p011 - p101 -p110 + p100 + p001 + p010 - p000)./ ...
   step1.*step2.*step3;

out1 = p000 + c1.*dx + c2.*dy + c3.*dz + c4.*dx.*dy + c5.*dx.*dz + c6.*dy.*dz + ...
   c7.*dx.*dy.*dz;

p000 = vals(offset(:, 1), 2);
p001 = vals(offset(:, 2), 2);
p010 = vals(offset(:, 3), 2);
p011 = vals(offset(:, 4), 2);
p100 = vals(offset(:, 5), 2);
p101 = vals(offset(:, 6), 2);
p110 = vals(offset(:, 7), 2);
p111 = vals(offset(:, 8), 2);

c0 = p000;
c1 = (p100-p000)./step1;
c2 = (p010-p000)./step2;
c3 = (p001-p000)./step3;
c4 = (p110 - p010 - p100 + p000)./(step1.*step2);
c5 = (p101 - p001 - p100 + p000)./(step1.*step3);
c6 = (p011 - p010 - p001 + p000)./(step2.*step3);
c7 = (p111 - p011 - p101 -p110 + p100 + p001 + p010 - p000)./ ...
   step1.*step2.*step3;

out2 = p000 + c1.*dx + c2.*dy + c3.*dz + c4.*dx.*dy + c5.*dx.*dz + c6.*dy.*dz + ...
   c7.*dx.*dy.*dz;

p000 = vals(offset(:, 1), 3);
p001 = vals(offset(:, 2), 3);
p010 = vals(offset(:, 3), 3);
p011 = vals(offset(:, 4), 3);
p100 = vals(offset(:, 5), 3);
p101 = vals(offset(:, 6), 3);
p110 = vals(offset(:, 7), 3);
p111 = vals(offset(:, 8), 3);

c0 = p000;
c1 = (p100-p000)./step1;
c2 = (p010-p000)./step2;
c3 = (p001-p000)./step3;
c4 = (p110 - p010 - p100 + p000)./(step1.*step2);
c5 = (p101 - p001 - p100 + p000)./(step1.*step3);
c6 = (p011 - p010 - p001 + p000)./(step2.*step3);
c7 = (p111 - p011 - p101 -p110 + p100 + p001 + p010 - p000)./ ...
   step1.*step2.*step3;

out3 = p000 + c1.*dx + c2.*dy + c3.*dz + c4.*dx.*dy + c5.*dx.*dz + c6.*dy.*dz + ...
   c7.*dx.*dy.*dz;

out1 = reshape( out1, size_in(1), size_in(2));
out2 = reshape( out2, size_in(1), size_in(2));
out3 = reshape( out3, size_in(1), size_in(2));
