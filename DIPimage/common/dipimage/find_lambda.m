%FIND_LAMBDA calculates the regularazation parameter for the TM_filter
%   using generalized cross validation 
% SYNOPSIS:
%   lambda = find_lambda(g,h)
%
% PARAMETERS:
%   g:      acquired image
%   h:      psf
%
%   lambda: regularization parameter
%
% LITERATURE:
%   G.M.P. van Kempen, L.J. van Vliet, P.J. Verveer and H.T.M. van der Voort
%   A Quantitative Comparison of Image Restoration Methods for Confocal Microscopy
%   Journal of Microscopy, 185(3):354-365, 1997.

% Bart Vermolen, June 2006.

function lambda = find_lambda(g,h)
if nargin == 1 & ischar(g) & strcmp(g,'DIP_GetParamList') % Avoid being in menu
      lambda = struct('menu','none');
      return
end

G = sqrt(prod(size(g))) * ft(g);
H = sqrt(prod(size(h))) * ft(h);
lambda = brent(1e-6,1e-4,1e-2,1e-6,0,'min',G,H);

%---------------------------------------------------------------
function f = fnctn(x,G,H)
% GCV function with parameters G and H and variable x
f = sum(x^2*abs(G)^2/(abs(H)^2+x)^2)/(sum(x/(abs(H)^2+x)))^2;

function [xmin,f] = brent(ax,bx,cx,tol,iprint,key,G,H)
%BRENT brent minimalization algorithm to find the regularization parameter
%   using generalized cross validation (GCV)
%
% SYNOPSIS
%   [xmin,f] = brent(ax,bx,cx,tol,iprint,key,G,H)
%
% PARAMETERS
%   ax:     lower boundary
%   bx:     first estimate
%   cx:     upper boundary
%   tol:    tolerance
%   iprint: 1 if you want intermediate value printed else 0
%   key:    choose between 'min' for minimalization and 'root' for root
%           finding
%   G:      Fourier transform of the acquired image
%   H:      Fourier transform of the PSF
%
%   xmin:   value where minimum of the GCV function occurs
%   f:      minimum of the GCV function
%
%  This routine is called the  Brent Method"
%  for finding a minimum in one dimension.
%
%  THIS CODE ONLY FINDS MINIMA, NOT MAXIMA.
%
%  This code is based on the "brent" code of 
%  Press, W.H.,  Flannery, B.P., Teukolsky, S.A., Vetterling, W.T.
%  "Numerical Recipes", Cambridge University Pres, Cambridge, 1986, p. 284-286.
%  
%  Fortran translated to Matlab by David Keffer
%  Department of Chemical Engineering, University of Tennessee
%  May,1999
%
%  Modifications made by B.J.Vermolen to include the parameters G and H
%  26 jan 2003
%
%  The code execute by typing 
%
%  [xmin,f]=brent(ax,bx,cx,tol,iprint,key,G,H)
%
%  where
%  ax , bx , and cx are x coordinates such that ax < bx < cx or ax > bx > cx
%  and f(bx) < f(ax) and f(bx) < f(cx)
%  tol is the tolerance
%  f is the function value at the minimum
%  iprint is 1 if you want intermediate values printed
%  key is either 'root' for locating roots or 'min' for locating minima
%  G is the fourier transform of the data image
%  H is the OTF of the lenssystem.
%
fa = fnctn_filter(ax,key,G,H);
fb = fnctn_filter(bx,key,G,H);
fc = fnctn_filter(cx,key,G,H);
if ( ax >= bx & cx >= bx ) 
   fprintf(1,'bracketing inputs are wrong:  bx is less than both ax and cx. \n');
   [ax, bx, cx] = mnbrak1(ax,bx,iprint,key,G,H);
   fprintf (1, 'new brackets: a = %9.2e b = %9.2e c = %9.2e \n', ax, bx, cx);
	fa = fnctn_filter(ax,key,G,H);
	fb = fnctn_filter(bx,key,G,H);
	fc = fnctn_filter(cx,key,G,H);
elseif( ax <= bx & cx <= bx )
   fprintf(1,'bracketing inputs are wrong:  bx is greater than both ax and cx. \n');
   [ax, bx, cx] = mnbrak1(ax,bx,iprint,key,G,H);
   fprintf (1, 'new brackets: a = %9.2e b = %9.2e c = %9.2e \n', ax, bx, cx);
	fa = fnctn_filter(ax,key,G,H);
	fb = fnctn_filter(bx,key,G,H);
	fc = fnctn_filter(cx,key,G,H);
end
if (fb > fa) 
   fprintf(1,'bracketing inputs are wrong:  f(bx) > f(ax) %9.2e > %9.2e \n', fb, fa);
   [ax, bx, cx] = mnbrak1(ax,bx,iprint,key,G,H);
   fprintf (1, 'new brackets: a = %9.2e b = %9.2e c = %9.2e \n', ax, bx, cx);
	fa = fnctn_filter(ax,key,G,H);
	fb = fnctn_filter(bx,key,G,H);
	fc = fnctn_filter(cx,key,G,H);
