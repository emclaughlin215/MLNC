function [val] = testRegressor(in, param)

val=zeros(length(in),1);
baseFuncs=param.baseFuncs;
w=param.w;
%calculate values of all testing datapoints

for i=1:length(in)
    for j=1:length(baseFuncs)
        val(i)=val(i)+w(j)*baseFuncs{j}(in(i,:));
    end
end

end