clear
close all
f = 'CalibIm';
ext = 'jpg';
I1 = imread([f '1.' ext]);   % left image
I2 = imread([f '2.' ext]);   % right image
I3 = imread([f '3.' ext]);


%% STITCHING IMAGE 1 and 2

% Find SIFT keypoints for each image that gives discriptor and location of each point

[des1, loc1] = sift(I1);
[des2, loc2] = sift(I2);
[des3, loc3] = sift(I3);
% display(des1);
% display(loc1);

%% match SIFT keyfeatures


[matchLoc1,matchLoc2]=match_features(des1,des2,loc1,loc2);
[matchLoc2_new,matchLoc3]=match_features(des2,des3,loc2,loc3);

    figure, imshow(I1);
    hold on;
    for i = 1: size(matchLoc1,2);
         scatter(matchLoc1(1,i),matchLoc1(2,i) , 'c');
    end

    figure, imshow(I2);
    hold on;
    for i = 1: size(matchLoc2,2);
        scatter(matchLoc2(1,i),matchLoc2(2,i) , 'r');
    end

    figure, imshow(I2);
    hold on;
    for i = 1: size(matchLoc2_new,2);
        scatter(matchLoc2_new(1,i),matchLoc2_new(2,i) , 'r');
    end

    figure, imshow(I3);
    hold on;
    for i = 1: size(matchLoc3,2);
        scatter(matchLoc3(1,i),matchLoc3(2,i) , 'y');
    end


% Create a new image showing the 1 and 2 images side by side.
    Im12 = [I1 I2];
    figure, imshow(Im12);
    hold on
    for i = 1: size(matchLoc1,2);
        plot([matchLoc1(1,i) matchLoc2(1,i)+size(I1,2)], ...
             [matchLoc1(2,i) matchLoc2(2,i)], 'Color', 'c');
        scatter(matchLoc1(1,i), matchLoc1(2,i), '.','b','Linewidth', 1);

        scatter(matchLoc2(1,i)+size(I1,2), matchLoc2(2,i), '.','r','Linewidth',1); 
    end
    hold off
    colormap('gray');
    figure, imagesc(Im12);
    hold on;
 
    
% Create a new image showing the 2 and 3 images side by side.   
    Im23 = [I2  I3];
    figure, imshow(Im23);
    hold on
    for i = 1: size(matchLoc2_new,2);
        plot([matchLoc2_new(1,i) matchLoc3(1,i)+size(I2,2)], ...
             [matchLoc2_new(2,i) matchLoc3(2,i)], 'Color', 'c');
        scatter(matchLoc2_new(1,i), matchLoc2_new(2,i), '.','b','Linewidth', 1);
        scatter(matchLoc3(1,i)+size(I1,2), matchLoc3(2,i), '.','r','Linewidth',1); 
    end


  
%% 

H21 = homography_ransac(matchLoc2,matchLoc1);   % X2=H21*X1
H23 = homography_ransac(matchLoc2_new,matchLoc3);   % X2=H21*X1


H21_new = [   1.9678    0.1447 -318.4466;
        0.2439    2.0891 -140.5103;
        0.0017    0.0014    1.0000];
    
    
H23_new = [ 0.6560    0.0167  128.1179;
            -0.1269    0.8693   21.0569;
            -0.0008   -0.0000    1.0000];

%  H_final1=   [1.6921   -0.1514 -335.3443;
%     0.2350    1.3328  -86.1962;
%     0.0012   -0.0003    1.0000];



%% stitching image 1 and 2

T=maketform('projective',H21_new');
[im2t,xdataim2t,ydataim2t]=imtransform(I1,T,'XYScale',1);    %% backprojecting 1 on 2
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout=[min(1,xdataim2t(1)) max(size(I2,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(I2,1),ydataim2t(2))];
% let's transform both images with the computed xdata and ydata

img2t_1=imtransform(I1,T,'XData',xdataout,'YData',ydataout,'XYScale',1);

img1t_1=imtransform(I2,maketform('projective',eye(3)),'XData',xdataout,'YData',ydataout,'XYScale',1);

imd12=uint8(abs(double(img2t_1)-double(img1t_1)));
% the casts necessary due to the images' data types
  ims12=max(img1t_1,img2t_1);
%  figure, imshow(ims12);


%% stitching image 2 and 3
T=maketform('projective',H23_new' );
[im2t,xdataim2t,ydataim2t]=imtransform(I3,T);
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout=[min(1,xdataim2t(1)) max(size(I2,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(I2,1),ydataim2t(2))];
% let's transform both images with the computed xdata and ydata

img2t_2=imtransform(I3,T,'XData',xdataout,'YData',ydataout);

img1t_2=imtransform(I2,maketform('projective',eye(3)),'XData',xdataout,'YData',ydataout);

imd23=uint8(abs(double(img1t_2)-double(img2t_2)));
% the casts necessary due to the images' data types
ims23=max(img1t_2,img2t_2);
figure, imshow(ims23);


%% Creating panaroma by stitching the already stitched image
[des12, loc12] = sift(ims12);
[des23, loc23] = sift(ims23);

[matchLoc12,matchLoc23]=match_features(des12,des23,loc12,loc23);

H = homography_ransac(matchLoc12,matchLoc23);

H_new = [ 1.0000   -0.0000  317.0000
          -0.0000    1.0000   95.0000
          -0.0000   -0.0000    1.0000]


T=maketform('projective',H_new' );

[im2t,xdataim2t,ydataim2t]=imtransform(ims23,T);
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout=[min(1,xdataim2t(1)) max(size(ims12,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(ims12,1),ydataim2t(2))];
% let's transform both images with the computed xdata and ydata

img2t_3=imtransform(ims23,T,'XData',xdataout,'YData',ydataout);

img1t_3=imtransform(ims12,maketform('projective',eye(3)),'XData',xdataout,'YData',ydataout);

% imd=uint8(abs(double(img1t_3)-double(img2t_3)));
% the casts necessary due to the images' data types
ims=max(img1t_3,img2t_3);
figure, imshow(ims);



