% EDIR Extended version of matlab's dir command
%
%  D = EDIR('directory_name') returns the results in an M-by-1                
%    structure with the fields:                                                
%    As MATLAB dir:                                                            
%        name           filename                                               
%        date           modification date                                      
%        bytes          number of bytes                                        
%        isdir          1 for a directory                                      
%    Extra fields:      (all are empty for non-supported platforms)                                                        
%        type           'file', 'directory', 'block device', etc. [] on windows
%        utc_accessed   last access time UTC                                   
%        utc_modified   last modified time UTC                                 
%        utc_reference  reference time UTC (read below)                        
%        t_accessed     last access time local time zone                       
%        t_modified     last modified time local time zone                     
%        t_reference    reference time local time zone (read below)            
%
%    Fields may be added in the future
%
%    The reference time field has different meanings on UNIX and windows
%    platforms:
%      UNIX:    the last time the file's metadata (such as file permissions)
%               were modified. This is derived from the system call "stat"'s
%               st_ctime field
%      windows: file creation time
%
%    In both cases this is the best candidate for use as a reference time,
%    for instance to derive the time spacing between when two images were
%    acquired.
%
%    NOTE: due to idiosynchrasies in matlab's dir command and windows'
%          way of dealing with file and path names, edir may fail to
%          correctly find the files you are looking for.

% (C) 2010-     Michael van Ginkel
%               Placed in the public domain
%               Included in DIPimage for convenience
% 
%  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR 
%  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
%  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, 
%  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
%  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
%  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
%  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
%  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
%  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.


function dd=edir(dn)

if nargin==1 & ischar(dn) & strcmp(dn,'DIP_GetParamList') % Avoid being in menu
   dd = struct('menu','none');
   return
end

bp=dn;
kdir=pwd;
try
  cd(dn);
  cd(kdir);
catch
  bp=fileparts(dn);  
end
try
  % try to get rid of '.' and '..', 'cause Bill can't handle them very well
  cd(bp);
catch
end
bp=pwd;
cd(kdir);
dd=edir_low(bp,dir(dn));
