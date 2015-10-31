
disp('Rotation of a 2D image');
disp({'a = readim(''erika'')   : input image';...
      'b = rotation(a,90/180*pi) : rotated 90 degrees';...
      'c = rotation(a,45/180*pi) : rotated 45 degrees'});
a=readim('erika');
b=rotation(a,90/180*pi);
c=rotation(a,45/180*pi);
dipshow(a);
dipshow(b);
dipshow(c);


disp('Notice some white pixels at the borders this is an interplotation problem.');
disp('The input image is of type unit8');
disp(' disp(a)');
disp(a)
disp('Solution: convert the input image to float.');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');
disp({'aa = dip_image(a,''float'');   : convert input image';...
      'd = rotation(aa,45/180*pi)'});
aa=dip_image(a,'float');
d=rotation(aa,45/180*pi);
dipshow(d);

disp('The overall size of the image changes.');
disp('From size(a): [256 256] to 45 degree rotated [364 364].');
disp('The background is default fill with zeros.');
disp('');
disp('There are different interpolation methods available');
disp('and some more options.');
disp('See the help file, or in the dipimage menu under');
disp('Transforms: rotation around an axis.');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');disp(' ');

disp('Rotation of a 3D image around an axis');
disp({'a = readim(''chromo3d'')    : input image';...
		'a = dip_image(a,''float'')  : convert to float';...
      'b = rotation(a,45/180*pi)   : rotated 45 degrees around z-axis';...
      'c = rotation(a,45/180*pi,1) : rotated 10 degrees around x-axis'});

a = readim('chromo3d');
a = dip_image(a,'float'); 
b = rotation(a,45/180*pi);
c = rotation(a,10/180*pi,1);
dipshow(a,'lin');
dipshow(b,'lin');
dipshow(c,'lin');
disp(' ');
disp('Further: See help rotation, or under dipimage:');
disp('Transforms: rotation around an axis.');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');
clear b c
disp('Rotation of a 3D image with Euler angles.')
disp({'a = readim(''chromo3d'')    : input image';...
		'a = dip_image(a,''float'')  : convert to float';...
      'b = rotation3d(a,''direct'',[ .7854 .7854 .7854] )  : rotate via direct'});
b=rotation3d(a,'direct',[0.7854      0.7854      0.7854]);
dipshow(b,'lin');

disp(' ');
disp('Hit any key to continue ...');
pause;

disp({'c = rotation3d(a,''9 shears'',[ .7854 .7854 .7854]) : rotate via 9 shears'});
c=rotation3d(a,'9 shears',[0.7854      0.7854      0.7854]);
dipshow(c,'lin');
disp('For the direct method the rotated image stays the same size,');
disp(' some object parts may now lie outside the image.');
disp(' Only foh interpolation is implemented, much faster than 9 shears.');
disp('For the 9 shear method, the same options apply as for a 2D image.');

disp('Also the complet rotation/transformation matrix can be given');
disp('for the direct method. See help rotation3d or under');
disp('dipimage:Transform:3D general rotation.');


