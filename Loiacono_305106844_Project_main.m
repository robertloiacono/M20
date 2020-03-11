%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Final Project MATLAB Script
%   Author: Robert Loiacono
%   Date:   3/13/20
%   UID: 305106844
%   Code for Final Project
%   This problem      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc

%%MAIN SCRIPT
J=1;
kT=0.1;
x_min=0;
x_max=150;
y_min=0;
y_max=100;
h=1;
currIter=1;
maxIter=1000000;

grid_type=input('Please enter grid-type: 1, 2 ,3: ');
while grid_type~=1 && grid_type~=2 && grid_type~=3
   fprintf('Error: Please enter a correct grid-type: 1, 2, 3\n');
   grid_type=input('Please enter grid-type: 1, 2 ,3: '); 
end

[dipole_field]=seed_initial(x_min,x_max,y_min,y_max,h,grid_type);
%function 1
while currIter<=maxIter
    
    [delE,Prob]=ProbCalculation(dipole_field,i,j,J,kT)
    r=rand;
    if delE<=0
        new_field=update_field(dipole_field(i,j));
    elseif delE>0 && r<=Prob
        new_field=update_field(dipole_field(i,j));
    else
        new_field=dipole_field(i,j);
    end
    dipole_field=new_field;
    if currIter==1 || currIter==10 || currIter==100 || currIter==1000 || currIter==10000 || currIter==100000 || currIter==1000000
        plot_dipole(dipole_field,currIter,grid_type);
    end
    currIter=currIter+1;
end


%%Function 1 Initial Condition Function
function [dipole_field]=seed_initial(x_min,x_max,y_min,y_max,h,grid_type)
    maxJPts=(x_max-x_min)/h +1;
    maxIPts=(y_max-y_min)/h+1;
    %dipole_field=zeros(rows,cols);
    if grid_type==1
        for i=1:1:maxJPts
            for j=1:1:maxIPts
                if dipole_field(i,j)>=0.5
                    dipole_field(i,j)=1;
                else
                    dipole_field(i,j)=-1;
                end
            end
        end
    elseif grid_type==2
        left_Half=0.5*maxJPts;
        for i=1:1:maxJPts
            for j=1:1:maxIPts
                if j<left_Half
                    dipole_field(i,j)=1;
                else
                    dipole_field(i,j)=-1;
                end
            end
        end
    else
        %TODO
    end
end
%pick a random point on field
%flip its sign
%calculate its prob now being the other sign using its neighbors
%pick a random number and compare to probability
%if rand>prob
%reject spin

%%Function 2- Energy and Probability Calculation Function
function[delE,Prob]=ProbCalculation(dipole_field,i,j,J,kT)
    maxJPts=(x_max-x_min)/h+1;
    maxIPts=(y_max-y_min)/h+1;
    
    if j==1 %left side of matrix
        if i==1 %top left corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i,j+1)+dipole_field(i+1,j)+dipole_field(maxIPts,j)+dipole_field(i,maxJPts));
        elseif i==maxYPts %bottom left corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i-1,j)+dipole_field(i,j+1)+dipole_field(1,1)+dipole_field(i,maxJPts));
        else %anywhere on the left wall of matrix not in corners
            delE=-1*J*dipole_field(i,j)*(dipole_field(i-1,j)+dipole_field(i+1,j)+dipole_field(i,j+1)+dipole_field(i,maxJPts)));
        end
    elseif j==maxJPts %right side of matrix
        if i==1 %top right corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i,j-1)+dipole_field(i,1)+dipole_field(i+1,j)+dipole_field(maxIPts,j));
        elseif i==maxIPts %bottom right corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i,j-1)+dipole_field(i,1)+dipole_field(i-1,j)+dipole_field(1,j));
        else  %anywhere else on the right wall not in corners
            delE=-1*J*dipole_field(i,j)*(dipole_field(i-1,j)+dipole_field(i+1,j)+dipole_field(i,j-1)+dipole_field(i,1));
        end
    elseif i==1 && (j>1 && j<maxJPts) %top wall but not corners
        delE=-1*J*dipole_field(i,j)*(dipole_field(i,j+1)+dipole_field(i,j-1)+dipole_field(i+1,j)+dipole_field(maxIPts,j));
    elseif i==maxIPts && (j>1 && j<maxJPts) %bottom wall but not corners
        delE=-1*J*dipole_field(i,j)*(dipole_field(i,j+1)+dipole_field(i,j-1)+dipole_field(i-1,j)+dipole_field(1,j));
    else %middle cell
        delE=-1*J*dipole_field(i,j)*(dipole_field(i+1,j)+dipole_field(i-1,j)+dipole_field(i,j+1)+dipole_field(i,j-1));
    end
    %finding probability
    if delE<=0
        Prob=1;
    else
        Prob=exp(-delE/kT);
    end
    
end 

%%Update Field Function
function [new_field]=update_field(dipole_field)
%TODOOOOOOOOOOOOOOOOOOOOOOOOOOO

end

%%Plot Field Function 
function plot_dipole(dipole_field,currIter,grid_type)
figure()
imagesc(dipole_field)
colorbar
title('Iteration Number'+num2str(currIter)+ 'For Grid Type'+num2str(grid_type),'FontSize',24);
%set(gcf,'Position',[0 0 150 100])
hold on 
grid on
drawnow
end
