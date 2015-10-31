function out = TRC_curve(in, TRC, tagtype) 

if( tagtype == 'curv')
   if( size( TRC, 1).*size(TRC, 2) == 1)
      out = in.^TRC;
   else
      s = size(TRC)
      if( s(2) < 2)
         TRC = [[0:255./(s(1)-1):255]', TRC]
      end         
      out = lin_interpol( in, TRC);
   end
elseif( tagtype == 'para');
   s = size(TRC, 1).*size(TRC, 2);
   switch s
      case 1
         out = in.^TRC;
      case 3
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         h = (in>= (-b./a)).*in + in < (-b./a)  
         out = (a.*h + b).^gam;
         out = out.* (in>= (-b./a));
      case 4
         c = TRC(4);
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         h = (in>= (-b./a)).*in + in < (-b./a)  
         out = (a.*h + b).^gam;
         out = out.* (in>= (-b./a)) + c;
      case 5
         d = TRC(5);
         c = TRC(4);
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         h = (in>= d).*in + in < (d);  
         out1 = (a.*h + b).^gam;
         out2 = c.*in;
         out = out1.* (in >= d) + out2.*(in<d);
      case 5
         f = TRC(7);
         e = TRC(6);
         d = TRC(5);
         c = TRC(4);
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         h = (in>= d).*in + in < (d);  
         out1 = (a.*h + b).^gam + e;
         out2 = c.*in + f;
         out = out1.* (in >= d) + out2.*(in<d);
      otherwise
         error('The number of parameters in paramCurve is not correct\n');
   end
else
   error('Tagtype %s not known in TRC_curve\n');
end
