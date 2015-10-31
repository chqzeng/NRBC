function out = di_convertphysDims(in, op)

% op -1: m->m^-1, m^-1 -> m-2
% op +1: m->m^2,  m^-1 -> m

%TODO

if ischar(op)
   switch lower(op)
      case 'invert'
         out = in;
      otherwise
         error('Unkown option.');
   end
elseif isnumeric(op)

else
   error('Unkown option.');
end
