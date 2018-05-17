function [ matchLoc1, matchLoc2 ] = match_features( des1,des2,loc1,loc2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

threshhold = 10;
distq1 = threshhold;
distq2 = threshhold;
distq3 = threshhold;
m=1;

% calculate disatnce from for each row of descriptor 1 w.r.t each row of discriptor 2 
for i=1:size(des1, 1)
  keypoint = des1(i, :);
  keylist = des2;
  
  distq1 = threshhold;
  distq2 = threshhold;
  
  for j=1:size(keylist, 1)
      dist = sum((keypoint - keylist(j, :)).^2);      
      if (dist < distq1)
          distq2 = distq1;
          distq1 = dist;
          minkey = j;
      elseif (dist < distq2)
          distq2 = dist;
      end
  end
  
  if (10*10*distq1 <6*6*distq2)
      a = loc1(i, :);
      b = loc2(minkey, :);
      match(m, 1) = a(1);
      match(m, 2) = a(2);
      match(m, 3) = b(1);
      match(m, 4) = b(2);
      match(m, 5) = distq1;  
      m = m + 1;
  end

end


matchLoc1 = [match(:,2)  match(:,1)];
matchLoc2 = [match(:,4)  match(:,3)];

matchLoc1=round(matchLoc1');
matchLoc1=[matchLoc1;ones(1,size(matchLoc1,2))];

matchLoc2=round(matchLoc2');
matchLoc2=[matchLoc2;ones(1,size(matchLoc2,2))];

end

