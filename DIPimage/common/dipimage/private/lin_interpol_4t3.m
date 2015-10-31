function [out1, out2, out3] = lin_interpol_4t3(in1, in2, in3, in4, matrix_in)

if( nargin < 1)
  p = [1.5, 9.7, 3.4, 4.15]./10;
  p(:, 1) + 2.*p(:, 2) + p(:, 3) - p(:, 4);
  2.*p(:, 1) + p(:, 3) + p(:, 4).^2;
  3.*p(:, 1)-p(:, 3)./2;
  in1 = p(1);
  in2 = p(2);
  in3 = p(3);
  in4 = p(4);
end
if( nargin < 4)
   x = [0:0.1:1]';
   for i=1:11
      y((i-1)*11+1:i*11, 4) = x;   
      y((i-1)*11+1:i*11, 3) = x(i);
   end
   for i=1:11
      y((i-1)*11.^2+1:i*11.^2, 3:4) = y(1:11.^2, 3:4);   
      y((i-1)*11.^2+1:i*11.^2, 2) = x(i);
   end
   for i=1:11
      y((i-1)*11.^3+1:i*11.^3, 2:4) = y(1:11.^3, 2:4);   
      y((i-1)*11.^3+1:i*11.^3, 1) = x(i);
   end
   vals = y(:, 1) + 2.*y(:, 2) + y(:, 3) - y(:, 4);
   vals(:, 2) = 2.*y(:, 1) + y(:, 3) + y(:, 4).^2;
   vals(:, 3) = 3.*y(:, 1)-y(:, 3)./2;
else
   y = matrix_in(:, 1:4);
   vals = matrix_in(:, 5:7);
end

size_in = size(in1);
in1 = in1(:);
in2 = in2(:);
in3 = in3(:);
in4 = in4(:);

out1 = zeros( size_in(1), size_in(2));
out2 = zeros( size_in(1), size_in(2));
out3 = zeros( size_in(1), size_in(2));

num_steps = size(vals, 1).^(1./4);

size_out = size(out1);

m3 = min(y(:, 3));
m4 = min(y(:, 4));
m2 = min(y(:, 2));
m1 = min(y(:, 1));

step4 = (max(y(:, 4))-min(y(:, 4)))./(num_steps-1);
step3 = (max(y(:, 3))-min(y(:, 3)))./(num_steps-1);
step2 = (max(y(:, 2))-min(y(:, 2)))./(num_steps-1);
step1 = (max(y(:, 1))-min(y(:, 1)))./(num_steps-1);
off4 = floor((in4-m4)./step4);
off3 = floor((in3-m3)./step3).*num_steps;
off2 = floor((in2-m2)./step2).*num_steps.^2;
off1 = floor((in1-m1)./step1).*num_steps.^3;
offset(:, 1) = off1 + off2 + off3 + off4 + 1;
offset(:, 2) = off1 + off2 + off3 + off4 + 2;
offset(:, 3:4) = offset(:, 1:2) + num_steps;
offset(:, 5:8) = offset(:, 1:4) + num_steps.^2;
offset(:, 9:16) = offset(:, 1:8) + num_steps.^3;

dx = in1-step1.*floor((in1-m1)./step1);
dy = in2-step2.*floor((in2-m2)./step2);
dz = in3-step3.*floor((in3-m3)./step3);
dt = in4-step4.*floor((in4-m4)./step4);

offset = ceil(offset);
io = find( offset(:, 2) > size(vals, 1));
offset(io, 2) = offset(io, 2) -1;
io = find( offset(:, 3) > size(vals, 1));
offset(io, 3:4) = offset(io, 1:2);
io = find( offset(:, 5) > size(vals, 1));
offset(io, 5:8) = offset(io, 1:4);
io = find( offset(:, 9) > size(vals, 1));
offset(io, 9:16) = offset(io, 1:8);

for ii=1:16
   io = find( offset(:, ii) > size(vals, 1));
   offset(io, ii) = size(vals, 1);
end

size(vals)
%%%% determination of the first variable  

