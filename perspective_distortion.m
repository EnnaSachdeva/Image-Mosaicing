clc;
clear all;
close all;

%% reference image to remove distortion
I1 = imread('test1.jpg'); 

%% image of which distortion is to be removed
I2 = imread('test4.jpg');

figure,imshow(I1);
hold on

figure,imshow(I2);
hold on

%% points in playground coordinates
img_points2= [185, 27, 1;
430, 90, 1;
493, 455, 1;
145, 462, 1]';

%% points in graphics coordinates
img_points1= [138, 21, 1;
436, 33, 1;
471, 475, 1;
109, 478, 1]';

  
number_points = 4;


display(img_points1);
display(img_points2);
% Ap = 0   


%% finding A matrix from the image and world points
A = [];

%%%%%%%% Ground=H*graphics
for i=1:number_points 
     xi= [img_points2(1,i); img_points2(2,i); img_points2(3,i)];
     x_p = img_points1(1,i);
     y_p = img_points1(2,i);
     w_p = img_points1(3,i);
   
    A  =  [ A ; zeros(1,3)         -w_p * xi'        y_p * xi'; 
                w_p * xi'           zeros(1,3)      -x_p * xi'];
             %   -y_p*xi'              x_p * xi'       zeros(1,4)];
    
end

%% finding  H matrix from A matrix
display(A);

[u,s,v] = svd(A);

display(v);


H = reshape(v(:,9),[3,3]);
H=H';
H=H/H(3,3);
display(H);
   
T=maketform('projective',H'); 
T.tdata.T
 

[im2t,xdataim2t,ydataim2t]=imtransform(I2,T);

figure, imshow(im2t)
% now xdataim2t and ydataim2t decides the the bounds of the transformed
% image2
xdataout=[min(1,xdataim2t(1)) max(size(I1,2),xdataim2t(2))];   %%%% getting dimensions of x and y pixels of 1st image for projecting the 2nd image 
ydataout=[min(1,ydataim2t(1)) max(size(I1,1),ydataim2t(2))];
% let's transform both images with the computed xdata and ydata

im2_newt=imtransform(I2,T,'XData',xdataout,'YData',ydataout);
% im1t=imtransform(I1,maketform('projective',eye(3)),'XData',xdataout,'YData',ydataout);

figure, imshow(im2_newt)

