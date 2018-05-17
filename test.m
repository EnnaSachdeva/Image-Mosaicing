im1=imread('hall1.jpg');
im2=imread('hall2.jpg');
im1f=figure; imshow(im1);
im2f=figure; imshow(im2);

figure(im1f), [x1,y1]=getpts
figure(im2f), [x2,y2]=getpts
figure(im1f), hold on, plot(x1,y1,'or');
figure(im2f), hold on, plot(x2,y2,'or');

T=maketform('projective',[x2 y2],[x1 y1]);
T.tdata.T

[im2t,xdataim2t,ydataim2t]=imtransform(im2,T);
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout=[min(1,xdataim2t(1)) max(size(im1,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(im1,1),ydataim2t(2))];
% let's transform both images with the computed xdata and ydata
im2t=imtransform(im2,T,'XData',xdataout,'YData',ydataout);
im1t=imtransform(im1,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);

ims=im1t/2+im2t/2;
figure, imshow(ims)

imd=uint8(abs(double(im1t)-double(im2t)));
% the casts necessary due to the images' data types
imshow(imd);

ims=max(im1t,im2t);
imshow(ims);

