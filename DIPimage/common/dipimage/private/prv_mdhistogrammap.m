% Undocumented function - don't use
% private function of MvG
% commited by BR to be able to use hist2image

function out=mdhistogrammap(varargin)

DIP_MDH_LOWER               =   0;
DIP_MDH_UPPER               =   1;
DIP_MDH_LOWER_UPPER_BINS    =   2;
DIP_MDH_LOWER_UPPER_BINSIZE =   3;
DIP_MDH_LOWER_PERCENTILE    =   4;
DIP_MDH_LOWER_CENTRE        =   8;
DIP_MDH_UPPER_PERCENTILE    =  16;
DIP_MDH_UPPER_CENTRE        =  32;
DIP_MDH_NO_CORRECTION       =  64;
DIP_MDH_ALL_SET             = 255;

if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end

channels=[];
mask=[];
binspecs={};
if isa(varargin{1},'dip_image_array')
   switch nargin
      case 1
         error('Too few arguments');
      case 2
      case 3
         binspecs=varargin{3};
      case 4
         mask=varargin{3};
         binspecs=varargin{4};
      otherwise
         error('Too many arguments');
   end
elseif isa( varargin{1}, 'dip_image' )
   switch nargin
      case 1
         error('Too few arguments');
      case 2
      case 3
         binspecs=varargin{3};
      case 4
         channels=varargin{3};
         binspecs=varargin{4};
      case 5
         channels=varargin{3};
         mask=varargin{4};
         binspecs=varargin{5};
      otherwise
         error('Too many arguments');
   end
else
   error('Input must be an image or tensor image');
end
map=varargin{2};
if ~isa(map,'dip_image')
   error('Map argument must be an image');
end


rtype=[];
rarg1=[];
rarg2=[];
rarg3=[];
% Let's parse the bloody thing
if ~isempty(binspecs)
   rtype=[0];
   rarg1=[0];
   rarg2=[0];
   rarg3=[0];
   if ~isa(binspecs,'cell')
      error('Bin specification must be a cell array')
   end
   if (length(size(binspecs))~=2) | (min(size(binspecs))~=1)
      error('Bin specification element must be a cell array with one dimension')
   end
   for ii=1:length(binspecs)
      if ~isempty(binspecs{ii})
         if ~isa(binspecs{ii},'cell')
            error('Bin specification element must be a cell array')
         end
         if (length(size(binspecs{ii}))~=2) | (min(size(binspecs{ii}))~=1)
            error('Bin specification element must be a cell array with one dimension')
         end
      end
      rtype(ii)=0;
      lwabs=0;
      upabs=0;
      lwcntr=0;
      upcntr=0;
      nocorr=0;
      if isempty(binspecs{ii})
         speclen=0;
      else
         speclen=length(binspecs{ii});
      end
      skip=0;
      for jj=1:speclen
         if skip
            skip=0;
         else
            switch binspecs{ii}{jj}
               case 'lower'
                  rtype(ii)=bitor(rtype(ii),1);
                  if (jj+1)>speclen
                     error('Missing argument to "lower"');
                  end
                  lower=binspecs{ii}{jj+1};
                  skip=1;
               case 'upper'
                  rtype(ii)=bitor(rtype(ii),2);
                  if (jj+1)>speclen
                     error('Missing argument to "upper"');
                  end
                  upper=binspecs{ii}{jj+1};
                  skip=1;
               case 'bins'
                  rtype(ii)=bitor(rtype(ii),4);
                  if (jj+1)>speclen
                     error('Missing argument to "bins"');
                  end
                  bins=binspecs{ii}{jj+1};
                  skip=1;
               case 'binsize'
                  rtype(ii)=bitor(rtype(ii),8);
                  if (jj+1)>speclen
                     error('Missing argument to "binsize"');
                  end
                  binsize=binspecs{ii}{jj+1};
                  skip=1;
               case 'lower_abs'
                  lwabs=1;
               case 'upper_abs'
                  upabs=1;
               case 'lower_centre'
                  lwcntr=1;
               case 'upper_centre'
                  upcntr=1;
               case 'no_correction'
                  nocorr=1;
               otherwise
                  error('Unknown option');
            end
         end
      end
      switch rtype(ii)
         case 0
            rtype(ii)=DIP_MDH_LOWER_UPPER_BINS;
            rarg1(ii)=0;
            rarg2(ii)=100;
            rarg3(ii)=100;
         case 7
            rtype(ii)=DIP_MDH_LOWER_UPPER_BINS;
            rarg1(ii)=lower;
            rarg2(ii)=upper;
            rarg3(ii)=bins;
         case 13
            rtype(ii)=DIP_MDH_LOWER;
            rarg1(ii)=lower;
            rarg2(ii)=binsize;
            rarg3(ii)=bins;
         case 14
            rtype(ii)=DIP_MDH_UPPER;
            rarg1(ii)=upper;
            rarg2(ii)=binsize;
            rarg3(ii)=bins;
         case 11
            rtype(ii)=DIP_MDH_LOWER_UPPER_BINSIZE;
            rarg1(ii)=lower;
            rarg2(ii)=upper;
            rarg3(ii)=binsize;
         otherwise
            error('Illegal combination of "lower", "upper", "bins" and "binsize"');
      end
      rtype(ii)=rtype(ii)+DIP_MDH_LOWER_PERCENTILE+DIP_MDH_UPPER_PERCENTILE;
      if lwabs
         rtype(ii)=bitand(rtype(ii),DIP_MDH_ALL_SET-DIP_MDH_LOWER_PERCENTILE);
      end
      if upabs
         rtype(ii)=bitand(rtype(ii),DIP_MDH_ALL_SET-DIP_MDH_UPPER_PERCENTILE);
      end
      if lwcntr
         rtype(ii)=bitor(rtype(ii),DIP_MDH_LOWER_CENTRE);
      end
      if upcntr
         rtype(ii)=bitor(rtype(ii),DIP_MDH_UPPER_CENTRE);
      end
      if nocorr
         rtype(ii)=bitor(rtype(ii),DIP_MDH_NO_CORRECTION);
      end
   end
end

if isa(varargin{1},'dip_image_array')
   out=dip_armdhistogrammap(varargin{1},mask,map,rtype,rarg1,rarg2,rarg3);
else
   out=dip_mdhistogrammap(varargin{1},channels,mask,map,rtype,rarg1,rarg2,rarg3);;
end
