% demomeasure: Demonstrates the MEASURE function and its relatives

% read in image
a = readim('cermet')

% threshold
b = a<128

% label
c = label(b);
dipshow(c,'labels');

% measure
data = measure(c,a,{'size','gravity','dimension'});

% display results
data

% get mean size
meansize = mean(data.size);

% select objects larger than mean size
d = msr2obj(c,data,'size');
e = d>=meansize
disp('Figure ''e'' contains only the objects larger than the mean size.');
