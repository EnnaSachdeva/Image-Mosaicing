clc;
clear all;
close all;

I1 =  imread('playground.jpg');
I2 =  imread('pepsi.jpg');
% I1 =  imread('tabletennis.jpg');
% I2 =  imread('score.jpg');
% I1 =  imread('badminton.jpg');
% I2 =  imread('Yonex.jpg');

 imshow(I1);
 hold on
% imshow(I2);
% hold on


%% points in playground coordinates
img_points1= [260, 276, 1;
611, 303, 1;
497, 470, 1;
50, 341, 1]';
% 
% %% points in pepsi coordinates
img_points2= [1, 3, 1;
639, 4, 1;
638, 480, 1;
3, 478, 1]';

% %% points in TT
% img_points1= [441, 4, 1;
% 635, 4, 1;
% 640, 126, 1;
% 460, 121, 1]';
% 
% %% points in score
% img_points2= [5, 23, 1;
% 640, 3, 1;
% 638, 477, 1;
% 7,  479, 1]';

%% points in badminton
% img_points1= [186, 333, 1;
% 376, 295, 1;
% 432, 398, 1;
% 197, 455, 1]';
% 
% %% points in Yonex
% img_points2= [1, 2, 1;
% 639, 2, 1;
% 639, 475, 1;
% 1, 475, 1]';


number_points = 4;


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

% [evec,~] = eig(A'*A);
% H = reshape(evec(:,1),[3,3])';
% H = H/H(end); % make H(3,3) = 1
% 

[u,s,v] = svd(A);

display(v);


H = reshape(v(:,9),[3,3]);
H=H';
H=H/H(3,3);
display(H);
   
%  x1 = img_points1(1,:)';
%  y1 = img_points1(2,:)';
% 
% 
%  x2 = img_points2(1,:)';
%  y2= img_points2(2,:)';

%  T=maketform('projective',[x2 y2],[x1 y1]);
T=maketform('projective',H'); 
T.tdata.T
 
%%Projecting graphics I2 on image I1 using homography

[im2t,xdataim2t,ydataim2t]=imtransform(I2,T);
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout=[min(1,xdataim2t(1)) max(size(I1,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(I1,1),ydataim2t(2))];


im2t=imtransform(I2,T,'XData',xdataout,'YData',ydataout);  % transformed graphics image w.r.t projectiveness 
im1t=imtransform(I1,maketform('projective',eye(3)),'XData',xdataout,'YData',ydataout);    % transformed ground image w.r.t projectiveness
 

ims=max(im2t , im1t);
figure, imshow(ims)


