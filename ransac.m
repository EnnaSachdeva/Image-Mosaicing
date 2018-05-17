function [ H_final ] = homography_ransac( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% calculate homography H using RANSAC

%%%%%%%% IMG2 = H*IMG1
thresh = 10;
number_points = 4;
N=size(matchLoc1,2);
number_iteration=500;   %%%%%%%%%%%%%%% (14C3=693)

A = [];

r = [];
 
for (p=1:number_iteration)
    
        num_inl(p)=0;
        err=0;
%            r1 = randperm(N,number_points);
          r1 = sort(randperm(N,number_points));     %%%%% randomly selecting 6 points from the world coordinate and corresponding image coordinates
        
% continuing with unique series further          
      

               %%%%%%%%%%%%%%%%%%% finding H matrix using DLT    ::::::
               %%%%%%%%%%%%%%%%%%% x2=H*x1 ~~~~~~~~~~~ x2=x_p,y_p,w_p
                        for i=1:number_points
                            
                             xi= [matchLoc1(1,r1(1,i)); matchLoc1(2,r1(1,i)); matchLoc1(3,r1(1,i))];
                             x_p = matchLoc2(1,r1(1,i));
                             y_p = matchLoc2(2,r1(1,i));
                             w_p = matchLoc2(3,r1(1,i));

                             A = [ A ; zeros(1,3)         -w_p * xi'      y_p * xi'; ... 
                                        w_p * xi'          zeros(1,3)     -x_p * xi'];
                                   % -y_p*xi'                 x_p * xi'       zeros(1,4)];

                        end

        %                         display(A);
                                [u,s,v] = svd(A);
                                %display(v);
                                Q = reshape(v(:,9),[3,3]);
                                Q = Q';
                                Q = Q/Q(3,3);
                                H(:,:,p) = Q;

        %                         display(H(:,:,p));


                                 M=[];

                       err(p)=0;
                   %%%%%%%%%%%%%%%%%% finding squared error for each P matrix found          
                               for k=1:N 

                                  
        %                                   display(k,'loop started');
        %                                                                  
                                           xi= [matchLoc1(1,k); matchLoc1(2,k); matchLoc1(3,k)];  %
                                            %%%%%%%%%% bac projecting points 

                                            T= H(:,:,p)*xi;
                                            T=T/T(3,1);
                                            T=round(T);
                                            M = horzcat(M , T);   %%%%%%%%%%% M contains all the values obtained after back projecting the world points

                                            err_xi= (((T(1,1))-matchLoc1(1,k))).^2;
                                            err_yi= (((T(2,1))-matchLoc1(2,k))).^2;
                                            err_zi= (((T(3,1))-matchLoc1(3,k))).^2;
                                            err1 =(err_xi + err_yi + err_zi);
                                            
                                            
                                             if (err1 < thresh)
                                                   num_inl(p)= num_inl(p) + 1 ;
                                            
                                            end
                                      inlier1 = find(iter_err(p) < thresh);
                                              if (inlier1==1)
                                                   num_inl(p)= num_inl(p) + 1 ;

                                              end

                                              err(p) = err(p)+err1;
%                                      
                                         end
                               end



% finding H matrix from the points corresponding to maximum number of inliers
%  display(iter_err);

%  display(num_inl);
 num_inl;

 [max_inlier,index]=max(num_inl);
%  

% [min_error,index] = min(iter_err);
%  display(index,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
 display(thresh,'using threshhold value as ');
 H_final = H(:,:,index);
 display(H_final);   
%  display(index);
%  
%  display(r(index,:));
%  
 
 corr_points1=[];
 corr_points2=[];

 
    for i=1:number_points
         corr_points1= [corr_points1 ; matchLoc1(:,r(index,i))];
         corr_points2= [corr_points2 ; matchLoc2(:,r(index,i))];
         
    end
    
    corr_points1=reshape(corr_points1(:,1),[3,4]);
    corr_points2=reshape(corr_points2(:,1),[3,4]);
%     
    display('Corresponding points from image 1 are ');
%     display(corr_points1);
%     
    display('Corresponding points are image 2 are ');
%     display(corr_points2);
%  


end

