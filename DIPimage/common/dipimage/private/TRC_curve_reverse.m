function out = TRC_curve_reverse(in, TRC, tagtype) 

if( tagtype == 'curv')
   if( size( TRC, 1).*size(TRC, 2) == 1)
      out = in.^(1./TRC);
   else
      s = size(TRC)
      if( s(2) < 2)
         TRC = [[0:255./(s(1)-1):255]', TRC]
      end         
      out = lin_interpol_reverse( in, TRC);
   end
elseif( tagtype == 'para');
   s = size(TRC, 1).*size(TRC, 2);
   switch s
      case 1
         out = in.^(1./TRC);
      case 3
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         h = (in >= 0).*in + (in < 0);
         out = 1./a.*(h.^(1./TRC)-b);
         out = (in >= 0).*out + (in<0).*(-b./a);
       case 4
         c = TRC(4);
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         h = (in >= c).*in + (in < c);
         out = 1./a.*((in-c).^(1./TRC)-b);
         out = (in >= c).*out + (in<c).*(-b./a);         
      case 5
         d = TRC(5);
         c = TRC(4);
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         out = 1./a.*(in.^(1./TRC)-b);
         out = (in >= c.*d).*out + (in < c.*d).*in/c; 
      case 7
         f = TRC(7);
         e = TRC(6);
         d = TRC(5);
         c = TRC(4);
         b = TRC(3);
         a = TRC(2);
         gam = TRC(1);
         out = 1./a.*((in-e).^(1./TRC)-b);
         out = (in >= c.*d + f).*out + (in < c.*d + f).*(in-f)/c; 
      otherwise
         error('The number of parameters in paramCurve is not correct\n');
   end
else
   error('Tagtype %s not known in TRC_curve\n');
end
