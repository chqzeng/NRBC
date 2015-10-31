%DEMORICE
% This is the sequence of commands in the Getting Started
% chapter of the DIPimage manual.

a = readim('rice')
bg = gaussf(a,25)
a = a-bg
diphist(a,[]);
b = a>20
b = brmedgeobjs(b)
l = label(b,2);
dipshow(l,'labels');
N = max(l)

data = measure(l,a,{'size','feret'})

feret = data.feret;
figure; scatter(feret(1,:),feret(2,:))
xlabel('largest object diameter (pixels)')
ylabel('smallest object diameter (pixels)')
%text(feret(1,:)+0.2,feret(2,:)+0.1,num2str([1:N]'))

sz = data.size;
figure; scatter(feret(1,:),sz)
xlabel('object length (pixels^2)')
ylabel('object area (pixels^2)')
%text(feret(1,:)+0.3,sz+5,num2str([1:N]'))

calc = pi*feret(1,:).*feret(2,:)/4;
figure; scatter(sz,calc)
hold on; plot([180,360],[180,360],'k--')
axis equal
box on
xlabel('object area   (pixels^2)')
ylabel('\pi{\cdot}a{\cdot}b   (pixels^2)')
%text(sz+3,calc+5,num2str([1:N]'))
