function [ Coordinate ] = Node_setting( Nnode,Nnode_crack,L_crack,L,dL,dW  )
Ncount=0;
Lcount=1;
Coordinate=zeros(round(Nnode),2);
for Nn=1:Nnode
    if Nn > (Nnode-Nnode_crack)% 超出后怎么办
        Coordinate(Nn,1)=(Nn-(Nnode-Nnode_crack))*dL/2+(-0.5*L_crack);
        Coordinate(Nn,2)=0;
    elseif mod(Lcount,2) == 0 %mod是返回lcount/2的余数，如果余数为0，也就是整除
        Coordinate(Nn,1)=Ncount*dL+(-0.5*L); 
        Coordinate(Nn,2)=(Lcount-1)*dW/2 + (-5*10^(-4));
    else
        Coordinate(Nn,1)=Ncount*dL/2+(-0.5*L);  %先走到这里
        Coordinate(Nn,2)=(Lcount-1)*dW/2 + (-5*10^(-4));
    end
    Ncount = Ncount + 1;
    if mod(Ncount,(2*L/dL+1))==0 && mod(Lcount,2) ~= 0
        Ncount=0;
        Lcount=Lcount+1;
    elseif mod(Ncount,(L/dL+1))==0 && mod(Lcount,2) == 0
        Ncount=0;
        Lcount=Lcount+1;
    end
end

end