p0000 = vals(offset(:, 1), 1);
p0001 = vals(offset(:, 2), 1);
p0010 = vals(offset(:, 3), 1);
p0011 = vals(offset(:, 4), 1);
p0100 = vals(offset(:, 5), 1);
p0101 = vals(offset(:, 6), 1);
p0110 = vals(offset(:, 7), 1);
p0111 = vals(offset(:, 8), 1);
p1000 = vals(offset(:, 9), 1);
p1001 = vals(offset(:, 10), 1);
p1010 = vals(offset(:, 11), 1);
p1011 = vals(offset(:, 12), 1);
p1100 = vals(offset(:, 13), 1);
p1101 = vals(offset(:, 14), 1);
p1110 = vals(offset(:, 15), 1);
p1111 = vals(offset(:, 16), 1);

c0 = p0000;
c1 = (p1000-p0000)./step1;
c2 = (p0100-p0000)./step2;
c3 = (p0010-p0000)./step3;
c4 = (p0001-p0000)./step4;
c5 = (p1100 - p0100 - p1000 + p0000)./(step1.*step2);
c6 = (p1010 - p0010 - p1000 + p0000)./(step1.*step3);
c7 = (p1001 - p0001 - p1000 + p0000)./(step1.*step4);
c8 = (p0110 - p0100 - p0010 + p0000)./(step2.*step3);
c9 = (p0101 - p0100 - p0001 + p0000)./(step2.*step4);
c10 = (p0011 - p0010 - p0001 + p0000)./(step3.*step4);
c11 = (p1110 - p0110 - p1010 -p1100 + p1000 + p0010 + p0100 - p0000)./ ...
   step1.*step2.*step3;
c12 = (p1101 - p0101 - p1001 -p1100 + p1000 + p0001 + p0100 - p0000)./ ...
   step1.*step2.*step4;
c13 = (p1011 - p1010 - p1001 -p0011 + p1000 + p0010 + p0010 - p0000)./ ...
   step1.*step3.*step4;
c14 = (p0111 - p0101 - p0110 -p0011 + p0100 + p0010 + p0001 - p0000)./ ...
   step2.*step3.*step4;
c15 = (p0111 - p0101 - p0110 -p0011 + p0100 + p0010 + p0001 - p0000)./ ...
   step2.*step3.*step4;

out1 = p0000 + c1.*dx + c2.*dy + c3.*dz + c4.*dt + ...
   c5.*dx.*dy + c6.*dx.*dz + c7.*dx.*dt + c8.*dy.*dz + c9.*dy.*dt + c10.*dz.*dt...
   + c11.*dx.*dy.*dz + c12.*dx.*dy.*dt + c13.*dx.*dz.*dt + c14.*dy.*dz.*dt ...
   + c15.*dx.*dy.*dz.*dt;

%%%% determination of the second variable  

p0000 = vals(offset(:, 1), 2);
p0001 = vals(offset(:, 2), 2);
p0010 = vals(offset(:, 3), 2);
p0011 = vals(offset(:, 4), 2);
p0100 = vals(offset(:, 5), 2);
p0101 = vals(offset(:, 6), 2);
p0110 = vals(offset(:, 7), 2);
p0111 = vals(offset(:, 8), 2);
p1000 = vals(offset(:, 9), 2);
p1001 = vals(offset(:, 10), 2);
p1010 = vals(offset(:, 11), 2);
p1011 = vals(offset(:, 12), 2);
p1100 = vals(offset(:, 13), 2);
p1101 = vals(offset(:, 14), 2);
p1110 = vals(offset(:, 15), 2);
p1111 = vals(offset(:, 16), 2);

c0 = p0000;
c1 = (p1000-p0000)./step1;
c2 = (p0100-p0000)./step2;
c3 = (p0010-p0000)./step3;
c4 = (p0001-p0000)./step4;
c5 = (p1100 - p0100 - p1000 + p0000)./(step1.*step2);
c6 = (p1010 - p0010 - p1000 + p0000)./(step1.*step3);
c7 = (p1001 - p0001 - p1000 + p0000)./(step1.*step4);
c8 = (p0110 - p0100 - p0010 + p0000)./(step2.*step3);
c9 = (p0101 - p0100 - p0001 + p0000)./(step2.*step4);
c10 = (p0011 - p0010 - p0001 + p0000)./(step3.*step4);
c11 = (p1110 - p0110 - p1010 -p1100 + p1000 + p0010 + p0100 - p0000)./ ...
   step1.*step2.*step3;
