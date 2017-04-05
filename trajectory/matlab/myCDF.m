function [x,y] = myCDF(sortedElements)
unique=[]; % unique array to save the x-axis
cumulate=[]; % cumulate number 
isExist=0;
for i = 1:size(sortedElements,2)
    isExist=0;
    for j = 1:size(unique,2)
        if unique(j)==sortedElements(i)
            cumulate(j)=cumulate(j)+1;
            isExist=1;
            break
        end;
    end
    if isExist == 0
        index=size(unique,2)+1;
        unique(index)=sortedElements(i);
        cumulate(index)=1;
        if i>1
            cumulate(index)=cumulate(index-1)+cumulate(index);
        end
    end
end
x=unique
y=cumulate./size(sortedElements,2)

% example:
% element=[1,1,5,5,3,4]
% sorted=sort(element)
% [x,y]=myCDF(sorted)
% plot(x,y)