function [ H_final ] = homography_ransac( matchLoc2,matchLoc1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% calculate homography H using RANSAC

%%%%%%%% IMG2 = H*IMG1
thresh = 100;
number_points = 4;
N=size(matchLoc1,2);
number_iteration=1000;   %%%%%%%%%%%%%%% (14C3=693)

A = [];

r = [];
 
for (p=1:number_iteration)
    
        num_inl(p)=0;
        err=0;
%            r1 = randperm(N,number_points);
          r1 = sort(randperm(N,number_points));     %%%%% randomly selecting 6 points from the world coordinate and corresponding image coordinates

% chacking whether that series is unique or is previously generated             
                  flag=0;
                  for l=1:p-1
                      if(r1==r(l,number_points))
                          flag=1;
                      end
                  end
% continuing with unique series further          
        if(flag~=1)  
            r=[r;r1];
                 %          
                 A=[];
        %         count=1;

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
                                Q = reshape(v(:,9)',[3,3]);
                                Q = Q';
                                Q = Q/Q(3,3);
                                H(:,:,p) = Q;

        %                         display(H(:,:,p));


                                 M=[];


                   %%%%%%%%%%%%%%%%%% finding squared error for each P matrix found          
                               for k=1:N 

                                     if (k~=r1(1,:))

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
                                            err = err+err1;
                                            err = round(err/10);
                                                                          
                                         end
                               end

                                             inlier1 = find(err < thresh);
                                              if (inlier1==1)
                                                   num_inl(p)= num_inl(p) + 1 ;

                                             end

      end
 end

 [max_inlier,index]=max(num_inl);
  display(thresh,'using threshhold value as ');
 H_final = H(:,:,index);
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

end

