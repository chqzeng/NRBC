function out=gst_subsampled(in,sg,st)

n = ndims (in);
out = newimar(n,n);
o1 = zeros(1,n);
o2 = o1; 
for ii = 1:n
   o1(ii) = 1;
   d1 = derivative(in, sg, o1);
   for jj = ii:n
      o2(jj) = 1;
      d2 = derivative(in, sg, o2);
      out{ii,jj}=subsample(gaussf(d1*d2,st),floor(st));
      o2(jj) = 0;
      if ii ~= jj
         out{jj,ii}=out{ii,jj};
      end
   end
   o1(ii) = 0;
end