end
if (fb > fc) 
   fprintf(1,'bracketing inputs are wrong:  f(bx) > f(cx) %9.2e > %9.2e \n', fb, fc);
   [ax, bx, cx] = mnbrak1(ax,bx,iprint,key,G,H);
   fprintf (1, 'new brackets: a = %9.2e b = %9.2e c = %9.2e \n', ax, bx, cx);
	fa = fnctn_filter(ax,key,G,H);
	fb = fnctn_filter(bx,key,G,H);
	fc = fnctn_filter(cx,key,G,H);
end

% 
%  parameters
%
%  maximum iterations
maxit = 1000;
% golden section search constants
cgold = 0.3819660;
% small number for zero-root protection
zeps = 1.0e-20;

%
%  define Brent's six abscissas
%
%  a = lower bound on the optimum
%  b = upper bound on the optimum
%  x = best guess to date
%  w = second best guess to date
%  v = previous value of w
%  u = point of most recent function evaluation
%  got it?
%
a = min(ax,cx);
b = max(ax,cx);
v  = bx;
w = v;
x = v;
% e is distance moved on step before last
e = 0.0;
d = 0.0;		%  correction: i had to add this line myself
fx = fb;
fv = fx;
fw = fx;
iter = 0;
%
%   initialize convergence criteria
%
xm = 0.5*(a+b);
tol1 = tol*abs(x)+zeps;
tol2 = 2*tol1;
err = abs(x - xm);
tole = ( tol2 - 0.5*(b-a) );
check = 1;
%
%  start the main loop
%
while check
   %
   %  First we need to find a new step-size, d
   %  if the previous step-size was too big, find a new step-size,  d
   %
   if (abs(e) > tol1)
      %
      % construct a trial parabolic fit
      %
      r = (x-w)*(fx-fv);
      q = (x-v)*(fx-fw);
      p = (x-v)*q - (x-w)*r;
      q = q*(q-r);
      if (q > 0) 
         p = -p;
      end
      q = abs(q);
      etemp = e;
      e = d;
      %
      %  test the parabolic fit
      %
      if ( ( abs(p) >= abs(0.5*q*etemp) ) | ( p <= q*(a-x) ) |  ( p >= q*(b-x) ) )            
         %
         % fit is bad
         %
         if (x >= xm)
            e = a - x;
         else
            e = b - x;
         end
         d = cgold*e;
         %fprintf (1, 'fit is bad, d = %9.2e \n ', d);
		else
         %
         % fit is good
         %
         d = p/q;
         u = x+d;
         if ( (u - a < tol2) | (b - u < tol2) )
            %d = sign(tol1, xm-x);  % FORTRAN sign function is different in MATLAB
            d = sign(tol1*(xm-x))*abs(xm-x);
         end         
      	%fprintf (1, 'fit is good, d = %9.2e \n ', d);
      end
	%
   %  if the previous step-size was not too big, find a new step-size,  d
   %
	else
      if (x >= xm)
      	e = a - x;
      else
         e = b - x;
      end
      d = cgold*e;
   end
   
   %
   %  find new abscissa and ordinate, u and fu
   %
   if (abs(d) > tol1)
      u = x+d;
   else
      % u = x+sign(tol1,d); % FORTRAN sign function is different in MATLAB
      u = x + sign(tol1*d)*abs(d);
   end
   fu = fnctn_filter(u,key,G,H);
   
   %
   %  decide what to do with our new abscissa and ordinate
   %
   if (fu <= fx )
      if (u >= x)
         a = x;
      else
         b = x;
      end
      v = w;
      fv = fw;
      w = x;
      fw = fx;
      x = u;
      fx = fu;
   else
      if (u < x)
         a = u;
      else
         b = u;
      end
      if ( fu <= fw | w == x )
         v  = w;
         fv = fw;
         w = u;
         fw = fu;
      elseif ( fu <= fv | v == x | v == w )
         v = u;
         fv = fu;
      end
   end

   %
   %  check for convergence
   %
   xm = 0.5*(a+b);
   tol1 = tol*abs(x)+zeps;
   tol2 = 2*tol1;
   err = abs(x - xm);
   tole = tol2 - 0.5*(b-a) ;
   if abs((b-a) / xm) < tol
       check = 0;
   end
   %
   %  check iterations
   %
   iter = iter +1;
   if (iter > maxit)
      fprintf (1, 'boundary 1:  a = %9.2e f(a) = % 9.2e \n', a, fnctn_filter(a,key,G,H) );
      fprintf (1, 'boundary 2:  b = %9.2e f(b) = % 9.2e \n', b, fnctn_filter(b,key,G,H) );
      fprintf (1, 'best guess:  x = %9.2e f(x) = % 9.2e \n', x, fx );
      fprintf (1, '2nd best guess:  w = %9.2e f(w) = % 9.2e \n', w, fw );
      fprintf (1, 'previous w:  v = %9.2e f(v) = % 9.2e \n', v, fv );
      fprintf (1, 'most recent point:  u = %9.2e f(u) = % 9.2e \n', u, fu );
      fprintf (1, 'error = %9.2e iter = %5i \n', err, iter );
      error('maximum number of iterations exceeded ');
   end

