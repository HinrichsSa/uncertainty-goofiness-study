function UndesignatedField = UnpackField(field_name,data_in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


fieldData = {};

for n=1:length(data_in)
    fieldData{n} = getfield(data_in(n), field_name);    
end

minLen = length(fieldData{1});
for n=2:length(data_in)
    minLen = min(minLen, length(fieldData{n}));
end

arr = fieldData;
maxLengthCell=max(cellfun('size',arr,1));  %finding the longest vector in the cell array
    for i=1:length(arr)
        for j=cellfun('size',arr(i),1)+1:maxLengthCell
             arr{i}(j)=NaN;   %zeropad the elements in each cell array with a length shorter than the maxlength
        end
    end
%     arr=cell2mat(arr); %A is your matrix
matrixTemp = [];
matrixVersion = [];
for i=1:length(arr);
matrixTemp(:,i) = cell2mat(arr(i));
matrixVersion = [matrixVersion matrixTemp(:,i)];
end

% for n=2:length(data_in)
%     arr = fieldData{n};
%     maxLen=length(arr);
%     deltaLen=maxLen-(minLen);
%     if  deltaLen <1
%         arr=arr;
%     else 
%         arr= arr(end-minLen+1:end);
%     end
%     
%     matrixVersion  = [matrixVersion, arr];
% end
matrixVersion(matrixVersion == -100) = NaN;
matrixVersion(matrixVersion == 100) = NaN;

UndesignatedField = matrixVersion;