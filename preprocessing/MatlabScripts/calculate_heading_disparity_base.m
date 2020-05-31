
function [a] = calculate_heading_disparity_base(endpoints,target)
%UNTITLED9 Summary of this function goes here
%Detailed explanation goes here

%a = atan2d((vector_base(:,1)*vector_test(:,2))-(vector_base(:,2)*vector_test(:,1)),(vector_base(:,1)*vector_test(:,1))+(vector_base(:,2)*vector_test(:,2)));

start_target = [0,0.2];
end_targets = [0,0.300000000000000;0.0500000000000000,0.286602540378000;0.0866025403784000,0.250000000000000;0.100000000000000,0.200000000000000;0.0866025403784000,0.150000000000000;0.0500000000000000,0.113397459622000;1.22464679915000e-17,0.100000000000000;-0.0500000000000000,0.113397459622000;-0.0866025403784000,0.150000000000000;-0.100000000000000,0.200000000000000;-0.0866025403784000,0.250000000000000;-0.0500000000000000,0.286602540378000];

end_target = end_targets(target,:);  

for i=1:length(endpoints)
    
   va(i,:) =  endpoints(i,:) - start_target; % <-- Consider this the first vector
   vb = end_target - start_target; % <-- and this the second vector
   a(i,:) = atan2d(va(i,1)*vb(2)-va(i,2)*vb(1),va(i,1)*vb(1)+va(i,2)*vb(2));
   
   if a(i,:) > 90
       a(i,:)=180 - a(i,:);
   else a(i,:)=a(i,:);
   end
   if a(i,:) < -90
       a(i,:)=-180 - a(i,:);
   else a(i,:)=a(i,:);
   end
   if a(i,:) > 60
       a(i,:)=90 - a(i,:);
   else a(i,:)=a(i,:);
   end
   if a(i,:) < -60
      a(i,:)=-90 - a(i,:);
   else a(i,:)=a(i,:);
   end

end
