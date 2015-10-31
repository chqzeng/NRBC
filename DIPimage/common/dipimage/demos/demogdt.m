% demogdt: Demonstrates the DIP_GDT function and image indexing.

% read in image
a = readim('cermet')

% create seed image
seed = ~newim(a);
seed(127,127) = 0;

% do it
[GDT,Distance] = dip_gdt(a,seed,3,0,0);
dipshow(GDT,'lin')
dipshow(Distance,'lin')