end
f = fx;
xmin = x;
%
if (iprint == 1)
      fprintf (1, 'boundary 1:  a = %9.2e f(a) = % 9.2e \n', a, fnctn_filter(a,key,G,H) );
      fprintf (1, 'boundary 2:  b = %9.2e f(b) = % 9.2e \n', b, fnctn_filter(b,key,G,H) );
      fprintf (1, 'best guess:  x = %9.2e f(x) = % 9.2e \n', x, fx );
      fprintf (1, '2nd best guess:  w = %9.2e f(w) = % 9.2e \n', w, fw );
      fprintf (1, 'previous w:  v = %9.2e f(v) = % 9.2e \n', v, fv );
      fprintf (1, 'most recent point:  u = %9.2e f(u) = % 9.2e \n', u, fu );
      fprintf (1, 'error = %9.2e iter = %5i \n \n', err, iter );
      fprintf (1, 'ANSWER = %13.6e \n', x);
end

function f = fnctn_filter(x,key,G,H);
f = fnctn(x,G,H);
if ( strcmp(key,'root') == 1 )
   f = abs(f);
end

%MNBRAK1 functions creates new brackets
%
% SYNOPSIS
%   [ax, bx, cx] = mnbrak1(ax,bx,iprint,key,G,H)
%
% PARAMETERS
%   ax:     lower boundery
%   bx:     first estimate
%   iprint: 1 if you want intermediate value printed else 0
%   key:    choose between 'min' for minimalization and 'root' for root
%           finding
%   G:      Fourier transform of the acquired image
%   H:      Fourier transform of the PSF
%
%   ax:     new lower boundary
%   bx:     new first estimate
%   cx:     new upper boundary

%
%   NOTE!   This m-file uses DIPlib, an image processing toolbox.
%           See: http://www.diplib.org
%
% Version: 1.0
% Bart Vermolen, June 2006.
% Last modification: July 2006.

%
%  this function creates the bracket
%
function  [ax, bx, cx] = mnbrak1(ax,bx,iprint,key,G,H);
%
%  This function creates brackets for a 1-D problem
%
%
%  This code is based on the "mnbrak" code of 
%  Press, W.H.,  Flannery, B.P., Teukolsky, S.A., Vetterling, W.T.
%  "Numerical Recipes", Cambridge University Pres, Cambridge, 1986, p. 281-282.
%
%  Modifications made by B.J.Vermolen to include the parameters G and H
%  26 jan 2003
%
 
%  Fortran translated to Matlab by David Keffer
%  Department of Chemical Engineering, University of Tennessee
%  May,1999
%
%  This function calls fnctn.m
%
gold = 1.618034;
glimit = 100.0;
tiny=1.e-20;
fa = fnctn_filter(ax,key,G,H);
fb = fnctn_filter(bx,key,G,H);
if (fb > fa)
   dum = ax;
   ax = bx;
   bx = dum;
   dum = fb;
   fb = fa;
   fa = dum;
end
%
% first guess for c
%
cx = bx+gold*(bx-ax);
fc = fnctn_filter(cx,key,G,H);
%
%  main loop
%
while (fb >= fc) 
   %
   % try parabolic fit
   %
   r = (bx - ax)*(fb-fc);
   q = (bx-cx)*(fb-fa);
   u = bx - ( (bx-cx)*q - (bx-ax)*r ) / ( 2*sign(max(abs(q-r),tiny)*(q-r))*abs(q-r) );
   ulim = bx + glimit*(cx - bx);
   if  ( (bx -u)*(u-cx) > 0 )
      fu = fnctn_filter(u,key,G,H);
      if ( fu < fc )
         ax = bx;
         fa = fb;
         bx = u;
         fb = fu;
         return;
      elseif (fu > fb )
         cx = u;
         fc = fu;
         return;
      end
      %
      % parabolic fit was no good, try default magnification
      %
      u = cx+gold*(cx-bx);
      fu = fnctn_filter(u,key,G,H); 
   elseif ( (cx-u)*(u-ulim) > 0 )
      fu = fnctn_filter(u,key,G,H); 
      if ( fu < fc ) 
         bx = cx;
         cx = u;
         u = cx + gold*(cx-bx);
         fb = fc;
         fc = fu;
         fu = fnctn_filter(u,key,G,H);
      end
   elseif ( (u-ulim)*(ulim-cx) >= 0) 
      u=ulim;
      fu = fnctn_filter(u,key,G,H);
   else
      u = cx + gold*(cx -bx);
      fu = fnctn_filter(u,key,G,H);
   end
   ax = bx;
   bx = cx;
   cx = u;
   fa = fb;
   fb = fc;
   fc = fu;
end


