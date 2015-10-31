disp('Visualisation of 2D/3D images');
disp('Possibilities to see what you want to see.');
disp({'a = readim(''erika'')  : normal display';...
      'b = a                : linear stretch';...
      'c = a                : percentile stretch'});
a=readim('erika');
b=a;
c=a;
dipshow(a);
dipshow(b,'lin');
dipshow(c,'percentile');

disp('You can access the different display options');
disp('from the command bar above the window: Mappings.');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');


disp({'a = readim(''erika'')  : normal display';...
      'b = a                : log stretch';...
      'c = a                : based at zero'});
dipshow(b,'log');
dipshow(c,'base');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');
disp({'a = xx/256*pi : linear stretch';...
      'b = a         : angle display';...
      'c = xx/256*16 : label display'});

a = xx/256*pi;
b=a;
c = xx/256*16;
dipshow(a,'lin');
dipshow(b,'angle');
dipshow(c,'labels');

disp('Angle maps all grey values in the interval [0 pi] to a colourmap.');
disp('Each grey value gets one colour, label has 16 colours available.');
disp('Notice the german flag in the middle.');

disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');

disp('Another helpful method is histogram equalization.');
disp({'a = readim(''erika'')  : normal display';...
      'b = hist_equalize(a) : histogram equalization'});
a = readim('erika');
b = hist_equalize(a);
dipshow(a,'normal');
dipshow(b,'normal');


disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');

dipclf

disp('Actions on 2D images');
disp('Retrieve the grey value at a certain position:');
disp({'a = readim(''erika'') : normal display';...
      'double(a(180,128))  : grey value at x=180, y=128'});
disp(['double(a(180,128))=',num2str(double(a(180,128)))]);
a = readim('erika');
dipshow(a);


disp(' ');
disp('You can interactivly retrieve the grey value with:');
disp('Action: Pixel testing');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');


disp('Orientation in 2D images.');
disp('Actions: Orientation testing');
disp('You can either compute the orientation image or');
disp('apply your own computed orientation image');

dipshow(a);
diporien
disp('Now you can click in the image as see the tangent to the local structure.');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');
diporien off

disp('3D Images.');
disp({'a = readim(''chromo3d''): linear stretch'});
a = readim('chromo3d');
dipshow(a,'lin');

disp('You can view different slices, xy, yz, xz by');
disp('selecting the view in Mappings:X-Y slice etc.');
disp('');
disp('Further the number in brackets indicates the slice you currently in.');
disp('Stepping through the image by either pressing:');
disp(' ''n'' (next) and ''p'' (previous) or');
disp('Actions: Step through slices, by mouse click');
disp(' left (next), right (previous)');
disp(' ');
disp('Hit any key to continue ...');
pause;
disp(' ');
disp('Isosurface plot.');
disp('To get a feeling what your are looking at.');
disp('A 3D plot of constant grey value...');
dipisosurface(a)
disp(' ');
disp('Use the button axis to scale the axis in a equal manner.');
disp('The number on the upper left is the grey value of the isosurface');
disp('You can use all MATLAB functionality,');
disp('e.g. Tools:Rotate 3D');