c12 = (p1101 - p0101 - p1001 -p1100 + p1000 + p0001 + p0100 - p0000)./ ...
   step1.*step2.*step4;
c13 = (p1011 - p1010 - p1001 -p0011 + p1000 + p0010 + p0010 - p0000)./ ...
   step1.*step3.*step4;
c14 = (p0111 - p0101 - p0110 -p0011 + p0100 + p0010 + p0001 - p0000)./ ...
   step2.*step3.*step4;
c15 = (p0111 - p0101 - p0110 -p0011 + p0100 + p0010 + p0001 - p0000)./ ...
   step2.*step3.*step4;

out2 = p0000 + c1.*dx + c2.*dy + c3.*dz + c4.*dt + ...
   c5.*dx.*dy + c6.*dx.*dz + c7.*dx.*dt + c8.*dy.*dz + c9.*dy.*dt + c10.*dz.*dt...
   + c11.*dx.*dy.*dz + c12.*dx.*dy.*dt + c13.*dx.*dz.*dt + c14.*dy.*dz.*dt ...
   + c15.*dx.*dy.*dz.*dt;

%%%% determination of the third variable  

p0000 = vals(offset(:, 1), 3);
p0001 = vals(offset(:, 2), 3);
p0010 = vals(offset(:, 3), 3);
p0011 = vals(offset(:, 4), 3);
p0100 = vals(offset(:, 5), 3);
p0101 = vals(offset(:, 6), 3);
p0110 = vals(offset(:, 7), 3);
p0111 = vals(offset(:, 8), 3);
p1000 = vals(offset(:, 9), 3);
p1001 = vals(offset(:, 10), 3);
p1010 = vals(offset(:, 11), 3);
p1011 = vals(offset(:, 12), 3);
p1100 = vals(offset(:, 13), 3);
p1101 = vals(offset(:, 14), 3);
p1110 = vals(offset(:, 15), 3);
p1111 = vals(offset(:, 16), 3);

c0 = p0000;
c1 = (p1000-p0000)./step1;
c2 = (p0100-p0000)./step2;
c3 = (p0010-p0000)./step3;
c4 = (p0001-p0000)./step4;
c5 = (p1100 - p0100 - p1000 + p0000)./(step1.*step2);
c6 = (p1010 - p0010 - p1000 + p0000)./(step1.*step3);
c7 = (p1001 - p0001 - p1000 + p0000)./(step1.*step4);
c8 = (p0110 - p0100 - p0010 + p0000)./(step2.*step3);
c9 = (p0101 - p0100 - p0001 + p0000)./(step2.*step4);
c10 = (p0011 - p0010 - p0001 + p0000)./(step3.*step4);
c11 = (p1110 - p0110 - p1010 -p1100 + p1000 + p0010 + p0100 - p0000)./ ...
   step1.*step2.*step3;
c12 = (p1101 - p0101 - p1001 -p1100 + p1000 + p0001 + p0100 - p0000)./ ...
   step1.*step2.*step4;
c13 = (p1011 - p1010 - p1001 -p0011 + p1000 + p0010 + p0010 - p0000)./ ...
   step1.*step3.*step4;
c14 = (p0111 - p0101 - p0110 -p0011 + p0100 + p0010 + p0001 - p0000)./ ...
   step2.*step3.*step4;
c15 = (p0111 - p0101 - p0110 -p0011 + p0100 + p0010 + p0001 - p0000)./ ...
   step2.*step3.*step4;

out3 = p0000 + c1.*dx + c2.*dy + c3.*dz + c4.*dt + ...
   c5.*dx.*dy + c6.*dx.*dz + c7.*dx.*dt + c8.*dy.*dz + c9.*dy.*dt + c10.*dz.*dt...
   + c11.*dx.*dy.*dz + c12.*dx.*dy.*dt + c13.*dx.*dz.*dt + c14.*dy.*dz.*dt ...
   + c15.*dx.*dy.*dz.*dt;


out1 = reshape( out1, size_in(1), size_in(2));
out2 = reshape( out2, size_in(1), size_in(2));
out3 = reshape( out3, size_in(1), size_in(2));
