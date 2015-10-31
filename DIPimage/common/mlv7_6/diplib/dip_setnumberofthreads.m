%dip_setnumberofthreads   Set the global number of threads.
%    dip_setnumberofthreads(threads)
%
%    threads
%      Integer number.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Jan Willem Brandenburg, December 2007

%   FUNCTION:
%This function sets the global default of the number of threads used by
%some of the diplib frameworks. The initial value of this global is 
%equal to the number of processors in the system.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_int threads    int threads    NumberOfThreads
%
%SEE ALSO
